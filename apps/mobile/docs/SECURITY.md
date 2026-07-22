# FixFlow Security Architecture

## Overview

FixFlow is a B2B SaaS for property management. Security protects:
1. **User data** - personal information, reports, photos
2. **Business model** - paid subscription access

**Key principle:** `anon_key` in app is PUBLIC. All security = RLS on server.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    TWO CLIENTS, ONE BACKEND                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Flutter App (iOS/Android)          Next.js Website             │
│   ├─ Free download                   ├─ Payment (Stripe)        │
│   ├─ No IAP/prices                   ├─ Estate provisioning     │
│   ├─ Uses anon_key                   ├─ Uses service_role       │
│   └─ Invitation code to join         └─ Webhook receiver        │
│                                                                  │
│                          ▼                                       │
│   ┌──────────────────────────────────────────────────────┐      │
│   │                    SUPABASE                           │      │
│   │  ┌─────────────┬─────────────┬───────────────────┐   │      │
│   │  │    Auth     │  Postgres   │  Edge Functions   │   │      │
│   │  │  (JWT)      │  (RLS!)     │  (service_role)   │   │      │
│   │  └─────────────┴─────────────┴───────────────────┘   │      │
│   └──────────────────────────────────────────────────────┘      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Security Layers

### 1. Authentication (Supabase Auth)

| Feature | Implementation |
|---------|----------------|
| Email/password login | ✅ Standard flow |
| Anonymous guests | ✅ `signInAnonymously()` |
| Account upgrade | ✅ `auth.updateUser()` (guest → full) |
| JWT tokens | ✅ Auto-refresh, passed in RLS |

### 2. Authorization (RLS - Row Level Security)

**Every table has RLS enabled.** Access rules:

| Table | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| `fixflow_reports` | estate member + active sub + (staff OR own report) | estate member + active sub | staff/assigned tech | admin only |
| `fixflow_buildings` | estate member + active sub | admin | admin | admin |
| `fixflow_announcements` | active + (global OR estate member + sub) | admin/board | admin/board | admin |
| `fixflow_invitation_codes` | admin | admin | admin | admin |
| `fixflow_subscriptions` | admin OR own | - | - | - |
| `fixflow_user_estates` | own memberships | via RPC | - | - |

**Critical RLS functions:**
- `fixflow_is_estate_member(estate_id)` - user belongs to estate
- `fixflow_estate_has_active_subscription(estate_id)` - B2B paywall
- `fixflow_is_estate_admin(estate_id)` - admin role check
- `fixflow_is_not_resident(user_id)` - staff (Zarząd/Admin/Serwisant/Ochrona)

### 3. Subscription Gating (B2B Paywall)

```sql
-- Estate must have active subscription for data access
fixflow_estate_has_active_subscription(estate_id)
  = status IN ('active', 'trialing')
  OR (status = 'past_due' AND current_period_end > now() - 7 days)
```

**When subscription expires:**
- RLS blocks all SELECT/INSERT on estate data
- App shows "subscription inactive" message
- Data is preserved, just inaccessible

### 4. Invitation Code Security

| Protection | Implementation |
|------------|----------------|
| Code format | 12 chars: `XXXX-XXXX-XXXX` (no ambiguous chars) |
| Max uses | Default 1 (single-use) |
| Expiration | Default 30 days |
| Rate limit | Max 5 attempts per 15 minutes per user |
| Subscription check | Can't join estate without active sub |
| Admin control | Can invalidate compromised codes |

**RPC `fixflow_redeem_invitation_code(code)`:**
1. Check rate limit (429 if exceeded)
2. Validate code (active, not expired, not exhausted)
3. Check estate subscription
4. Increment usage counter
5. Create membership + profile
6. Log attempt (success/failure)

### 5. Secrets Management

| Secret | Location | Access |
|--------|----------|--------|
| `SUPABASE_URL` | `config/api-keys.json` | App (via dart-define) |
| `SUPABASE_ANON_KEY` | `config/api-keys.json` | App (PUBLIC - ok) |
| `SUPABASE_SERVICE_ROLE_KEY` | Edge Function secrets | Server only |
| `STRIPE_SECRET_KEY` | Edge Function secrets | Server only |
| `STRIPE_WEBHOOK_SECRET` | Edge Function secrets | Server only |
| Trello API keys | `fixflow_estate_secrets` table | Admin RLS only |

**`.gitignore` includes:**
- `config/api-keys.json`
- `.env*`

## Attack Vectors & Mitigations

### 1. Code Bruteforce
**Attack:** Try random codes until one works.
**Mitigation:** Rate limit (5 attempts/15min), 12-char codes (36^12 combinations).

### 2. Code Sharing
**Attack:** Share valid code publicly.
**Mitigation:** Default max_uses=1, admin can invalidate, expiration.

### 3. Subscription Bypass
**Attack:** Use app without paying.
**Mitigation:** RLS checks `fixflow_estate_has_active_subscription()` on every query. No client-side only checks.

### 4. Direct API Access
**Attack:** Extract anon_key, call Supabase directly.
**Mitigation:** RLS enforces same rules regardless of client. anon_key is intentionally public.

### 5. Modified App
**Attack:** Patch app to skip checks.
**Mitigation:** All checks are server-side (RLS). Modified app hits same RLS.

### 6. Cross-Estate Data Access
**Attack:** User in Estate A tries to read Estate B data.
**Mitigation:** Every RLS policy checks `fixflow_is_estate_member(estate_id)`.

### 7. Privilege Escalation
**Attack:** Resident tries to act as admin.
**Mitigation:** Role checks in RLS (`fixflow_is_estate_admin`, `fixflow_is_not_resident`).

## Audit Trail

**`fixflow_report_events` table (append-only):**
- Logs: created, status_changed, priority_changed, assigned, unassigned, rated
- No UPDATE/DELETE policies = immutable
- Includes user_id, user_name, user_role, old/new values

## Testing Security

### Manual RLS Test
```sql
-- As resident, try to read another estate's reports
-- Should return 0 rows
SELECT * FROM fixflow_reports WHERE estate_id = 'other-estate-uuid';

-- As resident, try to read internal notes
-- Should fail or return empty
SELECT * FROM fixflow_report_internal_notes;

-- After subscription expires, try any query
-- Should return 0 rows
SELECT * FROM fixflow_reports;
```

### Code Redemption Test
```bash
# Try invalid code
curl -X POST '.../rpc/fixflow_redeem_invitation_code' \
  -d '{"p_code": "FAKE-CODE-1234"}' \
  -H "Authorization: Bearer $TOKEN"
# Should: 400 "Invalid or expired invitation code"

# Try 6+ times in 15 min
# Should: 400 "Too many attempts"
```

## Compliance

| Requirement | Status |
|-------------|--------|
| Data encrypted in transit | ✅ HTTPS/TLS |
| Data encrypted at rest | ✅ Supabase encryption |
| User can delete account | ✅ Edge Function `delete-account` |
| GDPR right to erasure | ✅ Complete data deletion |
| No hardcoded secrets | ✅ dart-define + Edge secrets |
| Audit trail | ✅ Append-only events table |

## Incident Response

If security issue discovered:

1. **Compromised invitation code:** Admin invalidates via `fixflow_invalidate_invitation_code(code_id)`
2. **Unauthorized access:** Check `fixflow_report_events` for audit trail
3. **Subscription fraud:** Verify webhook logs, check `fixflow_subscriptions` status
4. **Data breach:** Contact Supabase support, review RLS policies

# 🔒 Security Audit — Mestio Monorepo

**Date:** 2026-07-28  
**Scope:** middleware.ts, RLS policies, Auth config, dependencies (npm audit), Vercel config, API endpoints, role-based authorization  
**Auditor:** Hermes Agent

---

## CRITICAL FINDINGS

### C1. Next.js — 9 high-severity vulnerabilities (npm audit)

**Package:** next@16.2.10  
**Severity:** HIGH  
**Advisories:**
- **GHSA-6gpp-xcg3-24w24** — Middleware/Proxy bypass in App Router using Turbopack
- **GHSA-m99w-x7hq-7vfj** — DoS in Server Actions
- **GHSA-89xv-2m56-2m9x** — SSRF in Server Actions on custom servers
- **GHSA-68g3-v927-f742** — Cache confusion for requests with bodies
- **GHSA-4633-3j49-mh5q** — Cache confusion (invalid UTF-8)
- **GHSA-4c39-4ccg-62r3** — Unbounded Server Action payload (Edge)
- **GHSA-p9j2-gv94-2wf4** — SSRF in rewrites
- **GHSA-q8wf-6r8g-63ch** — DoS in Image Optimization (SVGs)
- **GHSA-955p-x3mx-jcvp** — Unauthenticated disclosure of Server Function endpoints

**Also affected:** PostCSS (XSS, arbitrary file read), Sharp/libvips (4 CVEs)  
**Total:** 12 high-severity vulnerabilities

**Fix:** Upgrade Next.js to latest 16.3.x patch, update PostCSS and Sharp.

---

### C2. Trello API credentials stored in plaintext in database

**Location:** `fixflow_estates` table — columns `trello_api_key`, `trello_token`, `trello_list_id`  
**File:** `migrations/0000_fixflow_base_schema.sql` (lines 16-18)  
**Severity:** CRITICAL

These credentials are stored as plaintext columns in a database table accessible to authenticated users with `fixflow_is_estate_member()` access. Any estate member (resident, serwisant, etc.) with sufficient RLS visibility could exfiltrate Trello API keys.

**Fix:**
1. Encrypt at rest using Supabase Vault (`pgsodium`) or a service-layer encryption mechanism
2. Move Trello integration to a queued service that holds the key in env vars
3. At minimum, restrict SELECT on these columns to admin/board only via a view or column-level permissions

---

### C3. supabaseAdmin (service_role) used in 8+ public API routes without user auth

**Files:**
- `apps/web/src/app/(public)/api/contact/route.ts` — no auth
- `apps/web/src/app/(public)/api/newsletter/route.ts` — no auth
- `apps/web/src/app/(public)/api/create-payment/route.ts` — rate-limited only
- `apps/web/src/app/(public)/api/create-checkout/route.ts` — rate-limited only
- `apps/web/src/app/(public)/api/create-transfer/route.ts` — rate-limited only
- `apps/web/src/app/(public)/api/invitation-code/route.ts` — no auth
- `apps/web/src/app/(public)/api/admin/pricing/route.ts` — GET has no auth
- `apps/web/src/app/(public)/api/crm/blog/route.ts` — x-api-key auth (ok)

**Severity:** HIGH

`supabaseAdmin()` creates a Supabase client with `SUPABASE_SERVICE_ROLE_KEY`, which **completely bypasses all RLS policies**. If any of these endpoints has an injection vulnerability, SSRF, or is called with malicious input, the attacker gains unrestricted read/write access to the entire database.

While some of these endpoints are intentionally public (newsletter, contact form), the use of service_role means a bug here is catastrophic. These should use the anon key with appropriate RLS policies, or at minimum have strict input validation + output sanitization.

**Fix:**
1. Newsletter/contact: use anon key with RLS (`newsletter_insert_public` policy already exists)
2. Payment/checkout/transfer: create dedicated Edge Functions with minimal permissions
3. Invitation code: add authentication or tie to user session
4. Admin pricing GET: add auth or use anon key with SELECT RLS policy

---

### C4. GET /api/invitation-code — no authentication, returns invitation codes

**File:** `apps/web/src/app/(public)/api/invitation-code/route.ts`  
**Severity:** CRITICAL

This endpoint accepts a Stripe `session_id` query param and returns invitation codes for the associated estate. There is NO authentication or API key check — only a rate limit. If an attacker obtains or guesses a Stripe session_id (which follow a predictable pattern), they can retrieve invitation codes that allow registration on any estate.

**Fix:** Require x-api-key authentication matching the user's session, or move this logic server-side behind a user-authenticated route.

---

## HIGH SEVERITY

### H1. Two parallel role systems create authorization confusion

**System 1 — `fixflow_user_estates.role`:** `admin`, `board`, `resident`  
**System 2 — `fixflow_resident_profiles.role`:** `owner`, `admin`, `manager`, `serwis`, `ochrona`, `resident`

**Files:**
- Middleware (`middleware.ts` line 50) checks `fixflow_resident_profiles.role`
- RLS policies check `fixflow_user_estates.role` (via `fixflow_is_estate_admin()` etc.)
- `getActiveEstate()` checks `fixflow_user_estates.role`
- `getResidentContext()` checks `fixflow_resident_profiles.role`

**Severity:** HIGH

A user could have `role='admin'` in `fixflow_user_estates` (granting full RLS access) but `role='resident'` in `fixflow_resident_profiles` (causing middleware to route them to `/resident/`). Or vice versa — `role='resident'` in user_estates (RLS restricts heavily) but `role='owner'` in resident_profiles (middleware tries `/owner/`). This inconsistency creates exploitable gaps.

**Fix:** Consolidate to a single role authority. Since RLS depends on `fixflow_user_estates`, that should be the source of truth. Remove or deprecate the `role` column in `fixflow_resident_profiles`.

---

### H2. Middleware role query has silent error swallowing

**File:** `apps/web/src/middleware.ts` (lines 48-58)  
**Severity:** HIGH

```typescript
try {
  const { data: profile } = await supabase
    .from("fixflow_resident_profiles")
    .select("role")
    .eq("user_id", user.id)
    .maybeSingle();
  role = profile?.role || "";
} catch {
  // If DB query fails, allow access (login page handles role check)
}
```

If the Supabase query fails (network error, RLS block, timeout), `role` defaults to `""`, and the middleware lets the user through to any dashboard. The catch block does not log the error, so this class of failure is invisible in production.

**Fix:** Log the error, return a 500 or redirect to login page with error param.

---

### H3. No rate limiting on login page

**File:** `apps/web/src/app/(dashboard)/login/page.tsx`  
**Severity:** HIGH

The login page calls `supabase.auth.signInWithPassword()` directly without any application-level rate limiting. Supabase has built-in rate limiting, but it's generous (typically 50-100 req/min). This allows brute-force password attacks at that rate.

**Fix:** Add exponential backoff and/or CAPTCHA after 3 failed attempts. Consider rate limiting the `/auth/v1/token` endpoint via Supabase's built-in rate limiting config.

---

### H4. GET /api/admin/pricing — no authentication

**File:** `apps/web/src/app/(public)/api/admin/pricing/route.ts`  
**Severity:** HIGH

The GET method returns pricing config data with no auth check (only rate limiting at 30/min). The PUT method correctly requires x-api-key. An admin endpoint leaking pricing data to unauthenticated users.

**Fix:** Add at minimum rate limiting with anon key, or better: use a proper auth check.

---

### H5. Auth callback lacks state parameter validation

**File:** `apps/web/src/app/(dashboard)/auth/callback/route.ts`  
**Severity:** HIGH

The callback exchanges any `code` for a session and redirects to a `next` parameter that has minimal validation (must start with "/", no "//", no "@"). Supabase codes are single-use and time-limited, but the absence of `state` parameter verification means an attacker who intercepts a code could potentially exploit the redirect.

**Fix:** Use Supabase's built-in PKCE flow with state parameter validation. Stricter redirect validation with a hostname whitelist.

---

## MEDIUM SEVERITY

### M1. In-memory rate limiter resets on every cold start

**File:** `apps/web/src/lib/rate-limit.ts`  
**Severity:** MEDIUM

The rate limiter uses a JavaScript `Map` in process memory. On Vercel (serverless), cold starts are frequent. Every deploy or scale-up resets all rate limit counters, and multiple concurrent instances don't share state. An attacker can simply wait for a cold start or hit different instances.

**Fix:** Use a shared store (Upstash Redis, Vercel KV, or Supabase) for rate limiting.

---

### M2. CSP weakened by unsafe-inline and unsafe-eval

**File:** `apps/web/next.config.ts` (line 68)  
**Severity:** MEDIUM

The Content-Security-Policy includes `'unsafe-inline'` and `'unsafe-eval'` in `script-src`, which is required by Next.js but significantly weakens XSS protection. Any script injection vulnerability becomes easily exploitable.

**Fix:** Use Next.js with strict CSP (requires next.config.js `strict: true` for CSP via nonces or hashes where possible). Consider `script-src 'strict-dynamic'` as a stronger alternative.

---

### M3. fixflow_resident_images INSERT RLS uses email instead of user_id

**File:** `migrations/0057_shared_infra_0057_report_images_resident_insert.sql` (line 15)  
**Severity:** MEDIUM

```sql
AND reporter_email = (SELECT email FROM auth.users WHERE id = auth.uid())
```

The INSERT policy for report_images matches `reporter_email` against the user's email, rather than using the foreign key relationship. Email is a mutable identifier — if a user changes their email, existing permissions break. Also, two users with the same email (theoretically impossible but a design anti-pattern) could access each other's reports.

**Fix:** Use `fixflow_reports.reporter_id` (user_id FK) instead of email matching.

---

### M4. No HMAC or additional webhook verification

**File:** `apps/web/supabase/functions/stripe-webhook/index.ts`  
**Severity:** MEDIUM

The Stripe webhook correctly validates the Stripe signature, but there's no additional application-level HMAC or authentication on the `userId` in `client_reference_id`. A valid Stripe session with a manipulated `client_reference_id` could cause cross-user estate association.

**Fix:** Verify that `client_reference_id` matches the authenticated Stripe customer's metadata. Or sign the userId before passing to Stripe and verify the signature in the webhook.

---

### M5. Invitation code usage tracked in plaintext integer

**Files:** `fixflow_invitation_codes` table — `current_uses` column, migration 0100  
**Severity:** MEDIUM

The `current_uses` counter for invitation codes is a plain integer without concurrency protection. On high-traffic estates, two users could simultaneously register with the same code, both seeing `current_uses < max_uses`, and both succeeding.

**Fix:** Use Supabase's atomic increment (`RPC` or `UPDATE ... SET current_uses = current_uses + 1 WHERE ... AND current_uses < max_uses RETURNING *`) instead of client-side read-then-write.

---

### M6. PATCH /api/crm/blog/[id] — field mapping bug

**File:** `apps/web/src/app/(public)/api/crm/blog/[id]/route.ts` (line 71)  
**Severity:** MEDIUM

```typescript
if (body.content !== undefined) update.body = body.content;
```

The PATCH handler maps `body.content` to `update.body`, but the database column is likely `content`, not `body`. This means content updates silently fail.

**Fix:** `update.content = body.content` instead of `update.body = body.content`.

---

## LOW SEVERITY

### L1. Email test endpoint shares API key with blog endpoint

**File:** `apps/web/src/app/(public)/api/email/test/route.ts`  
Both endpoints reuse the same `CRM_BLOG_API_KEY` env var. These should have separate keys with minimal permissions.

### L2. fixflow_estates doesn't explicitly enable RLS in CREATE TABLE

The base schema creates `fixflow_estates` without `ENABLE ROW LEVEL SECURITY`. While subsequent migrations add it, the drift window between creation and enabling is an attack surface.

### L3. Auth callback basic redirect validation

The `next` parameter checks `startsWith("/")` and `!includes("@")` and `!startsWith("//")`. Could still accept `next=//evil.com` via double slash bypass in some URL parsers. Use a URL parser or hostname whitelist.

### L4. CSP `form-action` includes checkout.stripe.com

While necessary for Stripe, this means the page can submit forms to Stripe. If an XSS is found, it could be used to submit Stripe forms.

---

## POSITIVE FINDINGS

These are things the codebase does **well**:

1. ✅ **Multiple RLS hardening migrations** (0069, 0095, 0096, 0100) — shows active security maintenance
2. ✅ **Security definer functions set `search_path = ''`** — prevents search_path hijacking
3. ✅ **`poweredByHeader: false`** — removes server fingerprinting
4. ✅ **HSTS with preload** (2 years, includes subdomains)
5. ✅ **Permissions-Policy** — disables camera, microphone, geolocation
6. ✅ **X-Frame-Options: DENY** — prevents clickjacking
7. ✅ **Generic login error messages** — doesn't leak whether email or password was wrong
8. ✅ **Zod validation on all API inputs** — prevents injection and malformed data
9. ✅ **Rate limiting on most API routes** (though in-memory)
10. ✅ **Stripe webhook signature verification** and idempotency checks
11. ✅ **RLS `WITH CHECK` prevents serwisant from setting "Odrzucone" status** (migration 0096)
12. ✅ **Board cannot create admin/board invitation codes** (migration 0096)
13. ✅ **RODO anonymization function** (anonymize_resident_profiles)
14. ✅ **Excessive grants revoked** from anon/authenticated on sensitive tables

---

## PRIORITY RECOMMENDATIONS

### Immediate (next 48 hours)
| # | Action | Severity |
|---|--------|----------|
| 1 | **Upgrade Next.js** from 16.2.10 to latest 16.3.x | CRITICAL |
| 2 | **Remove Trello credentials from DB columns** — use env vars or Supabase Vault | CRITICAL |
| 3 | **Add auth to GET /api/invitation-code** — requires user session or x-api-key | CRITICAL |
| 4 | **Replace supabaseAdmin with anon key + RLS** on contact/newsletter endpoints | HIGH |

### Short-term (next sprint)
| # | Action | Severity |
|---|--------|----------|
| 5 | **Consolidate role systems** — fixflow_user_estates as single source of truth | HIGH |
| 6 | **Fix middleware role query** — log errors, don't silently swallow | HIGH |
| 7 | **Add rate limiting to login page** — exponential backoff after 3 failures | HIGH |
| 8 | **Move rate limiting to shared store** (Upstash Redis, Vercel KV) | MEDIUM |
| 9 | **Fix fixflow_report_images INSERT RLS** — use user_id not email | MEDIUM |
| 10 | **Fix PATCH blog [id] field mapping** — update.content not update.body | MEDIUM |

### Medium-term (next 2 sprints)
| # | Action | Severity |
|---|--------|----------|
| 11 | **Implement state parameter validation** in auth callback | HIGH |
| 12 | **Add HMAC verification** for Stripe client_reference_id | MEDIUM |
| 13 | **Make invitation code usage atomic** (single SQL increment) | MEDIUM |
| 14 | **Harden CSP** — use strict-dynamic or nonces | MEDIUM |
| 15 | **Separate API keys** for email test vs blog endpoints | LOW |

---

## AUDIT TRAIL

Files examined:
- `apps/web/src/middleware.ts`
- `apps/web/src/app/(dashboard)/login/page.tsx`
- `apps/web/src/app/(dashboard)/auth/callback/route.ts`
- `apps/web/src/lib/supabase/middleware.ts`
- `apps/web/src/lib/supabase/client.ts`
- `apps/web/src/lib/supabase/server.ts`
- `apps/web/src/lib/supabase/admin.ts`
- `apps/web/src/lib/supabase-admin.ts`
- `apps/web/src/lib/rate-limit.ts`
- `apps/web/src/lib/security-check.ts`
- `apps/web/src/lib/validations.ts`
- `apps/web/src/lib/active-estate.ts`
- `apps/web/src/lib/resident-context.ts`
- `apps/web/next.config.ts`
- `apps/web/vercel.json`
- `vercel.json`
- `package.json` (root + apps/web)
- `packages/config/env.ts`
- `packages/supabase/src/rls-policies.sql`
- `packages/supabase/migrations/` (30 files)
- `apps/mobile/supabase/migrations/` (35+ files including all RLS migrations)
- `apps/web/supabase/functions/stripe-webhook/index.ts`
- All 11 API route handlers under `apps/web/src/app/api/`
- npm audit output (root + apps/web)

Tools used:
- `read_file` for source code review
- `search_files` for file discovery
- `terminal` for npm audit execution
- `web_extract` for advisory lookup (NVD/GitHub)

# FixFlow Data Safety & Store Compliance

## App Store / Google Play Compliance

### Business Model Declaration

FixFlow is a **B2B SaaS application** for property management companies and housing associations. 

**Key compliance points:**

| Requirement | FixFlow Status |
|-------------|----------------|
| No IAP/prices in app | ✅ No purchase buttons or pricing displayed |
| Real functionality after login | ✅ Full issue tracking, announcements, contacts |
| No links to external payment | ✅ No "subscribe" or pricing links in app |
| Free for end users | ✅ Residents pay nothing, managers pay via website |

**Note on RevenueCat:** the `purchases_flutter`/`purchases_ui_flutter` packages and a
full paywall UI still exist in the repository (kept for a possible future B2C
add-on), but are unconditionally disabled by `RevenueCatConfig.fixflowB2bMode = true`
(`lib/core/config/revenuecat_config.dart`) - no purchase code ever runs, and
nothing is rendered to users or reviewers. A CI test
(`test/core/config/revenuecat_config_test.dart`) fails the build if this flag
is ever changed, so it can't be silently flipped by a merge/refactor. If this
flag is ever intentionally set to `false`, this document and
`docs/REVIEW_NOTES.md` MUST be updated in the same change - do not resubmit to
the stores with stale "no IAP" claims.

### Revenue Model Explanation (for App Review)

> "FixFlow is a B2B service where property management companies pay subscription fees through our website. The mobile app is free for all users (residents, security staff, technicians). End users receive an invitation code from their property manager to join their community. No purchases or subscriptions are offered within the application."

## Data Safety (Google Play)

### Data Collection Declaration

| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Email address | Yes | No | Account authentication |
| Name | Yes | No | User identification in reports |
| Phone number | Optional | No | Contact information |
| Photos | Yes | No | Issue documentation |
| Location | Optional | No | Issue location (if enabled) |
| Device identifiers | Yes | No | Push notifications (FCM) |
| Crash logs | Yes | No | App stability (Crashlytics) |

### Data Handling

| Practice | Status |
|----------|--------|
| Data encrypted in transit | ✅ HTTPS/TLS |
| Data encrypted at rest | ✅ Supabase encryption |
| Users can request deletion | ✅ Delete Account feature |
| Data retention | See detailed policy below |
| Third-party sharing | None (except Crashlytics) |

## Data Retention Policy

### Active User Data
Data is retained **while the user account is active**. Upon account deletion via the "Delete Account" button, all personal data is **immediately and permanently deleted** (GDPR Article 17 compliance):

| Data Type | Retention After Deletion | Reason |
|-----------|--------------------------|--------|
| User Profile (name, email) | Immediate deletion | Personal data removed immediately |
| Authentication credentials | Immediate deletion | Supabase Auth handles removal |
| Reports created by user | Immediate deletion | GDPR right to erasure |
| Comments by user | Immediate deletion | Removed with reports |
| Photos attached to reports | Immediate deletion | Removed from Supabase Storage |
| Content moderation reports | Immediate deletion | Tied to user identity |
| FCM tokens | Immediate deletion | Push notification cleanup |
| Crash logs (Crashlytics) | 90 days | Google-controlled, anonymized |
| Database backups | 30 days | Supabase automatic backup rotation |

**Note:** The `fixflow-cleanup` Edge Function executes all deletions atomically when "Delete Account" is confirmed. There is no deferred/soft-delete window — the deletion is irreversible and applies to all FixFlow data across all estates the user belonged to.

### Automated Cleanup
- **Expired announcements:** Deleted 30 days after expiration
- **Invitation codes:** Deactivated after expiration or max uses reached
- **Guest accounts (anonymous):** Session expires after inactivity, no persistent data

### Backup Retention
- **Database backups:** 30 days (Supabase default)
- **After deletion request:** User data removed from live DB, backups expire naturally
- **No restore after deletion:** Account deletion is **permanent**

### Third-Party Data Retention

#### Firebase/Google
- **Crashlytics:** 90 days automatic cleanup
- **Cloud Messaging:** FCM tokens deleted with account

#### Supabase
- **Database:** Controlled by our retention policy above
- **Storage (photos):** Deleted immediately and atomically when the account is
  deleted (`fixflow-cleanup` Edge Function) — no post-deletion retention window.
- **Auth:** Immediate deletion when account deleted

### Legal Requirements
- **Audit trail (`fixflow_report_events`):** the `user_id` reference is set to
  NULL on account deletion (`ON DELETE SET NULL`), but the `user_name`/`user_role`
  text snapshot on entries about OTHER users' reports (e.g. a technician who
  updated someone else's ticket) is **not currently anonymized** — this is a
  known gap, tracked for a follow-up migration, not a "1 year retention by
  design" feature.
- **Content moderation reports (`fixflow_content_reports`):** deleted along
  with the account by `fixflow-cleanup`, same as everything else — no
  extended retention.

### User Control
Users can request:
1. **Immediate deletion:** Via "Delete Account" in app
2. **Data export:** Contact support (GDPR Article 20)
3. **Deletion override:** Immediate removal of all data (support ticket required)

### Third-Party Services

| Service | Purpose | Data Shared |
|---------|---------|-------------|
| Supabase | Backend, database | All app data |
| Firebase Crashlytics | Crash reporting | Crash logs, device info |
| Firebase Cloud Messaging | Push notifications | FCM token |

## App Privacy (Apple App Store)

### Privacy Nutrition Label

**Data Used to Track You:** None

**Data Linked to You:**
- Contact Info (email, name, phone)
- User Content (photos, issue reports)
- Identifiers (user ID)

**Data Not Linked to You:**
- Crash Data
- Diagnostics

### Privacy Policy Requirements

Your privacy policy should include:
1. What data is collected
2. How data is used
3. Data retention policy
4. How to request deletion
5. Contact information

## GDPR Compliance (EU)

### Data Controller
Your company (property management software provider)

### Legal Basis for Processing
- **Consent:** User agrees to Terms of Service
- **Contract:** Processing necessary for service delivery
- **Legitimate Interest:** App functionality, security

### Data Subject Rights
| Right | Implementation |
|-------|----------------|
| Access | User can view all their data in Profile |
| Rectification | User can edit profile information |
| Erasure | Delete Account feature (see retention policy above) |
| Portability | Contact support for JSON export (within 30 days) |
| Objection | User can delete account or contact support |
| Restriction | Contact support to freeze data processing |

### Right to Erasure ("Right to be Forgotten")
When a user deletes their account, `fixflow-cleanup` deletes atomically and
immediately (see the Data Retention Policy table above for the full list):
profile, reports, comments, photos, content-moderation reports, estate
memberships, FCM token. There is **no deferred/soft-delete window** and no
"contact support to expedite" step — deletion via the in-app button is already
immediate. The only known gap is the audit-trail text snapshot (see Legal
Requirements above), tracked for a follow-up fix, not an intentional retention
period.

### Data Processing Agreement (DPA)
Required with:
- Supabase (backend provider)
- Google/Firebase (analytics, push)

## Security Measures

### Authentication
- Email/password via Supabase Auth
- Anonymous guest accounts supported
- Session tokens with automatic refresh

### Authorization (RLS)
- Row Level Security on all tables
- Users can only access their estate's data
- Subscription status gating (blocked without active sub)

### Data Isolation
- Multi-tenant with `estate_id` filtering
- Cross-estate access prevented by RLS
- Admin-only tables for secrets (Trello keys)

## Implementation Notes

### Automated Data Cleanup (TODO)
To fully implement the retention policy, create Supabase Edge Functions or Database Triggers:

Account deletion itself is already immediate (`fixflow-cleanup`, no TODO
there). What's still missing is cleanup for data belonging to **active**
accounts that has simply gone stale:

1. **Expired Announcements Cleanup** — the DB function already exists
   (`fixflow_cleanup_expired_announcements()`, migration `0032`) but nothing
   calls it on a schedule yet. Needs a pg_cron job or a scheduled Edge
   Function invocation.
   ```sql
   SELECT fixflow_cleanup_expired_announcements();
   ```

2. **Audit trail anonymization** — see "Legal Requirements" above:
   `fixflow_report_events.user_name`/`user_role` for a deleted user are not
   anonymized when they appear on someone else's report. Needs a migration to
   either NULL these columns via the same `ON DELETE` path, or a periodic job.

3. **Old content-moderation reports** for accounts that were never deleted
   (resolved/dismissed reports lingering indefinitely) — no retention job
   exists yet; not currently a GDPR blocker since these rows contain the
   *reporter's* own identity, removed automatically when they delete their
   account, but still worth a periodic cleanup for hygiene.

**Recommended:** Set up Supabase Database Webhooks or pg_cron jobs for automated execution.

## Checklist Before Store Submission

### Google Play
- [ ] Complete Data Safety form in Play Console
- [ ] Ensure no IAP product IDs in app
- [ ] Privacy policy URL in store listing
- [ ] Target API level compliance

### App Store
- [ ] Complete App Privacy questionnaire
- [ ] Ensure no StoreKit/IAP code active
- [ ] Privacy policy URL in App Store Connect
- [ ] Export compliance (uses encryption)

### Both Stores
- [ ] Test app without any payment flow
- [ ] Verify Delete Account works completely
- [ ] Confirm no pricing/payment UI visible
- [ ] Test invitation code flow end-to-end

# Mestio - Review Notes for App Store & Google Play

## Overview
Mestio (formerly FixFlow) is a comprehensive incident and defect management system for housing communities (cooperatives and homeowners associations). The app connects residents, property managers, and technicians, enabling efficient reporting and resolution of maintenance issues.

## Test Account Credentials

### Manager Account (Full Access)
- **Email:** demo-manager@fixflow.app
- **Password:** Demo123!
- **Role:** Property Manager
- **Access:** Full dashboard, report management, announcements, resident management

### Resident Account (Limited Access)
- **Email:** demo-resident@fixflow.app
- **Password:** Demo123!
- **Role:** Resident
- **Access:** Create reports, view announcements, view own reports, emergency contacts

## Key Features to Test

### 1. Authentication Flow
- **Guest Access:** Tap "Continue as guest" on the Welcome screen (Supabase anonymous auth). After guest sign-in, complete the registration wizard (name, phone, invitation code) — use code **`TEST-1234-ABCD`** to join the demo estate as a resident instantly (see "Invitation Code System" below for how other roles work).
- **Email Login:** Use credentials above (already-registered demo accounts skip the wizard).
- **Sign in with Apple:** Not offered. The app only has email/password + guest (anonymous) auth. There is no third-party or social login, so Apple Sign-In is not required by Guideline 4.8.
- **Password Reset:** Available via "Forgot password" flow

### 2. Report Management (Manager View)
1. Login as manager
2. Navigate to "Home" tab
3. View dashboard with:
   - Active reports count
   - Latest announcements
   - Quick stats
4. Tap on any report to:
   - View details
   - Add comments
   - Change status (Open → In Progress → Completed)
   - Assign priority (Low, Normal, High, Critical)
   - View audit trail
5. Create new report via "+" button

### 3. Resident Experience
1. Login as resident
2. View home screen with:
   - Building status
   - Latest announcement
   - Active reports summary
3. Create new report:
   - Add title, description, location
   - Attach photos (optional)
   - Submit
4. View report details:
   - Track status
   - Add comments
   - Rate completed reports (CSAT)

### 4. Announcements
- **Manager:** Create announcements for all residents or specific buildings
- **Resident:** View announcements on home screen
- **Moderation:** ✅ Residents can report inappropriate announcements (required for store compliance)

### 5. Emergency Contacts
- Both manager and resident can view emergency contacts
- Quick access to essential services (plumber, electrician, etc.)

### 6. Content Moderation (UGC Reporting)
✅ **Required for App Store & Google Play Compliance**

**How to Test:**
1. Login as resident
2. Navigate to any announcement or comment
3. Tap the flag icon (🚩) in the top-right corner
4. Select reason:
   - Spam
   - Harassment
   - Inappropriate content
   - Misinformation
   - Privacy violation
   - Other
5. Optionally add description
6. Submit report

**Backend Protection:**
- Rate limiting: 5 reports per user per 24 hours
- Duplicate prevention: Can't report same content twice
- Manager review queue (future feature)

### 7. Invitation Code System
- **Manager:** Can generate one active code per role (resident/technician/security/admin/board) in Profile → "Kody zaproszeń", with copy + rotate.
- **Code Format:** `XXXX-XXXX-XXXX` (e.g. `TEST-1234-ABCD` — permanent demo resident code, no expiry/use limit).
- **Role comes from the code**, not a picker — residents join their estate immediately; technician/security/admin codes queue the user in a "pending approval" screen until the office (admin/board) approves the join request.
- **Security:** Rate limited (5 attempts / 15 min), per-role capacity limits (max 5 admins/board members, max 4 residents per apartment).

## Business Model (Important for Review)

### B2B SaaS - NO In-App Purchases
- ✅ App is **FREE** for all users
- ✅ **NO subscription prompts** in the app
- ✅ **NO payment buttons** or price displays
- ✅ **NO RevenueCat or StoreKit integrations** visible to users

### How It Works:
1. Property managers subscribe via **external website** (Stripe)
2. Subscription managed through invitation codes
3. App checks subscription status via backend (Supabase)
4. **Zero app store commission** (complies with Apple 3.1.3(b) & Google Play policies for B2B/enterprise apps)

**Why this matters for reviewers:**
- No IAP = No app store fees
- No risk of Apple/Google policy violations
- Business payments happen outside the app ecosystem
- Multi-platform reader app exception does NOT apply (this is B2B enterprise, not reader content)

## Privacy & Data Protection

### Data Collection
- User profile: name, email, phone, apartment location (building/stairwell/floor/apartment)
- Reports: title, description, category, optional GPS coordinates, optional photos
- Comments: text (internal team notes are never shown to residents, enforced by RLS)

### Data Retention
- Active data: retained while the account exists
- On "Delete Account": all of the user's data (profile, reports, comments,
  photos, estate memberships, FCM token) is deleted **immediately and
  atomically** — no deferred/grace window. See `docs/DATA_SAFETY.md` for
  the full table.

### User Rights
- **View data:** Profile screen shows all personal data
- **Delete account:** Profile → Delete Account (requires confirmation)
- **Data export:** Contact support (GDPR compliance)

### Third-Party Services
- **Supabase:** Database, authentication, storage
- **Firebase:** Crashlytics (crash reporting), Cloud Messaging (push notifications)

## Technical Details

### Platform Requirements
- **iOS:** 16.0+
- **Android:** minSdk 26 (Android 8.0+), targetSdk 36

### Permissions Requested
- **Camera:** Optional, for report photos
- **Photo Library:** Optional, for attaching existing photos
- **Notifications:** Optional, for report updates

### Offline Functionality
- Reports created offline are queued
- Synchronized when connection restored
- Visual indicator for offline mode

### Security Features
- Row-Level Security (RLS) on all database tables
- Rate limiting on sensitive operations
- Input validation and sanitization
- Secure password reset flow (OTP-based)
- Content moderation with rate limiting

## Known Limitations (By Design)
1. **No RevenueCat:** Intentionally disabled at runtime (B2B model, no IAP) —
   see the "Business Model" section above. The code/dependency still exists
   in the repo behind a hard-coded flag (`RevenueCatConfig.fixflowB2bMode`);
   nothing is shown to reviewers or users.
2. **Web:** A management CRM web build exists for property managers/board
   (browser-only, separate use case from the reviewed mobile app) — not part
   of what App Store/Google Play review.
3. **Multi-language:** Polish, English, Ukrainian.

## Support & Documentation
- **Email:** aivolux@gmail.com
- **Privacy Policy:** https://mestio.pl/privacy-policy
- **Terms of Service:** https://mestio.pl/terms-of-service

## Testing Checklist

### Must Test
- [ ] Login with demo-manager@fixflow.app
- [ ] Login with demo-resident@fixflow.app
- [ ] Create a new report (both roles)
- [ ] Add comment to existing report
- [ ] Change report status (manager only)
- [ ] View announcements
- [ ] Report inappropriate content (flag button)
- [ ] View emergency contacts
- [ ] Sign in with Apple (not offered — N/A)

### Optional
- [ ] Create new announcement (manager)
- [ ] Generate invitation code (manager)
- [ ] Use invitation code (resident)
- [ ] Delete account flow
- [ ] Offline report creation

## Common Reviewer Questions

### Q: Why no payment options in the app?
**A:** Mestio uses a B2B SaaS model. Property managers subscribe via our website (Stripe), not through app stores. This complies with Apple 3.1.3(b) and Google Play policies for enterprise/B2B software.

### Q: How do users subscribe?
**A:** Property managers visit our website, subscribe via Stripe, and receive invitation codes. Residents use these codes to join their community for free.

### Q: What about App Store Guidelines 3.1.3(b)?
**A:** We comply under the B2B/enterprise exception:
- Not offering IAP for digital services
- Payment happens on external website (before app download, managed by property manager)
- No "Subscribe" or "Upgrade" buttons in-app
- Business model is B2B, not B2C — end users never pay
- App provides real functionality without any purchase

### Q: Is content moderation implemented?
**A:** Yes! Users can report announcements and comments via flag button. Backend enforces rate limiting (5 reports/24h) and duplicate prevention.

### Q: What happens if a demo account expires?
**A:** Demo accounts have 1-year subscriptions (auto-renewed for testing). If expired, contact us to refresh.

## Emergency Contact
If reviewers encounter any issues:
- **Email:** aivolux@gmail.com
- **Response time:** Within 24 hours
- **Timezone:** CET (Central European Time)

---

**Thank you for reviewing Mestio!** We're committed to providing housing communities with efficient, user-friendly incident management.

# FixFlow Stripe Setup Guide

## Overview

FixFlow uses a B2B monetization model where payment happens **outside the app** via Stripe on the website. This means:
- **0% App Store / Google Play commission** (no IAP)
- Only ~2-3% Stripe processing fee
- Property managers pay, residents get free access with invitation codes

## Stripe Keys Required

You need two keys from Stripe Dashboard → Developers → API keys:

| Key | Format | Purpose |
|-----|--------|---------|
| `STRIPE_SECRET_KEY` | `sk_test_...` or `sk_live_...` | Server-side API calls |
| `STRIPE_WEBHOOK_SECRET` | `whsec_...` | Verify webhook signatures |

### Test vs Live Keys

- **Test mode** (`sk_test_...`): Use for development. Fake payments, no real charges.
- **Live mode** (`sk_live_...`): Use for production. Real payments, real money.

## Supabase Configuration

### 1. Add Secrets to Edge Functions

Go to: **Supabase Dashboard → Edge Functions → stripe-webhook → Secrets**

Add these secrets:
```
STRIPE_SECRET_KEY = sk_test_YOUR_KEY_HERE
STRIPE_WEBHOOK_SECRET = whsec_YOUR_WEBHOOK_SECRET_HERE
```

### 2. Verify Edge Function Deployment

The `stripe-webhook` function should be deployed with `--no-verify-jwt` (public endpoint):
```bash
npx supabase functions deploy stripe-webhook --no-verify-jwt --project-ref <your-ref>
```

## Stripe Webhook Configuration

### 1. Create Webhook Endpoint

Go to: **Stripe Dashboard → Developers → Webhooks → Add endpoint**

- **Endpoint URL:** `https://<your-project>.supabase.co/functions/v1/stripe-webhook`
- **Events to send:**
  - `checkout.session.completed` (initial purchase)
  - `customer.subscription.created`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `invoice.payment_failed`

### 2. Get Webhook Secret

After creating the endpoint, click "Reveal" on the signing secret. It starts with `whsec_`.

## Integration Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  YOUR WEBSITE (Landing Page for Property Managers)              │
│  1. Manager registers and provides estate name                  │
│  2. Redirects to Stripe Checkout with:                         │
│     - client_reference_id = Supabase user.id                   │
│     - metadata.estate_name = "Osiedle Słoneczne"               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STRIPE CHECKOUT                                                │
│  Manager pays subscription fee                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  STRIPE WEBHOOK → stripe-webhook Edge Function                  │
│  1. Verify signature (constructEventAsync)                      │
│  2. Call fixflow_provision_subscription() RPC                   │
│     - Creates estate                                            │
│     - Adds manager as admin                                     │
│     - Generates invitation code                                 │
│     - Records subscription                                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  FIXFLOW APP                                                    │
│  1. Manager logs in, sees their new estate                      │
│  2. Shares invitation code with residents                       │
│  3. Residents download free app, enter code                     │
└─────────────────────────────────────────────────────────────────┘
```

## Checkout Session Setup (Website Code)

Example Node.js/JavaScript code for your website:

```javascript
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// After manager registers and logs in (get their Supabase user.id)
const session = await stripe.checkout.sessions.create({
  mode: 'subscription',
  payment_method_types: ['card'],
  line_items: [{
    price: 'price_XXXXXXXX', // Your Stripe price ID
    quantity: 1,
  }],
  // CRITICAL: Pass Supabase user ID for provisioning
  client_reference_id: supabaseUserId,
  metadata: {
    estate_name: formData.estateName, // From registration form
  },
  success_url: 'https://yoursite.com/success?session_id={CHECKOUT_SESSION_ID}',
  cancel_url: 'https://yoursite.com/cancel',
});

// Redirect to session.url
```

## Subscription Status Handling

| Stripe Status | App Behavior |
|---------------|--------------|
| `active` | Full access |
| `trialing` | Full access (trial period) |
| `past_due` | Full access for 7 days (grace period), then blocked |
| `canceled` | Blocked immediately |
| `unpaid` | Blocked immediately |

## Testing

### 1. Stripe Test Cards

Use these in test mode:
- **Success:** `4242 4242 4242 4242`
- **Decline:** `4000 0000 0000 0002`
- **3D Secure:** `4000 0025 0000 3155`

### 2. Test Webhook Locally

```bash
# Install Stripe CLI
# Forward webhooks to local Supabase
stripe listen --forward-to http://localhost:54321/functions/v1/stripe-webhook
```

### 3. Verify Provisioning

After successful payment, check:
1. `fixflow_estates` - new estate created
2. `fixflow_user_estates` - manager is admin
3. `fixflow_invitation_codes` - code generated
4. `fixflow_subscriptions` - subscription recorded

## Troubleshooting

### "Subscription not found" error
The webhook received an update for a subscription that wasn't provisioned. Check:
- Was `checkout.session.completed` received first?
- Is `client_reference_id` set correctly?

### "Invalid signature" error
- Verify `STRIPE_WEBHOOK_SECRET` matches the endpoint's signing secret
- Make sure you're using the correct secret for test vs live mode

### RLS blocks access after payment
- Check `fixflow_subscriptions.status` = 'active'
- Verify `estate_id` is linked to subscription
- Run: `SELECT * FROM v_fixflow_estate_subscription_status WHERE estate_id = '...'`

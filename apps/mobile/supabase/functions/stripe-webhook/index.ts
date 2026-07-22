/**
 * FixFlow Stripe Webhook Handler
 * 
 * Handles Stripe subscription events and provisions estates.
 * Deploy with: npx supabase functions deploy stripe-webhook --no-verify-jwt --project-ref <ref>
 * 
 * SECURITY: This endpoint is PUBLIC (no JWT) but verifies Stripe signature.
 * Set STRIPE_WEBHOOK_SECRET in Supabase Dashboard -> Edge Functions -> Secrets
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import Stripe from "npm:stripe@14";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const stripeSecretKey = Deno.env.get("STRIPE_SECRET_KEY") ?? "";
const stripeWebhookSecret = Deno.env.get("STRIPE_WEBHOOK_SECRET") ?? "";

if (!supabaseUrl || !supabaseServiceRoleKey) {
  throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

const stripe = stripeSecretKey ? new Stripe(stripeSecretKey, { apiVersion: "2023-10-16" }) : null;

const json = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

serve(async (req: Request) => {
  // Only accept POST
  if (req.method !== "POST") {
    return json(405, { error: "method_not_allowed" });
  }

  // Check if Stripe is configured
  if (!stripe || !stripeWebhookSecret) {
    console.warn("Stripe not configured - webhook disabled");
    return json(200, { 
      received: true, 
      warning: "Stripe not configured - event logged but not processed" 
    });
  }

  try {
    // Get raw body for signature verification
    const body = await req.text();
    const signature = req.headers.get("stripe-signature");

    if (!signature) {
      console.error("Missing stripe-signature header");
      return json(400, { error: "missing_signature" });
    }

    // CRITICAL: Verify webhook signature with constructEventAsync
    let event: Stripe.Event;
    try {
      event = await stripe.webhooks.constructEventAsync(
        body,
        signature,
        stripeWebhookSecret
      );
    } catch (err) {
      console.error("Webhook signature verification failed:", err);
      return json(400, { error: "invalid_signature" });
    }

    console.log(`Received Stripe event: ${event.type} (${event.id})`);

    // Create Supabase client with service role (bypasses RLS)
    const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    // Handle different event types
    // IMPORTANT: Use event.data.object, NOT event.object
    switch (event.type) {
      case "customer.subscription.created":
      case "checkout.session.completed": {
        await handleSubscriptionCreated(supabase, event);
        break;
      }

      case "customer.subscription.updated": {
        await handleSubscriptionUpdated(supabase, event);
        break;
      }

      case "customer.subscription.deleted": {
        await handleSubscriptionDeleted(supabase, event);
        break;
      }

      case "invoice.payment_failed": {
        await handlePaymentFailed(supabase, event);
        break;
      }

      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    return json(200, { received: true, event_type: event.type });

  } catch (error) {
    console.error("Webhook error:", error);
    return json(500, { error: "webhook_processing_failed" });
  }
});

/**
 * Handle new subscription - provision estate + admin + invitation code
 */
async function handleSubscriptionCreated(
  supabase: ReturnType<typeof createClient>,
  event: Stripe.Event
) {
  let subscription: Stripe.Subscription;
  let userId: string | null = null;
  let estateName: string | null = null;

  if (event.type === "checkout.session.completed") {
    const session = event.data.object as Stripe.Checkout.Session;
    
    // Get user_id from client_reference_id (must be set in checkout)
    userId = session.client_reference_id ?? null;
    estateName = session.metadata?.estate_name ?? null;
    
    // Get subscription from session
    if (!session.subscription) {
      console.log("Checkout session without subscription - skipping");
      return;
    }
    
    // Fetch full subscription object
    subscription = await stripe!.subscriptions.retrieve(session.subscription as string);
  } else {
    subscription = event.data.object as Stripe.Subscription;
    userId = subscription.metadata?.user_id ?? null;
    estateName = subscription.metadata?.estate_name ?? null;
  }

  console.log(`Provisioning subscription: ${subscription.id} for user: ${userId}`);

  // Call provision function (IDEMPOTENT - safe to call multiple times)
  const { data, error } = await supabase.rpc("fixflow_provision_subscription", {
    p_stripe_subscription_id: subscription.id,
    p_stripe_customer_id: subscription.customer as string,
    p_stripe_price_id: subscription.items.data[0]?.price.id ?? null,
    p_user_id: userId,
    p_estate_name: estateName ?? "Moje Osiedle",
    p_status: subscription.status,
    p_current_period_start: new Date(subscription.current_period_start * 1000).toISOString(),
    p_current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
    p_metadata: subscription.metadata ?? {},
  });

  if (error) {
    console.error("Provision error:", error);
    throw new Error(`Provision failed: ${error.message}`);
  }

  console.log("Provision result:", data);
}

/**
 * Handle subscription update - status change, renewal, etc.
 */
async function handleSubscriptionUpdated(
  supabase: ReturnType<typeof createClient>,
  event: Stripe.Event
) {
  const subscription = event.data.object as Stripe.Subscription;

  console.log(`Updating subscription: ${subscription.id} to status: ${subscription.status}`);

  const { data, error } = await supabase.rpc("fixflow_update_subscription_status", {
    p_stripe_subscription_id: subscription.id,
    p_status: subscription.status,
    p_current_period_start: new Date(subscription.current_period_start * 1000).toISOString(),
    p_current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
    p_cancel_at_period_end: subscription.cancel_at_period_end,
  });

  if (error) {
    console.error("Update error:", error);
    throw new Error(`Update failed: ${error.message}`);
  }

  console.log("Update result:", data);
}

/**
 * Handle subscription deletion - mark as canceled
 */
async function handleSubscriptionDeleted(
  supabase: ReturnType<typeof createClient>,
  event: Stripe.Event
) {
  const subscription = event.data.object as Stripe.Subscription;

  console.log(`Canceling subscription: ${subscription.id}`);

  const { data, error } = await supabase.rpc("fixflow_update_subscription_status", {
    p_stripe_subscription_id: subscription.id,
    p_status: "canceled",
    p_current_period_start: null,
    p_current_period_end: null,
    p_cancel_at_period_end: true,
  });

  if (error) {
    console.error("Cancel error:", error);
    throw new Error(`Cancel failed: ${error.message}`);
  }

  console.log("Cancel result:", data);
}

/**
 * Handle payment failure - mark as past_due
 * IMPORTANT: We use grace period (7 days) before locking out users
 */
async function handlePaymentFailed(
  supabase: ReturnType<typeof createClient>,
  event: Stripe.Event
) {
  const invoice = event.data.object as Stripe.Invoice;
  
  if (!invoice.subscription) {
    console.log("Invoice without subscription - skipping");
    return;
  }

  const subscriptionId = typeof invoice.subscription === "string" 
    ? invoice.subscription 
    : invoice.subscription.id;

  console.log(`Payment failed for subscription: ${subscriptionId}`);

  // Mark as past_due - grace period is handled in v_fixflow_estate_subscription_status view
  const { data, error } = await supabase.rpc("fixflow_update_subscription_status", {
    p_stripe_subscription_id: subscriptionId,
    p_status: "past_due",
    p_current_period_start: null,
    p_current_period_end: null,
    p_cancel_at_period_end: null,
  });

  if (error) {
    console.error("Payment failed update error:", error);
    throw new Error(`Payment failed update error: ${error.message}`);
  }

  console.log("Payment failed result:", data);
}

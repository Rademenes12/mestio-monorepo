-- Seed active subscriptions for ALL existing estates (development mode)
-- Run this to enable app testing without Stripe

INSERT INTO public.fixflow_subscriptions (
  stripe_subscription_id,
  stripe_customer_id,
  estate_id,
  status,
  current_period_start,
  current_period_end
)
SELECT 
  'sub_dev_' || id::text,
  'cus_dev_' || id::text,
  id,
  'active',
  now(),
  now() + interval '1 year'
FROM public.fixflow_estates
ON CONFLICT (stripe_subscription_id) DO UPDATE SET
  status = 'active',
  current_period_end = now() + interval '1 year',
  updated_at = now();

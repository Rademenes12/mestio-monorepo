-- Migracja: dodanie stripe_payment_intent_id do fixflow_invoices
-- Obsluguje BLIK/P24 (mode: payment) gdzie nie ma subscription_id
ALTER TABLE fixflow_invoices ADD COLUMN IF NOT EXISTS stripe_payment_intent_id text;
COMMENT ON COLUMN fixflow_invoices.stripe_payment_intent_id IS 'Stripe PaymentIntent ID dla platnosci jednorazowych (BLIK/P24). NULL dla subskrypcji.';

CREATE TABLE IF NOT EXISTS fixflow_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number TEXT UNIQUE NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  estate_id UUID NOT NULL REFERENCES fixflow_estates(id),
  subscription_id TEXT NOT NULL,
  plan_name TEXT NOT NULL,
  period_start TIMESTAMPTZ NOT NULL,
  period_end TIMESTAMPTZ NOT NULL,
  amount_net INTEGER NOT NULL,
  vat_rate INTEGER NOT NULL DEFAULT 23,
  amount_vat INTEGER NOT NULL,
  amount_gross INTEGER NOT NULL,
  currency TEXT NOT NULL DEFAULT 'PLN',
  buyer_company TEXT NOT NULL,
  buyer_nip TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'issued' CHECK (status IN ('issued', 'paid', 'cancelled')),
  html_content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_invoices_user_id ON fixflow_invoices(user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_invoices_estate_id ON fixflow_invoices(estate_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_invoices_invoice_number ON fixflow_invoices(invoice_number);

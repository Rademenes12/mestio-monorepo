CREATE TABLE IF NOT EXISTS fixflow_transfer_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  estate_name TEXT NOT NULL,
  plan TEXT NOT NULL,
  amount INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'expired')),
  transfer_title TEXT UNIQUE NOT NULL,
  due_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_transfer_payments_user_id ON fixflow_transfer_payments(user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_transfer_payments_status ON fixflow_transfer_payments(status);
CREATE INDEX IF NOT EXISTS idx_fixflow_transfer_payments_transfer_title ON fixflow_transfer_payments(transfer_title);

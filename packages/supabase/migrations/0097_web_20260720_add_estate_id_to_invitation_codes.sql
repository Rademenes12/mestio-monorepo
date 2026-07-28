-- ============================================
-- Migracja: dodanie estate_id do fixflow_invitation_codes
-- Data: 2026-07-20
-- Problem: webhook próbuje pisać estate_id, tabela ma tylko building_id/stairwell_id
-- ============================================

ALTER TABLE public.fixflow_invitation_codes
  ADD COLUMN IF NOT EXISTS estate_id UUID REFERENCES public.fixflow_estates(id);

-- Indeks dla szybszego lookup po estate_id
CREATE INDEX IF NOT EXISTS ix_fixflow_invitation_codes_estate_id
  ON public.fixflow_invitation_codes(estate_id);

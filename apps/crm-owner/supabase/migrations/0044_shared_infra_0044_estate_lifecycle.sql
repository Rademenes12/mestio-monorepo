-- Migration: Estate lifecycle (MASTER_BUILD §14)
-- Description: Adds lifecycle status (active/archived/purged) and owner_company_id
-- to fixflow_estates. Archived estates enter a 30-day grace period (read-only),
-- purge permanently deletes data (GDPR). Transfer changes owner_company_id while
-- residents and history stay.
--
-- This migration adds columns + helper only; archive/transfer/purge flows come later.

ALTER TABLE public.fixflow_estates
ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'active'
  CHECK (status IN ('active', 'archived', 'purged')),
ADD COLUMN IF NOT EXISTS owner_company_id uuid,
ADD COLUMN IF NOT EXISTS archived_at timestamptz;

COMMENT ON COLUMN public.fixflow_estates.status IS
  'Lifecycle: active -> archived (30-day reversible grace, read-only) -> purged (GDPR delete)';
COMMENT ON COLUMN public.fixflow_estates.owner_company_id IS
  'Platform-level owning company (for estate transfer between managing companies)';
COMMENT ON COLUMN public.fixflow_estates.archived_at IS
  'When the estate was archived; purge eligibility = archived_at + 30 days';

CREATE INDEX IF NOT EXISTS idx_fixflow_estates_status ON public.fixflow_estates(status);

-- Helper used by RLS policies: estate is operational only while active.
-- SECURITY DEFINER so it can read fixflow_estates regardless of caller policies.
CREATE OR REPLACE FUNCTION public.fixflow_estate_active(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_estates
    WHERE id = p_estate_id AND status = 'active'
  );
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_estate_active(uuid) TO authenticated;

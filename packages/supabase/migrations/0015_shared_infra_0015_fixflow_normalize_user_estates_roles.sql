-- FixFlow — normalize user_estates.role values and make admin checks robust
-- ============================================================================
-- The app historically stored display roles (e.g. 'Administrator', 'Zarząd')
-- in fixflow_user_estates.role, but RLS policies expect the membership role
-- namespace: 'admin' or 'resident'. This migration fixes existing data and
-- makes the helper function tolerate legacy values until all clients update.
-- ============================================================================

-- Make the admin check case-insensitive and treat any non-resident role as
-- admin. This fixes RLS for users whose membership role was stored as a
-- display label (Administrator, Zarząd, Serwisant, Ochrona, etc.).
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_admin(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND estate_id = p_estate_id
      AND lower(role) != 'resident'
      AND lower(role) != 'mieszkaniec'
  );
$$;

-- Backfill: convert display roles to membership roles so future code can rely
-- on the canonical 'admin'/'resident' values.
UPDATE public.fixflow_user_estates
SET role = 'resident'
WHERE lower(role) IN ('resident', 'mieszkaniec');

UPDATE public.fixflow_user_estates
SET role = 'admin'
WHERE lower(role) NOT IN ('admin', 'resident', 'mieszkaniec');

-- Grant execute to authenticated users (idempotent).
GRANT EXECUTE ON FUNCTION public.fixflow_is_estate_admin(uuid) TO authenticated;

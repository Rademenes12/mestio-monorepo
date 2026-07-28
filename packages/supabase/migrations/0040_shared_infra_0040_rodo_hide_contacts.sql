-- =====================================================
-- RODO toggle: hide resident contacts for board role
-- =====================================================
-- When hide_resident_contacts is true on fixflow_estates:
--   - 'admin' role sees full data
--   - 'board' role sees masked phone/email ('ukryte (RODO)')
--   - 'resident' role already sees only their own profile via RLS
--
-- Uses a helper function for reusable, consistent masking logic
-- across all policies that read fixflow_resident_profiles.

CREATE OR REPLACE FUNCTION public.fixflow_maybe_mask_contacts(
  p_estate_id uuid,
  p_phone text,
  p_email text
)
RETURNS TABLE(phone text, email text)
LANGUAGE sql
STABLE
AS $$
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1 FROM public.fixflow_user_estates
        WHERE user_id = auth.uid()
          AND estate_id = p_estate_id
          AND role = 'admin'
      ) THEN p_phone
      WHEN EXISTS (
        SELECT 1 FROM public.fixflow_user_estates
        WHERE user_id = auth.uid()
          AND estate_id = p_estate_id
          AND role = 'board'
      ) AND EXISTS (
        SELECT 1 FROM public.fixflow_estates
        WHERE id = p_estate_id
          AND hide_resident_contacts = true
      ) THEN CASE WHEN p_phone IS NOT NULL THEN 'ukryte (RODO)' END
      ELSE p_phone
    END AS phone,
    CASE
      WHEN EXISTS (
        SELECT 1 FROM public.fixflow_user_estates
        WHERE user_id = auth.uid()
          AND estate_id = p_estate_id
          AND role = 'admin'
      ) THEN p_email
      WHEN EXISTS (
        SELECT 1 FROM public.fixflow_user_estates
        WHERE user_id = auth.uid()
          AND estate_id = p_estate_id
          AND role = 'board'
      ) AND EXISTS (
        SELECT 1 FROM public.fixflow_estates
        WHERE id = p_estate_id
          AND hide_resident_contacts = true
      ) THEN CASE WHEN p_email IS NOT NULL THEN 'ukryte (RODO)' END
      ELSE p_email
    END AS email;
$$;

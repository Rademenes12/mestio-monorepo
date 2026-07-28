-- =====================================================
-- Permanent invitation codes: use proper format, no expiry
-- =====================================================
-- Updates fixflow_create_estate_invitation_code to:
--   1. Use fixflow_generate_code_string() (XXXX-XXXX-XXXX)
--      instead of the old 6-char md5 approach.
--   2. Set max_uses = NULL (unlimited) and expires_at = NULL
--      (permanent) by default, matching the CRM spec of
--      "always active invitation codes".
--   3. Only estate admins can create codes (unchanged).

CREATE OR REPLACE FUNCTION public.fixflow_create_estate_invitation_code(
  p_estate_id uuid
)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_code text;
BEGIN
  IF NOT public.fixflow_is_estate_admin(p_estate_id) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Deactivate all existing codes before creating a new one (rotation)
  UPDATE public.fixflow_invitation_codes
  SET is_active = false,
      updated_at = now()
  WHERE estate_id = p_estate_id
    AND is_active = true;

  -- Generate a new permanent code
  v_code := public.fixflow_generate_code_string();

  INSERT INTO public.fixflow_invitation_codes (estate_id, code, max_uses, expires_at, is_active)
  VALUES (p_estate_id, v_code, NULL, NULL, true)
  RETURNING code INTO v_code;

  RETURN v_code;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_create_estate_invitation_code
  TO authenticated;

COMMENT ON FUNCTION public.fixflow_create_estate_invitation_code IS
  'Generates a permanent (no expiry, unlimited uses) invitation code in XXXX-XXXX-XXXX format. Rotates by deactivating the previous code.';

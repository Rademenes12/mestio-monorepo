-- Migration: Per-role invitation codes + join requests + registration limits
-- (FixFlow_KODY_ZAPROSZEN + FixFlow_REJESTRACJA_KOD specs)
--
-- Model change: one shared estate code -> separate code per (estate, role).
-- The code now determines the user's role - users no longer pick a role at
-- registration (closes the "anyone can make themselves board" hole).
--   - resident         -> auto_join = true, joins immediately
--   - technician/security -> join_request, approved by admin/board
--   - admin            -> join_request, approved only by board
-- Limits: admin <= 5, board <= 5 per estate; resident <= 4 per apartment.

-- ============================================================
-- 1. invitation_codes: role + auto_join
-- ============================================================
ALTER TABLE public.fixflow_invitation_codes
ADD COLUMN IF NOT EXISTS role text NOT NULL DEFAULT 'resident'
  CHECK (role IN ('resident', 'technician', 'security', 'admin', 'board')),
ADD COLUMN IF NOT EXISTS auto_join boolean NOT NULL DEFAULT false;

-- Backfill: all pre-existing codes were resident codes with instant join.
UPDATE public.fixflow_invitation_codes
SET auto_join = true
WHERE role = 'resident';

-- One ACTIVE code per (estate, role). Deactivate older duplicates first.
UPDATE public.fixflow_invitation_codes ic
SET is_active = false, updated_at = now()
WHERE ic.is_active = true
  AND EXISTS (
    SELECT 1 FROM public.fixflow_invitation_codes newer
    WHERE newer.estate_id = ic.estate_id
      AND newer.role = ic.role
      AND newer.is_active = true
      AND newer.created_at > ic.created_at
  );

CREATE UNIQUE INDEX IF NOT EXISTS idx_fixflow_invitation_codes_active_per_role
ON public.fixflow_invitation_codes (estate_id, role)
WHERE is_active = true;

-- ============================================================
-- 2. user_estates: role check + resident location (per-apartment limit)
-- ============================================================
ALTER TABLE public.fixflow_user_estates
ADD COLUMN IF NOT EXISTS building text,
ADD COLUMN IF NOT EXISTS stairwell text,
ADD COLUMN IF NOT EXISTS floor text,
ADD COLUMN IF NOT EXISTS apartment text;

-- ============================================================
-- 3. join_requests
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_join_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('technician', 'security', 'admin', 'board')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  info text,
  created_at timestamptz DEFAULT now(),
  decided_at timestamptz,
  decided_by uuid
);

CREATE INDEX IF NOT EXISTS idx_fixflow_join_requests_estate
ON public.fixflow_join_requests(estate_id, status);

-- Only one pending request per user per estate.
CREATE UNIQUE INDEX IF NOT EXISTS idx_fixflow_join_requests_pending_unique
ON public.fixflow_join_requests (user_id, estate_id)
WHERE status = 'pending';

ALTER TABLE public.fixflow_join_requests ENABLE ROW LEVEL SECURITY;

-- Requester sees own requests (to render the "waiting" screen).
DROP POLICY IF EXISTS join_requests_select ON public.fixflow_join_requests;
CREATE POLICY join_requests_select ON public.fixflow_join_requests
FOR SELECT USING (
  user_id = (SELECT auth.uid())
  OR public.fixflow_is_estate_admin(estate_id)
);

-- Inserts and decisions happen only via SECURITY DEFINER RPCs; no direct
-- INSERT/UPDATE policies on purpose.

GRANT SELECT ON public.fixflow_join_requests TO authenticated;

-- ============================================================
-- 4. Office helper hardening: technician/security are NOT office.
--    (Previously "role != resident" would treat them as estate admins.)
-- ============================================================
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_admin(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND estate_id = p_estate_id
      AND lower(role) IN ('admin', 'board')
  );
$$;

-- ============================================================
-- 5. Peek RPC: validate a code BEFORE registration to learn role + estate.
--    SECURITY DEFINER because the caller is not a member yet. Knowing the
--    code is the credential; returns nothing without a valid active code.
-- ============================================================
CREATE OR REPLACE FUNCTION public.fixflow_peek_invitation_code(p_code text)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_rec record;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  IF p_code !~ '^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$' THEN
    RAISE EXCEPTION 'invalid_code_format';
  END IF;

  SELECT ic.role, ic.estate_id, e.name AS estate_name
  INTO v_rec
  FROM public.fixflow_invitation_codes ic
  JOIN public.fixflow_estates e ON e.id = ic.estate_id
  WHERE UPPER(ic.code) = UPPER(p_code)
    AND ic.is_active = true
    AND (ic.expires_at IS NULL OR ic.expires_at > now())
    AND (ic.max_uses IS NULL OR COALESCE(ic.current_uses, 0) < ic.max_uses);

  IF NOT FOUND THEN
    RAISE EXCEPTION 'code_not_found_or_expired';
  END IF;

  RETURN jsonb_build_object(
    'role', v_rec.role,
    'estate_id', v_rec.estate_id,
    'estate_name', v_rec.estate_name
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_peek_invitation_code(text) TO authenticated;

-- ============================================================
-- 6. Redeem RPC v2: role from code, limits, auto_join vs pending.
--    Returns jsonb {status: joined|pending, estate_id, role}.
--    Errors keep the RAISE EXCEPTION errorKey convention used app-wide.
-- ============================================================
DROP FUNCTION IF EXISTS public.fixflow_redeem_invitation_code(text);

CREATE OR REPLACE FUNCTION public.fixflow_redeem_invitation_code(
  p_code text,
  p_building text DEFAULT NULL,
  p_stairwell text DEFAULT NULL,
  p_floor text DEFAULT NULL,
  p_apartment text DEFAULT NULL,
  p_info text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid;
  v_code_record record;
  v_estate_id uuid;
  v_attempt_count integer;
  v_role_count integer;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  -- Rate limiting: max 5 attempts per 15 minutes per user
  SELECT COUNT(*) INTO v_attempt_count
  FROM public.fixflow_code_redemption_attempts
  WHERE user_id = v_user_id
    AND attempted_at > now() - interval '15 minutes';

  IF v_attempt_count >= 5 THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'rate_limit_exceeded';
  END IF;

  IF p_code !~ '^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$' THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'invalid_code_format';
  END IF;

  SELECT * INTO v_code_record
  FROM public.fixflow_invitation_codes
  WHERE UPPER(code) = UPPER(p_code)
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > now())
    AND (max_uses IS NULL OR COALESCE(current_uses, 0) < max_uses)
  FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'code_not_found_or_expired';
  END IF;

  v_estate_id := v_code_record.estate_id;

  -- Estate must have an active lifecycle status (0044).
  IF NOT public.fixflow_estate_active(v_estate_id) THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'estate_inactive';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = v_user_id AND estate_id = v_estate_id
  ) THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'already_member';
  END IF;

  -- Role capacity limits: max 5 admins and 5 board members per estate.
  IF v_code_record.role IN ('admin', 'board') THEN
    SELECT COUNT(*) INTO v_role_count
    FROM public.fixflow_user_estates
    WHERE estate_id = v_estate_id AND role = v_code_record.role;
    IF v_role_count >= 5 THEN
      INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
      VALUES (v_user_id, false);
      RAISE EXCEPTION 'role_limit_reached';
    END IF;
  END IF;

  -- Resident limit: max 4 per apartment (family).
  IF v_code_record.role = 'resident' AND p_building IS NOT NULL THEN
    SELECT COUNT(*) INTO v_role_count
    FROM public.fixflow_user_estates
    WHERE estate_id = v_estate_id
      AND role = 'resident'
      AND building = p_building
      AND COALESCE(stairwell, '') = COALESCE(p_stairwell, '')
      AND COALESCE(floor, '') = COALESCE(p_floor, '')
      AND COALESCE(apartment, '') = COALESCE(p_apartment, '');
    IF v_role_count >= 4 THEN
      INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
      VALUES (v_user_id, false);
      RAISE EXCEPTION 'apartment_limit_reached';
    END IF;
  END IF;

  -- Count the use
  UPDATE public.fixflow_invitation_codes
  SET current_uses = COALESCE(current_uses, 0) + 1,
      updated_at = now(),
      is_active = CASE
        WHEN max_uses IS NOT NULL AND COALESCE(current_uses, 0) + 1 >= max_uses THEN false
        ELSE is_active
      END
  WHERE id = v_code_record.id;

  IF v_code_record.auto_join THEN
    -- Resident: joins immediately
    INSERT INTO public.fixflow_user_estates
      (user_id, estate_id, role, building, stairwell, floor, apartment)
    VALUES
      (v_user_id, v_estate_id, v_code_record.role,
       p_building, p_stairwell, p_floor, p_apartment);

    INSERT INTO public.fixflow_resident_profiles (id, role, name, email)
    SELECT
      v_user_id,
      'Mieszkaniec',
      COALESCE(su.first_name, 'Mieszkaniec'),
      au.email
    FROM auth.users au
    LEFT JOIN public.shared_users su ON su.id = v_user_id
    WHERE au.id = v_user_id
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, true);

    RETURN jsonb_build_object(
      'status', 'joined',
      'estate_id', v_estate_id,
      'role', v_code_record.role
    );
  ELSE
    -- Staff roles: queue for approval
    INSERT INTO public.fixflow_join_requests (estate_id, user_id, role, info)
    VALUES (v_estate_id, v_user_id, v_code_record.role, p_info)
    ON CONFLICT (user_id, estate_id) WHERE status = 'pending' DO NOTHING;

    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, true);

    RETURN jsonb_build_object(
      'status', 'pending',
      'estate_id', v_estate_id,
      'role', v_code_record.role
    );
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_redeem_invitation_code(text, text, text, text, text, text) TO authenticated;

-- ============================================================
-- 7. Approve / reject join requests
--    admin or board approves technician/security; only board approves admin.
--    Bootstrap exception: if the estate has no board member yet, an admin
--    may approve another admin (early-stage estates created via Stripe
--    provisioning have a single admin and no board).
-- ============================================================
CREATE OR REPLACE FUNCTION public.fixflow_approve_join_request(p_request_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_req record;
  v_caller uuid := auth.uid();
  v_caller_role text;
  v_board_exists boolean;
  v_profile_role text;
BEGIN
  IF v_caller IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  SELECT * INTO v_req
  FROM public.fixflow_join_requests
  WHERE id = p_request_id AND status = 'pending'
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'request_not_found';
  END IF;

  SELECT role INTO v_caller_role
  FROM public.fixflow_user_estates
  WHERE user_id = v_caller AND estate_id = v_req.estate_id;

  IF v_caller_role IS NULL OR lower(v_caller_role) NOT IN ('admin', 'board') THEN
    RAISE EXCEPTION 'only_office_can_approve';
  END IF;

  IF v_req.role IN ('admin', 'board') THEN
    SELECT EXISTS (
      SELECT 1 FROM public.fixflow_user_estates
      WHERE estate_id = v_req.estate_id AND lower(role) = 'board'
    ) INTO v_board_exists;
    -- Board approves admins; admin may bootstrap when no board exists yet.
    IF v_board_exists AND lower(v_caller_role) != 'board' THEN
      RAISE EXCEPTION 'only_board_can_approve_admin';
    END IF;
  END IF;

  INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_req.user_id, v_req.estate_id, v_req.role);

  -- Profile role uses the app's Polish role labels.
  v_profile_role := CASE v_req.role
    WHEN 'technician' THEN 'Serwisant'
    WHEN 'security' THEN 'Ochrona'
    WHEN 'admin' THEN 'Administrator'
    WHEN 'board' THEN 'Zarząd'
    ELSE 'Mieszkaniec'
  END;

  INSERT INTO public.fixflow_resident_profiles (id, role, name, email, company_name, is_verified)
  SELECT
    v_req.user_id,
    v_profile_role,
    COALESCE(su.first_name, v_profile_role),
    au.email,
    COALESCE(v_req.info, ''),
    true
  FROM auth.users au
  LEFT JOIN public.shared_users su ON su.id = v_req.user_id
  WHERE au.id = v_req.user_id
  ON CONFLICT (id) DO UPDATE
  SET role = EXCLUDED.role,
      is_verified = true,
      company_name = COALESCE(NULLIF(EXCLUDED.company_name, ''), public.fixflow_resident_profiles.company_name);

  UPDATE public.fixflow_join_requests
  SET status = 'approved', decided_at = now(), decided_by = v_caller
  WHERE id = p_request_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.fixflow_reject_join_request(p_request_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_req record;
  v_caller uuid := auth.uid();
BEGIN
  IF v_caller IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  SELECT * INTO v_req
  FROM public.fixflow_join_requests
  WHERE id = p_request_id AND status = 'pending'
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'request_not_found';
  END IF;

  IF NOT public.fixflow_is_estate_admin(v_req.estate_id) THEN
    RAISE EXCEPTION 'only_office_can_approve';
  END IF;

  UPDATE public.fixflow_join_requests
  SET status = 'rejected', decided_at = now(), decided_by = v_caller
  WHERE id = p_request_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_approve_join_request(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_reject_join_request(uuid) TO authenticated;

-- ============================================================
-- 8. Per-role code generation (rotation). Replaces the single-code RPC.
-- ============================================================
DROP FUNCTION IF EXISTS public.fixflow_create_estate_invitation_code(uuid);

CREATE OR REPLACE FUNCTION public.fixflow_create_estate_invitation_code(
  p_estate_id uuid,
  p_role text DEFAULT 'resident'
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
    RAISE EXCEPTION 'not_authorized';
  END IF;

  IF p_role NOT IN ('resident', 'technician', 'security', 'admin', 'board') THEN
    RAISE EXCEPTION 'invalid_role';
  END IF;

  -- Rotation: deactivate the current active code for this (estate, role).
  UPDATE public.fixflow_invitation_codes
  SET is_active = false, updated_at = now()
  WHERE estate_id = p_estate_id AND role = p_role AND is_active = true;

  v_code := public.fixflow_generate_code_string();

  INSERT INTO public.fixflow_invitation_codes
    (estate_id, code, role, auto_join, max_uses, expires_at, is_active)
  VALUES (
    p_estate_id,
    v_code,
    p_role,
    p_role = 'resident',
    -- Admin codes are one-shot per spec; other roles unlimited.
    CASE WHEN p_role = 'admin' THEN 1 ELSE NULL END,
    NULL,
    true
  );

  RETURN v_code;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_create_estate_invitation_code(uuid, text) TO authenticated;

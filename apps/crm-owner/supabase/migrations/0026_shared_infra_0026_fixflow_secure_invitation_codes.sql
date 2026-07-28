-- ════════════════════════════════════════════════════════════════════════════
-- FixFlow Security: Secure invitation code redemption
-- Migration 0026
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- 1. Rate limiting table for code redemption attempts
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.fixflow_code_redemption_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  attempted_at timestamptz NOT NULL DEFAULT now(),
  success boolean NOT NULL DEFAULT false
);

CREATE INDEX IF NOT EXISTS idx_fixflow_redemption_attempts_user_time 
  ON public.fixflow_code_redemption_attempts(user_id, attempted_at DESC);

-- Auto-cleanup old attempts (older than 24h)
CREATE OR REPLACE FUNCTION public.fixflow_cleanup_old_redemption_attempts()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM public.fixflow_code_redemption_attempts 
  WHERE attempted_at < now() - interval '24 hours';
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cleanup_redemption_attempts ON public.fixflow_code_redemption_attempts;
CREATE TRIGGER trg_cleanup_redemption_attempts
  AFTER INSERT ON public.fixflow_code_redemption_attempts
  FOR EACH STATEMENT EXECUTE FUNCTION public.fixflow_cleanup_old_redemption_attempts();

-- RLS: users can only insert their own attempts (no select needed)
ALTER TABLE public.fixflow_code_redemption_attempts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "redemption_attempts_insert_own" ON public.fixflow_code_redemption_attempts;
CREATE POLICY "redemption_attempts_insert_own" ON public.fixflow_code_redemption_attempts
  FOR INSERT WITH CHECK (user_id = auth.uid());

GRANT INSERT ON public.fixflow_code_redemption_attempts TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- 2. SECURE redeem invitation code function (replaces old one)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_redeem_invitation_code(p_code text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid;
  v_code_record RECORD;
  v_recent_attempts integer;
  v_estate_id uuid;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  -- RATE LIMIT: Max 5 attempts per 15 minutes
  SELECT count(*) INTO v_recent_attempts
  FROM public.fixflow_code_redemption_attempts
  WHERE user_id = v_user_id
    AND attempted_at > now() - interval '15 minutes';

  IF v_recent_attempts >= 5 THEN
    -- Log failed attempt (for monitoring)
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'Too many attempts. Please wait 15 minutes.';
  END IF;

  -- Validate code: active, not expired, not exhausted
  SELECT * INTO v_code_record
  FROM public.fixflow_invitation_codes
  WHERE code = p_code
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > now())
    AND (max_uses IS NULL OR use_count < max_uses)
  FOR UPDATE; -- Lock row to prevent race condition

  IF v_code_record IS NULL THEN
    -- Log failed attempt
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'Invalid or expired invitation code';
  END IF;

  v_estate_id := v_code_record.estate_id;

  -- Check if estate has active subscription (B2B enforcement)
  IF NOT public.fixflow_estate_has_active_subscription(v_estate_id) THEN
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    RAISE EXCEPTION 'Estate subscription is not active';
  END IF;

  -- Check if user is already a member
  IF EXISTS (
    SELECT 1 FROM public.fixflow_user_estates 
    WHERE user_id = v_user_id AND estate_id = v_estate_id
  ) THEN
    -- Success - already member, no need to re-add
    INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, true);
    RETURN v_estate_id;
  END IF;

  -- Increment usage counter
  UPDATE public.fixflow_invitation_codes
  SET use_count = COALESCE(use_count, 0) + 1,
      -- Auto-deactivate if max uses reached
      is_active = CASE 
        WHEN max_uses IS NOT NULL AND COALESCE(use_count, 0) + 1 >= max_uses THEN false
        ELSE is_active
      END
  WHERE id = v_code_record.id;

  -- Create membership
  INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_user_id, v_estate_id, 'resident');

  -- Create resident profile if not exists
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

  -- Log successful attempt
  INSERT INTO public.fixflow_code_redemption_attempts (user_id, success)
  VALUES (v_user_id, true);

  RETURN v_estate_id;
END;
$$;

-- ════════════════════════════════════════════════════════════════════════════
-- 3. Admin function to invalidate codes (for compromised codes)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_invalidate_invitation_code(p_code_id uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_estate_id uuid;
BEGIN
  -- Get estate_id for permission check
  SELECT estate_id INTO v_estate_id
  FROM public.fixflow_invitation_codes
  WHERE id = p_code_id;

  IF v_estate_id IS NULL THEN
    RETURN false;
  END IF;

  -- Only admin can invalidate
  IF NOT public.fixflow_is_estate_admin(v_estate_id) THEN
    RAISE EXCEPTION 'Only estate admin can invalidate codes';
  END IF;

  UPDATE public.fixflow_invitation_codes
  SET is_active = false
  WHERE id = p_code_id;

  RETURN true;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_invalidate_invitation_code(uuid) TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- 4. Ensure invitation codes have secure defaults
-- ════════════════════════════════════════════════════════════════════════════

-- Update code generation to use longer, more random codes
CREATE OR REPLACE FUNCTION public.fixflow_generate_code_string()
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
  v_chars text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- No I, O, 0, 1 (ambiguous)
  v_code text := '';
  i integer;
BEGIN
  -- Generate 12-character code (more entropy than 6-8)
  FOR i IN 1..12 LOOP
    v_code := v_code || substr(v_chars, floor(random() * length(v_chars) + 1)::integer, 1);
  END LOOP;
  -- Format: XXXX-XXXX-XXXX for readability
  RETURN substr(v_code, 1, 4) || '-' || substr(v_code, 5, 4) || '-' || substr(v_code, 9, 4);
END;
$$;

-- ════════════════════════════════════════════════════════════════════════════
-- 5. Set default expiration for new codes (30 days)
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.fixflow_invitation_codes 
  ALTER COLUMN expires_at SET DEFAULT now() + interval '30 days';

ALTER TABLE public.fixflow_invitation_codes 
  ALTER COLUMN max_uses SET DEFAULT 1;

ALTER TABLE public.fixflow_invitation_codes 
  ALTER COLUMN use_count SET DEFAULT 0;

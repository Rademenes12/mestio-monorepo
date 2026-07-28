-- =====================================================
-- Fix: Remove estate_id from fixflow_resident_profiles insert
-- =====================================================
-- The fixflow_resident_profiles table doesn't have estate_id column
-- Estate membership is tracked via fixflow_user_estates table

CREATE OR REPLACE FUNCTION fixflow_redeem_invitation_code(p_code text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id uuid;
  v_code_record record;
  v_estate_id uuid;
  v_attempt_count integer;
BEGIN
  -- Get authenticated user
  v_user_id := auth.uid();
  
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'not_authenticated';
  END IF;

  -- Rate limiting: max 5 attempts per 15 minutes per user
  SELECT COUNT(*)
  INTO v_attempt_count
  FROM fixflow_code_redemption_attempts
  WHERE user_id = v_user_id
    AND created_at > now() - interval '15 minutes';
  
  IF v_attempt_count >= 5 THEN
    -- Log failed attempt
    INSERT INTO fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    
    RAISE EXCEPTION 'rate_limit_exceeded';
  END IF;

  -- Validate code format
  IF p_code !~ '^[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$' THEN
    -- Log failed attempt
    INSERT INTO fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    
    RAISE EXCEPTION 'invalid_code_format';
  END IF;

  -- Get code details
  SELECT *
  INTO v_code_record
  FROM fixflow_invitation_codes
  WHERE UPPER(code) = UPPER(p_code)
    AND is_active = true
    AND (expires_at IS NULL OR expires_at > now())
    AND (max_uses IS NULL OR COALESCE(current_uses, 0) < max_uses)
  FOR UPDATE;

  IF NOT FOUND THEN
    -- Log failed attempt
    INSERT INTO fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    
    RAISE EXCEPTION 'code_not_found_or_expired';
  END IF;

  v_estate_id := v_code_record.estate_id;

  -- Check if user is already a member
  IF EXISTS (
    SELECT 1 FROM fixflow_user_estates
    WHERE user_id = v_user_id AND estate_id = v_estate_id
  ) THEN
    -- Log failed attempt
    INSERT INTO fixflow_code_redemption_attempts (user_id, success)
    VALUES (v_user_id, false);
    
    RAISE EXCEPTION 'already_member';
  END IF;

  -- Increment usage counter
  UPDATE fixflow_invitation_codes
  SET 
      current_uses = COALESCE(current_uses, 0) + 1,
      updated_at = now(),
      is_active = CASE 
        WHEN max_uses IS NOT NULL AND COALESCE(current_uses, 0) + 1 >= max_uses THEN false
        ELSE is_active
      END
  WHERE id = v_code_record.id;

  -- Create membership
  INSERT INTO fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_user_id, v_estate_id, 'resident');

  -- Create resident profile if not exists (FIXED: removed estate_id)
  INSERT INTO fixflow_resident_profiles (id, role, name, email)
  SELECT 
    v_user_id,
    'Mieszkaniec',
    COALESCE(su.first_name, 'Mieszkaniec'),
    au.email
  FROM auth.users au
  LEFT JOIN shared_users su ON su.id = v_user_id
  WHERE au.id = v_user_id
  ON CONFLICT (id) DO NOTHING;

  -- Log successful attempt
  INSERT INTO fixflow_code_redemption_attempts (user_id, success)
  VALUES (v_user_id, true);

  RETURN v_estate_id;
END;
$$;

GRANT EXECUTE ON FUNCTION fixflow_redeem_invitation_code TO authenticated;

COMMENT ON FUNCTION fixflow_redeem_invitation_code IS 
  'FIXED: Removed estate_id from resident_profiles insert (column does not exist)';

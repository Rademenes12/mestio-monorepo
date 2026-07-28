-- =====================================================
-- Fix TEST1234 code format + add missing columns
-- =====================================================
-- The redeem RPC (0036) requires format XXXX-XXXX-XXXX.
-- TEST1234 does not match and gets rejected with invalid_code_format.
-- Also, migrations 0026/0028/0036 reference columns (expires_at,
-- max_uses, use_count) that were never ADDed to the table.

-- 1. Add missing columns (if they don't exist)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_invitation_codes' AND column_name = 'max_uses'
  ) THEN
    ALTER TABLE public.fixflow_invitation_codes ADD COLUMN max_uses integer;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_invitation_codes' AND column_name = 'use_count'
  ) THEN
    ALTER TABLE public.fixflow_invitation_codes ADD COLUMN use_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_invitation_codes' AND column_name = 'expires_at'
  ) THEN
    ALTER TABLE public.fixflow_invitation_codes ADD COLUMN expires_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_invitation_codes' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE public.fixflow_invitation_codes ADD COLUMN updated_at timestamptz;
  END IF;
END $$;

-- 2. Update TEST1234 to TEST-1234 format, unlimited uses, no expiry
UPDATE public.fixflow_invitation_codes
SET code = 'TEST-1234',
    max_uses = NULL,
    expires_at = NULL,
    updated_at = now()
WHERE code = 'TEST1234';

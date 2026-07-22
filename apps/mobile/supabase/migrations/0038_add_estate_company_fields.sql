-- =====================================================
-- Add company/contract fields to fixflow_estates
-- =====================================================
-- Replaces the removed Trello section: shows management company
-- name, admin contact, and invitation code in the Profile screen.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_estates' AND column_name = 'company_name'
  ) THEN
    ALTER TABLE public.fixflow_estates ADD COLUMN company_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_estates' AND column_name = 'admin_name'
  ) THEN
    ALTER TABLE public.fixflow_estates ADD COLUMN admin_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_estates' AND column_name = 'admin_email'
  ) THEN
    ALTER TABLE public.fixflow_estates ADD COLUMN admin_email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_estates' AND column_name = 'admin_phone'
  ) THEN
    ALTER TABLE public.fixflow_estates ADD COLUMN admin_phone text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'fixflow_estates' AND column_name = 'hide_resident_contacts'
  ) THEN
    ALTER TABLE public.fixflow_estates ADD COLUMN hide_resident_contacts boolean NOT NULL DEFAULT false;
  END IF;
END $$;

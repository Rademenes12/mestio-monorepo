-- FixFlow — RLS for emergency contacts
-- ============================================================================
-- Admins can manage contacts per estate; residents can read contacts for
-- estates they belong to. Legacy global contacts (estate_id IS NULL) are
-- readable by everyone.
-- ============================================================================

-- Ensure the table exists with the columns the app expects. If it was created
-- outside of migrations, add missing columns without touching existing data.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts'
  ) THEN
    CREATE TABLE public.fixflow_emergency_contacts (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      name text NOT NULL,
      role text NOT NULL,
      phone text NOT NULL,
      email text,
      category text NOT NULL,
      estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
      display_order integer NOT NULL DEFAULT 0,
      is_active boolean NOT NULL DEFAULT true,
      created_at timestamptz NOT NULL DEFAULT now(),
      updated_at timestamptz NOT NULL DEFAULT now()
    );
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'name'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN name text NOT NULL DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'role'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN role text NOT NULL DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'phone'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN phone text NOT NULL DEFAULT '';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'email'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN email text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'category'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN category text NOT NULL DEFAULT 'administration';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'estate_id'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'display_order'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN display_order integer NOT NULL DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'is_active'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN is_active boolean NOT NULL DEFAULT true;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'created_at'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'fixflow_emergency_contacts' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE public.fixflow_emergency_contacts ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
  END IF;
END $$;

-- Enable RLS
ALTER TABLE public.fixflow_emergency_contacts ENABLE ROW LEVEL SECURITY;

-- Drop old policies if they exist
DROP POLICY IF EXISTS "emergency_contacts_select_members" ON public.fixflow_emergency_contacts;
DROP POLICY IF EXISTS "emergency_contacts_select_global" ON public.fixflow_emergency_contacts;
DROP POLICY IF EXISTS "emergency_contacts_insert_admin" ON public.fixflow_emergency_contacts;
DROP POLICY IF EXISTS "emergency_contacts_update_admin" ON public.fixflow_emergency_contacts;
DROP POLICY IF EXISTS "emergency_contacts_delete_admin" ON public.fixflow_emergency_contacts;

-- Residents can read active contacts for their estate or global contacts.
CREATE POLICY "emergency_contacts_select_members"
ON public.fixflow_emergency_contacts FOR SELECT
USING (
  is_active = true
  AND (
    estate_id IS NULL
    OR public.fixflow_is_estate_member(estate_id)
  )
);

-- Admins can create contacts for estates they manage.
CREATE POLICY "emergency_contacts_insert_admin"
ON public.fixflow_emergency_contacts FOR INSERT
WITH CHECK (
  estate_id IS NOT NULL
  AND public.fixflow_is_estate_admin(estate_id)
);

-- Admins can update contacts for estates they manage.
CREATE POLICY "emergency_contacts_update_admin"
ON public.fixflow_emergency_contacts FOR UPDATE
USING (
  estate_id IS NOT NULL
  AND public.fixflow_is_estate_admin(estate_id)
)
WITH CHECK (
  estate_id IS NOT NULL
  AND public.fixflow_is_estate_admin(estate_id)
);

-- Admins can soft-delete contacts for estates they manage.
CREATE POLICY "emergency_contacts_delete_admin"
ON public.fixflow_emergency_contacts FOR DELETE
USING (
  estate_id IS NOT NULL
  AND public.fixflow_is_estate_admin(estate_id)
);

-- Grants
GRANT SELECT, INSERT, UPDATE ON public.fixflow_emergency_contacts TO authenticated;

-- Realtime
ALTER TABLE public.fixflow_emergency_contacts REPLICA IDENTITY FULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'fixflow_emergency_contacts'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.fixflow_emergency_contacts;
  END IF;
END $$;

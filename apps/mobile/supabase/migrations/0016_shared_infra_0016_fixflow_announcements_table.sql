-- FixFlow — announcements table and RLS
-- ============================================================================
-- Admin/Zarząd broadcast messages scoped to an estate (or global when
-- estate_id is NULL). Residents can only read active announcements for estates
-- they belong to.
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.fixflow_announcements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  content text NOT NULL,
  author_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  author_name text,
  author_role text,
  target_label text,
  estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  expires_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_announcements_estate_active
  ON public.fixflow_announcements(estate_id, is_active, created_at DESC);

-- Enable realtime (requires the table to be in the supabase_realtime publication).
ALTER TABLE public.fixflow_announcements REPLICA IDENTITY FULL;

-- RLS
ALTER TABLE public.fixflow_announcements ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "announcements_select_members" ON public.fixflow_announcements;
DROP POLICY IF EXISTS "announcements_insert_admin" ON public.fixflow_announcements;
DROP POLICY IF EXISTS "announcements_update_admin" ON public.fixflow_announcements;
DROP POLICY IF EXISTS "announcements_delete_admin" ON public.fixflow_announcements;

-- Residents can read active announcements for their estates or global ones.
CREATE POLICY "announcements_select_members"
ON public.fixflow_announcements FOR SELECT
USING (
  is_active = true
  AND (
    estate_id IS NULL
    OR public.fixflow_is_estate_member(estate_id)
  )
);

-- Admins can create announcements for estates they manage (global requires admin).
CREATE POLICY "announcements_insert_admin"
ON public.fixflow_announcements FOR INSERT
WITH CHECK (
  (estate_id IS NOT NULL AND public.fixflow_is_estate_admin(estate_id))
  OR (estate_id IS NULL AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND lower(role) != 'resident'
      AND lower(role) != 'mieszkaniec'
  ))
);

-- Admins can update announcements they authored or for estates they manage.
CREATE POLICY "announcements_update_admin"
ON public.fixflow_announcements FOR UPDATE
USING (
  (estate_id IS NOT NULL AND public.fixflow_is_estate_admin(estate_id))
  OR (estate_id IS NULL AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND lower(role) != 'resident'
      AND lower(role) != 'mieszkaniec'
  ))
)
WITH CHECK (
  (estate_id IS NOT NULL AND public.fixflow_is_estate_admin(estate_id))
  OR (estate_id IS NULL AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND lower(role) != 'resident'
      AND lower(role) != 'mieszkaniec'
  ))
);

-- Admins can soft-delete announcements for estates they manage.
CREATE POLICY "announcements_delete_admin"
ON public.fixflow_announcements FOR DELETE
USING (
  (estate_id IS NOT NULL AND public.fixflow_is_estate_admin(estate_id))
  OR (estate_id IS NULL AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND lower(role) != 'resident'
      AND lower(role) != 'mieszkaniec'
  ))
);

GRANT SELECT, INSERT, UPDATE ON public.fixflow_announcements TO authenticated;

-- Ensure realtime publication includes this table.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'fixflow_announcements'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.fixflow_announcements;
  END IF;
END $$;

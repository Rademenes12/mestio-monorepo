-- ════════════════════════════════════════════════════════════════════════════
-- FixFlow Security Hardening — Migration 0023
-- Fixes: BLOKER 1 (Trello secrets), BLOKER 2 (permissions RLS), 
--        HIGH 2 (board_notes separation)
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- BLOKER 1: Przenieś sekrety Trello do osobnej tabeli z RLS admin-only
-- ════════════════════════════════════════════════════════════════════════════

-- Utwórz tabelę na sekrety (tylko admin ma dostęp)
CREATE TABLE IF NOT EXISTS public.fixflow_estate_secrets (
  estate_id uuid PRIMARY KEY REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  trello_api_key text,
  trello_token text,
  trello_list_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Włącz RLS
ALTER TABLE public.fixflow_estate_secrets ENABLE ROW LEVEL SECURITY;

-- Tylko admin osiedla może odczytać i modyfikować sekrety
DROP POLICY IF EXISTS "secrets_select_admin" ON public.fixflow_estate_secrets;
CREATE POLICY "secrets_select_admin" ON public.fixflow_estate_secrets
  FOR SELECT USING (public.fixflow_is_estate_admin(estate_id));

DROP POLICY IF EXISTS "secrets_insert_admin" ON public.fixflow_estate_secrets;
CREATE POLICY "secrets_insert_admin" ON public.fixflow_estate_secrets
  FOR INSERT WITH CHECK (public.fixflow_is_estate_admin(estate_id));

DROP POLICY IF EXISTS "secrets_update_admin" ON public.fixflow_estate_secrets;
CREATE POLICY "secrets_update_admin" ON public.fixflow_estate_secrets
  FOR UPDATE USING (public.fixflow_is_estate_admin(estate_id))
  WITH CHECK (public.fixflow_is_estate_admin(estate_id));

DROP POLICY IF EXISTS "secrets_delete_admin" ON public.fixflow_estate_secrets;
CREATE POLICY "secrets_delete_admin" ON public.fixflow_estate_secrets
  FOR DELETE USING (public.fixflow_is_estate_admin(estate_id));

-- Migruj istniejące dane z fixflow_estates do fixflow_estate_secrets
INSERT INTO public.fixflow_estate_secrets (estate_id, trello_api_key, trello_token, trello_list_id)
SELECT id, trello_api_key, trello_token, trello_list_id 
FROM public.fixflow_estates
WHERE trello_api_key IS NOT NULL OR trello_token IS NOT NULL OR trello_list_id IS NOT NULL
ON CONFLICT (estate_id) DO UPDATE SET
  trello_api_key = EXCLUDED.trello_api_key,
  trello_token = EXCLUDED.trello_token,
  trello_list_id = EXCLUDED.trello_list_id,
  updated_at = now();

-- Usuń kolumny sekretów z głównej tabeli estates (teraz są w secrets)
ALTER TABLE public.fixflow_estates DROP COLUMN IF EXISTS trello_api_key;
ALTER TABLE public.fixflow_estates DROP COLUMN IF EXISTS trello_token;
ALTER TABLE public.fixflow_estates DROP COLUMN IF EXISTS trello_list_id;

-- Grant dla authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON public.fixflow_estate_secrets TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- BLOKER 2: Napraw RLS na fixflow_permissions (dodaj filtr estate_id)
-- ════════════════════════════════════════════════════════════════════════════

-- Upewnij się że kolumna estate_id istnieje
ALTER TABLE public.fixflow_permissions ADD COLUMN IF NOT EXISTS estate_id uuid 
  REFERENCES public.fixflow_estates(id) ON DELETE CASCADE;

-- Usuń stare polityki bez filtra estate_id
DROP POLICY IF EXISTS "permissions_read_office" ON public.fixflow_permissions;
DROP POLICY IF EXISTS "permissions_write_office" ON public.fixflow_permissions;
DROP POLICY IF EXISTS "permissions_read_estate_scope" ON public.fixflow_permissions;
DROP POLICY IF EXISTS "permissions_write_estate_scope" ON public.fixflow_permissions;

-- Nowe polityki z filtrem estate_id
CREATE POLICY "permissions_select_estate_scope" ON public.fixflow_permissions
  FOR SELECT USING (
    public.fixflow_is_not_resident(auth.uid())
    AND public.fixflow_is_estate_member(estate_id)
  );

CREATE POLICY "permissions_insert_estate_admin" ON public.fixflow_permissions
  FOR INSERT WITH CHECK (
    public.fixflow_is_estate_admin(estate_id)
  );

CREATE POLICY "permissions_update_estate_admin" ON public.fixflow_permissions
  FOR UPDATE USING (public.fixflow_is_estate_admin(estate_id))
  WITH CHECK (public.fixflow_is_estate_admin(estate_id));

CREATE POLICY "permissions_delete_estate_admin" ON public.fixflow_permissions
  FOR DELETE USING (public.fixflow_is_estate_admin(estate_id));

-- ════════════════════════════════════════════════════════════════════════════
-- HIGH 2: Separacja board_notes do osobnej tabeli (staff-only)
-- ════════════════════════════════════════════════════════════════════════════

-- Utwórz tabelę na wewnętrzne notatki (tylko staff ma dostęp)
-- Note: fixflow_reports.id może być text lub uuid - używamy text dla kompatybilności
CREATE TABLE IF NOT EXISTS public.fixflow_report_internal_notes (
  report_id uuid PRIMARY KEY REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  board_notes text,
  internal_tech_notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Włącz RLS
ALTER TABLE public.fixflow_report_internal_notes ENABLE ROW LEVEL SECURITY;

-- Tylko staff (non-resident) z osiedla może odczytać/modyfikować
DROP POLICY IF EXISTS "internal_notes_select_staff" ON public.fixflow_report_internal_notes;
CREATE POLICY "internal_notes_select_staff" ON public.fixflow_report_internal_notes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND public.fixflow_is_not_resident(auth.uid())
    )
  );

DROP POLICY IF EXISTS "internal_notes_insert_staff" ON public.fixflow_report_internal_notes;
CREATE POLICY "internal_notes_insert_staff" ON public.fixflow_report_internal_notes
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND public.fixflow_is_not_resident(auth.uid())
    )
  );

DROP POLICY IF EXISTS "internal_notes_update_staff" ON public.fixflow_report_internal_notes;
CREATE POLICY "internal_notes_update_staff" ON public.fixflow_report_internal_notes
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND public.fixflow_is_not_resident(auth.uid())
    )
  );

-- Migruj istniejące board_notes do nowej tabeli
INSERT INTO public.fixflow_report_internal_notes (report_id, board_notes)
SELECT id, board_notes FROM public.fixflow_reports
WHERE board_notes IS NOT NULL AND board_notes != ''
ON CONFLICT (report_id) DO UPDATE SET
  board_notes = EXCLUDED.board_notes,
  updated_at = now();

-- Zostaw kolumnę board_notes w reports jako legacy (ale nie używana przez mieszkańców)
-- Nie usuwamy jej aby nie złamać istniejącego kodu - stopniowa migracja

-- Grant dla authenticated users
GRANT SELECT, INSERT, UPDATE ON public.fixflow_report_internal_notes TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- DODATKOWE: Upewnij się że report_comments ma poprawną politykę z is_visible_to_residents
-- ════════════════════════════════════════════════════════════════════════════

-- Dodaj kolumnę jeśli nie istnieje
ALTER TABLE public.fixflow_report_comments 
  ADD COLUMN IF NOT EXISTS is_visible_to_residents boolean DEFAULT false;

-- Polityka SELECT dla komentarzy z uwzględnieniem is_visible_to_residents
DROP POLICY IF EXISTS "report_comments_select_office_in_estate" ON public.fixflow_report_comments;
DROP POLICY IF EXISTS "report_comments_select_all" ON public.fixflow_report_comments;

CREATE POLICY "report_comments_select_all" ON public.fixflow_report_comments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND (
        public.fixflow_is_not_resident(auth.uid())
        OR is_visible_to_residents = true
      )
    )
  );

-- Mieszkaniec może dodać komentarz do własnego zgłoszenia (widoczny dla wszystkich)
DROP POLICY IF EXISTS "report_comments_insert_office_in_estate" ON public.fixflow_report_comments;
DROP POLICY IF EXISTS "report_comments_insert_all" ON public.fixflow_report_comments;

CREATE POLICY "report_comments_insert_all" ON public.fixflow_report_comments
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND (
        public.fixflow_is_not_resident(auth.uid())
        OR r.reporter_email = (
          SELECT email FROM public.fixflow_resident_profiles WHERE id = auth.uid()
        )
      )
    )
  );

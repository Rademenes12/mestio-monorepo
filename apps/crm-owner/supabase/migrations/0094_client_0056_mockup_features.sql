-- Migration 0056: Funkcje z mockupu "FixFlow_Panel CRM klient.dc.html"
-- Uruchom w Supabase SQL Editor
--
-- Zakres:
--  1. Udziały: fixflow_estates.total_shares + edycja share_units (admin/board)
--  2. Pomieszczenia i miejsca mieszkańca (fixflow_resident_spaces)
--  3. Notatki przy kontakcie (fixflow_contact_notes) — wewnętrzne, niewidoczne dla mieszkańca
--  4. Zadania: typ (resident/internal), przypisanie do grupy (zarzad/serwis)
--  5. Komentarze/dyskusja przy zadaniach wewnętrznych (fixflow_task_comments)
--  6. Uchwały: numer, closed_at, głosy per mieszkaniec ważone udziałami (fixflow_resolution_votes)
--  7. Telefony: RLS — mieszkaniec/serwis/ochrona widzą tylko kategorie emergency/service
--  8. Dokumenty od Mestio (fixflow_client_documents) i faktury (fixflow_client_invoices) — read-only dla klienta
--  9. Dane administratora + data końca umowy na osiedlu

-- ============================================================
-- 1. UDZIAŁY
-- ============================================================
ALTER TABLE public.fixflow_estates
  ADD COLUMN IF NOT EXISTS total_shares integer NOT NULL DEFAULT 1000;

-- Edycja share_units przez admin/board obsługiwana jest istniejącą polityką
-- update na fixflow_resident_profiles (jeśli brak — poniżej bezpieczna polityka):
DROP POLICY IF EXISTS "admin_board_update_profiles" ON public.fixflow_resident_profiles;
CREATE POLICY "admin_board_update_profiles" ON public.fixflow_resident_profiles
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_resident_profiles.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- ============================================================
-- 2. POMIESZCZENIA I MIEJSCA (komórka, piwnica, postojowe...)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_resident_spaces (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.fixflow_resident_profiles(id) ON DELETE CASCADE,
  space_type text NOT NULL, -- 'Komórka lokatorska' | 'Piwnica' | 'Miejsce postojowe' | 'Garaż' | 'Inne'
  label text NOT NULL,      -- np. 'K-14, poziom -1'
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_resident_spaces ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_board_all" ON public.fixflow_resident_spaces;
CREATE POLICY "admin_board_all" ON public.fixflow_resident_spaces
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_resident_spaces.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- Mieszkaniec widzi i uzupełnia własne pomieszczenia (self-service w aplikacji)
DROP POLICY IF EXISTS "resident_own_spaces" ON public.fixflow_resident_spaces;
CREATE POLICY "resident_own_spaces" ON public.fixflow_resident_spaces
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_resident_profiles rp
      WHERE rp.id = fixflow_resident_spaces.user_id
        AND rp.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_resident_profiles rp
      WHERE rp.id = fixflow_resident_spaces.user_id
        AND rp.user_id = auth.uid()
    )
  );

CREATE INDEX IF NOT EXISTS idx_resident_spaces_resident ON public.fixflow_resident_spaces(user_id);
CREATE INDEX IF NOT EXISTS idx_resident_spaces_estate ON public.fixflow_resident_spaces(estate_id);

-- ============================================================
-- 3. NOTATKI PRZY KONTAKCIE (wewnętrzne — nigdy dla mieszkańca)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_contact_notes (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES public.fixflow_resident_profiles(id) ON DELETE CASCADE,
  body text NOT NULL,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_contact_notes ENABLE ROW LEVEL SECURITY;

-- WYŁĄCZNIE admin/board — mieszkaniec nie ma tu żadnego dostępu
DROP POLICY IF EXISTS "admin_board_all" ON public.fixflow_contact_notes;
CREATE POLICY "admin_board_all" ON public.fixflow_contact_notes
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_contact_notes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

CREATE INDEX IF NOT EXISTS idx_contact_notes_resident ON public.fixflow_contact_notes(user_id);

-- ============================================================
-- 4. ZADANIA: typ + przypisanie do grupy
-- ============================================================
ALTER TABLE public.fixflow_tasks
  ADD COLUMN IF NOT EXISTS kind text NOT NULL DEFAULT 'resident'; -- 'resident' | 'internal' | 'maintenance'
ALTER TABLE public.fixflow_tasks
  ADD COLUMN IF NOT EXISTS assigned_group text; -- 'zarzad' | 'serwis'

-- ============================================================
-- 5. KOMENTARZE / DYSKUSJA PRZY ZADANIACH
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_task_comments (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  task_id uuid NOT NULL REFERENCES public.fixflow_tasks(id) ON DELETE CASCADE,
  body text NOT NULL,
  author_name text,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_task_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_board_all" ON public.fixflow_task_comments;
CREATE POLICY "admin_board_all" ON public.fixflow_task_comments
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_task_comments.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

CREATE INDEX IF NOT EXISTS idx_task_comments_task ON public.fixflow_task_comments(task_id);

-- ============================================================
-- 6. UCHWAŁY: numer, closed_at + głosy per mieszkaniec
-- ============================================================
-- UWAGA (audyt QA 2026-07-09): tabela fixflow_resolution_votes JUŻ ISTNIEJE
-- w bazie (prawdopodobnie z aplikacji mobilnej) z kolumnami
-- (id, resolution_id, user_id, choice, created_at) — NIE user_id/vote/
-- share_units jak pierwotnie zakładano. Poniżej DOPISUJEMY kolumny
-- potrzebne do wagi udziałów, zamiast tworzyć tabelę od nowa (co i tak by
-- się nie wykonało przez IF NOT EXISTS, ale polityki poniżej referowałyby
-- nieistniejące kolumny i migracja by się wysypała).
ALTER TABLE public.resolutions
  ADD COLUMN IF NOT EXISTS number text;
ALTER TABLE public.resolutions
  ADD COLUMN IF NOT EXISTS closed_at timestamptz;

CREATE TABLE IF NOT EXISTS public.fixflow_resolution_votes (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  resolution_id uuid NOT NULL REFERENCES public.resolutions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  choice text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Dopisujemy kolumny wagi udziałów do istniejącej (lub właśnie utworzonej) tabeli
ALTER TABLE public.fixflow_resolution_votes
  ADD COLUMN IF NOT EXISTS estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE CASCADE;
ALTER TABLE public.fixflow_resolution_votes
  ADD COLUMN IF NOT EXISTS share_units integer NOT NULL DEFAULT 0;

-- Unikalność głosu per uchwała+user (bezpieczne IF NOT EXISTS przez DO-block,
-- bo ADD CONSTRAINT nie ma IF NOT EXISTS w Postgresie)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'fixflow_resolution_votes_resolution_user_uniq'
  ) THEN
    ALTER TABLE public.fixflow_resolution_votes
      ADD CONSTRAINT fixflow_resolution_votes_resolution_user_uniq UNIQUE (resolution_id, user_id);
  END IF;
END $$;

ALTER TABLE public.fixflow_resolution_votes ENABLE ROW LEVEL SECURITY;

-- Admin/board: pełny wgląd w głosy swojego osiedla
DROP POLICY IF EXISTS "admin_board_select" ON public.fixflow_resolution_votes;
CREATE POLICY "admin_board_select" ON public.fixflow_resolution_votes
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_resolution_votes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- Mieszkaniec: głosuje raz, tylko gdy uchwała otwarta i przed terminem
DROP POLICY IF EXISTS "resident_vote_insert" ON public.fixflow_resolution_votes;
CREATE POLICY "resident_vote_insert" ON public.fixflow_resolution_votes
  FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM public.resolutions r
      WHERE r.id = fixflow_resolution_votes.resolution_id
        AND r.status = 'open'
        AND r.deadline > now()
    )
  );

-- Mieszkaniec widzi własny głos
DROP POLICY IF EXISTS "resident_vote_select_own" ON public.fixflow_resolution_votes;
CREATE POLICY "resident_vote_select_own" ON public.fixflow_resolution_votes
  FOR SELECT
  USING (user_id = auth.uid());

CREATE INDEX IF NOT EXISTS idx_resolution_votes_resolution ON public.fixflow_resolution_votes(resolution_id);

-- ============================================================
-- 7. TELEFONY: widoczność kategorii per rola
--    mieszkaniec/serwisant/ochrona widzą tylko 'emergency' (alarmowe)
--    i 'maintenance' (serwis); admin/board widzą wszystko (też 'administration')
-- ============================================================
DROP POLICY IF EXISTS "members_select_contacts" ON public.fixflow_emergency_contacts;
CREATE POLICY "members_select_contacts" ON public.fixflow_emergency_contacts
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_emergency_contacts.estate_id
        AND ue.user_id = auth.uid()
        AND (
          ue.role IN ('admin', 'board')
          OR fixflow_emergency_contacts.category IN ('emergency', 'maintenance')
        )
    )
  );

-- ============================================================
-- 8. DOKUMENTY OD MESTIO + FAKTURY (read-only dla klienta;
--    wstawia/aktualizuje CRM Owner przez service role)
--
-- UWAGA (audyt QA 2026-07-09): w bazie istnieją już tabele `client_documents`
-- i `crm_invoices` (inny schemat, prawdopodobnie z CRM Owner) bez widocznego
-- pod anon/authenticated FK do estate_id — nie udało się ustalić jak są
-- powiązane z klientem/osiedlem. Poniższe tabele fixflow_client_documents/
-- fixflow_client_invoices to NOWA, izolowana ścieżka (bezpieczna, nie
-- koliduje nazwami) — ale dopóki CRM Owner nie zacznie do nich pisać, sekcje
-- w Ustawieniach będą zawsze puste. DO ROZSTRZYGNIĘCIA PRODUKTOWO: czy
-- integrować się z istniejącymi client_documents/crm_invoices, czy zasilać
-- te nowe tabele z CRM Owner.
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_client_documents (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  name text NOT NULL,
  meta text,             -- np. 'Plan Standard · PDF'
  status text NOT NULL DEFAULT 'Aktualna', -- 'Podpisana' | 'Aktualna' | ...
  file_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_client_documents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_board_select" ON public.fixflow_client_documents;
CREATE POLICY "admin_board_select" ON public.fixflow_client_documents
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_client_documents.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

CREATE TABLE IF NOT EXISTS public.fixflow_client_invoices (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  invoice_number text NOT NULL, -- np. 'FV/2026/07'
  period text,                  -- np. 'Lipiec 2026'
  amount text,                  -- np. '179 zł'
  status text NOT NULL DEFAULT 'Wystawiona', -- 'Opłacona' | 'Wystawiona' | 'Okres próbny'
  file_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_client_invoices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_board_select" ON public.fixflow_client_invoices;
CREATE POLICY "admin_board_select" ON public.fixflow_client_invoices
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_client_invoices.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- ============================================================
-- 9. DANE ADMINISTRATORA + UMOWA na osiedlu
-- ============================================================
ALTER TABLE public.fixflow_estates
  ADD COLUMN IF NOT EXISTS admin_name text;
ALTER TABLE public.fixflow_estates
  ADD COLUMN IF NOT EXISTS admin_email text;
ALTER TABLE public.fixflow_estates
  ADD COLUMN IF NOT EXISTS admin_phone text;
ALTER TABLE public.fixflow_estates
  ADD COLUMN IF NOT EXISTS contract_until date;

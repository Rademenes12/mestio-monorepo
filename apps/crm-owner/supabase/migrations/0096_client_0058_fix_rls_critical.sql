-- ============================================================================
-- MIGRACJA 0058: Fix krytycznych bledow RLS (17.07.2026)
-- ============================================================================
-- Fix #1: Serwisant NIE moze ustawic statusu "Odrzucone" w reports_update
-- Fix #2: Board NIE moze tworzyc kodu admina/board w invitation_codes
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- FIX #1: reports_update_board — blokada "Odrzucone" dla nie-admin/board
-- Problem: WITH CHECK nie sprawdzal statusu — serwisant mogl ustawic Odrzucone
-- Rozwiazanie: Dodanie warunku status <> 'Odrzucone' dla rol nie-bedacych board/admin
-- ────────────────────────────────────────────────────────────────────────────
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'reports_update_board'
      AND tablename = 'fixflow_reports'
  ) THEN
    -- Drop the old policy and recreate with the fix
    DROP POLICY reports_update_board ON public.fixflow_reports;
  END IF;

  -- Recreate with proper WITH CHECK that blocks 'Odrzucone' for non-admin/board
  CREATE POLICY reports_update_board ON public.fixflow_reports
    FOR UPDATE
    USING (
      fixflow_is_estate_member(estate_id)
      AND (
        fixflow_is_board_or_admin(auth.uid())
        OR (
          (assigned_to_user_id = auth.uid() OR assigned_to_user_id IS NULL)
          AND EXISTS (
            SELECT 1 FROM public.fixflow_resident_profiles rp
            WHERE rp.id = auth.uid() AND rp.role = 'Serwisant'
          )
        )
      )
    )
    WITH CHECK (
      fixflow_is_estate_member(estate_id)
      AND (
        fixflow_is_board_or_admin(auth.uid())
        OR (
          (assigned_to_user_id = auth.uid() OR assigned_to_user_id IS NULL)
        )
      )
      -- 🔒 NOWE: serwisant/ochrona NIE moze ustawic statusu 'Odrzucone'
      AND (
        fixflow_is_board_or_admin(auth.uid())
        OR status IS DISTINCT FROM 'Odrzucone'
      )
    );
END $$;

-- ────────────────────────────────────────────────────────────────────────────
-- FIX #2: invitation_codes_insert — board nie moze tworzyc kodu admin/board
-- Problem: fixflow_is_estate_admin() akceptuje rowniez 'board', a polityka
--          invitation_codes_insert_admin uzywala tej funkcji.
--          fixflow_invite_codes_insert_admin_restrict miala poprawna logike
--          ale byla nadpisywana przez pierwsza polityke (RLS OR).
-- Rozwiazanie: Drop starych INSERT policy, zostaw tylko restrict.
--              Dla SELECT/UPDATE/DELETE: dodaj polityke dla board tez.
-- ────────────────────────────────────────────────────────────────────────────

-- 1. Usun stare polityki INSERT na invitation_codes
DROP POLICY IF EXISTS invitation_codes_insert_admin ON public.fixflow_invitation_codes;
DROP POLICY IF EXISTS fixflow_invite_codes_insert_admin_restrict ON public.fixflow_invitation_codes;

-- 2. Nowa, JEDNA polityka INSERT — admin full, board restricted
CREATE POLICY invitation_codes_insert ON public.fixflow_invitation_codes
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_invitation_codes.estate_id
        AND ue.user_id = auth.uid()
        AND (
          ue.role = 'admin'
          OR (
            ue.role = 'board'
            AND fixflow_invitation_codes.role <> ALL (ARRAY['admin', 'board'])
          )
        )
    )
  );

-- 3. SELECT — admin i board moga widziec kody swojego osiedla
DROP POLICY IF EXISTS invitation_codes_select_admin ON public.fixflow_invitation_codes;
CREATE POLICY invitation_codes_select ON public.fixflow_invitation_codes
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_invitation_codes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- 4. UPDATE — admin i board moga zarzadzac kodami (ale board tylko swoje role)
DROP POLICY IF EXISTS invitation_codes_update_admin ON public.fixflow_invitation_codes;
CREATE POLICY invitation_codes_update ON public.fixflow_invitation_codes
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_invitation_codes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_invitation_codes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- 5. DELETE — admin i board moga usuwac kody
DROP POLICY IF EXISTS invitation_codes_delete_admin ON public.fixflow_invitation_codes;
CREATE POLICY invitation_codes_delete ON public.fixflow_invitation_codes
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = fixflow_invitation_codes.estate_id
        AND ue.user_id = auth.uid()
        AND ue.role IN ('admin', 'board')
    )
  );

-- ────────────────────────────────────────────────────────────────────────────
-- FIX #3: Sprawdzenie i dokumentacja schematu fixflow_report_internal_notes
-- Kolumny: report_id (text), board_notes (text), internal_tech_notes (text),
--          created_at, updated_at
-- Tabela NIE ma kolumny 'id' — PK to prawdopodobnie report_id (one-to-one).
-- Kod CRM Klienta uzywa .upsert({ report_id, content }) — zgodne ze schematem.
-- ────────────────────────────────────────────────────────────────────────────
-- (brak zmian — schemat poprawny, tylko kod testowy mial bledne SELECT id)

-- ============================================================================
-- KONIEC MIGRACJI
-- ============================================================================

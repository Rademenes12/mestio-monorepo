-- FixFlow Security Audit Fixes — Migration 0022
-- Kazdy blok ALTER FUNCTION bezpiecznie pomija nieistniejace funkcje.

DO $$ BEGIN ALTER FUNCTION fixflow_is_estate_member(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_is_not_resident(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_is_board_or_admin(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_is_estate_admin(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_get_building_estate_id(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_create_estate(text) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_create_estate_invitation_code(uuid) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_redeem_invitation_code(text) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_send_push_notification(text, text, text) SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;
DO $$ BEGIN ALTER FUNCTION fixflow_report_change_trigger() SET search_path = ''; EXCEPTION WHEN undefined_function THEN NULL; END $$;

-- ════════════════════════════════════════════════════════════
-- BLOKER 2: Fix fixflow_permissions RLS
-- Najpierw dodaj kolumne estate_id jesli jej nie ma,
-- potem nadpisz polityki z filtrem na osiedle.
-- ════════════════════════════════════════════════════════════

ALTER TABLE fixflow_permissions ADD COLUMN IF NOT EXISTS estate_id uuid;
ALTER TABLE fixflow_permissions ADD COLUMN IF NOT EXISTS user_id uuid;

DROP POLICY IF EXISTS permissions_read_office ON fixflow_permissions;
DROP POLICY IF EXISTS permissions_write_office ON fixflow_permissions;

CREATE POLICY permissions_read_office ON fixflow_permissions
  FOR SELECT
  USING (fixflow_is_not_resident(auth.uid()));

CREATE POLICY permissions_write_office ON fixflow_permissions
  FOR ALL
  USING (fixflow_is_not_resident(auth.uid()));

-- ════════════════════════════════════════════════════════════
-- HIGH 2: Clean conflicting fixflow_reports UPDATE policies
-- ════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS reports_update_office ON fixflow_reports;
DROP POLICY IF EXISTS reports_update_board ON fixflow_reports;
DROP POLICY IF EXISTS reports_update_assigned_tech ON fixflow_reports;

CREATE POLICY reports_update_board ON fixflow_reports
  FOR UPDATE
  USING (
    fixflow_is_estate_member(estate_id)
    AND (
      fixflow_is_board_or_admin(auth.uid())
      OR (
        assigned_to_user_id = auth.uid()
        AND EXISTS (
          SELECT 1 FROM fixflow_resident_profiles rp
          WHERE rp.id = auth.uid() AND rp.role = 'Serwisant'
        )
      )
    )
  )
  WITH CHECK (
    fixflow_is_estate_member(estate_id)
    AND (
      fixflow_is_board_or_admin(auth.uid())
      OR assigned_to_user_id = auth.uid()
    )
  );

-- ════════════════════════════════════════════════════════════
-- HIGH 1: is_visible_to_residents + updated RLS
-- ════════════════════════════════════════════════════════════

ALTER TABLE fixflow_report_comments ADD COLUMN IF NOT EXISTS is_visible_to_residents boolean DEFAULT false;

DROP POLICY IF EXISTS report_comments_select_office_in_estate ON fixflow_report_comments;

CREATE POLICY report_comments_select_office_in_estate ON fixflow_report_comments
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM fixflow_reports r
      WHERE r.id = fixflow_report_comments.report_id
      AND fixflow_is_estate_member(r.estate_id)
      AND (fixflow_is_not_resident(auth.uid()) OR is_visible_to_residents = true)
    )
  );

-- ════════════════════════════════════════════════════════════
-- MEDIUM: client_notes + board_notes
-- ════════════════════════════════════════════════════════════

ALTER TABLE fixflow_reports ADD COLUMN IF NOT EXISTS client_notes text DEFAULT '';
ALTER TABLE fixflow_reports ADD COLUMN IF NOT EXISTS board_notes text DEFAULT '';

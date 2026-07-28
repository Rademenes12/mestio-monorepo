-- Fix fixflow_maintenance_schedules write policy: migration 0021 only
-- allowed role = 'admin' (Administrator), silently excluding 'board'
-- (Zarząd) even though both roles are treated as estate management
-- elsewhere (e.g. 0040_rodo_hide_contacts.sql uses the same admin+board
-- pairing). Without this fix, Zarząd users get RLS-denied errors from the
-- new "Konserwacja prewencyjna" UI.

DROP POLICY IF EXISTS maintenance_write_board ON fixflow_maintenance_schedules;
CREATE POLICY maintenance_write_board ON fixflow_maintenance_schedules
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM fixflow_user_estates
      WHERE fixflow_user_estates.estate_id = fixflow_maintenance_schedules.estate_id
      AND fixflow_user_estates.user_id = auth.uid()
      AND fixflow_user_estates.role IN ('admin', 'board')
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM fixflow_user_estates
      WHERE fixflow_user_estates.estate_id = fixflow_maintenance_schedules.estate_id
      AND fixflow_user_estates.user_id = auth.uid()
      AND fixflow_user_estates.role IN ('admin', 'board')
    )
  );

GRANT SELECT, INSERT, UPDATE, DELETE ON fixflow_maintenance_schedules TO authenticated;

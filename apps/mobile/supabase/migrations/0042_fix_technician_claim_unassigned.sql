-- =====================================================
-- Fix: Technician can claim unassigned reports
-- =====================================================
-- Migration 0022 created reports_update_board that checks
-- assigned_to_user_id = auth.uid() — correct for assigned reports
-- but blocks technicians from claiming unassigned reports
-- (assigned_to_user_id IS NULL fails the USING check).
-- This allows technicians to update unassigned reports so they
-- can auto-claim them when changing status.

DROP POLICY IF EXISTS reports_update_board ON public.fixflow_reports;

CREATE POLICY reports_update_board ON public.fixflow_reports
  FOR UPDATE
  USING (
    fixflow_is_estate_member(estate_id)
    AND (
      fixflow_is_board_or_admin(auth.uid())
      OR (
        (assigned_to_user_id = auth.uid() OR assigned_to_user_id IS NULL)
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
      OR (assigned_to_user_id = auth.uid() OR assigned_to_user_id IS NULL)
    )
  );

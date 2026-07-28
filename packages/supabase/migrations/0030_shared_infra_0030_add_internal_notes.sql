-- Migration: Add internal notes support
-- Description: Adds is_internal column to differentiate service notes from team notes

-- Add is_internal column (default false = visible to residents)
ALTER TABLE fixflow_report_comments
ADD COLUMN is_internal BOOLEAN NOT NULL DEFAULT false;

-- Update comment
COMMENT ON COLUMN fixflow_report_comments.is_internal IS 'Internal team notes (true) vs service notes visible to residents (false)';

-- Update RLS policy: residents can only see non-internal comments
DROP POLICY IF EXISTS "report_comments_select_by_estate_member" ON fixflow_report_comments;

CREATE POLICY "report_comments_select_by_estate_member"
ON fixflow_report_comments FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM fixflow_reports r
    INNER JOIN fixflow_user_estates ue ON ue.estate_id = r.estate_id
    WHERE r.id = fixflow_report_comments.report_id
      AND ue.user_id = auth.uid()
      -- Residents only see non-internal comments
      AND (
        ue.role IN ('admin', 'technician') 
        OR (ue.role = 'resident' AND is_internal = false)
        OR (ue.role = 'security' AND is_internal = false)
      )
  )
);

-- Index for filtering internal vs public notes
CREATE INDEX idx_report_comments_internal 
ON fixflow_report_comments(report_id, is_internal);

-- Migration: Fix report_images RLS - add resident SELECT + DELETE
-- Also resolves report_comments policy conflict from 0030

-- ============================================================================
-- FIX 1: Add SELECT for residents on their own report images
-- ============================================================================
DROP POLICY IF EXISTS "report_images_select_own" ON fixflow_report_images;

CREATE POLICY "report_images_select_own"
ON fixflow_report_images FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM fixflow_reports
    WHERE id = fixflow_report_images.report_id
      AND reporter_email = (SELECT email FROM auth.users WHERE id = auth.uid())
  )
);

-- ============================================================================
-- FIX 2: Add DELETE policy for report images (admin + image owner)
-- ============================================================================
DROP POLICY IF EXISTS "report_images_delete_estate_admin" ON fixflow_report_images;

CREATE POLICY "report_images_delete_estate_admin"
ON fixflow_report_images FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM fixflow_user_estates
    WHERE user_id = auth.uid()
      AND estate_id IN (
        SELECT estate_id FROM fixflow_reports WHERE id = fixflow_report_images.report_id
      )
      AND role = 'admin'
  )
);

-- Grant DELETE to authenticated
GRANT DELETE ON fixflow_report_images TO authenticated;

-- ============================================================================
-- FIX 3: Resolve report_comments policy conflict
-- Drop the old 0023 policy that was never dropped in 0030
-- ============================================================================
DROP POLICY IF EXISTS "report_comments_select_all" ON fixflow_report_comments;

-- ============================================================================
-- FIX 4: Add DELETE policy for report_comments (admin only)
-- ============================================================================
DROP POLICY IF EXISTS "report_comments_delete_admin" ON fixflow_report_comments;

CREATE POLICY "report_comments_delete_admin"
ON fixflow_report_comments FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM fixflow_reports r
    INNER JOIN fixflow_user_estates ue ON ue.estate_id = r.estate_id
    WHERE r.id = fixflow_report_comments.report_id
      AND ue.user_id = auth.uid()
      AND ue.role = 'admin'
  )
);

GRANT DELETE ON fixflow_report_comments TO authenticated;

-- ============================================================================
-- FIX 5: Add DELETE for fixflow_report_internal_notes (admin only)
-- ============================================================================
DROP POLICY IF EXISTS "internal_notes_delete_staff" ON fixflow_report_internal_notes;

CREATE POLICY "internal_notes_delete_staff"
ON fixflow_report_internal_notes FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM fixflow_reports r
    INNER JOIN fixflow_user_estates ue ON ue.estate_id = r.estate_id
    WHERE r.id = fixflow_report_internal_notes.report_id
      AND ue.user_id = auth.uid()
      AND ue.role = 'admin'
  )
);

GRANT DELETE ON fixflow_report_internal_notes TO authenticated;

-- ============================================================================
-- FIX 6: Add DELETE for fixflow_content_reports (admin review)
-- ============================================================================
DROP POLICY IF EXISTS "content_reports_delete_admin" ON fixflow_content_reports;

CREATE POLICY "content_reports_delete_admin"
ON fixflow_content_reports FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM fixflow_user_estates
    WHERE user_id = auth.uid()
      AND role = 'admin'
  )
);

GRANT DELETE ON fixflow_content_reports TO authenticated;

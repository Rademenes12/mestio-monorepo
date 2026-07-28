-- fixflow_report_images: residents could already SELECT/DELETE their own
-- report's images (0034) but had no INSERT policy at all — only
-- "office/staff" could insert (0014). This blocked the multi-photo gallery
-- feature: a resident attaching more than one photo when creating their own
-- report needs to insert here directly.

DROP POLICY IF EXISTS "report_images_insert_own" ON fixflow_report_images;

CREATE POLICY "report_images_insert_own"
ON fixflow_report_images FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM fixflow_reports
    WHERE id = fixflow_report_images.report_id
      AND reporter_email = (SELECT email FROM auth.users WHERE id = auth.uid())
  )
);

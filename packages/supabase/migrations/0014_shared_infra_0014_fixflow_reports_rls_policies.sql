-- ============================================================================
-- FixFlow — MIGRACJA UZUPEŁNIAJĄCA POLITYKI RLS
-- ============================================================================
-- Migracja 0012 włączała RLS na tabelach FixFlow, ale nie tworzyła polityk
-- dla fixflow_reports, fixflow_report_comments ani fixflow_report_images.
-- Bez tych polityk każda operacja na tych tabelach kończy się błędem 42501
-- (permission denied), dlatego np. Ochrona nie mogła dodawać zgłoszeń.
-- ============================================================================

-- fixflow_reports: members can read reports visible to them
DROP POLICY IF EXISTS "reports_select_estate_members" ON public.fixflow_reports;
CREATE POLICY "reports_select_estate_members"
ON public.fixflow_reports FOR SELECT
USING (
  public.fixflow_is_estate_member(estate_id)
  AND (
    public.fixflow_is_not_resident((SELECT auth.uid()))
    OR reporter_email = (
      SELECT email FROM public.fixflow_resident_profiles WHERE id = (SELECT auth.uid())
    )
  )
);

-- fixflow_reports: any estate member can create a report
DROP POLICY IF EXISTS "reports_insert_estate_members" ON public.fixflow_reports;
CREATE POLICY "reports_insert_estate_members"
ON public.fixflow_reports FOR INSERT
WITH CHECK (public.fixflow_is_estate_member(estate_id));

-- fixflow_reports: office/staff can update reports in their estate
DROP POLICY IF EXISTS "reports_update_office" ON public.fixflow_reports;
CREATE POLICY "reports_update_office"
ON public.fixflow_reports FOR UPDATE
USING (
  public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_not_resident((SELECT auth.uid()))
)
WITH CHECK (
  public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_not_resident((SELECT auth.uid()))
);

-- fixflow_reports: only estate admins can delete reports
DROP POLICY IF EXISTS "reports_delete_estate_admin" ON public.fixflow_reports;
CREATE POLICY "reports_delete_estate_admin"
ON public.fixflow_reports FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));

-- fixflow_report_comments: office/staff can view comments for reports in their estate
DROP POLICY IF EXISTS "report_comments_select_office_in_estate" ON public.fixflow_report_comments;
CREATE POLICY "report_comments_select_office_in_estate"
ON public.fixflow_report_comments FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_comments: office/staff can add comments to reports in their estate
DROP POLICY IF EXISTS "report_comments_insert_office_in_estate" ON public.fixflow_report_comments;
CREATE POLICY "report_comments_insert_office_in_estate"
ON public.fixflow_report_comments FOR INSERT
WITH CHECK (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_images: office/staff can view images for reports in their estate
DROP POLICY IF EXISTS "report_images_select_office_in_estate" ON public.fixflow_report_images;
CREATE POLICY "report_images_select_office_in_estate"
ON public.fixflow_report_images FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_images: office/staff can add images to reports in their estate
DROP POLICY IF EXISTS "report_images_insert_office_in_estate" ON public.fixflow_report_images;
CREATE POLICY "report_images_insert_office_in_estate"
ON public.fixflow_report_images FOR INSERT
WITH CHECK (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- ============================================================================
-- FixFlow — MIGRACJA BEZPIECZENSTWA RLS (kroki 1-8)
-- ============================================================================
-- Ta migracja zostala juz zastosowana na bazie. Plik sluzy jako dokumentacja
-- i umozliwia odtworzenie schematu z repo.
-- ============================================================================

-- KROK 1 — estate_id na zgloszeniach
ALTER TABLE public.fixflow_reports
  ADD COLUMN IF NOT EXISTS estate_id uuid
  REFERENCES public.fixflow_estates(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_fixflow_reports_estate
  ON public.fixflow_reports(estate_id);

-- Polityki RLS dla reports (mieszkaniec tylko swoje; biuro/serwis cale osiedle)
DROP POLICY IF EXISTS "Authenticated users can read reports"   ON public.fixflow_reports;
DROP POLICY IF EXISTS "Authenticated users can create reports" ON public.fixflow_reports;
DROP POLICY IF EXISTS "Authenticated users can update reports" ON public.fixflow_reports;
DROP POLICY IF EXISTS "Authenticated users can delete reports" ON public.fixflow_reports;

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

CREATE POLICY "reports_insert_estate_members"
ON public.fixflow_reports FOR INSERT
WITH CHECK (public.fixflow_is_estate_member(estate_id));

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

CREATE POLICY "reports_delete_estate_admin"
ON public.fixflow_reports FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));


-- KROK 2 — RLS na budynkach i klatkach
DROP POLICY IF EXISTS "Anyone can read buildings"   ON public.fixflow_buildings;
DROP POLICY IF EXISTS "Anyone can insert buildings" ON public.fixflow_buildings;
DROP POLICY IF EXISTS "Anyone can update buildings" ON public.fixflow_buildings;
DROP POLICY IF EXISTS "Anyone can delete buildings" ON public.fixflow_buildings;

CREATE POLICY "buildings_select_members" ON public.fixflow_buildings FOR SELECT
USING (public.fixflow_is_estate_member(estate_id));
CREATE POLICY "buildings_insert_admin" ON public.fixflow_buildings FOR INSERT
WITH CHECK (public.fixflow_is_estate_admin(estate_id));
CREATE POLICY "buildings_update_admin" ON public.fixflow_buildings FOR UPDATE
USING (public.fixflow_is_estate_admin(estate_id))
WITH CHECK (public.fixflow_is_estate_admin(estate_id));
CREATE POLICY "buildings_delete_admin" ON public.fixflow_buildings FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));

DROP POLICY IF EXISTS "Anyone can read stairwells"   ON public.fixflow_stairwells;
DROP POLICY IF EXISTS "Anyone can insert stairwells" ON public.fixflow_stairwells;
DROP POLICY IF EXISTS "Anyone can update stairwells" ON public.fixflow_stairwells;
DROP POLICY IF EXISTS "Anyone can delete stairwells" ON public.fixflow_stairwells;

CREATE POLICY "stairwells_select_members" ON public.fixflow_stairwells FOR SELECT
USING (EXISTS (SELECT 1 FROM public.fixflow_buildings b
  WHERE b.id = building_id AND public.fixflow_is_estate_member(b.estate_id)));
CREATE POLICY "stairwells_insert_admin" ON public.fixflow_stairwells FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.fixflow_buildings b
  WHERE b.id = building_id AND public.fixflow_is_estate_admin(b.estate_id)));
CREATE POLICY "stairwells_update_admin" ON public.fixflow_stairwells FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.fixflow_buildings b
  WHERE b.id = building_id AND public.fixflow_is_estate_admin(b.estate_id)))
WITH CHECK (EXISTS (SELECT 1 FROM public.fixflow_buildings b
  WHERE b.id = building_id AND public.fixflow_is_estate_admin(b.estate_id)));
CREATE POLICY "stairwells_delete_admin" ON public.fixflow_stairwells FOR DELETE
USING (EXISTS (SELECT 1 FROM public.fixflow_buildings b
  WHERE b.id = building_id AND public.fixflow_is_estate_admin(b.estate_id)));


-- KROK 3 — RLS na kodach zaproszen
DROP POLICY IF EXISTS "Admin can manage invitation codes"        ON public.fixflow_invitation_codes;
DROP POLICY IF EXISTS "Anyone can check invitation code validity" ON public.fixflow_invitation_codes;

CREATE POLICY "invitation_codes_select_admin" ON public.fixflow_invitation_codes FOR SELECT
USING (public.fixflow_is_estate_admin(estate_id));
CREATE POLICY "invitation_codes_insert_admin" ON public.fixflow_invitation_codes FOR INSERT
WITH CHECK (public.fixflow_is_estate_admin(estate_id));
CREATE POLICY "invitation_codes_update_admin" ON public.fixflow_invitation_codes FOR UPDATE
USING (public.fixflow_is_estate_admin(estate_id))
WITH CHECK (public.fixflow_is_estate_admin(estate_id));
CREATE POLICY "invitation_codes_delete_admin" ON public.fixflow_invitation_codes FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));


-- KROK 5 — mieszkancy filtrowani po osiedlu (widok)
CREATE OR REPLACE VIEW public.v_fixflow_residents_by_estate
WITH (security_invoker = true) AS
SELECT rp.id, rp.name, rp.email, rp.phone,
       rp.building, rp.footbridge, rp.floor, rp.apartment,
       rp.role, rp.is_verified, rp.created_at, ue.estate_id
FROM public.fixflow_resident_profiles rp
JOIN public.fixflow_user_estates ue ON ue.user_id = rp.id;

DROP POLICY IF EXISTS "Board can read all resident profiles" ON public.fixflow_resident_profiles;

CREATE POLICY "resident_profiles_board_read_own_estate"
ON public.fixflow_resident_profiles FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates ue_self
    JOIN public.fixflow_user_estates ue_target
      ON ue_target.estate_id = ue_self.estate_id
    WHERE ue_self.user_id = (SELECT auth.uid())
      AND ue_target.user_id = fixflow_resident_profiles.id
  )
);


-- KROK 7 — zdjecia do Supabase Storage (prywatny bucket)
INSERT INTO storage.buckets (id, name, public)
VALUES ('fixflow-report-photos', 'fixflow-report-photos', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "report_photos_select_members"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'fixflow-report-photos'
  AND public.fixflow_is_estate_member(NULLIF((storage.foldername(name))[1], '')::uuid));

CREATE POLICY "report_photos_insert_members"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'fixflow-report-photos'
  AND public.fixflow_is_estate_member(NULLIF((storage.foldername(name))[1], '')::uuid));

CREATE POLICY "report_photos_delete_admin"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'fixflow-report-photos'
  AND public.fixflow_is_estate_admin(NULLIF((storage.foldername(name))[1], '')::uuid));


-- KROK 8 — permissions, FK i RLS komentarzy/zdjec
DROP POLICY IF EXISTS "Admin can manage permissions" ON public.fixflow_permissions;
CREATE POLICY "permissions_read_office" ON public.fixflow_permissions FOR SELECT
USING (public.fixflow_is_not_resident((SELECT auth.uid())));
CREATE POLICY "permissions_write_office" ON public.fixflow_permissions FOR ALL
USING (public.fixflow_is_not_resident((SELECT auth.uid())))
WITH CHECK (public.fixflow_is_not_resident((SELECT auth.uid())));

ALTER TABLE public.fixflow_report_comments
  ADD CONSTRAINT fk_report_comments_report
  FOREIGN KEY (report_id) REFERENCES public.fixflow_reports(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE public.fixflow_report_comments VALIDATE CONSTRAINT fk_report_comments_report;

ALTER TABLE public.fixflow_report_images
  ADD CONSTRAINT fk_report_images_report
  FOREIGN KEY (report_id) REFERENCES public.fixflow_reports(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE public.fixflow_report_images VALIDATE CONSTRAINT fk_report_images_report;

DROP POLICY IF EXISTS "Non-residents can view report comments" ON public.fixflow_report_comments;
DROP POLICY IF EXISTS "Non-residents can add report comments"  ON public.fixflow_report_comments;

CREATE POLICY "report_comments_select_office_in_estate"
ON public.fixflow_report_comments FOR SELECT
USING (public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)));

CREATE POLICY "report_comments_insert_office_in_estate"
ON public.fixflow_report_comments FOR INSERT
WITH CHECK (public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)));

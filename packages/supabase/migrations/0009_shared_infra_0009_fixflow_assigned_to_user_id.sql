-- ============================================================================
-- KROK 9 — assigned_to_user_id: powiązanie z kontem serwisanta
-- ============================================================================

-- Dodaj nową kolumnę uuid (nie ruszamy starej text, by nie zepsuć żywej apki)
ALTER TABLE public.fixflow_reports
  ADD COLUMN IF NOT EXISTS assigned_to_user_id uuid
  REFERENCES public.fixflow_resident_profiles(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_fixflow_reports_assigned_uid
  ON public.fixflow_reports(assigned_to_user_id);

-- Backfill: dopasuj istniejący tekst (e-mail lub nazwa) do konta serwisanta
UPDATE public.fixflow_reports r
SET assigned_to_user_id = rp.id
FROM public.fixflow_resident_profiles rp
WHERE r.assigned_to_user_id IS NULL
  AND r.assigned_to IS NOT NULL
  AND rp.role = 'Serwisant'
  AND (lower(rp.email) = lower(r.assigned_to) OR rp.name = r.assigned_to);

-- Zawężenie zapisu: biuro edytuje wszystko w osiedlu; serwisant tylko przypisane
DROP POLICY IF EXISTS "reports_update_office" ON public.fixflow_reports;

CREATE POLICY "reports_update_board"
ON public.fixflow_reports FOR UPDATE
USING (public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_board_or_admin((SELECT auth.uid())))
WITH CHECK (public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_board_or_admin((SELECT auth.uid())));

CREATE POLICY "reports_update_assigned_tech"
ON public.fixflow_reports FOR UPDATE
USING (
  public.fixflow_is_estate_member(estate_id)
  AND assigned_to_user_id = (SELECT auth.uid())
  AND EXISTS (SELECT 1 FROM public.fixflow_resident_profiles rp
    WHERE rp.id = (SELECT auth.uid()) AND rp.role = 'Serwisant')
)
WITH CHECK (
  public.fixflow_is_estate_member(estate_id)
  AND assigned_to_user_id = (SELECT auth.uid())
);

-- ============================================================================
-- RLS CONFIGURATION — FixFlow CRM Klienta
-- ============================================================================
-- Run these in Supabase SQL Editor (one table at a time recommended)
-- These complement the mobile app's existing RLS policies
-- ============================================================================

-- 1. fixflow_reports — status "Odrzucone" only for admin/board
DROP FUNCTION IF EXISTS public.fixflow_can_update_report(uuid);
CREATE FUNCTION public.fixflow_can_update_report(report_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    JOIN public.fixflow_user_estates ue
      ON r.estate_id = ue.estate_id AND ue.user_id = auth.uid()
    WHERE r.id::uuid = report_id
    AND ue.role IN ('admin', 'board')
  );
$$;

-- Add WITH CHECK for UPDATE (status "Odrzucone" only admin/board)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'fixflow_reports_update_check'
    AND tablename = 'fixflow_reports'
  ) THEN
    EXECUTE $p$
      CREATE POLICY fixflow_reports_update_check ON public.fixflow_reports
        FOR UPDATE
        USING (
          EXISTS (
            SELECT 1 FROM public.fixflow_user_estates ue
            WHERE ue.estate_id = fixflow_reports.estate_id
            AND ue.user_id = auth.uid()
            AND ue.role IN ('admin', 'board')
          )
        );
    $p$;
  END IF;
END $$;

-- 2. fixflow_report_internal_notes — visible only to admin/board
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'fixflow_rpt_notes_admin_board'
    AND tablename = 'fixflow_report_internal_notes'
  ) THEN
    EXECUTE $p$
      CREATE POLICY fixflow_rpt_notes_admin_board ON public.fixflow_report_internal_notes
        FOR ALL
        USING (
          EXISTS (
            SELECT 1 FROM public.fixflow_reports r
            JOIN public.fixflow_user_estates ue
              ON r.estate_id = ue.estate_id AND ue.user_id = auth.uid()
            WHERE r.id::text = fixflow_report_internal_notes.report_id
            AND ue.role IN ('admin', 'board')
          )
        );
    $p$;
  END IF;
END $$;

-- 3. fixflow_estates — only admin can toggle hide_resident_contacts
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'fixflow_estates_update_rodo_admin'
    AND tablename = 'fixflow_estates'
  ) THEN
    EXECUTE $p$
      CREATE POLICY fixflow_estates_update_rodo_admin ON public.fixflow_estates
        FOR UPDATE
        USING (
          EXISTS (
            SELECT 1 FROM public.fixflow_user_estates ue
            WHERE ue.estate_id = fixflow_estates.id
            AND ue.user_id = auth.uid()
            AND ue.role = 'admin'
          )
        );
    $p$;
  END IF;
END $$;

-- 4. fixflow_invitation_codes — only admin creates admin/board codes
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'fixflow_invite_codes_insert_admin_restrict'
    AND tablename = 'fixflow_invitation_codes'
  ) THEN
    EXECUTE $p$
      CREATE POLICY fixflow_invite_codes_insert_admin_restrict
        ON public.fixflow_invitation_codes
        FOR INSERT
        WITH CHECK (
          EXISTS (
            SELECT 1 FROM public.fixflow_user_estates ue
            WHERE ue.estate_id = fixflow_invitation_codes.estate_id
            AND ue.user_id = auth.uid()
            AND (
              ue.role = 'admin'
              OR (ue.role = 'board' AND fixflow_invitation_codes.role NOT IN ('admin', 'board'))
            )
          )
        );
    $p$;
  END IF;
END $$;

-- 5. fixflow_join_requests — only admin/board of the estate can approve/reject
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE policyname = 'fixflow_join_requests_update_estate_admin'
    AND tablename = 'fixflow_join_requests'
  ) THEN
    EXECUTE $p$
      CREATE POLICY fixflow_join_requests_update_estate_admin ON public.fixflow_join_requests
        FOR UPDATE
        USING (
          EXISTS (
            SELECT 1 FROM public.fixflow_user_estates ue
            WHERE ue.estate_id = fixflow_join_requests.estate_id
            AND ue.user_id = auth.uid()
            AND ue.role IN ('admin', 'board')
          )
        );
    $p$;
  END IF;
END $$;

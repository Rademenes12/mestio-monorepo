-- 0058: Fix pre-existing bugs found in ecosystem audit
--
-- Bug 0: Migrations 0053 (fixflow_resident_spaces) and 0054
--        (fixflow_estate_health_index) were marked as "applied" in the
--        migration history table, but were NEVER actually executed against
--        the remote database (same "migration repair without running SQL"
--        pattern documented in STATE.md for the 0013 push notification
--        trigger). Verified via `supabase db query --linked`: the table
--        and the function are both absent in production. This migration
--        recreates them from scratch (idempotent) with the bugs below
--        already fixed, so no separate follow-up migration is needed.
--
-- Bug 1: fixflow_resident_spaces RLS policy referenced fixflow_is_board(uuid),
--        a function that was never defined anywhere in the migration history.
--        fixflow_is_estate_admin() already covers admin AND board roles
--        (see 0045), so it is redundant and safe to drop.
--
-- Bug 2: fixflow_report_content() was created with SET search_path = public
--        instead of '' (unlike every other SECURITY DEFINER function in this
--        project). Recreate it with search_path = '' and public.-qualified
--        table references to close the search_path hijacking vector.

-- ============================================================
-- Bug 0a: recreate fixflow_resident_spaces (never actually applied)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.fixflow_resident_spaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('storage','basement','parking','garage','other')),
  label text NOT NULL,
  created_by text NOT NULL DEFAULT 'resident',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_resident_spaces_user_id ON public.fixflow_resident_spaces(user_id);
CREATE INDEX IF NOT EXISTS idx_resident_spaces_estate_id ON public.fixflow_resident_spaces(estate_id);

ALTER TABLE public.fixflow_resident_spaces ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE ON public.fixflow_resident_spaces TO authenticated;

DROP POLICY IF EXISTS resident_spaces_owner ON public.fixflow_resident_spaces;
CREATE POLICY resident_spaces_owner ON public.fixflow_resident_spaces
  FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ============================================================
-- Bug 1: fixflow_resident_spaces RLS (fixflow_is_board() never existed)
-- ============================================================
DROP POLICY IF EXISTS resident_spaces_office ON public.fixflow_resident_spaces;

CREATE POLICY resident_spaces_office ON public.fixflow_resident_spaces
  FOR ALL
  USING (public.fixflow_is_estate_admin(estate_id))
  WITH CHECK (public.fixflow_is_estate_admin(estate_id));

-- ============================================================
-- Bug 2: fixflow_report_content search_path
-- ============================================================
CREATE OR REPLACE FUNCTION public.fixflow_report_content(
  p_content_type public.fixflow_content_report_type,
  p_content_id uuid,
  p_reason public.fixflow_content_report_reason,
  p_description text DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid;
  v_report_count integer;
  v_report_id uuid;
BEGIN
  v_user_id := auth.uid();

  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'unauthenticated'
    );
  END IF;

  -- Rate limiting: max 5 reports per user per 24 hours
  SELECT count(*)
  INTO v_report_count
  FROM public.fixflow_content_reports
  WHERE reporter_id = v_user_id
    AND created_at > now() - interval '24 hours';

  IF v_report_count >= 5 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'rate_limit_exceeded'
    );
  END IF;

  -- Validate content exists based on type
  CASE p_content_type
    WHEN 'announcement' THEN
      IF NOT EXISTS (SELECT 1 FROM public.fixflow_announcements WHERE id = p_content_id) THEN
        RETURN jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      END IF;

    WHEN 'report_comment' THEN
      IF NOT EXISTS (SELECT 1 FROM public.fixflow_report_comments WHERE id = p_content_id) THEN
        RETURN jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      END IF;

    WHEN 'emergency_contact' THEN
      IF NOT EXISTS (SELECT 1 FROM public.fixflow_emergency_contacts WHERE id = p_content_id) THEN
        RETURN jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      END IF;
  END CASE;

  -- Insert report (or return existing if duplicate)
  INSERT INTO public.fixflow_content_reports (
    reporter_id,
    content_type,
    content_id,
    reason,
    description,
    status
  )
  VALUES (
    v_user_id,
    p_content_type,
    p_content_id,
    p_reason,
    p_description,
    'pending'
  )
  ON CONFLICT (reporter_id, content_type, content_id)
  DO NOTHING
  RETURNING id INTO v_report_id;

  IF v_report_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'already_reported'
    );
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'report_id', v_report_id
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_report_content(
  public.fixflow_content_report_type, uuid, public.fixflow_content_report_reason, text
) TO authenticated;

-- ============================================================
-- Bug 3: fixflow_estate_health_index references fixflow_reports
--        without the public. schema prefix while search_path = ''.
--        This raises "relation does not exist" at runtime.
-- ============================================================
CREATE OR REPLACE FUNCTION public.fixflow_estate_health_index(p_estate_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_total_reports int;
  v_open_reports int;
  v_overdue_reports int;
  v_open_score numeric;
  v_overdue_score numeric;
  v_total_score int;
  v_label text;
  v_color text;
BEGIN
  -- Count reports for this estate
  SELECT
    count(*) FILTER (WHERE status_enum IS DISTINCT FROM 'closed' AND status_enum IS DISTINCT FROM 'rejected'),
    count(*) FILTER (WHERE status_enum IS DISTINCT FROM 'closed' AND status_enum IS DISTINCT FROM 'rejected' AND sla_deadline < now()),
    count(*)
  INTO v_open_reports, v_overdue_reports, v_total_reports
  FROM public.fixflow_reports
  WHERE estate_id = p_estate_id;

  -- Open reports score (inverted: fewer open = higher score)
  IF v_total_reports = 0 THEN
    v_open_score := 100;
  ELSE
    v_open_score := 100 - ((v_open_reports::numeric / v_total_reports) * 50);
  END IF;

  -- Overdue SLA score
  IF v_open_reports = 0 THEN
    v_overdue_score := 100;
  ELSE
    v_overdue_score := 100 - ((v_overdue_reports::numeric / v_open_reports) * 50);
  END IF;

  -- Composite score (simple average for prototype)
  v_total_score := greatest(0, least(100, ((v_open_score + v_overdue_score) / 2)::int));

  -- Label based on score thresholds
  IF v_total_score >= 80 THEN
    v_label := 'Dobry stan';
    v_color := '#2E9E6B';
  ELSIF v_total_score >= 50 THEN
    v_label := 'Wymaga uwagi';
    v_color := '#F2A900';
  ELSE
    v_label := 'Krytyczny';
    v_color := '#C0392B';
  END IF;

  RETURN jsonb_build_object(
    'score', v_total_score,
    'label', v_label,
    'color', v_color,
    'open_reports', v_open_reports,
    'overdue_reports', v_overdue_reports,
    'total_reports', v_total_reports
  );
END;
$$;

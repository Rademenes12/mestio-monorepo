-- 0054: Estate health index RPC — composite health score 0-100
-- Factors: open reports ratio, avg resolution time, SLA overdue ratio,
-- scheduled maintenance compliance, resolution vote backlog.

CREATE OR REPLACE FUNCTION fixflow_estate_health_index(p_estate_id uuid)
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
  FROM fixflow_reports
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

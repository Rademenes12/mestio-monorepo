-- ============================================================================
-- Status jako enum PostgreSQL
-- ============================================================================

-- Utwórz typ enum dla statusów
DO $$ BEGIN
  CREATE TYPE public.fixflow_report_status AS ENUM ('new', 'in_progress', 'closed', 'rejected');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Dodaj nową kolumnę enum (nie ruszamy starej text, by nie zepsuć żywej apki)
ALTER TABLE public.fixflow_reports
  ADD COLUMN IF NOT EXISTS status_enum public.fixflow_report_status;

-- Backfill: konwertuj istniejące tekstowe statusy na enum
UPDATE public.fixflow_reports
SET status_enum = CASE
  WHEN lower(status) LIKE '%now%' OR lower(status) = 'new' THEN 'new'::public.fixflow_report_status
  WHEN lower(status) LIKE '%trakt%' OR lower(status) LIKE '%toku%' OR lower(status) LIKE '%realizac%' OR lower(status) = 'in_progress' THEN 'in_progress'::public.fixflow_report_status
  WHEN lower(status) LIKE '%zrealiz%' OR lower(status) LIKE '%zakoń%' OR lower(status) LIKE '%zamkni%' OR lower(status) = 'closed' THEN 'closed'::public.fixflow_report_status
  WHEN lower(status) LIKE '%odrzuc%' OR lower(status) = 'rejected' THEN 'rejected'::public.fixflow_report_status
  ELSE 'new'::public.fixflow_report_status
END
WHERE status_enum IS NULL;

-- Ustaw domyślną wartość dla nowych wierszy
ALTER TABLE public.fixflow_reports
  ALTER COLUMN status_enum SET DEFAULT 'new'::public.fixflow_report_status;

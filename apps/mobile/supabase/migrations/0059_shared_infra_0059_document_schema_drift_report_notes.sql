-- 0059: Document schema drift found in ecosystem audit.
--
-- `fixflow_reports.tech_notes` and `fixflow_reports.reveal_board_notes_to_tech`
-- already exist on production (confirmed via `supabase db query --linked`)
-- and are actively used by `ReportModel.toJson()` on every insert/update
-- (lib/features/reports/models/report_model.dart), but were never created by
-- any tracked migration - the columns predate full migration history tracking
-- for this project. Without this migration, a fresh environment provisioned
-- purely from `supabase/migrations/` would be missing these columns and every
-- report insert/update would fail with a PostgREST "column not found" error.
--
-- ADD COLUMN IF NOT EXISTS is a no-op on the current production database;
-- this migration exists purely to make migration history match reality.

ALTER TABLE public.fixflow_reports
  ADD COLUMN IF NOT EXISTS tech_notes text,
  ADD COLUMN IF NOT EXISTS reveal_board_notes_to_tech boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN public.fixflow_reports.tech_notes IS
  'Internal notes visible to technicians only, set by board/admin.';

COMMENT ON COLUMN public.fixflow_reports.reveal_board_notes_to_tech IS
  'When true, board_notes is also shown to the assigned technician.';

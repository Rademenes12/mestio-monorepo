-- Migration: Give fixflow_reports a stable reporter_user_id (GDPR fix)
--
-- fixflow-cleanup (the "Delete Account" Edge Function) deletes a user's
-- reports by matching reporter_email = user.email. If the account's email
-- ever differs from what was captured on the report (case difference, email
-- changed after reporting, migrated from an anonymous session, etc.), those
-- reports survive account deletion - directly contradicting the "immediate
-- and permanent deletion" claim in docs/DATA_SAFETY.md.
--
-- Fix: add reporter_user_id defaulting to auth.uid(), so every new report
-- is tied to a stable identity regardless of email changes. Backfill best-
-- effort for existing rows by matching email. fixflow-cleanup (deployed
-- separately) now deletes by reporter_user_id OR reporter_email, covering
-- both old and new rows.

ALTER TABLE public.fixflow_reports
ADD COLUMN IF NOT EXISTS reporter_user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.fixflow_reports
ALTER COLUMN reporter_user_id SET DEFAULT auth.uid();

CREATE INDEX IF NOT EXISTS idx_fixflow_reports_reporter_user_id
ON public.fixflow_reports(reporter_user_id);

-- Best-effort backfill for pre-existing rows (case-insensitive email match).
UPDATE public.fixflow_reports r
SET reporter_user_id = au.id
FROM auth.users au
WHERE r.reporter_user_id IS NULL
  AND lower(au.email) = lower(r.reporter_email);

COMMENT ON COLUMN public.fixflow_reports.reporter_user_id IS
  'Stable identity of the reporter, defaults to auth.uid() at insert time.
   Used by fixflow-cleanup for GDPR-complete deletion (reporter_email alone
   is not reliable across email changes). NULL for rows whose reporter
   account has since been deleted, or legacy rows with no email match.';

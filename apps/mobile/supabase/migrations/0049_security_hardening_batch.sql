-- Migration: Security hardening batch (post-audit)
-- See STATE.md Sesja 12 for the full 3-role audit this addresses.

-- ============================================================
-- 1. Narrow fixflow_subscriptions grants (defense in depth)
-- ============================================================
-- RLS already blocks authenticated from writing here (verified live: a
-- forged INSERT attempt via REST returned 403). But the table-level GRANT
-- currently allows INSERT/UPDATE/DELETE/TRUNCATE for `authenticated` too -
-- if a future RLS policy change is ever misconfigured, the GRANT alone
-- would then permit it. Subscriptions are written exclusively by the
-- stripe-webhook Edge Function via the service_role key, which bypasses
-- RLS/GRANTs entirely - so authenticated never legitimately needs write
-- access here.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON public.fixflow_subscriptions FROM authenticated;

-- ============================================================
-- 2. Anonymize audit trail on account deletion
-- ============================================================
-- fixflow_report_events.user_id is already ON DELETE SET NULL, but the
-- user_name/user_role text snapshot survives account deletion whenever the
-- deleted user acted on someone ELSE's report (e.g. a technician who
-- updated a resident's ticket). fixflow-cleanup only deletes rows the user
-- authored themselves via other tables; it has no reach into text columns
-- on other people's report history. Fix: a trigger that nulls the text
-- snapshot the moment user_id is nulled by the FK cascade.
CREATE OR REPLACE FUNCTION public.fixflow_anonymize_report_event()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NEW.user_id IS NULL AND OLD.user_id IS NOT NULL THEN
    NEW.user_name := NULL;
    NEW.user_role := NULL;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_fixflow_anonymize_report_event ON public.fixflow_report_events;
CREATE TRIGGER trg_fixflow_anonymize_report_event
BEFORE UPDATE ON public.fixflow_report_events
FOR EACH ROW
EXECUTE FUNCTION public.fixflow_anonymize_report_event();

COMMENT ON TRIGGER trg_fixflow_anonymize_report_event ON public.fixflow_report_events IS
  'When user_id is cleared by the auth.users ON DELETE SET NULL cascade
   (account deletion), also clear the user_name/user_role text snapshot so
   the deleted person is not identifiable in someone else''s report history.';

-- One-off backfill: anonymize existing rows where user_id is already NULL
-- (accounts deleted before this trigger existed).
UPDATE public.fixflow_report_events
SET user_name = NULL, user_role = NULL
WHERE user_id IS NULL AND (user_name IS NOT NULL OR user_role IS NOT NULL);

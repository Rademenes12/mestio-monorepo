-- Migration: Recreate the missing push-notification trigger on fixflow_reports
--
-- Discovered during audit: migration 0013 is marked "applied" in the
-- migration history (both local and remote per `supabase migration list`),
-- but neither `fixflow_report_change_trigger()` nor the
-- `fixflow_report_change` trigger it creates actually exist in the live
-- database (verified via pg_proc / pg_trigger - zero rows). Most likely
-- cause: the migration history was resynced via `supabase migration repair`
-- in an earlier session (STATE.md mentions "migration repair 0001-0014"),
-- which marks a migration as applied WITHOUT executing its SQL.
--
-- Net effect: creating, updating status on, or assigning a report has NEVER
-- actually triggered a push notification in production, silently, since the
-- trigger simply wasn't there to fire fixflow_send_push_notification()
-- (itself also fixed in 0047 - it was reachable but pg_net didn't exist and
-- the auth was wrong).
--
-- This migration is close to a straight re-run of 0013, with two additions:
-- SET search_path (defense in depth, all references were already schema-
-- qualified) and idempotent CREATE OR REPLACE / DROP+CREATE so it's safe to
-- run again if repair happens once more.

CREATE OR REPLACE FUNCTION public.fixflow_report_change_trigger()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_reporter_email text;
  v_assigned_email text;
  v_estate_id uuid;
  v_topic text;
  v_title text;
  v_body text;
  v_data jsonb;
BEGIN
  v_estate_id := COALESCE(NEW.estate_id, OLD.estate_id);

  SELECT reporter_email INTO v_reporter_email
  FROM public.fixflow_reports
  WHERE id = COALESCE(NEW.id, OLD.id);

  IF TG_OP = 'INSERT' THEN
    v_topic := 'estate_' || v_estate_id || '_admin';
    v_title := 'Nowe zgłoszenie: ' || NEW.title;
    v_body := 'Zgłoszenie awarii wymaga Twojej uwagi.';
    v_data := jsonb_build_object(
      'reportId', NEW.id::text,
      'status', 'new',
      'estateId', v_estate_id::text
    );

    PERFORM public.fixflow_send_push_notification(v_topic, v_title, v_body, v_data);

    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF NEW.status_enum IS DISTINCT FROM OLD.status_enum THEN
      IF v_reporter_email IS NOT NULL THEN
        v_topic := 'resident_' || lower(regexp_replace(v_reporter_email, '[^a-z0-9]', '_', 'g'));
        v_title := 'Zmiana statusu: ' || NEW.title;
        v_body := 'Twoje zgłoszenie zmieniło status na: ' || NEW.status_enum::text;
        v_data := jsonb_build_object(
          'reportId', NEW.id::text,
          'status', NEW.status_enum::text,
          'estateId', v_estate_id::text
        );

        PERFORM public.fixflow_send_push_notification(v_topic, v_title, v_body, v_data);
      END IF;
    END IF;

    IF NEW.assigned_to_user_id IS DISTINCT FROM OLD.assigned_to_user_id
       AND NEW.assigned_to_user_id IS NOT NULL THEN
      SELECT email INTO v_assigned_email
      FROM public.fixflow_resident_profiles
      WHERE id = NEW.assigned_to_user_id;

      IF v_assigned_email IS NOT NULL THEN
        v_topic := 'tech_' || lower(regexp_replace(
          (SELECT role FROM public.fixflow_resident_profiles WHERE id = NEW.assigned_to_user_id),
          '[^a-z0-9]', '_', 'g'
        ));
        v_title := 'Nowe zlecenie: ' || NEW.title;
        v_body := 'Zgłoszenie zostało przypisane do Ciebie.';
        v_data := jsonb_build_object(
          'reportId', NEW.id::text,
          'status', 'in_progress',
          'estateId', v_estate_id::text
        );

        PERFORM public.fixflow_send_push_notification(v_topic, v_title, v_body, v_data);
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS fixflow_report_change ON public.fixflow_reports;
CREATE TRIGGER fixflow_report_change
AFTER INSERT OR UPDATE ON public.fixflow_reports
FOR EACH ROW
EXECUTE FUNCTION public.fixflow_report_change_trigger();

COMMENT ON TRIGGER fixflow_report_change ON public.fixflow_reports IS
  'RECREATED (0048): was missing from the live DB despite migration 0013
   being marked applied - likely lost to a migration history repair that
   synced history without running the SQL. See 0047 for the related
   pg_net/auth fixes to fixflow_send_push_notification().';

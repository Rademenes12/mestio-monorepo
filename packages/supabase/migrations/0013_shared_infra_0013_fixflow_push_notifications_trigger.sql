-- ============================================================================
-- FixFlow — TRIGGER PUSH NOTIFICATIONS
-- ============================================================================
-- Ten trigger wysyła powiadomienia push gdy:
-- 1. Tworzone jest nowe zgłoszenie (do zarządcy/admina osiedla)
-- 2. Zmieniany jest status zgłoszenia (do zgłaszającego)
-- 3. Przypisywany jest serwisant (do serwisanta)
-- ============================================================================

-- Funkcja wysyłająca powiadomienie przez Edge Function
CREATE OR REPLACE FUNCTION public.fixflow_send_push_notification(
  p_topic text,
  p_title text,
  p_body text,
  p_data jsonb DEFAULT '{}'::jsonb
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Call the Edge Function via HTTP
  -- Note: This requires the Supabase project to have HTTP extension enabled
  -- or we use the net.http_request function
  PERFORM net.http_post(
    url := current_setting('app.settings.supabase_url', true) || '/functions/v1/send-notification',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || current_setting('app.settings.supabase_anon_key', true)
    ),
    body := jsonb_build_object(
      'topic', p_topic,
      'title', p_title,
      'body', p_body,
      'data', p_data
    )
  );
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the transaction
    RAISE WARNING 'Failed to send push notification: %', SQLERRM;
END;
$$;

-- Trigger function for report changes
CREATE OR REPLACE FUNCTION public.fixflow_report_change_trigger()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
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
  -- Get estate_id from NEW or OLD
  v_estate_id := COALESCE(NEW.estate_id, OLD.estate_id);
  
  -- Get reporter email
  SELECT reporter_email INTO v_reporter_email
  FROM public.fixflow_reports
  WHERE id = COALESCE(NEW.id, OLD.id);
  
  -- Handle INSERT (new report)
  IF TG_OP = 'INSERT' THEN
    -- Notify estate admin/board about new report
    v_topic := 'estate_' || v_estate_id || '_admin';
    v_title := 'Nowe zgłoszenie: ' || NEW.title;
    v_body := 'Zgłoszenie awarii wymaga Twojej uwagi.';
    v_data := jsonb_build_object(
      'reportId', NEW.id::text,
      'status', 'new',
      'estateId', v_estate_id::text
    );
    
    PERFORM public.fixflow_send_push_notification(
      v_topic, v_title, v_body, v_data
    );
    
    RETURN NEW;
  END IF;
  
  -- Handle UPDATE (status change or assignment)
  IF TG_OP = 'UPDATE' THEN
    -- Check if status changed
    IF NEW.status_enum IS DISTINCT FROM OLD.status_enum THEN
      -- Notify reporter about status change
      IF v_reporter_email IS NOT NULL THEN
        v_topic := 'resident_' || lower(regexp_replace(v_reporter_email, '[^a-z0-9]', '_', 'g'));
        v_title := 'Zmiana statusu: ' || NEW.title;
        v_body := 'Twoje zgłoszenie zmieniło status na: ' || NEW.status_enum::text;
        v_data := jsonb_build_object(
          'reportId', NEW.id::text,
          'status', NEW.status_enum::text,
          'estateId', v_estate_id::text
        );
        
        PERFORM public.fixflow_send_push_notification(
          v_topic, v_title, v_body, v_data
        );
      END IF;
    END IF;
    
    -- Check if assigned_to_user_id changed (new assignment)
    IF NEW.assigned_to_user_id IS DISTINCT FROM OLD.assigned_to_user_id 
       AND NEW.assigned_to_user_id IS NOT NULL THEN
      -- Get assigned user's email
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
        
        PERFORM public.fixflow_send_push_notification(
          v_topic, v_title, v_body, v_data
        );
      END IF;
    END IF;
    
    RETURN NEW;
  END IF;
  
  RETURN NULL;
END;
$$;

-- Create the trigger
DROP TRIGGER IF EXISTS fixflow_report_change ON public.fixflow_reports;
CREATE TRIGGER fixflow_report_change
AFTER INSERT OR UPDATE ON public.fixflow_reports
FOR EACH ROW
EXECUTE FUNCTION public.fixflow_report_change_trigger();

-- Enable HTTP extension if not already enabled
-- Note: This requires Supabase to have the http extension available
-- CREATE EXTENSION IF NOT EXISTS http;

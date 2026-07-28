-- ════════════════════════════════════════════════════════════════════════════
-- FixFlow B2B Model: Subscription-gated RLS + Audit Events + Priority/CSAT RLS
-- Migration 0025
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- 1. HELPER FUNCTION: Check if estate has active subscription
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_estate_has_active_subscription(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT 
    -- Active or trialing subscription exists
    EXISTS (
      SELECT 1 FROM public.fixflow_subscriptions s
      WHERE s.estate_id = p_estate_id
      AND s.status IN ('active', 'trialing')
    )
    -- OR past_due with grace period (7 days from period end)
    OR EXISTS (
      SELECT 1 FROM public.fixflow_subscriptions s
      WHERE s.estate_id = p_estate_id
      AND s.status = 'past_due'
      AND s.current_period_end > (now() - interval '7 days')
    );
$$;

COMMENT ON FUNCTION public.fixflow_estate_has_active_subscription IS 
'Returns true if estate has active, trialing, or past_due (within 7-day grace) subscription. Used for RLS gating.';

-- ════════════════════════════════════════════════════════════════════════════
-- 2. HELPER FUNCTION: Check if user can set priority (zarząd/admin/ochrona)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_can_set_priority(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_resident_profiles
    WHERE id = p_user_id
    AND role IN ('Zarząd', 'Administrator', 'Ochrona')
  );
$$;

COMMENT ON FUNCTION public.fixflow_can_set_priority IS 
'Returns true if user has role that can set report priority (Zarząd, Administrator, Ochrona).';

-- ════════════════════════════════════════════════════════════════════════════
-- 3. HELPER FUNCTION: Check if user can rate report (author + closed)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_can_rate_report(p_user_id uuid, p_report_id text)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    JOIN public.fixflow_resident_profiles rp ON rp.id = p_user_id
    WHERE r.id = p_report_id
    AND r.reporter_email = rp.email
    AND (r.status = 'Zamknięte' OR r.status_enum = 'closed')
  );
$$;

COMMENT ON FUNCTION public.fixflow_can_rate_report IS 
'Returns true if user is report author AND report is closed (can submit CSAT rating).';

-- ════════════════════════════════════════════════════════════════════════════
-- 4. UPDATE RLS POLICIES: Add subscription gating
-- ════════════════════════════════════════════════════════════════════════════

-- Drop old policies and recreate with subscription check
-- Note: We add subscription check to SELECT policies for core tables

-- fixflow_reports: SELECT with subscription gating
DROP POLICY IF EXISTS "reports_select_estate_members" ON public.fixflow_reports;
DROP POLICY IF EXISTS "reports_select_with_subscription" ON public.fixflow_reports;

CREATE POLICY "reports_select_with_subscription" ON public.fixflow_reports
  FOR SELECT USING (
    public.fixflow_is_estate_member(estate_id)
    AND public.fixflow_estate_has_active_subscription(estate_id)
    AND (
      public.fixflow_is_not_resident(auth.uid())
      OR reporter_email = (
        SELECT email FROM public.fixflow_resident_profiles WHERE id = auth.uid()
      )
    )
  );

-- fixflow_reports: INSERT with subscription gating
DROP POLICY IF EXISTS "reports_insert_estate_members" ON public.fixflow_reports;
DROP POLICY IF EXISTS "reports_insert_with_subscription" ON public.fixflow_reports;

CREATE POLICY "reports_insert_with_subscription" ON public.fixflow_reports
  FOR INSERT WITH CHECK (
    public.fixflow_is_estate_member(estate_id)
    AND public.fixflow_estate_has_active_subscription(estate_id)
  );

-- fixflow_buildings: SELECT with subscription gating
DROP POLICY IF EXISTS "buildings_select_members" ON public.fixflow_buildings;
DROP POLICY IF EXISTS "buildings_select_with_subscription" ON public.fixflow_buildings;

CREATE POLICY "buildings_select_with_subscription" ON public.fixflow_buildings
  FOR SELECT USING (
    public.fixflow_is_estate_member(estate_id)
    AND public.fixflow_estate_has_active_subscription(estate_id)
  );

-- fixflow_announcements: SELECT with subscription gating
DROP POLICY IF EXISTS "announcements_select_members" ON public.fixflow_announcements;
DROP POLICY IF EXISTS "announcements_select_with_subscription" ON public.fixflow_announcements;

CREATE POLICY "announcements_select_with_subscription" ON public.fixflow_announcements
  FOR SELECT USING (
    is_active = true
    AND (
      estate_id IS NULL  -- Global announcements
      OR (
        public.fixflow_is_estate_member(estate_id)
        AND public.fixflow_estate_has_active_subscription(estate_id)
      )
    )
  );

-- ════════════════════════════════════════════════════════════════════════════
-- 5. AUDIT EVENTS TABLE (append-only)
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.fixflow_report_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  event_type text NOT NULL,
  -- Event types: 'created', 'status_changed', 'priority_changed', 'assigned', 
  --              'unassigned', 'rated', 'comment_added', 'attachment_added'
  description text,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  user_name text,
  user_role text,
  old_value text,
  new_value text,
  metadata_json jsonb DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);

-- Indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_fixflow_report_events_report 
  ON public.fixflow_report_events(report_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_fixflow_report_events_user 
  ON public.fixflow_report_events(user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_report_events_type 
  ON public.fixflow_report_events(event_type);

-- Enable RLS
ALTER TABLE public.fixflow_report_events ENABLE ROW LEVEL SECURITY;

-- APPEND-ONLY: Only INSERT allowed, no UPDATE or DELETE
DROP POLICY IF EXISTS "events_insert_estate_member" ON public.fixflow_report_events;
CREATE POLICY "events_insert_estate_member" ON public.fixflow_report_events
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
    )
  );

-- SELECT: estate members can read events for reports in their estate
DROP POLICY IF EXISTS "events_select_estate_member" ON public.fixflow_report_events;
CREATE POLICY "events_select_estate_member" ON public.fixflow_report_events
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_reports r
      WHERE r.id = report_id
      AND public.fixflow_is_estate_member(r.estate_id)
      AND public.fixflow_estate_has_active_subscription(r.estate_id)
    )
  );

-- NO UPDATE/DELETE POLICIES = append-only enforcement

-- Grant only SELECT and INSERT
GRANT SELECT, INSERT ON public.fixflow_report_events TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- 6. TRIGGER: Auto-log events on report changes
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_log_report_event()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid;
  v_user_name text;
  v_user_role text;
BEGIN
  -- Get current user info
  v_user_id := auth.uid();
  SELECT name, role INTO v_user_name, v_user_role
  FROM public.fixflow_resident_profiles
  WHERE id = v_user_id;

  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.fixflow_report_events 
      (report_id, event_type, description, user_id, user_name, user_role)
    VALUES 
      (NEW.id, 'created', 'Zgłoszenie utworzone', v_user_id, v_user_name, v_user_role);
    RETURN NEW;
  END IF;

  IF TG_OP = 'UPDATE' THEN
    -- Log status change
    IF OLD.status IS DISTINCT FROM NEW.status OR OLD.status_enum IS DISTINCT FROM NEW.status_enum THEN
      INSERT INTO public.fixflow_report_events 
        (report_id, event_type, description, user_id, user_name, user_role, old_value, new_value)
      VALUES 
        (NEW.id, 'status_changed', 'Zmiana statusu', v_user_id, v_user_name, v_user_role,
         COALESCE(OLD.status_enum, OLD.status), COALESCE(NEW.status_enum, NEW.status));
    END IF;

    -- Log priority change
    IF OLD.priority IS DISTINCT FROM NEW.priority THEN
      INSERT INTO public.fixflow_report_events 
        (report_id, event_type, description, user_id, user_name, user_role, old_value, new_value)
      VALUES 
        (NEW.id, 'priority_changed', 'Zmiana priorytetu', v_user_id, v_user_name, v_user_role,
         OLD.priority, NEW.priority);
    END IF;

    -- Log assignment change
    IF OLD.assigned_to_user_id IS DISTINCT FROM NEW.assigned_to_user_id THEN
      IF NEW.assigned_to_user_id IS NOT NULL THEN
        INSERT INTO public.fixflow_report_events 
          (report_id, event_type, description, user_id, user_name, user_role, new_value,
           metadata_json)
        VALUES 
          (NEW.id, 'assigned', 'Przypisano do: ' || COALESCE(NEW.assigned_to_name, 'użytkownika'), 
           v_user_id, v_user_name, v_user_role, NEW.assigned_to_user_id::text,
           jsonb_build_object('assigned_name', NEW.assigned_to_name, 'assigned_role', NEW.assigned_to_role));
      ELSE
        INSERT INTO public.fixflow_report_events 
          (report_id, event_type, description, user_id, user_name, user_role, old_value)
        VALUES 
          (NEW.id, 'unassigned', 'Usunięto przypisanie', v_user_id, v_user_name, v_user_role,
           OLD.assigned_to_user_id::text);
      END IF;
    END IF;

    -- Log CSAT rating
    IF OLD.csat_rating IS DISTINCT FROM NEW.csat_rating AND NEW.csat_rating IS NOT NULL THEN
      INSERT INTO public.fixflow_report_events 
        (report_id, event_type, description, user_id, user_name, user_role, new_value)
      VALUES 
        (NEW.id, 'rated', 'Ocena: ' || NEW.csat_rating || '/5', v_user_id, v_user_name, v_user_role,
         NEW.csat_rating::text);
    END IF;

    RETURN NEW;
  END IF;

  RETURN NULL;
END;
$$;

-- Create trigger (drop first if exists)
DROP TRIGGER IF EXISTS trg_fixflow_report_events ON public.fixflow_reports;
CREATE TRIGGER trg_fixflow_report_events
  AFTER INSERT OR UPDATE ON public.fixflow_reports
  FOR EACH ROW EXECUTE FUNCTION public.fixflow_log_report_event();

-- ════════════════════════════════════════════════════════════════════════════
-- 7. SEED: Test estate with active subscription (for development)
-- ════════════════════════════════════════════════════════════════════════════

-- Insert test subscription for existing test estate (if exists)
DO $$
DECLARE
  v_test_estate_id uuid;
BEGIN
  -- Find test estate
  SELECT id INTO v_test_estate_id 
  FROM public.fixflow_estates 
  WHERE name ILIKE '%test%' OR name ILIKE '%demo%'
  LIMIT 1;

  IF v_test_estate_id IS NOT NULL THEN
    -- Insert or update test subscription
    INSERT INTO public.fixflow_subscriptions (
      stripe_subscription_id,
      stripe_customer_id,
      estate_id,
      status,
      current_period_start,
      current_period_end
    ) VALUES (
      'sub_test_' || v_test_estate_id::text,
      'cus_test_development',
      v_test_estate_id,
      'active',
      now(),
      now() + interval '1 year'
    )
    ON CONFLICT (stripe_subscription_id) DO UPDATE SET
      status = 'active',
      current_period_end = now() + interval '1 year',
      updated_at = now();
    
    RAISE NOTICE 'Test subscription created/updated for estate %', v_test_estate_id;
  END IF;
END $$;

-- ════════════════════════════════════════════════════════════════════════════
-- 8. GRANTS
-- ════════════════════════════════════════════════════════════════════════════

GRANT EXECUTE ON FUNCTION public.fixflow_estate_has_active_subscription(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_can_set_priority(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_can_rate_report(uuid, uuid) TO authenticated;

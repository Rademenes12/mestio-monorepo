-- Migration: Fix unqualified table references in SECURITY DEFINER functions
-- Description: Several functions were altered (migration 0022) to SET search_path = ''
-- for security hardening, but their bodies reference tables without the "public."
-- schema prefix. With an empty search_path, unqualified names cannot be resolved,
-- causing "relation ... does not exist" (42P01) errors at runtime.
--
-- Affected and fixed here:
--   - fixflow_is_estate_member: used by many RLS policies (reports, comments,
--     buildings, storage, announcements, emergency contacts) -> broke estate
--     membership checks app-wide.
--   - fixflow_generate_report_display_id / fixflow_set_report_display_id: the
--     BEFORE INSERT trigger on fixflow_reports -> broke creating new reports.
--   - fixflow_create_estate: broke creating a new estate.
--   - fixflow_cleanup_expired_announcements: broke the announcement cleanup job.

CREATE OR REPLACE FUNCTION public.fixflow_is_estate_member(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE estate_id = p_estate_id AND user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.fixflow_create_estate(p_name text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_estate_id uuid;
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  INSERT INTO public.fixflow_estates (name, created_by)
  VALUES (p_name, v_uid)
  RETURNING id INTO v_estate_id;

  INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_uid, v_estate_id, 'admin');

  RETURN v_estate_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.fixflow_generate_report_display_id(p_estate_id uuid)
RETURNS TEXT
SET search_path = ''
AS $$
DECLARE
  v_next_num integer;
  v_display_id text;
BEGIN
  -- Get next sequence number for this estate
  -- Use a counter table approach for per-estate sequences
  INSERT INTO public.fixflow_report_counters AS frc (estate_id, last_number)
  VALUES (p_estate_id, 1)
  ON CONFLICT (estate_id)
  DO UPDATE SET last_number = frc.last_number + 1
  RETURNING last_number INTO v_next_num;

  -- Format as FX-####
  v_display_id := 'FX-' || LPAD(v_next_num::text, 4, '0');

  RETURN v_display_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.fixflow_set_report_display_id()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  IF NEW.display_id IS NULL THEN
    NEW.display_id := public.fixflow_generate_report_display_id(NEW.estate_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.fixflow_cleanup_expired_announcements()
RETURNS INTEGER
SET search_path = ''
AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM public.fixflow_announcements
  WHERE expires_at IS NOT NULL
    AND expires_at < now()
    AND is_active = true;

  GET DIAGNOSTICS deleted_count = ROW_COUNT;

  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

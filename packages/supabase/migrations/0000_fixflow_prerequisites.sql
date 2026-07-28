-- ===================================================
-- FixFlow Prerequisites (base tables, types, functions)
-- Consolidated from mobile migrations for correct ordering
-- ===================================================

------ ENUM TYPES ------
-- ============================================================================
-- Status jako enum PostgreSQL
-- ============================================================================

-- Utwórz typ enum dla statusów
DO $$ BEGIN
  CREATE TYPE public.fixflow_report_status AS ENUM ('new', 'in_progress', 'closed', 'rejected');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

------ BASE TABLES ------
CREATE TABLE IF NOT EXISTS public.fixflow_estates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  address text,
  city text,
  postal_code text,
  country text DEFAULT 'PL',
  status text NOT NULL DEFAULT 'active',
  stripe_customer_id text,
  stripe_subscription_id text,
  subscription_status text DEFAULT 'incomplete',
  subscription_period_start timestamptz,
  subscription_period_end timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_buildings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  name text NOT NULL,
  address text,
  building_type text DEFAULT 'residential',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_stairwells (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES public.fixflow_buildings(id) ON DELETE CASCADE,
  name text NOT NULL,
  floor_count integer DEFAULT 5,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_resident_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  email text,
  phone text,
  first_name text,
  last_name text,
  building_id uuid REFERENCES public.fixflow_buildings(id) ON DELETE SET NULL,
  stairwell text,
  floor text,
  apartment text,
  fcm_token text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_user_estates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'resident',
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, estate_id)
);

CREATE TABLE IF NOT EXISTS public.fixflow_invitation_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  code text NOT NULL UNIQUE,
  role text NOT NULL DEFAULT 'resident',
  is_active boolean NOT NULL DEFAULT true,
  max_uses integer DEFAULT 0,
  use_count integer DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz
);

CREATE TABLE IF NOT EXISTS public.fixflow_permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  role text NOT NULL,
  resource text NOT NULL,
  action text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(role, resource, action)
);

CREATE TABLE IF NOT EXISTS public.fixflow_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  category text,
  reporter_name text,
  reporter_email text,
  reporter_building text,
  reporter_footbridge text,
  reporter_floor text,
  reporter_apartment text,
  status text NOT NULL DEFAULT 'Nowe',
  status_enum public.fixflow_report_status,
  timestamp bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()) * 1000)::bigint,
  estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE RESTRICT,
  photo_path text,
  attachments_json text,
  latitude double precision,
  longitude double precision,
  assigned_to text,
  assigned_to_user_id uuid REFERENCES public.fixflow_resident_profiles(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_report_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  user_id uuid,
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_report_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  url text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

------ CORE FUNCTIONS ------
-- fixflow_is_estate_member - sprawdza czy user nalezy do osiedla
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_member(p_estate_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = auth.uid()
    AND estate_id = p_estate_id
  );
END;
$$;

-- fixflow_is_not_resident - sprawdza czy user NIE jest rezydentem
CREATE OR REPLACE FUNCTION public.fixflow_is_not_resident(p_user_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = p_user_id
    AND role = 'resident'
  );
END;
$$;

-- fixflow_is_board_or_admin - sprawdza czy user ma role zarzadu/admina
CREATE OR REPLACE FUNCTION public.fixflow_is_board_or_admin(p_user_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = p_user_id
    AND role IN ('board', 'admin')
  );
END;
$$;

-- fixflow_is_estate_admin - sprawdza czy user jest adminem osiedla
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_admin(p_estate_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = auth.uid()
    AND estate_id = p_estate_id
    AND role IN ('admin', 'board', 'service')
  );
END;
$$;

------ CORE VIEWS ------
CREATE OR REPLACE VIEW public.v_fixflow_residents_by_estate AS
SELECT
  ue.estate_id,
  ue.user_id,
  rp.email,
  rp.first_name,
  rp.last_name,
  rp.phone,
  rp.building_id,
  rp.stairwell,
  rp.floor,
  rp.apartment,
  ue.role
FROM public.fixflow_user_estates ue
LEFT JOIN public.fixflow_resident_profiles rp ON rp.user_id = ue.user_id;

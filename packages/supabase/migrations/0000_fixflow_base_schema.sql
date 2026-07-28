-- ===================================================
-- FixFlow Base Tables (prerequisites for all FixFlow migrations)
-- Extracted from 0012 to ensure correct ordering
-- ===================================================

-- Enum types needed by base tables
DO $$ BEGIN
  CREATE TYPE public.fixflow_report_status AS ENUM ('new', 'in_progress', 'closed', 'rejected');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS public.fixflow_estates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  address text,
  trello_api_key text,
  trello_token text,
  trello_list_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_buildings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  name text NOT NULL,
  address text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_stairwells (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES public.fixflow_buildings(id) ON DELETE CASCADE,
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_resident_profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name text,
  email text,
  phone text,
  building text,
  footbridge text,
  floor text,
  apartment text,
  role text NOT NULL DEFAULT 'Mieszkaniec',
  is_verified boolean NOT NULL DEFAULT false,
  fcm_token text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_user_estates (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'resident',
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, estate_id)
);

CREATE TABLE IF NOT EXISTS public.fixflow_invitation_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  code text NOT NULL UNIQUE,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  role text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
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
  author_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fixflow_report_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  image_path text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
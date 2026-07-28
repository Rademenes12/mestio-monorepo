-- ============================================================================
-- FixFlow — MIGRACJA NAPRAWCZA (krytyczne poprawki)
-- ============================================================================
-- Ta migracja:
-- 1. Tworzy brakujące tabele FixFlow (jeśli nie istnieją)
-- 2. Tworzy funkcje RLS helper (fixflow_is_estate_member, etc.)
-- 3. Ustawia estate_id NOT NULL na fixflow_reports
-- 4. Naprawia RLS policies
-- ============================================================================

-- ============================================================================
-- KROK 1 — Tworzenie tabel FixFlow (jeśli nie istnieją)
-- ============================================================================

-- fixflow_estates
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

-- fixflow_buildings
CREATE TABLE IF NOT EXISTS public.fixflow_buildings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  name text NOT NULL,
  address text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_buildings_estate ON public.fixflow_buildings(estate_id);

-- fixflow_stairwells
CREATE TABLE IF NOT EXISTS public.fixflow_stairwells (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES public.fixflow_buildings(id) ON DELETE CASCADE,
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_stairwells_building ON public.fixflow_stairwells(building_id);

-- fixflow_resident_profiles
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

-- fixflow_user_estates
CREATE TABLE IF NOT EXISTS public.fixflow_user_estates (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'resident',
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, estate_id)
);

CREATE INDEX IF NOT EXISTS idx_fixflow_user_estates_estate ON public.fixflow_user_estates(estate_id);

-- fixflow_invitation_codes
CREATE TABLE IF NOT EXISTS public.fixflow_invitation_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  code text NOT NULL UNIQUE,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_invitation_codes_estate ON public.fixflow_invitation_codes(estate_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_invitation_codes_code ON public.fixflow_invitation_codes(code);

-- fixflow_permissions
CREATE TABLE IF NOT EXISTS public.fixflow_permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  role text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_permissions_user ON public.fixflow_permissions(user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_permissions_estate ON public.fixflow_permissions(estate_id);

-- fixflow_reports
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

CREATE INDEX IF NOT EXISTS idx_fixflow_reports_estate ON public.fixflow_reports(estate_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_reports_assigned_uid ON public.fixflow_reports(assigned_to_user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_reports_reporter_email ON public.fixflow_reports(reporter_email);

-- fixflow_report_comments
CREATE TABLE IF NOT EXISTS public.fixflow_report_comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  author_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_report_comments_report ON public.fixflow_report_comments(report_id);

-- fixflow_report_images
CREATE TABLE IF NOT EXISTS public.fixflow_report_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL REFERENCES public.fixflow_reports(id) ON DELETE CASCADE,
  image_path text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_report_images_report ON public.fixflow_report_images(report_id);

-- ============================================================================
-- KROK 2 — Funkcje RLS helper
-- ============================================================================

-- Check if user is a member of the estate (resident, board, admin, or service)
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_member(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND estate_id = p_estate_id
  );
$$;

-- Check if user is NOT a resident (i.e., is board, admin, or service)
CREATE OR REPLACE FUNCTION public.fixflow_is_not_resident(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_resident_profiles
    WHERE id = p_user_id
      AND role != 'Mieszkaniec'
  );
$$;

-- Check if user is board or admin of any estate
CREATE OR REPLACE FUNCTION public.fixflow_is_board_or_admin(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_resident_profiles
    WHERE id = p_user_id
      AND role IN ('Zarząd', 'Administrator')
  );
$$;

-- Check if user is admin of the specific estate
CREATE OR REPLACE FUNCTION public.fixflow_is_estate_admin(p_estate_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_user_estates
    WHERE user_id = (SELECT auth.uid())
      AND estate_id = p_estate_id
      AND role = 'admin'
  );
$$;

-- ============================================================================
-- KROK 3 — estate_id NOT NULL na fixflow_reports
-- ============================================================================

-- Backfill: ustaw estate_id na pierwsze dostępne osiedle dla raportów bez estate_id
UPDATE public.fixflow_reports
SET estate_id = (
  SELECT ue.estate_id
  FROM public.fixflow_user_estates ue
  WHERE ue.user_id = (
    SELECT id FROM public.fixflow_resident_profiles
    WHERE email = public.fixflow_reports.reporter_email
    LIMIT 1
  )
  LIMIT 1
)
WHERE estate_id IS NULL;

-- Jeśli nadal są raporty bez estate_id, ustaw na pierwsze osiedle w systemie
UPDATE public.fixflow_reports
SET estate_id = (SELECT id FROM public.fixflow_estates LIMIT 1)
WHERE estate_id IS NULL;

-- Teraz ustaw NOT NULL
ALTER TABLE public.fixflow_reports
  ALTER COLUMN estate_id SET NOT NULL;

-- ============================================================================
-- KROK 4 — Włącz RLS na wszystkich tabelach FixFlow
-- ============================================================================

ALTER TABLE public.fixflow_estates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_stairwells ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_resident_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_user_estates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_invitation_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_report_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_report_images ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- KROK 5 — Polityki RLS
-- ============================================================================

-- fixflow_estates: members can read (via join with user_estates)
DROP POLICY IF EXISTS "estates_select_members" ON public.fixflow_estates;
CREATE POLICY "estates_select_members"
ON public.fixflow_estates FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.fixflow_user_estates ue
    WHERE ue.estate_id = fixflow_estates.id
      AND ue.user_id = (SELECT auth.uid())
  )
);

-- fixflow_estates: admin can insert/update/delete
DROP POLICY IF EXISTS "estates_insert_admin" ON public.fixflow_estates;
CREATE POLICY "estates_insert_admin"
ON public.fixflow_estates FOR INSERT
WITH CHECK (public.fixflow_is_estate_admin(id));

DROP POLICY IF EXISTS "estates_update_admin" ON public.fixflow_estates;
CREATE POLICY "estates_update_admin"
ON public.fixflow_estates FOR UPDATE
USING (public.fixflow_is_estate_admin(id))
WITH CHECK (public.fixflow_is_estate_admin(id));

DROP POLICY IF EXISTS "estates_delete_admin" ON public.fixflow_estates;
CREATE POLICY "estates_delete_admin"
ON public.fixflow_estates FOR DELETE
USING (public.fixflow_is_estate_admin(id));

-- fixflow_user_estates: users can read their own memberships
DROP POLICY IF EXISTS "user_estates_select_own" ON public.fixflow_user_estates;
CREATE POLICY "user_estates_select_own"
ON public.fixflow_user_estates FOR SELECT
USING (user_id = (SELECT auth.uid()));

-- fixflow_user_estates: users can insert their own memberships (via invitation)
DROP POLICY IF EXISTS "user_estates_insert_own" ON public.fixflow_user_estates;
CREATE POLICY "user_estates_insert_own"
ON public.fixflow_user_estates FOR INSERT
WITH CHECK (user_id = (SELECT auth.uid()));

-- fixflow_user_estates: admin can manage memberships
DROP POLICY IF EXISTS "user_estates_admin_manage" ON public.fixflow_user_estates;
CREATE POLICY "user_estates_admin_manage"
ON public.fixflow_user_estates FOR ALL
USING (public.fixflow_is_estate_admin(estate_id))
WITH CHECK (public.fixflow_is_estate_admin(estate_id));

-- fixflow_resident_profiles: users can read their own profile
DROP POLICY IF EXISTS "resident_profiles_select_own" ON public.fixflow_resident_profiles;
CREATE POLICY "resident_profiles_select_own"
ON public.fixflow_resident_profiles FOR SELECT
USING (id = (SELECT auth.uid()));

-- fixflow_resident_profiles: users can update their own profile
DROP POLICY IF EXISTS "resident_profiles_update_own" ON public.fixflow_resident_profiles;
CREATE POLICY "resident_profiles_update_own"
ON public.fixflow_resident_profiles FOR UPDATE
USING (id = (SELECT auth.uid()))
WITH CHECK (id = (SELECT auth.uid()));

-- fixflow_resident_profiles: board can read profiles in their estate
DROP POLICY IF EXISTS "resident_profiles_board_read_own_estate" ON public.fixflow_resident_profiles;
CREATE POLICY "resident_profiles_board_read_own_estate"
ON public.fixflow_resident_profiles FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_user_estates ue_self
    JOIN public.fixflow_user_estates ue_target
      ON ue_target.estate_id = ue_self.estate_id
    WHERE ue_self.user_id = (SELECT auth.uid())
      AND ue_target.user_id = fixflow_resident_profiles.id
  )
);

-- fixflow_reports: members can read reports visible to them
DROP POLICY IF EXISTS "reports_select_estate_members" ON public.fixflow_reports;
CREATE POLICY "reports_select_estate_members"
ON public.fixflow_reports FOR SELECT
USING (
  public.fixflow_is_estate_member(estate_id)
  AND (
    public.fixflow_is_not_resident((SELECT auth.uid()))
    OR reporter_email = (
      SELECT email FROM public.fixflow_resident_profiles WHERE id = (SELECT auth.uid())
    )
  )
);

-- fixflow_reports: any estate member can create a report
DROP POLICY IF EXISTS "reports_insert_estate_members" ON public.fixflow_reports;
CREATE POLICY "reports_insert_estate_members"
ON public.fixflow_reports FOR INSERT
WITH CHECK (public.fixflow_is_estate_member(estate_id));

-- fixflow_reports: office/staff can update reports in their estate
DROP POLICY IF EXISTS "reports_update_office" ON public.fixflow_reports;
CREATE POLICY "reports_update_office"
ON public.fixflow_reports FOR UPDATE
USING (
  public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_not_resident((SELECT auth.uid()))
)
WITH CHECK (
  public.fixflow_is_estate_member(estate_id)
  AND public.fixflow_is_not_resident((SELECT auth.uid()))
);

-- fixflow_reports: only estate admins can delete reports
DROP POLICY IF EXISTS "reports_delete_estate_admin" ON public.fixflow_reports;
CREATE POLICY "reports_delete_estate_admin"
ON public.fixflow_reports FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));

-- fixflow_report_comments: office/staff can view comments for reports in their estate
DROP POLICY IF EXISTS "report_comments_select_office_in_estate" ON public.fixflow_report_comments;
CREATE POLICY "report_comments_select_office_in_estate"
ON public.fixflow_report_comments FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_comments: office/staff can add comments to reports in their estate
DROP POLICY IF EXISTS "report_comments_insert_office_in_estate" ON public.fixflow_report_comments;
CREATE POLICY "report_comments_insert_office_in_estate"
ON public.fixflow_report_comments FOR INSERT
WITH CHECK (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_images: office/staff can view images for reports in their estate
DROP POLICY IF EXISTS "report_images_select_office_in_estate" ON public.fixflow_report_images;
CREATE POLICY "report_images_select_office_in_estate"
ON public.fixflow_report_images FOR SELECT
USING (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- fixflow_report_images: office/staff can add images to reports in their estate
DROP POLICY IF EXISTS "report_images_insert_office_in_estate" ON public.fixflow_report_images;
CREATE POLICY "report_images_insert_office_in_estate"
ON public.fixflow_report_images FOR INSERT
WITH CHECK (
  public.fixflow_is_not_resident((SELECT auth.uid()))
  AND EXISTS (
    SELECT 1 FROM public.fixflow_reports r
    WHERE r.id = report_id AND public.fixflow_is_estate_member(r.estate_id)
  )
);

-- ============================================================================
-- KROK 6 — RPC functions
-- ============================================================================

-- Create estate and make caller admin
CREATE OR REPLACE FUNCTION public.fixflow_create_estate(p_name text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_estate_id uuid;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  INSERT INTO public.fixflow_estates (name)
  VALUES (p_name)
  RETURNING id INTO v_estate_id;

  INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_user_id, v_estate_id, 'admin');

  RETURN v_estate_id;
END;
$$;

-- Create invitation code for estate
CREATE OR REPLACE FUNCTION public.fixflow_create_estate_invitation_code(p_estate_id uuid)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_code text;
BEGIN
  IF NOT public.fixflow_is_estate_admin(p_estate_id) THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  -- Generate random 6-character code
  v_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 6));

  INSERT INTO public.fixflow_invitation_codes (estate_id, code)
  VALUES (p_estate_id, v_code)
  RETURNING code INTO v_code;

  RETURN v_code;
END;
$$;

-- Redeem invitation code
CREATE OR REPLACE FUNCTION public.fixflow_redeem_invitation_code(p_code text)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_estate_id uuid;
  v_user_id uuid;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;

  SELECT estate_id INTO v_estate_id
  FROM public.fixflow_invitation_codes
  WHERE code = p_code
    AND is_active = true;

  IF v_estate_id IS NULL THEN
    RAISE EXCEPTION 'Invalid or expired invitation code';
  END IF;

  INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
  VALUES (v_user_id, v_estate_id, 'resident')
  ON CONFLICT (user_id, estate_id) DO NOTHING;

  RETURN v_estate_id;
END;
$$;

-- ============================================================================
-- KROK 7 — Grants
-- ============================================================================

GRANT SELECT, INSERT, UPDATE ON public.fixflow_estates TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_buildings TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_stairwells TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_resident_profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_user_estates TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_invitation_codes TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_permissions TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_reports TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_report_comments TO authenticated;
GRANT SELECT, INSERT, UPDATE ON public.fixflow_report_images TO authenticated;

GRANT EXECUTE ON FUNCTION public.fixflow_is_estate_member(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_is_not_resident(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_is_board_or_admin(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_is_estate_admin(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_create_estate(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_create_estate_invitation_code(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fixflow_redeem_invitation_code(text) TO authenticated;

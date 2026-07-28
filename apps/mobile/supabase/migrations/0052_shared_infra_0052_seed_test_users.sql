-- Migration: seed verified profiles + estate memberships for QA test users
--
-- The five test accounts (test-admin/zarzad/serwisant/ochrona/mieszkaniec@
-- fixflow.app) existed in auth.users but had no fixflow_resident_profiles row
-- and no fixflow_user_estates membership. Without a verified profile the app
-- (home_screen.dart) routes every login to the registration LockScreen, so
-- QA could never reach the dashboard.
--
-- This backfills each account into the seed estate "FixFlow QA"
-- (00000000-0000-0000-0000-000000000001) with the role its email implies.
-- Idempotent: re-running only refreshes the rows. Safe on any environment —
-- the JOIN on auth.users means it is a no-op when the test users are absent
-- (e.g. production).

-- Verified profiles (PK = id = auth.users.id).
INSERT INTO public.fixflow_resident_profiles
  (id, name, email, phone, role, is_verified,
   building, footbridge, floor, apartment, verification_code, terms_accepted_at)
SELECT u.id,
  m.name, u.email, '123456789', m.label, true,
  CASE WHEN m.db_role = 'resident' THEN 'Budynek A' END,
  CASE WHEN m.db_role = 'resident' THEN 'Klatka A' END,
  CASE WHEN m.db_role = 'resident' THEN 'Parter' END,
  CASE WHEN m.db_role = 'resident' THEN 'Mieszkanie 1' END,
  'TEST1234', now()
FROM auth.users u
JOIN (VALUES
  ('test-admin@fixflow.app',      'admin',      'Administrator', 'Test Admin'),
  ('test-zarzad@fixflow.app',     'board',      'Zarząd',        'Test Zarzad'),
  ('test-serwisant@fixflow.app',  'technician', 'Serwisant',     'Test Serwisant'),
  ('test-ochrona@fixflow.app',    'security',   'Ochrona',       'Test Ochrona'),
  ('test-mieszkaniec@fixflow.app','resident',   'Mieszkaniec',   'Test Mieszkaniec')
) AS m(email, db_role, label, name) ON m.email = u.email
ON CONFLICT (id) DO UPDATE SET
  is_verified       = true,
  role              = EXCLUDED.role,
  name              = EXCLUDED.name,
  phone             = EXCLUDED.phone,
  building          = EXCLUDED.building,
  footbridge        = EXCLUDED.footbridge,
  floor             = EXCLUDED.floor,
  apartment         = EXCLUDED.apartment,
  terms_accepted_at = COALESCE(public.fixflow_resident_profiles.terms_accepted_at, EXCLUDED.terms_accepted_at),
  updated_at        = now();

-- Estate memberships (unique on user_id, estate_id).
INSERT INTO public.fixflow_user_estates
  (user_id, estate_id, role, building, stairwell, floor, apartment)
SELECT u.id, '00000000-0000-0000-0000-000000000001'::uuid, m.db_role,
  CASE WHEN m.db_role = 'resident' THEN 'Budynek A' END,
  CASE WHEN m.db_role = 'resident' THEN 'Klatka A' END,
  CASE WHEN m.db_role = 'resident' THEN 'Parter' END,
  CASE WHEN m.db_role = 'resident' THEN 'Mieszkanie 1' END
FROM auth.users u
JOIN (VALUES
  ('test-admin@fixflow.app',      'admin'),
  ('test-zarzad@fixflow.app',     'board'),
  ('test-serwisant@fixflow.app',  'technician'),
  ('test-ochrona@fixflow.app',    'security'),
  ('test-mieszkaniec@fixflow.app','resident')
) AS m(email, db_role) ON m.email = u.email
ON CONFLICT (user_id, estate_id) DO UPDATE SET
  role      = EXCLUDED.role,
  building  = EXCLUDED.building,
  stairwell = EXCLUDED.stairwell,
  floor     = EXCLUDED.floor,
  apartment = EXCLUDED.apartment;

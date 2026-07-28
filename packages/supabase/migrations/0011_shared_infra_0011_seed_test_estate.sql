-- ============================================================================
-- Seed test estate with invitation code TEST1234
-- ============================================================================
-- This creates a test estate "FixFlow QA" with a fixed invitation code
-- for easy testing of resident/board/admin/service flows.
-- Can be removed before production deployment.

-- Create test estate
INSERT INTO public.fixflow_estates (id, name, address, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'FixFlow QA',
  'Test Estate for QA purposes',
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Create invitation code TEST1234
INSERT INTO public.fixflow_invitation_codes (id, estate_id, code, is_active, created_at)
VALUES (
  gen_random_uuid(),
  '00000000-0000-0000-0000-000000000001',
  'TEST1234',
  true,
  NOW()
)
ON CONFLICT DO NOTHING;

-- Create test buildings
INSERT INTO public.fixflow_buildings (id, estate_id, name, address, created_at)
VALUES 
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000001', 'Budynek A', 'Test Address A', NOW()),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000001', 'Budynek B', 'Test Address B', NOW())
ON CONFLICT DO NOTHING;

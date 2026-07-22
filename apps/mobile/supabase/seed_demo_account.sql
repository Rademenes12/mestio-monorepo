-- =====================================================
-- Demo Account Setup for App Store & Google Play Review
-- =====================================================
-- Creates a fully functional demo estate with sample data
-- for app reviewers to test all features.
--
-- CREDENTIALS:
-- Manager: demo-manager@fixflow.app / Demo123!
-- Resident: demo-resident@fixflow.app / Demo123!
-- =====================================================

-- Clean up existing demo data (if any)
DELETE FROM fixflow_content_reports WHERE content_id IN (
  SELECT id FROM fixflow_announcements WHERE estate_id IN (
    SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
  )
);

DELETE FROM fixflow_report_comments WHERE report_id IN (
  SELECT id FROM fixflow_reports WHERE estate_id IN (
    SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
  )
);

DELETE FROM fixflow_report_event_audit WHERE report_id IN (
  SELECT id FROM fixflow_reports WHERE estate_id IN (
    SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
  )
);

DELETE FROM fixflow_reports WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_announcements WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_emergency_contacts WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_user_estates WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_residents WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_buildings WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_subscriptions WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_invitation_codes WHERE estate_id IN (
  SELECT id FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers'
);

DELETE FROM fixflow_estates WHERE name = 'Demo Estate - Reviewers';

-- Note: Demo users will be created manually via Supabase Auth UI
-- with these credentials:
-- Manager: demo-manager@fixflow.app / Demo123!
-- Resident: demo-resident@fixflow.app / Demo123!

-- Create demo estate
INSERT INTO fixflow_estates (
  id,
  name,
  city,
  created_at,
  updated_at
) VALUES (
  'demo-estate-reviewers-001',
  'Demo Estate - Reviewers',
  'Warsaw',
  now(),
  now()
);

-- Create active subscription for demo estate
INSERT INTO fixflow_subscriptions (
  stripe_subscription_id,
  stripe_customer_id,
  estate_id,
  status,
  current_period_start,
  current_period_end,
  created_at,
  updated_at
) VALUES (
  'sub_demo_reviewers',
  'cus_demo_reviewers',
  'demo-estate-reviewers-001',
  'active',
  now(),
  now() + interval '1 year',
  now(),
  now()
);

-- Create invitation code for reviewers (never expires, unlimited uses for testing)
INSERT INTO fixflow_invitation_codes (
  id,
  code,
  estate_id,
  created_by,
  max_uses,
  expires_at,
  is_active,
  created_at,
  updated_at
) VALUES (
  'demo-invite-reviewers-001',
  'DEMO-REVIEW-TEST',
  'demo-estate-reviewers-001',
  '00000000-0000-0000-0000-000000000000', -- placeholder, will be updated after manager is created
  999,
  now() + interval '10 years',
  true,
  now(),
  now()
);

-- Create buildings
INSERT INTO fixflow_buildings (
  id,
  estate_id,
  name,
  building_type,
  address,
  floors,
  created_at,
  updated_at
) VALUES 
(
  'demo-building-a',
  'demo-estate-reviewers-001',
  'Building A',
  'residential',
  'Main Street 123, Warsaw',
  5,
  now(),
  now()
),
(
  'demo-building-b',
  'demo-estate-reviewers-001',
  'Building B',
  'residential',
  'Main Street 125, Warsaw',
  4,
  now(),
  now()
);

-- =====================================================
-- MANUAL STEPS REQUIRED AFTER RUNNING THIS SCRIPT:
-- =====================================================
-- 1. Create auth users in Supabase Dashboard > Authentication > Users:
--    - Email: demo-manager@fixflow.app, Password: Demo123!, Confirm email
--    - Email: demo-resident@fixflow.app, Password: Demo123!, Confirm email
--
-- 2. Get the user IDs and run the following commands:
--
--    -- Add manager user to shared_users
--    INSERT INTO shared_users (id, first_name, created_at, updated_at)
--    VALUES ('MANAGER_USER_ID', 'Demo Manager', now(), now());
--
--    -- Add resident user to shared_users
--    INSERT INTO shared_users (id, first_name, created_at, updated_at)
--    VALUES ('RESIDENT_USER_ID', 'Demo Resident', now(), now());
--
--    -- Link manager to estate
--    INSERT INTO fixflow_user_estates (user_id, estate_id, role, created_at, updated_at)
--    VALUES ('MANAGER_USER_ID', 'demo-estate-reviewers-001', 'manager', now(), now());
--
--    -- Link resident to estate
--    INSERT INTO fixflow_user_estates (user_id, estate_id, role, created_at, updated_at)
--    VALUES ('RESIDENT_USER_ID', 'demo-estate-reviewers-001', 'resident', now(), now());
--
--    -- Create resident profile
--    INSERT INTO fixflow_residents (
--      id, estate_id, user_id, name, email, building_id, apartment,
--      is_verified, created_at, updated_at
--    ) VALUES (
--      gen_random_uuid(),
--      'demo-estate-reviewers-001',
--      'RESIDENT_USER_ID',
--      'Demo Resident',
--      'demo-resident@fixflow.app',
--      'demo-building-a',
--      '12',
--      true,
--      now(),
--      now()
--    );
--
--    -- Update invitation code creator
--    UPDATE fixflow_invitation_codes
--    SET created_by = 'MANAGER_USER_ID'
--    WHERE id = 'demo-invite-reviewers-001';
--
-- 3. Run seed_demo_data.sql to populate sample content
-- =====================================================

-- Sample emergency contacts
INSERT INTO fixflow_emergency_contacts (
  id,
  estate_id,
  name,
  phone,
  description,
  is_active,
  created_at,
  updated_at
) VALUES 
(
  gen_random_uuid(),
  'demo-estate-reviewers-001',
  'Emergency Services',
  '112',
  'Police, Fire, Ambulance',
  true,
  now(),
  now()
),
(
  gen_random_uuid(),
  'demo-estate-reviewers-001',
  'Building Manager',
  '+48 123 456 789',
  'Available 24/7 for emergencies',
  true,
  now(),
  now()
),
(
  gen_random_uuid(),
  'demo-estate-reviewers-001',
  'Plumber - Quick Fix',
  '+48 555 111 222',
  'Emergency plumbing services',
  true,
  now(),
  now()
),
(
  gen_random_uuid(),
  'demo-estate-reviewers-001',
  'Electrician - PowerPro',
  '+48 555 333 444',
  'Electrical emergency repairs',
  true,
  now(),
  now()
);

-- Sample announcements (will be created after user setup)
-- These need to be inserted manually after manager user is created
-- See seed_demo_data.sql

-- Sample reports (will be created after user setup)
-- These need to be inserted manually after users are created
-- See seed_demo_data.sql

COMMENT ON TABLE fixflow_estates IS 'Demo estate "Demo Estate - Reviewers" created for app store review';

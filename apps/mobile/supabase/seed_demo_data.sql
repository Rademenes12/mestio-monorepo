-- =====================================================
-- Demo Data Population Script
-- =====================================================
-- Run this AFTER creating demo users and linking them to estate
-- Populates sample announcements, reports, and comments
--
-- PREREQUISITES:
-- 1. seed_demo_account.sql has been executed
-- 2. Demo users created in Supabase Auth:
--    - demo-manager@fixflow.app
--    - demo-resident@fixflow.app
-- 3. Users linked to demo estate via fixflow_user_estates
-- =====================================================

-- Replace these UUIDs with actual user IDs from your Supabase instance
-- Get them from: Supabase Dashboard > Authentication > Users
DO $$
DECLARE
  v_manager_id uuid;
  v_resident_id uuid;
  v_estate_id uuid := 'demo-estate-reviewers-001';
  v_building_a_id uuid := 'demo-building-a';
  v_building_b_id uuid := 'demo-building-b';
  v_report_1_id uuid;
  v_report_2_id uuid;
  v_report_3_id uuid;
BEGIN
  -- Get manager user ID (update this email if different)
  SELECT id INTO v_manager_id
  FROM auth.users
  WHERE email = 'demo-manager@fixflow.app'
  LIMIT 1;

  -- Get resident user ID
  SELECT id INTO v_resident_id
  FROM auth.users
  WHERE email = 'demo-resident@fixflow.app'
  LIMIT 1;

  -- Exit if users not found
  IF v_manager_id IS NULL OR v_resident_id IS NULL THEN
    RAISE NOTICE 'Demo users not found. Please create them first.';
    RETURN;
  END IF;

  RAISE NOTICE 'Manager ID: %', v_manager_id;
  RAISE NOTICE 'Resident ID: %', v_resident_id;

  -- =====================================================
  -- Sample Announcements
  -- =====================================================
  
  INSERT INTO fixflow_announcements (
    id,
    estate_id,
    author_id,
    title,
    content,
    target_buildings,
    expires_at,
    created_at,
    updated_at
  ) VALUES 
  (
    gen_random_uuid(),
    v_estate_id,
    v_manager_id,
    'Welcome to Demo Estate!',
    'This is a demonstration account for app reviewers. Feel free to explore all features including creating reports, viewing announcements, and managing contacts.',
    ARRAY[v_building_a_id, v_building_b_id],
    now() + interval '30 days',
    now() - interval '2 days',
    now() - interval '2 days'
  ),
  (
    gen_random_uuid(),
    v_estate_id,
    v_manager_id,
    'Scheduled Maintenance - Elevator',
    'Elevator in Building A will be under maintenance on Monday, 9 AM - 12 PM. Please use the stairs during this time.',
    ARRAY[v_building_a_id],
    now() + interval '7 days',
    now() - interval '1 day',
    now() - interval '1 day'
  ),
  (
    gen_random_uuid(),
    v_estate_id,
    v_manager_id,
    'Winter Season Reminder',
    'Please ensure your heating systems are working properly. Report any issues immediately through the app.',
    ARRAY[v_building_a_id, v_building_b_id],
    now() + interval '60 days',
    now() - interval '5 hours',
    now() - interval '5 hours'
  );

  -- =====================================================
  -- Sample Reports
  -- =====================================================

  -- Report 1: Open report from resident
  v_report_1_id := gen_random_uuid();
  INSERT INTO fixflow_reports (
    id,
    estate_id,
    title,
    description,
    location,
    building_id,
    status,
    priority,
    created_by,
    created_at,
    updated_at
  ) VALUES (
    v_report_1_id,
    v_estate_id,
    'Broken Mailbox Lock',
    'The mailbox lock in Building A, ground floor is broken. Unable to access mail.',
    'Building A - Ground Floor Mailboxes',
    v_building_a_id,
    'open',
    'normal',
    v_resident_id,
    now() - interval '3 hours',
    now() - interval '3 hours'
  );

  -- Report 2: In progress report with comments
  v_report_2_id := gen_random_uuid();
  INSERT INTO fixflow_reports (
    id,
    estate_id,
    title,
    description,
    location,
    building_id,
    status,
    priority,
    created_by,
    assigned_to_user_id,
    created_at,
    updated_at
  ) VALUES (
    v_report_2_id,
    v_estate_id,
    'Leaking Pipe in Stairwell',
    'Water leaking from ceiling pipe on 3rd floor stairwell. Needs urgent attention.',
    'Building B - 3rd Floor Stairwell',
    v_building_b_id,
    'in_progress',
    'high',
    v_resident_id,
    v_manager_id,
    now() - interval '2 days',
    now() - interval '4 hours'
  );

  -- Add comments to report 2
  INSERT INTO fixflow_report_comments (
    id,
    report_id,
    author_id,
    comment,
    created_at,
    updated_at
  ) VALUES 
  (
    gen_random_uuid(),
    v_report_2_id,
    v_manager_id,
    'Plumber has been contacted and will arrive tomorrow morning.',
    now() - interval '1 day',
    now() - interval '1 day'
  ),
  (
    gen_random_uuid(),
    v_report_2_id,
    v_resident_id,
    'Thank you for the quick response!',
    now() - interval '20 hours',
    now() - interval '20 hours'
  ),
  (
    gen_random_uuid(),
    v_report_2_id,
    v_manager_id,
    'Plumber is on site now, repair should be completed within 2 hours.',
    now() - interval '4 hours',
    now() - interval '4 hours'
  );

  -- Report 3: Completed report with CSAT rating
  v_report_3_id := gen_random_uuid();
  INSERT INTO fixflow_reports (
    id,
    estate_id,
    title,
    description,
    location,
    building_id,
    status,
    priority,
    created_by,
    assigned_to_user_id,
    csat_rating,
    created_at,
    updated_at
  ) VALUES (
    v_report_3_id,
    v_estate_id,
    'Light Bulb Replacement',
    'Light bulb in hallway (Building A, 2nd floor) needs replacement.',
    'Building A - 2nd Floor Hallway',
    v_building_a_id,
    'completed',
    'low',
    v_resident_id,
    v_manager_id,
    5,
    now() - interval '5 days',
    now() - interval '3 days'
  );

  -- Add completion comment
  INSERT INTO fixflow_report_comments (
    id,
    report_id,
    author_id,
    comment,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    v_report_3_id,
    v_manager_id,
    'Bulb replaced. Issue resolved.',
    now() - interval '3 days',
    now() - interval '3 days'
  );

  -- =====================================================
  -- Audit Events for Reports
  -- =====================================================

  -- Report 2 audit trail
  INSERT INTO fixflow_report_event_audit (
    id,
    report_id,
    event_type,
    actor_id,
    old_value,
    new_value,
    created_at
  ) VALUES 
  (
    gen_random_uuid(),
    v_report_2_id,
    'status_change',
    v_manager_id,
    'open',
    'in_progress',
    now() - interval '1 day'
  ),
  (
    gen_random_uuid(),
    v_report_2_id,
    'priority_change',
    v_manager_id,
    'normal',
    'high',
    now() - interval '1 day'
  ),
  (
    gen_random_uuid(),
    v_report_2_id,
    'assignment',
    v_manager_id,
    NULL,
    v_manager_id::text,
    now() - interval '1 day'
  );

  -- Report 3 audit trail
  INSERT INTO fixflow_report_event_audit (
    id,
    report_id,
    event_type,
    actor_id,
    old_value,
    new_value,
    created_at
  ) VALUES 
  (
    gen_random_uuid(),
    v_report_3_id,
    'status_change',
    v_manager_id,
    'open',
    'in_progress',
    now() - interval '4 days'
  ),
  (
    gen_random_uuid(),
    v_report_3_id,
    'status_change',
    v_manager_id,
    'in_progress',
    'completed',
    now() - interval '3 days'
  );

  RAISE NOTICE 'Demo data populated successfully!';
  RAISE NOTICE 'Report IDs: %, %, %', v_report_1_id, v_report_2_id, v_report_3_id;

END $$;

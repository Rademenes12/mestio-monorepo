-- =====================================================
-- Test Seed: 4 role test accounts in FixFlow QA estate
-- =====================================================
-- Uses estate: 00000000-0000-0000-0000-000000000001 (FixFlow QA)
-- Invitation code: TEST-1234 (migration 0037)
-- 
-- NOTE: Auth users must be created first via:
--   1. App: "Continue as guest" → register with email below
--   2. Or Admin API / Supabase Dashboard
-- Credentials for each role after registration:
--   Resident:  test-mieszkaniec@fixflow.app  / Test123!
--   Manager:   test-zarzad@fixflow.app       / Test123!
--   Technician: test-serwisant@fixflow.app    / Test123!
--   Security:  test-ochrona@fixflow.app      / Test123!
-- =====================================================

-- Insert resident profiles (after auth users exist)
INSERT INTO fixflow_resident_profiles (id, name, email, phone, role, building, footbridge, floor, apartment, is_verified)
VALUES
  ('test-resident-01', 'Jan Kowalski', 'test-mieszkaniec@fixflow.app', '+48123456789', 'Mieszkaniec', 'Budynek A', 'Klatka A', '2', '12', true),
  ('test-manager-01', 'Anna Zarządca', 'test-zarzad@fixflow.app', '+48123456780', 'Zarząd', 'Budynek A', 'Klatka A', '1', '1', true),
  ('test-tech-01', 'Tomasz Serwis', 'test-serwisant@fixflow.app', '+48123456781', 'Serwisant', '', '', '', '', true)
ON CONFLICT (id) DO NOTHING;

-- Insert estate memberships
INSERT INTO fixflow_user_estates (user_id, estate_id, role)
VALUES
  ('test-resident-01', '00000000-0000-0000-0000-000000000001', 'resident'),
  ('test-manager-01', '00000000-0000-0000-0000-000000000001', 'admin'),
  ('test-tech-01', '00000000-0000-0000-0000-000000000001', 'admin')
ON CONFLICT (user_id, estate_id) DO NOTHING;

-- Create sample reports in various statuses
INSERT INTO fixflow_reports (id, title, description, category, reporter_name, reporter_email, reporter_building, reporter_footbridge, reporter_floor, reporter_apartment, status, status_enum, priority, estate_id, assigned_to_user_id, assigned_to_name, assigned_to_role, created_at)
VALUES
  -- Resident's new report
  (
    'test-report-001',
    'Cieknący kran w kuchni',
    'Kran w kuchni cieknie od wczoraj. Woda kapie cały czas, tworzy się kałuża na blacie.',
    'Hydraulika',
    'Jan Kowalski',
    'test-mieszkaniec@fixflow.app',
    'Budynek A',
    'Klatka A',
    '2',
    '12',
    'Nowe',
    'nowe',
    'normal',
    '00000000-0000-0000-0000-000000000001',
    NULL, NULL, NULL,
    NOW() - interval '2 hours'
  ),
  -- Assigned report for technician
  (
    'test-report-002',
    'Winda nie działa',
    'Winda w Budynku A stoi na parterze. Nie reaguje na przyciski. Mieszkańcy zgłaszają problem.',
    'Winda',
    'Jan Kowalski',
    'test-mieszkaniec@fixflow.app',
    'Budynek A',
    'Klatka A',
    '5',
    '20',
    'W realizacji',
    'w_realizacji',
    'high',
    '00000000-0000-0000-0000-000000000001',
    'test-tech-01',
    'Tomasz Serwis',
    'Serwisant',
    NOW() - interval '1 day'
  ),
  -- Completed report (for CSAT testing)
  (
    'test-report-003',
    'Żarówka na klatce przepalona',
    'Na 3 piętrze w klatce A przepalona żarówka. Ciemno na całym korytarzu.',
    'Oswietlenie',
    'Jan Kowalski',
    'test-mieszkaniec@fixflow.app',
    'Budynek A',
    'Klatka A',
    '3',
    '',
    'Zamknięte',
    'zamkniete',
    'low',
    '00000000-0000-0000-0000-000000000001',
    'test-tech-01',
    'Tomasz Serwis',
    'Serwisant',
    NOW() - interval '3 days'
  ),
  -- Security incident
  (
    'test-report-004',
    'Podejrzana osoba na terenie osiedla',
    'O 23:15 zauważono nieznaną osobę kręcącą się przy Budynku B.',
    'ZarzadAdministrator',
    'Ochroniarz',
    'test-ochrona@fixflow.app',
    'Budynek B',
    '',
    '',
    '',
    'Nowe',
    'nowe',
    'high',
    '00000000-0000-0000-0000-000000000001',
    NULL, NULL, NULL,
    NOW() - interval '30 minutes'
  )
ON CONFLICT (id) DO NOTHING;

-- Add service notes to completed report
UPDATE fixflow_reports SET tech_notes = 'Wymieniono przepaloną żarówkę na nową LED 10W. Klatka oświetlona.' WHERE id = 'test-report-003';
UPDATE fixflow_reports SET board_notes = 'Sprawdzić pozostałe piętra - być może inne żarówki też są przepalone.' WHERE id = 'test-report-003';
UPDATE fixflow_reports SET audit_trail = '[
  {"action":"Utworzono zgłoszenie","user_name":"Jan Kowalski","timestamp":"' || (NOW() - interval '3 days')::text || '"},
  {"action":"Przypisano do: Tomasz Serwis (Serwisant)","user_name":"Anna Zarządca","timestamp":"' || (NOW() - interval '2 days')::text || '"},
  {"action":"Zmieniono status na: W realizacji","user_name":"Tomasz Serwis","timestamp":"' || (NOW() - interval '2 days')::text || '"},
  {"action":"Zmieniono status na: Zamknięte","user_name":"Tomasz Serwis","timestamp":"' || (NOW() - interval '1 day')::text || '"}
]'::jsonb WHERE id = 'test-report-003';

-- Add sample comments
INSERT INTO fixflow_report_comments (report_id, author_id, author_name, author_role, comment, is_internal, created_at)
VALUES
  ('test-report-002', 'test-manager-01', 'Anna Zarządca', 'Zarząd', 'Serwisant został wezwany. Proszę o szybką naprawę - winda jest niezbędna dla starszych mieszkańców.', false, NOW() - interval '12 hours'),
  ('test-report-002', 'test-tech-01', 'Tomasz Serwis', 'Serwisant', 'Jestem na miejscu. Awaria głównego silnika. Naprawa potrwa ok 2-3h.', false, NOW() - interval '6 hours'),
  ('test-report-002', 'test-manager-01', 'Anna Zarządca', 'Zarząd', 'Zespół techniczny - proszę o kontakt z dostawcą części zamiennych.', true, NOW() - interval '5 hours'),
  ('test-report-003', 'test-mieszkaniec-01', 'Jan Kowalski', 'Mieszkaniec', 'Dziękuję za szybką naprawę!', false, NOW() - interval '1 day')
ON CONFLICT DO NOTHING;

-- Add emergency contacts
INSERT INTO fixflow_emergency_contacts (estate_id, name, role, phone, email, category)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Biuro Zarządu', 'Administrator', '+48221111111', 'biuro@fixflow.app', 'Administracja'),
  ('00000000-0000-0000-0000-000000000001', 'Pogotowie Windowe', 'Serwis Windowy', '+48111111111', 'windy@serwis.pl', 'Serwis'),
  ('00000000-0000-0000-0000-000000000001', 'Dyżurny Ochrony', 'Ochrona', '+48333333333', 'ochrona@fixflow.app', 'Ochrona'),
  ('00000000-0000-0000-0000-000000000001', 'Pogotowie Gazowe', 'Gazowe', '+48992', '', 'Służby Awaryjne')
ON CONFLICT DO NOTHING;

-- Add active announcement
INSERT INTO fixflow_announcements (estate_id, author_id, author_name, author_role, title, content, target_label, is_active, expires_at, created_at)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'test-manager-01',
  'Anna Zarządca',
  'Zarząd',
  'Przegląd instalacji gazowej',
  'W przyszłym tygodniu (10-14 lipca) odbędzie się obowiązkowy przegląd instalacji gazowej we wszystkich mieszkaniach. Prosimy o udostępnienie dostępu do kuchenek i piecyków gazowych. Kontakt do serwisu: 111-111-111.',
  'Wszystkie budynki',
  true,
  NOW() + interval '7 days',
  NOW()
)
ON CONFLICT DO NOTHING;

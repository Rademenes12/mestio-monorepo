-- FixFlow Security Audit SQL — Sekcje 1-6
-- Uruchom w SQL Editor w Supabase Dashboard
-- Wersja: 1.0 | Data: 2026-07-01

-- ════════════════════════════════════════════════════════════
-- SEKCJA 1: RLS — czy wszystkie tabele mają RLS?
-- ════════════════════════════════════════════════════════════
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE 'fixflow%'
ORDER BY tablename;

-- ════════════════════════════════════════════════════════════
-- SEKCJA 2: Polityki z USING/WITH CHECK = true (krytyczne!)
-- ════════════════════════════════════════════════════════════
SELECT
  schemaname, tablename, policyname,
  permissive, cmd,
  CASE WHEN qual IS NOT NULL THEN pg_get_expr(qual, schemaname::regnamespace::oid)
       ELSE '—' END AS using_condition,
  CASE WHEN with_check IS NOT NULL THEN pg_get_expr(with_check, schemaname::regnamespace::oid)
       ELSE '—' END AS with_check_condition
FROM pg_policies
WHERE schemaname = 'public'
  AND (
    pg_get_expr(qual, schemaname::regnamespace::oid) LIKE '%true%'
    OR pg_get_expr(with_check, schemaname::regnamespace::oid) LIKE '%true%'
  )
ORDER BY tablename, policyname;

-- ════════════════════════════════════════════════════════════
-- SEKCJA 3: Wszystkie polityki RLS (pełna lista)
-- ════════════════════════════════════════════════════════════
SELECT
  tablename, policyname, cmd,
  permissive,
  CASE WHEN qual IS NOT NULL THEN substring(pg_get_expr(qual, schemaname::regnamespace::oid), 1, 150)
       ELSE '—' END AS using_condition,
  CASE WHEN with_check IS NOT NULL THEN substring(pg_get_expr(with_check, schemaname::regnamespace::oid), 1, 150)
       ELSE '—' END AS with_check_condition
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename LIKE 'fixflow%'
ORDER BY tablename, policyname;

-- ════════════════════════════════════════════════════════════
-- SEKCJA 4: SECURITY DEFINER — brak SET search_path?
-- ════════════════════════════════════════════════════════════
SELECT
  p.proname,
  pg_get_functiondef(p.oid) LIKE '%SET search_path%' AS has_search_path,
  substring(pg_get_functiondef(p.oid) from 1 for 400) AS def_snippet
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.prosecdef = true
ORDER BY p.proname;

-- ════════════════════════════════════════════════════════════
-- SEKCJA 5: Kolumny z danymi osobowymi (PII)
-- ════════════════════════════════════════════════════════════
SELECT
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name LIKE 'fixflow%'
  AND (
    column_name ~* 'email'
    OR column_name ~* 'phone'
    OR column_name ~* 'name'
    OR column_name ~* 'address'
    OR column_name ~* 'token'
    OR column_name ~* 'key'
    OR column_name ~* 'password'
  )
ORDER BY table_name, column_name;

-- ════════════════════════════════════════════════════════════
-- SEKCJA 6: Test wycieku — mieszkaniec osiedla A vs osiedle B
-- ════════════════════════════════════════════════════════════
-- Uruchom jako mieszkaniec osiedla A:
--  1. SELECT * FROM fixflow_buildings;  -- powinien zwrócić TYLKO buildings osiedla A
--  2. SELECT * FROM fixflow_user_estates;  -- powinien zwrócić TYLKO własny wpis
--  3. UPDATE fixflow_reports SET status = 'Zamkniete' WHERE estate_id = 'INNE_ESTATE_ID'; -- 0 wierszy
--  4. DELETE FROM fixflow_buildings WHERE estate_id = 'INNE_ESTATE_ID'; -- 0 wierszy / 42501

-- 🔴 Test query: czy fixflow_permissions wycieka między osiedlami?
-- Jako dowolny non-resident, odczytaj wszystkie permissions:
-- SELECT * FROM fixflow_permissions;
-- Powinno zwrócić TYLKO permissions z osiedla użytkownika, ale polityka sprawdza
-- tylko fixflow_is_not_resident() BEZ filtera estate_id → WYCIEK POTWIERDZONY jeśli
-- zwróci >0 wierszy dla permissions spoza osiedla użytkownika.

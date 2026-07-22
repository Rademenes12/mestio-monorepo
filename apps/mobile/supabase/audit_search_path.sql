-- Check search_path for all SECURITY DEFINER functions
SELECT 
  p.proname as function_name,
  pg_get_functiondef(p.oid) as definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public' 
  AND p.proname LIKE 'fixflow_%'
  AND p.prosecdef = true;

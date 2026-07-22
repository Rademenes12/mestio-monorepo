-- 5. List all SECURITY DEFINER functions and check search_path
SELECT routine_name, security_type FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name LIKE 'fixflow_%';

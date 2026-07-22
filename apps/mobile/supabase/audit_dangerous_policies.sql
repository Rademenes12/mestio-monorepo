-- 3. Check for dangerous policies (qual = true or with_check = true)
SELECT tablename, policyname, cmd FROM pg_policies WHERE schemaname = 'public' AND tablename LIKE 'fixflow_%' AND (qual::text = 'true' OR with_check::text = 'true');

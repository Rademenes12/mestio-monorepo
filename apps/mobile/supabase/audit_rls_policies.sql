-- 2. List ALL RLS policies on fixflow_* tables with their qual (WHERE clause)
SELECT tablename, policyname, cmd, qual, with_check FROM pg_policies WHERE schemaname = 'public' AND tablename LIKE 'fixflow_%' ORDER BY tablename, policyname;

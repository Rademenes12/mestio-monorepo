-- 1. List ALL fixflow_* tables and check if RLS is enabled
SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'fixflow_%';

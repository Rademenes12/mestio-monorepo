-- 6. Check if fixflow_subscriptions has INSERT/UPDATE policies for authenticated
SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'fixflow_subscriptions';

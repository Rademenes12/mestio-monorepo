-- 4. Check fixflow_reports columns (especially estate_id nullable)
SELECT column_name, is_nullable, data_type FROM information_schema.columns WHERE table_name = 'fixflow_reports' ORDER BY ordinal_position;

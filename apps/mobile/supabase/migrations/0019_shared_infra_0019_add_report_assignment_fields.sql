-- FixFlow — Add report assignment display fields
-- ============================================================================
-- Adding assigned_to_name and assigned_to_role to cache display values
-- on the report directly without requiring multiple joins in queries.
-- ============================================================================

ALTER TABLE public.fixflow_reports ADD COLUMN IF NOT EXISTS assigned_to_name text;
ALTER TABLE public.fixflow_reports ADD COLUMN IF NOT EXISTS assigned_to_role text;

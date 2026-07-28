-- Phase 2: Report enhancements — priority, SLA, CSAT, audit trail, company name
-- Migration: 0020_fixflow_report_enhancements.sql

-- Priority enum
DO $$ BEGIN
  CREATE TYPE fixflow_report_priority AS ENUM ('low', 'normal', 'high', 'critical');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- New columns on fixflow_reports
ALTER TABLE fixflow_reports
  ADD COLUMN IF NOT EXISTS priority fixflow_report_priority DEFAULT 'normal',
  ADD COLUMN IF NOT EXISTS sla_deadline timestamptz,
  ADD COLUMN IF NOT EXISTS csat_rating smallint CHECK (csat_rating BETWEEN 1 AND 5),
  ADD COLUMN IF NOT EXISTS audit_trail jsonb DEFAULT '[]'::jsonb;

COMMENT ON COLUMN fixflow_reports.priority IS 'Report priority: low, normal, high, critical';
COMMENT ON COLUMN fixflow_reports.sla_deadline IS 'SLA deadline calculated from priority (low=168h, normal=72h, high=24h, critical=4h)';
COMMENT ON COLUMN fixflow_reports.csat_rating IS 'Customer satisfaction rating 1-5, set by resident after closure';
COMMENT ON COLUMN fixflow_reports.audit_trail IS 'JSON array of {action, user_id, timestamp, details} entries';

-- Company name for technician profiles
ALTER TABLE fixflow_resident_profiles
  ADD COLUMN IF NOT EXISTS company_name text DEFAULT '';

COMMENT ON COLUMN fixflow_resident_profiles.company_name IS 'Service company name, used by Serwisant role';

-- Index for SLA overdue queries (only open reports with a deadline)
CREATE INDEX IF NOT EXISTS idx_fixflow_reports_sla_deadline
  ON fixflow_reports (sla_deadline)
  WHERE sla_deadline IS NOT NULL AND status_enum NOT IN ('closed', 'rejected');

-- Index for priority filtering
CREATE INDEX IF NOT EXISTS idx_fixflow_reports_priority
  ON fixflow_reports (priority)
  WHERE priority IS NOT NULL;

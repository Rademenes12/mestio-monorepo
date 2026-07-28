-- Phase 6: Building type (residential/garage) and preventive maintenance schedules
-- Migration: 0021_fixflow_building_type_and_maintenance.sql

-- Building type enum
DO $$ BEGIN
  CREATE TYPE fixflow_building_type AS ENUM ('residential', 'garage');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Add building_type to fixflow_buildings
ALTER TABLE fixflow_buildings
  ADD COLUMN IF NOT EXISTS building_type fixflow_building_type DEFAULT 'residential';

COMMENT ON COLUMN fixflow_buildings.building_type IS 'Building type: residential (standard) or garage (underground parking)';

-- Preventive maintenance schedule table
CREATE TABLE IF NOT EXISTS fixflow_maintenance_schedules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES fixflow_estates(id) ON DELETE CASCADE,
  building_id uuid REFERENCES fixflow_buildings(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '',
  frequency_days int NOT NULL DEFAULT 365,
  last_performed date,
  next_due_date date NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE fixflow_maintenance_schedules IS 'Preventive maintenance inspections (elevators, chimney, pest control, fire safety, oil separators)';
COMMENT ON COLUMN fixflow_maintenance_schedules.frequency_days IS 'Interval in days between inspections';
COMMENT ON COLUMN fixflow_maintenance_schedules.last_performed IS 'Date of last completed inspection';
COMMENT ON COLUMN fixflow_maintenance_schedules.next_due_date IS 'Next scheduled inspection date';

-- Enable RLS
ALTER TABLE fixflow_maintenance_schedules ENABLE ROW LEVEL SECURITY;

-- RLS: estate members can read
DROP POLICY IF EXISTS maintenance_read_estate_members ON fixflow_maintenance_schedules;
CREATE POLICY maintenance_read_estate_members ON fixflow_maintenance_schedules
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM fixflow_user_estates
      WHERE fixflow_user_estates.estate_id = fixflow_maintenance_schedules.estate_id
      AND fixflow_user_estates.user_id = auth.uid()
    )
  );

-- RLS: admin/board can insert/update/delete
DROP POLICY IF EXISTS maintenance_write_board ON fixflow_maintenance_schedules;
CREATE POLICY maintenance_write_board ON fixflow_maintenance_schedules
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM fixflow_user_estates
      WHERE fixflow_user_estates.estate_id = fixflow_maintenance_schedules.estate_id
      AND fixflow_user_estates.user_id = auth.uid()
      AND fixflow_user_estates.role = 'admin'
    )
  );

-- Index for filtering by estate
CREATE INDEX IF NOT EXISTS idx_fixflow_maintenance_estate
  ON fixflow_maintenance_schedules (estate_id);

-- Add index for due date queries
CREATE INDEX IF NOT EXISTS idx_fixflow_maintenance_due
  ON fixflow_maintenance_schedules (next_due_date)
  WHERE next_due_date IS NOT NULL;

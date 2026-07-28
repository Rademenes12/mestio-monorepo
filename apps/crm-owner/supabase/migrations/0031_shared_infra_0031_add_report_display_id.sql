-- Migration: Add display_id with FX-#### format for reports
-- Description: Adds display_id column and sequence per estate for user-friendly report IDs

-- Create sequence function that generates FX-#### format
CREATE OR REPLACE FUNCTION fixflow_generate_report_display_id(p_estate_id uuid)
RETURNS TEXT
SET search_path = ''
AS $$
DECLARE
  v_next_num integer;
  v_display_id text;
BEGIN
  -- Get next sequence number for this estate
  -- Use a counter table approach for per-estate sequences
  INSERT INTO fixflow_report_counters (estate_id, last_number)
  VALUES (p_estate_id, 1)
  ON CONFLICT (estate_id)
  DO UPDATE SET last_number = fixflow_report_counters.last_number + 1
  RETURNING last_number INTO v_next_num;
  
  -- Format as FX-####
  v_display_id := 'FX-' || LPAD(v_next_num::text, 4, '0');
  
  RETURN v_display_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create counter table for per-estate sequences (must exist before backfill)
CREATE TABLE IF NOT EXISTS fixflow_report_counters (
  estate_id uuid PRIMARY KEY REFERENCES fixflow_estates(id) ON DELETE CASCADE,
  last_number integer NOT NULL DEFAULT 0,
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE fixflow_report_counters ENABLE ROW LEVEL SECURITY;

-- RLS policy: estate members can read
CREATE POLICY "report_counters_select_by_estate_member"
ON fixflow_report_counters FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM fixflow_user_estates
    WHERE estate_id = fixflow_report_counters.estate_id
      AND user_id = auth.uid()
  )
);

-- Add display_id column to reports
ALTER TABLE fixflow_reports
ADD COLUMN IF NOT EXISTS display_id TEXT;

-- Create unique index on display_id (across all estates, globally unique)
CREATE UNIQUE INDEX IF NOT EXISTS idx_fixflow_reports_display_id 
ON fixflow_reports(display_id);

-- Create trigger to auto-generate display_id on insert
CREATE OR REPLACE FUNCTION fixflow_set_report_display_id()
RETURNS TRIGGER
SET search_path = ''
AS $$
BEGIN
  IF NEW.display_id IS NULL THEN
    NEW.display_id := fixflow_generate_report_display_id(NEW.estate_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_set_report_display_id
BEFORE INSERT ON fixflow_reports
FOR EACH ROW
EXECUTE FUNCTION fixflow_set_report_display_id();

-- Add comment
COMMENT ON COLUMN fixflow_reports.display_id IS 'User-friendly report ID in format FX-####, unique globally';

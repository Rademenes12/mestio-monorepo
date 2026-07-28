-- Migration: Add additional_info field for "Inne dla zarządu"
-- Description: Optional field in report form for extra info visible to management/service

-- Add additional_info column
ALTER TABLE fixflow_reports
ADD COLUMN additional_info TEXT;

-- Comment
COMMENT ON COLUMN fixflow_reports.additional_info IS 'Additional info for management (e.g., "police will arrive", "fire department notified"). Visible to admin and technician only.';

-- Index for searching
CREATE INDEX idx_fixflow_reports_additional_info
ON fixflow_reports(id) WHERE additional_info IS NOT NULL;

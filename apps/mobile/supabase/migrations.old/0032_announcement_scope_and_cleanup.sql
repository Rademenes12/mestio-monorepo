-- Migration: Add structured scope for announcements and auto-cleanup
-- Description: Replaces target_label with scope_type + scope_id, adds cleanup Edge Function

-- Add scope columns
ALTER TABLE fixflow_announcements
ADD COLUMN scope_type TEXT CHECK (scope_type IN ('estate', 'building', 'stairwell')),
ADD COLUMN scope_building_id UUID REFERENCES fixflow_buildings(id) ON DELETE CASCADE,
ADD COLUMN scope_stairwell_id UUID REFERENCES fixflow_stairwells(id) ON DELETE CASCADE;

-- Set default scope_type to 'estate' for existing rows
UPDATE fixflow_announcements
SET scope_type = 'estate'
WHERE scope_type IS NULL;

-- Make scope_type NOT NULL with default 'estate'
ALTER TABLE fixflow_announcements
ALTER COLUMN scope_type SET DEFAULT 'estate',
ALTER COLUMN scope_type SET NOT NULL;

-- Create index for scope filtering
CREATE INDEX idx_fixflow_announcements_scope
ON fixflow_announcements(estate_id, scope_type, scope_building_id, scope_stairwell_id);

-- Comments
COMMENT ON COLUMN fixflow_announcements.scope_type IS 'Scope: estate (all), building (specific building), stairwell (specific stairwell)';
COMMENT ON COLUMN fixflow_announcements.scope_building_id IS 'Building ID when scope_type = building';
COMMENT ON COLUMN fixflow_announcements.scope_stairwell_id IS 'Stairwell ID when scope_type = stairwell';

-- Update RLS policy to respect scope
-- Residents can read active announcements matching their scope
DROP POLICY IF EXISTS "announcements_select_members" ON fixflow_announcements;

CREATE POLICY "announcements_select_members"
ON fixflow_announcements FOR SELECT
USING (
  is_active = true
  AND (expires_at IS NULL OR expires_at > now())
  AND (
    estate_id IS NULL
    OR (
      fixflow_is_estate_member(estate_id)
      AND (
        -- Estate-wide announcement
        scope_type = 'estate'
        -- TODO: Building/stairwell filtering requires user's building/stairwell in fixflow_user_estates
        -- For now, show all scopes to all estate members
        OR scope_type = 'building'
        OR scope_type = 'stairwell'
      )
    )
  )
);

-- Note: For building/stairwell filtering, we'd need to add building_id and stairwell_id
-- to fixflow_user_estates. Currently, user's location is stored as text fields
-- (reporter_building, reporter_footbridge). This is a future enhancement.

-- Add comment about auto-cleanup
COMMENT ON TABLE fixflow_announcements IS 'Announcements with structured scope (estate/building/stairwell) and auto-expiry. Use Supabase Edge Function or pg_cron to delete expired announcements.';

-- Create a database function to clean up expired announcements
CREATE OR REPLACE FUNCTION fixflow_cleanup_expired_announcements()
RETURNS INTEGER
SET search_path = ''
AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM fixflow_announcements
  WHERE expires_at IS NOT NULL
    AND expires_at < now()
    AND is_active = true;
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comment on cleanup function
COMMENT ON FUNCTION fixflow_cleanup_expired_announcements IS 'Deletes expired announcements. Call from Edge Function or pg_cron.';

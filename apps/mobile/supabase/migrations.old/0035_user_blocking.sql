-- Migration: User blocking mechanism (App Store Guideline 1.2 - UGC)
-- Allows users to block other users so their content is hidden.

CREATE TABLE IF NOT EXISTS fixflow_blocked_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  blocker_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  blocked_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (blocker_id, blocked_id)
);

COMMENT ON TABLE fixflow_blocked_users IS 'User-to-user blocks. blocker no longer sees blocked user content.';

CREATE INDEX idx_fixflow_blocked_users_blocker ON fixflow_blocked_users(blocker_id);
CREATE INDEX idx_fixflow_blocked_users_blocked ON fixflow_blocked_users(blocked_id);

-- RLS
ALTER TABLE fixflow_blocked_users ENABLE ROW LEVEL SECURITY;

-- Users can see their own blocks
CREATE POLICY "blocked_users_select_own"
ON fixflow_blocked_users FOR SELECT
USING (blocker_id = auth.uid());

-- Users can create their own blocks
CREATE POLICY "blocked_users_insert_own"
ON fixflow_blocked_users FOR INSERT
WITH CHECK (blocker_id = auth.uid());

-- Users can remove their own blocks (unblock)
CREATE POLICY "blocked_users_delete_own"
ON fixflow_blocked_users FOR DELETE
USING (blocker_id = auth.uid());

GRANT SELECT, INSERT, DELETE ON fixflow_blocked_users TO authenticated;

-- Helper: is a user blocked by the current user?
CREATE OR REPLACE FUNCTION fixflow_is_user_blocked(p_blocked_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = ''
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.fixflow_blocked_users
    WHERE blocker_id = auth.uid()
      AND blocked_id = p_blocked_id
  );
$$;

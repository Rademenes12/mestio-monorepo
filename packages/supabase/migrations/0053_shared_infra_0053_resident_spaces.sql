-- 0053: Resident spaces (komórki, piwnice, miejsca postojowe, garaże)
-- Each resident can have multiple spaces associated with their profile.

CREATE TABLE IF NOT EXISTS fixflow_resident_spaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  estate_id uuid NOT NULL REFERENCES fixflow_estates(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('storage','basement','parking','garage','other')),
  label text NOT NULL,
  created_by text NOT NULL DEFAULT 'resident',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_resident_spaces_user_id ON fixflow_resident_spaces(user_id);
CREATE INDEX IF NOT EXISTS idx_resident_spaces_estate_id ON fixflow_resident_spaces(estate_id);

ALTER TABLE fixflow_resident_spaces ENABLE ROW LEVEL SECURITY;

-- Resident: full CRUD on their own spaces
CREATE POLICY resident_spaces_owner ON fixflow_resident_spaces
  FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Office (board/admin): read and write within their estate
CREATE POLICY resident_spaces_office ON fixflow_resident_spaces
  FOR ALL
  USING (fixflow_is_estate_admin(estate_id) OR fixflow_is_board(estate_id))
  WITH CHECK (fixflow_is_estate_admin(estate_id) OR fixflow_is_board(estate_id));

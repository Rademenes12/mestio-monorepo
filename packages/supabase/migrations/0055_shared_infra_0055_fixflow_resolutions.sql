-- FixFlow — resolutions (uchwały) with voting
-- ============================================================================
-- Board/admin creates resolutions for an estate; residents vote For/Against.
-- Tally is hidden from a resident until they cast their own vote (or the
-- resolution is closed) to avoid anchoring bias — enforced server-side in
-- fixflow_list_resolutions.
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.fixflow_resolutions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'passed', 'rejected')),
  deadline timestamptz,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  closed_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_fixflow_resolutions_estate
  ON public.fixflow_resolutions(estate_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.fixflow_resolution_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  resolution_id uuid NOT NULL REFERENCES public.fixflow_resolutions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  choice text NOT NULL CHECK (choice IN ('for', 'against')),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (resolution_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_fixflow_resolution_votes_resolution
  ON public.fixflow_resolution_votes(resolution_id);

-- ============================================================================
-- RLS
-- ============================================================================

ALTER TABLE public.fixflow_resolutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fixflow_resolution_votes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "resolutions_select_members" ON public.fixflow_resolutions;
DROP POLICY IF EXISTS "resolutions_insert_admin" ON public.fixflow_resolutions;
DROP POLICY IF EXISTS "resolutions_update_admin" ON public.fixflow_resolutions;
DROP POLICY IF EXISTS "resolutions_delete_admin" ON public.fixflow_resolutions;
DROP POLICY IF EXISTS "resolution_votes_select_own_or_admin" ON public.fixflow_resolution_votes;
DROP POLICY IF EXISTS "resolution_votes_insert_own" ON public.fixflow_resolution_votes;

CREATE POLICY "resolutions_select_members"
ON public.fixflow_resolutions FOR SELECT
USING (public.fixflow_is_estate_member(estate_id));

CREATE POLICY "resolutions_insert_admin"
ON public.fixflow_resolutions FOR INSERT
WITH CHECK (public.fixflow_is_estate_admin(estate_id));

CREATE POLICY "resolutions_update_admin"
ON public.fixflow_resolutions FOR UPDATE
USING (public.fixflow_is_estate_admin(estate_id))
WITH CHECK (public.fixflow_is_estate_admin(estate_id));

CREATE POLICY "resolutions_delete_admin"
ON public.fixflow_resolutions FOR DELETE
USING (public.fixflow_is_estate_admin(estate_id));

-- A voter can always see their own vote; estate admins can audit all votes.
CREATE POLICY "resolution_votes_select_own_or_admin"
ON public.fixflow_resolution_votes FOR SELECT
USING (
  user_id = (SELECT auth.uid())
  OR EXISTS (
    SELECT 1 FROM public.fixflow_resolutions r
    WHERE r.id = resolution_id
      AND public.fixflow_is_estate_admin(r.estate_id)
  )
);

-- Vote only as yourself, only on open resolutions of estates you belong to.
-- Votes are immutable (no UPDATE/DELETE policies).
CREATE POLICY "resolution_votes_insert_own"
ON public.fixflow_resolution_votes FOR INSERT
WITH CHECK (
  user_id = (SELECT auth.uid())
  AND EXISTS (
    SELECT 1 FROM public.fixflow_resolutions r
    WHERE r.id = resolution_id
      AND r.status = 'open'
      AND public.fixflow_is_estate_member(r.estate_id)
  )
);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.fixflow_resolutions TO authenticated;
GRANT SELECT, INSERT ON public.fixflow_resolution_votes TO authenticated;

-- ============================================================================
-- Listing RPC — returns resolutions with tally and caller's vote.
-- Tally columns are NULL for a resident who has not voted on an open
-- resolution yet (results hidden until you vote).
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fixflow_list_resolutions(p_estate_id uuid)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  status text,
  deadline timestamptz,
  created_at timestamptz,
  closed_at timestamptz,
  votes_for integer,
  votes_against integer,
  my_vote text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_is_admin boolean;
BEGIN
  IF NOT public.fixflow_is_estate_member(p_estate_id) THEN
    RAISE EXCEPTION 'not a member of estate %', p_estate_id;
  END IF;

  v_is_admin := public.fixflow_is_estate_admin(p_estate_id);

  RETURN QUERY
  SELECT
    r.id,
    r.title,
    r.description,
    r.status,
    r.deadline,
    r.created_at,
    r.closed_at,
    CASE WHEN v_is_admin OR r.status <> 'open' OR mv.choice IS NOT NULL
      THEN COALESCE(t.votes_for, 0) ELSE NULL END AS votes_for,
    CASE WHEN v_is_admin OR r.status <> 'open' OR mv.choice IS NOT NULL
      THEN COALESCE(t.votes_against, 0) ELSE NULL END AS votes_against,
    mv.choice AS my_vote
  FROM public.fixflow_resolutions r
  LEFT JOIN LATERAL (
    SELECT
      count(*) FILTER (WHERE v.choice = 'for')::integer AS votes_for,
      count(*) FILTER (WHERE v.choice = 'against')::integer AS votes_against
    FROM public.fixflow_resolution_votes v
    WHERE v.resolution_id = r.id
  ) t ON true
  LEFT JOIN public.fixflow_resolution_votes mv
    ON mv.resolution_id = r.id AND mv.user_id = (SELECT auth.uid())
  WHERE r.estate_id = p_estate_id
  ORDER BY (r.status = 'open') DESC, r.created_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_list_resolutions(uuid) TO authenticated;

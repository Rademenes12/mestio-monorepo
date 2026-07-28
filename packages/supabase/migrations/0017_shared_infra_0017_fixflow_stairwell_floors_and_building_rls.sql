-- FixFlow — estate structure schema fix and RLS completion
-- ============================================================================
-- The estate structure UI lets admins create buildings and stairwells, but the
-- production schema was missing several columns used by the app and RLS was
-- enabled without policies for fixflow_buildings / fixflow_stairwells. This
-- migration adds the missing columns, migrates legacy floor_count if present,
-- creates the missing RLS policies, and enables Realtime for both tables.
-- ============================================================================

-- ============================================================================
-- KROK 1 — Missing columns on fixflow_buildings
-- ============================================================================

ALTER TABLE public.fixflow_buildings
  ADD COLUMN IF NOT EXISTS display_order integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();

-- ============================================================================
-- KROK 2 — Missing columns on fixflow_stairwells
-- ============================================================================

ALTER TABLE public.fixflow_stairwells
  ADD COLUMN IF NOT EXISTS floor_min integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS floor_max integer NOT NULL DEFAULT 4,
  ADD COLUMN IF NOT EXISTS garage_entrance_label text,
  ADD COLUMN IF NOT EXISTS display_order integer NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();

-- If a legacy floor_count column exists (from an earlier manual fix), migrate
-- its values to the new floor range before dropping it.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'fixflow_stairwells'
      AND column_name = 'floor_count'
  ) THEN
    UPDATE public.fixflow_stairwells
    SET floor_min = 0,
        floor_max = GREATEST(0, floor_count - 1)
    WHERE floor_max IS NULL OR floor_max = 4;

    ALTER TABLE public.fixflow_stairwells DROP COLUMN floor_count;
  END IF;
END $$;

-- ============================================================================
-- KROK 3 — Helper for stairwell RLS (resolves estate_id via building)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fixflow_get_building_estate_id(p_building_id uuid)
RETURNS uuid
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT estate_id FROM public.fixflow_buildings WHERE id = p_building_id;
$$;

GRANT EXECUTE ON FUNCTION public.fixflow_get_building_estate_id(uuid) TO authenticated;

-- ============================================================================
-- KROK 4 — RLS policies for fixflow_buildings
-- ============================================================================

DROP POLICY IF EXISTS "buildings_select_members" ON public.fixflow_buildings;
DROP POLICY IF EXISTS "buildings_admin_all" ON public.fixflow_buildings;

CREATE POLICY "buildings_select_members"
ON public.fixflow_buildings FOR SELECT
USING (public.fixflow_is_estate_member(estate_id));

CREATE POLICY "buildings_admin_all"
ON public.fixflow_buildings FOR ALL
USING (public.fixflow_is_estate_admin(estate_id))
WITH CHECK (public.fixflow_is_estate_admin(estate_id));

-- ============================================================================
-- KROK 5 — RLS policies for fixflow_stairwells
-- ============================================================================

DROP POLICY IF EXISTS "stairwells_select_members" ON public.fixflow_stairwells;
DROP POLICY IF EXISTS "stairwells_admin_all" ON public.fixflow_stairwells;

CREATE POLICY "stairwells_select_members"
ON public.fixflow_stairwells FOR SELECT
USING (
  public.fixflow_is_estate_member(
    public.fixflow_get_building_estate_id(building_id)
  )
);

CREATE POLICY "stairwells_admin_all"
ON public.fixflow_stairwells FOR ALL
USING (
  public.fixflow_is_estate_admin(
    public.fixflow_get_building_estate_id(building_id)
  )
)
WITH CHECK (
  public.fixflow_is_estate_admin(
    public.fixflow_get_building_estate_id(building_id)
  )
);

-- ============================================================================
-- KROK 6 — Realtime publication
-- ============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'fixflow_buildings'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.fixflow_buildings;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'fixflow_stairwells'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.fixflow_stairwells;
  END IF;
END $$;

-- ============================================================================
-- KROK 7 — Grants
-- ============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON public.fixflow_buildings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.fixflow_stairwells TO authenticated;

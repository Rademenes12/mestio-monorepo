-- ============================================================================
-- FixFlow — fcm_token na fixflow_resident_profiles
-- ============================================================================
-- Potrzebne dla push notifications. Poprzednio token byl zapisywany do
-- martwej tabeli fixflow_residents.
-- ============================================================================

ALTER TABLE public.fixflow_resident_profiles
  ADD COLUMN IF NOT EXISTS fcm_token text;

CREATE INDEX IF NOT EXISTS idx_resident_profiles_fcm_token 
  ON public.fixflow_resident_profiles(fcm_token) 
  WHERE fcm_token IS NOT NULL;

-- Migracja istniejacych tokenow z fixflow_residents (jesli istnieje)
DO $$ BEGIN
  UPDATE public.fixflow_resident_profiles rp
  SET fcm_token = r.fcm_token
  FROM public.fixflow_residents r
  WHERE rp.id = r.user_id
    AND r.fcm_token IS NOT NULL
    AND rp.fcm_token IS NULL;
EXCEPTION
  WHEN undefined_table THEN null;
END $$;

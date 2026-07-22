-- 0060: Document further schema drift found in ecosystem audit.
--
-- `fixflow_resident_profiles.verification_code` already exists on production
-- and is actively written by `ResidentProfileModel.toJson()` via
-- `saveResidentProfile()` (reports_remote_data_source.dart, upsert), but was
-- never created by any tracked migration - same pre-migration-tracking drift
-- pattern as 0059. Documented here so migration history matches reality.

ALTER TABLE public.fixflow_resident_profiles
  ADD COLUMN IF NOT EXISTS verification_code text;

COMMENT ON COLUMN public.fixflow_resident_profiles.verification_code IS
  'Invitation code used at registration time, kept for support/audit purposes.';

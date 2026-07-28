-- Migration: Persist GDPR consent (terms_accepted_at)
--
-- Consent to the Terms of Service / Privacy Policy was only enforced as a
-- transient UI checkbox in register_screen.dart (_acceptedTerms) - never
-- sent to the backend or stored anywhere. Per GDPR Article 7(1), the
-- controller must be able to DEMONSTRATE that consent was given. Also, the
-- guest (signInAnonymously) + lock_screen wizard path collected real PII
-- (name, phone, apartment) with no consent reference at all.

ALTER TABLE public.fixflow_resident_profiles
ADD COLUMN IF NOT EXISTS terms_accepted_at timestamptz;

COMMENT ON COLUMN public.fixflow_resident_profiles.terms_accepted_at IS
  'Timestamp when the user accepted the Terms of Service / Privacy Policy,
   captured in lock_screen.dart (the one screen every new user - guest or
   registered - passes through before collecting name/phone/apartment).';

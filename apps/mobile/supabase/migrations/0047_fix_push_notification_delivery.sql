-- Migration: Fix push notification delivery (was silently broken since inception)
--
-- Root cause #1: pg_net extension was never enabled on this project, so every
-- call to net.http_post() inside fixflow_send_push_notification() failed with
-- "schema net does not exist" - caught by the function's blanket
-- `EXCEPTION WHEN OTHERS` handler, so it silently logged a WARNING and moved
-- on. No report/status-change/assignment notification has ever actually been
-- sent by this trigger.
--
-- Root cause #2: even with pg_net working, the function sent the anon key as
-- the Authorization bearer token. send-notification/index.ts requires a real
-- user session (`supabase.auth.getUser(token)`), which the anon key is not -
-- the call would still be rejected with 401 invalid_token. DB triggers have
-- no user session to attach, so this call must authenticate as a trusted
-- service call instead.
--
-- Fix: (1) CREATE EXTENSION pg_net (done directly, not here, since it can't
-- run inside a transaction the same way in some environments - see below).
-- (2) Store the service_role key in Supabase Vault (never in a migration
-- file / git) and have this function read it at call time. (3) Update
-- send-notification/index.ts (deployed separately) to accept the
-- service_role key as an internal/trusted caller, bypassing the end-user
-- JWT check for this one case.

CREATE EXTENSION IF NOT EXISTS pg_net;

CREATE OR REPLACE FUNCTION public.fixflow_send_push_notification(
  p_topic text,
  p_title text,
  p_body text,
  p_data jsonb DEFAULT '{}'::jsonb
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_service_role_key text;
BEGIN
  SELECT decrypted_secret INTO v_service_role_key
  FROM vault.decrypted_secrets
  WHERE name = 'fixflow_service_role_key';

  IF v_service_role_key IS NULL THEN
    RAISE WARNING 'fixflow_send_push_notification: service role key not found in Vault, skipping push';
    RETURN;
  END IF;

  PERFORM net.http_post(
    url := 'https://rtyywhbisjaxlpjcugdk.supabase.co/functions/v1/send-notification',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_service_role_key
    ),
    body := jsonb_build_object(
      'topic', p_topic,
      'title', p_title,
      'body', p_body,
      'data', p_data
    )
  );
EXCEPTION
  WHEN OTHERS THEN
    -- Non-fatal: a report create/update must never fail because a push
    -- notification couldn't be queued.
    RAISE WARNING 'Failed to send push notification: %', SQLERRM;
END;
$$;

COMMENT ON FUNCTION public.fixflow_send_push_notification IS
  'FIXED (0047): enables pg_net, reads service_role key from Vault instead of
   sending the anon key (which send-notification rejects - it expects a real
   user JWT or, per this fix, the service_role key for trusted/internal calls).';

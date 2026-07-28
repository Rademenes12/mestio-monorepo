-- ============================================================
-- Telegram notifications — wywołuje Edge Function przy:
--   - nowym leadzie (INSERT do crm_leads)
--   - zmianie etapu leada (UPDATE stage w crm_leads -> won)
--   - nowym feedbacku (INSERT do fixflow_feedback)
-- ============================================================

-- ============================================================
-- 1. Funkcja: powiadomienie o nowym leadzie
-- ============================================================
create or replace function public.fixflow_notify_new_lead()
returns trigger
language plpgsql
security definer
as $$
declare
  v_chat_id text;
begin
  select decrypted_secret into v_chat_id
  from vault.decrypted_secrets
  where name = 'telegram_chat_id';

  if v_chat_id is null then
    raise warning 'fixflow_notify_new_lead: telegram_chat_id not found in Vault, skipping';
    return new;
  end if;

  perform net.http_post(
    url := 'https://legeebmbpzjlbgjsnwpd.supabase.co/functions/v1/telegram-notifier',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'supabase_anon_key' limit 1)
    ),
    body := jsonb_build_object(
      'type', 'new_lead',
      'title', 'Nowy lead: ' || new.company_name,
      'message', format(
        E'Firma: *%s*\nKontakt: %s\nEmail: %s\nTel: %s\nŹródło: %s\nMRR: %s zł',
        new.company_name,
        coalesce(new.contact_name, '—'),
        coalesce(new.contact_email, '—'),
        coalesce(new.contact_phone, '—'),
        new.source,
        coalesce(new.mrr::text, '0')
      ),
      'link', 'https://admin.mestio.pl/pipeline'
    ),
    timeout_milliseconds := 5000
  );

  return new;
end;
$$;

-- ============================================================
-- 2. Funkcja: powiadomienie o wygranym leadzie (stage -> won)
-- ============================================================
create or replace function public.fixflow_notify_won_lead()
returns trigger
language plpgsql
security definer
as $$
begin
  if old.stage != 'won' and new.stage = 'won' then
    perform net.http_post(
      url := 'https://legeebmbpzjlbgjsnwpd.supabase.co/functions/v1/telegram-notifier',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'supabase_anon_key' limit 1)
      ),
      body := jsonb_build_object(
        'type', 'stage_change',
        'title', '🎉 Wygrana: ' || new.company_name,
        'message', format(
          E'Firma: *%s*\nMRR: %s zł\nEtap: %s → *WYGRANA*\n\nCzas w pipeline: %s dni',
          new.company_name,
          coalesce(new.mrr::text, '0'),
          old.stage,
          extract(day from now() - new.created_at)::int
        ),
        'link', 'https://admin.mestio.pl/customers/' || new.id
      ),
      timeout_milliseconds := 5000
    );
  end if;
  return new;
end;
$$;

-- ============================================================
-- 3. Funkcja: powiadomienie o nowym feedbacku
-- ============================================================
create or replace function public.fixflow_notify_feedback()
returns trigger
language plpgsql
security definer
as $$
begin
  perform net.http_post(
    url := 'https://legeebmbpzjlbgjsnwpd.supabase.co/functions/v1/telegram-notifier',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'supabase_anon_key' limit 1)
    ),
    body := jsonb_build_object(
      'type', 'feedback',
      'title', '💬 Nowa opinia',
      'message', coalesce(new.message, '(brak treści)'),
      'link', 'https://admin.mestio.pl/feedback'
    ),
    timeout_milliseconds := 5000
  );
  return new;
end;
$$;

-- ============================================================
-- 4. Triggery
-- ============================================================

drop trigger if exists trg_fixflow_notify_new_lead on crm_leads;
create trigger trg_fixflow_notify_new_lead
  after insert on crm_leads
  for each row
  execute function public.fixflow_notify_new_lead();

drop trigger if exists trg_fixflow_notify_won_lead on crm_leads;
create trigger trg_fixflow_notify_won_lead
  after update on crm_leads
  for each row
  when (old.stage is distinct from new.stage and new.stage = 'won')
  execute function public.fixflow_notify_won_lead();

drop trigger if exists trg_fixflow_notify_feedback on fixflow_feedback;
create trigger trg_fixflow_notify_feedback
  after insert on fixflow_feedback
  for each row
  execute function public.fixflow_notify_feedback();

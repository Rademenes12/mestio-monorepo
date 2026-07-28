-- RODO fixes (audyt 09.07.2026):
-- 1. crm_emails: osierocone e-maile z danymi osobowymi po usunieciu leada -> kaskada
-- 2. Funkcja anonimizacji leada (art. 17 RODO) - zachowuje dane fakturowe (5 lat, art. 74 UoR),
--    usuwa dane osobowe osoby kontaktowej, interakcje, e-maile i zadania
-- 3. Czyszczenie wypisanych subskrybentow newslettera (retencja)

-- ============================================================
-- 1. crm_emails: on delete set null -> on delete cascade
--    (tresc e-maila zawiera dane osobowe - nie moze zostac osierocona)
-- ============================================================
alter table crm_emails drop constraint if exists crm_emails_lead_id_fkey;
alter table crm_emails
  add constraint crm_emails_lead_id_fkey
  foreign key (lead_id) references crm_leads(id) on delete cascade;

-- ============================================================
-- 2. Anonimizacja leada (prawo do bycia zapomnianym, art. 17 RODO)
--    Nie usuwa rekordu leada ani faktur (obowiazek 5 lat - art. 74 ustawy
--    o rachunkowosci / art. 86 Ordynacji podatkowej - wyjatek art. 17 ust. 3
--    lit. b RODO). Usuwa/czysci wszystkie dane osobowe osoby kontaktowej.
-- ============================================================
create or replace function crm_anonymize_lead(p_lead_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  -- tylko wlasciciel platformy
  if auth.uid() is distinct from '48ffc236-5d63-4af2-94f6-d10d2470e9c7' then
    raise exception 'FORBIDDEN';
  end if;

  -- dane osobowe osoby kontaktowej -> czyszczone; firma+NIP zostaja (dane fakturowe)
  update crm_leads set
    contact_name = null,
    contact_email = null,
    contact_phone = null,
    notes = '[dane zanonimizowane ' || to_char(now(), 'YYYY-MM-DD') || ' - art. 17 RODO]',
    updated_at = now()
  where id = p_lead_id;

  -- historia interakcji, e-maile i zadania moga zawierac dane osobowe -> usuwane
  delete from crm_interactions where lead_id = p_lead_id;
  delete from crm_emails where lead_id = p_lead_id;
  delete from crm_tasks where lead_id = p_lead_id;

  -- dokumenty: tresc zawiera dane osobowe -> czyszczona, metadane statusu zostaja
  update client_documents set
    body = '[tresc zanonimizowana - art. 17 RODO]'
  where lead_id = p_lead_id;
end $$;

comment on function crm_anonymize_lead is
  'Realizacja prawa do bycia zapomnianym (art. 17 RODO). Zachowuje dane fakturowe przez 5 lat podatkowych.';

-- ============================================================
-- 3. Czyszczenie newslettera: wypisani przechowywani max 30 dni
--    (dowod wypisania), potem usuwani. Wywoluj recznie lub przez pg_cron:
--    select cron.schedule('newsletter-cleanup', '0 3 * * *',
--      $$select newsletter_cleanup()$$);
-- ============================================================
create or replace function newsletter_cleanup()
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare v_count integer;
begin
  delete from newsletter_subscribers
  where unsubscribed = true
    and subscribed_at < now() - interval '30 days';
  get diagnostics v_count = row_count;
  return v_count;
end $$;

comment on function newsletter_cleanup is
  'Retencja: usuwa wypisanych subskrybentow po 30 dniach (art. 5 ust. 1 lit. e RODO).';

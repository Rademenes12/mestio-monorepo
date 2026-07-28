-- 0013: Automatyczna sekwencja onboardingowa (Day 0/1/2/3/7/14) + kolejka mailowa
--
-- Problem (audyt A3, HubSpot benchmark): nowy platny klient nie dostaje ZADNEJ
-- automatycznej wiadomosci po zakupie. Ryzyko porzucenia produktu w pierwszych
-- 14 dniach = utrata MRR. Automatyzacje w CRM dzialaly tez tylko gdy owner
-- odwiedzil Pulpit - jesli nie zalogowal sie kilka dni, nic sie nie dzialo.
--
-- Rozwiazanie: kolejka (crm_email_queue) + trigger zapisujacy do niej przy
-- stage->won + pg_cron co 15 min wysylajacy dojrzale wpisy przez Edge Function
-- send-email (Resend). Niezalezne od tego czy ktokolwiek jest zalogowany.

create extension if not exists pg_cron;
create extension if not exists pg_net;

-- ============================================================
-- 1. Kolejka mailowa
-- ============================================================
create table if not exists crm_email_queue (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid not null references crm_leads(id) on delete cascade,
  template_key text not null,
  scheduled_at timestamptz not null,
  status text not null default 'pending', -- pending / sent / error / cancelled
  attempts int not null default 0,
  sent_at timestamptz,
  error text,
  created_at timestamptz default now(),
  unique (lead_id, template_key)
);

alter table crm_email_queue enable row level security;

create policy crm_email_queue_owner on crm_email_queue for all
  using (auth.uid() = '8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8')
  with check (auth.uid() = '8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8');

create index if not exists idx_crm_email_queue_due
  on crm_email_queue (scheduled_at)
  where status = 'pending';

-- ============================================================
-- 2. Szablony (edytowalne z Ustawien bez deployu - wzorzec z automations.ts)
-- Placeholdery: {{firma}}, {{imie}}, {{kod}}
-- ============================================================
insert into crm_settings (key, value) values
  ('email_template:onboarding_d0', jsonb_build_object(
    'subject', 'Witamy w Mestio, {{imie}}! Oto Twoje dane startowe',
    'body', E'Cze\u015b\u0107 {{imie}},\n\ndzi\u0119kujemy za za\u0142o\u017cenie konta dla {{firma}} w Mestio!\n\nOto co dalej:\n1. Zaloguj si\u0119 do panelu zarz\u0105dcy: panel.mestio.pl\n2. Kod zaproszenia dla administratora: {{kod}}\n3. Aplikacja dla mieszka\u0144c\u00f3w: App Store / Google Play (szukaj "Mestio")\n\nJe\u015bli cokolwiek jest niejasne - po prostu odpisz na tego maila.\n\nZesp\u00f3\u0142 Mestio'
  )),
  ('email_template:onboarding_d1', jsonb_build_object(
    'subject', 'Skonfiguruj swoje osiedle w 10 minut',
    'body', E'Cze\u015b\u0107 {{imie}},\n\ndrugi krok: skonfiguruj dane {{firma}} w panelu.\n\n1. Wejd\u017a w Ustawienia \u2192 Dane osiedla\n2. Dodaj budynki i klatki schodowe\n3. Uzupe\u0142nij adres i dane administratora\n\nTo zajmuje dos\u0142ownie kilka minut, a u\u0142atwia \u017cycie wszystkim mieszka\u0144com.\n\nZesp\u00f3\u0142 Mestio'
  )),
  ('email_template:onboarding_d2', jsonb_build_object(
    'subject', 'Zaproś mieszkańców — kody robią to za Ciebie',
    'body', E'Cze\u015b\u0107 {{imie}},\n\nkod dla mieszka\u0144c\u00f3w Twojego osiedla: {{kod}}\n\nWystarczy, \u017ce wklejenie go w og\u0142oszeniu na klatce albo w grupie osiedlowej - mieszka\u0144cy do\u0142\u0105czaj\u0105 do aplikacji sami, bez Twojego udzia\u0142u (rola resident do\u0142\u0105cza automatycznie).\n\nWskaz\u00f3wka: w Ustawieniach mo\u017cesz w\u0142\u0105czy\u0107 tryb ukrywania danych kontaktowych mieszka\u0144c\u00f3w (RODO).\n\nZesp\u00f3\u0142 Mestio'
  )),
  ('email_template:onboarding_d3', jsonb_build_object(
    'subject', 'Pierwsze zgłoszenie? Tak je obsłużysz w 2 minuty',
    'body', E'Cze\u015b\u0107 {{imie}},\n\nkiedy pojawi si\u0119 pierwsze zg\u0142oszenie od mieszka\u0144ca, cykl \u017cycia sprawy wygl\u0105da tak:\n\nNowe \u2192 W realizacji \u2192 Zamkni\u0119te (lub Odrzucone)\n\nMo\u017cesz przypisa\u0107 zg\u0142oszenie do serwisanta, ustawi\u0107 priorytet, doda\u0107 komentarz wewn\u0119trzny (widoczny tylko dla zarz\u0105du) albo odpowiedzie\u0107 mieszka\u0144cowi wprost.\n\nCa\u0142a historia zapisuje si\u0119 automatycznie - \u017cadnych zagubionych karteczek.\n\nZesp\u00f3\u0142 Mestio'
  )),
  ('email_template:onboarding_d7', jsonb_build_object(
    'subject', 'Tydzień z Mestio — jak idzie, {{imie}}?',
    'body', E'Cze\u015b\u0107 {{imie}},\n\nmija tydzie\u0144 od za\u0142o\u017cenia konta dla {{firma}}. Kr\u00f3tkie podsumowanie tips & tricks:\n\n- Og\u0142oszenia mo\u017cesz kierowa\u0107 do konkretnej klatki, nie tylko ca\u0142ego osiedla\n- Zadania cykliczne (np. przegl\u0105d gaszenia po\u017carowego) ustawisz raz i zapomnisz\n- Health Score na Pulpicie pokazuje kondycj\u0119 osiedla jednym spojrzeniem\n\nMasz pytanie albo utkn\u0105\u0142e\u015b gdzie\u015b? Po prostu odpisz - ch\u0119tnie pomo\u017cemy.\n\nZesp\u00f3\u0142 Mestio'
  )),
  ('email_template:onboarding_d14', jsonb_build_object(
    'subject', 'Jedno pytanie: czy polecił(a)byś Mestio?',
    'body', E'Cze\u015b\u0107 {{imie}},\n\nw skali 0-10, jak bardzo prawdopodobne jest, \u017ce poleci\u0142(a)by\u015b Mestio innemu zarz\u0105dcy lub wsp\u00f3lnocie?\n\nOdpisz na tego maila sam\u0105 liczb\u0105 (0-10) - a je\u015bli co\u015b Ci przeszkadza, napisz od razu co poprawi\u0107. Czytamy ka\u017cd\u0105 odpowied\u017a osobi\u015bcie.\n\nDzi\u0119kujemy, \u017ce jeste\u015bcie z nami!\n\nZesp\u00f3\u0142 Mestio'
  ))
on conflict (key) do nothing;

-- ============================================================
-- 3. Trigger: enrollment przy stage->won, anulowanie przy churned/lost
-- ============================================================
create or replace function crm_enroll_onboarding_sequence()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.stage = 'won' and (old.stage is distinct from 'won') then
    insert into public.crm_email_queue (lead_id, template_key, scheduled_at)
    values
      (new.id, 'onboarding_d0', now()),
      (new.id, 'onboarding_d1', now() + interval '1 day'),
      (new.id, 'onboarding_d2', now() + interval '2 days'),
      (new.id, 'onboarding_d3', now() + interval '3 days'),
      (new.id, 'onboarding_d7', now() + interval '7 days'),
      (new.id, 'onboarding_d14', now() + interval '14 days')
    on conflict (lead_id, template_key) do nothing;
  end if;

  if new.stage in ('churned', 'lost') and (old.stage is distinct from new.stage) then
    update public.crm_email_queue
    set status = 'cancelled'
    where lead_id = new.id and status = 'pending';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_crm_enroll_onboarding on crm_leads;
create trigger trg_crm_enroll_onboarding
  after update of stage on crm_leads
  for each row
  execute function crm_enroll_onboarding_sequence();

-- ============================================================
-- 4. Przetwarzanie kolejki (wywolywane przez pg_cron co 15 min)
-- Uwaga: anon key ponizej to publiczny "publishable" klucz - identyczny z
-- tym zaszytym we wszystkich frontendach ekosystemu (bezpieczny do embedowania,
-- funkcja i tak jest SECURITY DEFINER wywolywana tylko przez pg_cron/postgres).
-- ============================================================
create or replace function crm_process_email_queue()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  q record;
  lead record;
  estate_code text;
  tmpl jsonb;
  subject text;
  body text;
  first_name text;
  reports_count int;
  residents_count int;
  anon_key constant text := 'sb_publishable_CSysnJ7O6wLxRQsGG8sXGg_5sTQaTiR';
begin
  for q in
    select * from public.crm_email_queue
    where status = 'pending' and scheduled_at <= now()
    order by scheduled_at
    limit 50
  loop
    begin
      select * into lead from public.crm_leads where id = q.lead_id;
      if not found then
        update public.crm_email_queue set status = 'error', error = 'lead not found', attempts = q.attempts + 1 where id = q.id;
        continue;
      end if;

      if lead.contact_email is null then
        update public.crm_email_queue set status = 'error', error = 'brak contact_email', attempts = q.attempts + 1 where id = q.id;
        continue;
      end if;

      select value into tmpl from public.crm_settings where key = 'email_template:' || q.template_key;
      if tmpl is null then
        update public.crm_email_queue set status = 'error', error = 'brak szablonu', attempts = q.attempts + 1 where id = q.id;
        continue;
      end if;

      first_name := nullif(split_part(coalesce(lead.contact_name, ''), ' ', 1), '');
      if first_name is null then first_name := 'Państwu'; end if;

      select code into estate_code
      from public.fixflow_invitation_codes
      where estate_id = lead.estate_id and role = 'admin'
      order by created_at desc
      limit 1;

      subject := replace(replace(tmpl->>'subject', '{{firma}}', lead.company_name), '{{imie}}', first_name);
      body := replace(replace(replace(tmpl->>'body', '{{firma}}', lead.company_name), '{{imie}}', first_name), '{{kod}}', coalesce(estate_code, 'dostępny w panelu → Ustawienia → Kody zaproszeń'));

      -- Branch D7: onboarding utkniety (0 mieszkancow i 0 zgloszen) -> zadanie dla ownera
      if q.template_key = 'onboarding_d7' and lead.estate_id is not null then
        select count(*) into residents_count from public.fixflow_user_estates where estate_id = lead.estate_id and role = 'resident';
        select count(*) into reports_count from public.fixflow_reports where estate_id = lead.estate_id;
        if residents_count = 0 and reports_count = 0 then
          insert into public.crm_tasks (lead_id, title, due_date, priority)
          values (lead.id, 'Zadzwoń do ' || lead.company_name || ' — utknął onboarding (0 mieszkańców, 0 zgłoszeń po 7 dniach)', current_date, 'Wysoki');
        end if;
      end if;

      perform net.http_post(
        url := 'https://rtyywhbisjaxlpjcugdk.supabase.co/functions/v1/send-email',
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || anon_key
        ),
        body := jsonb_build_object('to', lead.contact_email, 'subject', subject, 'body', body)
      );

      insert into public.crm_emails (lead_id, to_email, subject, body, status, sent_at)
      values (lead.id, lead.contact_email, subject, body, 'sent', now());

      update public.crm_email_queue
      set status = 'sent', sent_at = now(), attempts = q.attempts + 1
      where id = q.id;
    exception when others then
      update public.crm_email_queue
      set status = 'error', error = sqlerrm, attempts = q.attempts + 1
      where id = q.id;
    end;
  end loop;
end;
$$;

-- ============================================================
-- 5. Harmonogram pg_cron (co 15 minut)
-- ============================================================
do $$
begin
  perform cron.unschedule('crm-process-email-queue');
exception when others then
  null; -- job jeszcze nie istnial, nic sie nie stalo
end $$;

select cron.schedule(
  'crm-process-email-queue',
  '*/15 * * * *',
  $$select crm_process_email_queue();$$
);

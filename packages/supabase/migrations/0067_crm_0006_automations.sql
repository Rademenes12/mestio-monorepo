-- Automatyzacje v2 (wzorzec HubSpot Workflows):
-- regula = wyzwalacz -> segment -> akcja; edytowalna, trwala, z silnikiem deduplikacji

create table if not exists crm_automations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  trigger_type text not null, -- new_lead | contract_expiring | invoice_overdue | inactive_client
  trigger_days int not null default 14, -- prog dni (dla expiring/overdue/inactive)
  segment jsonb not null default '{}'::jsonb, -- {stages:[], plans:[], sources:[]} - puste = wszyscy
  action_type text not null, -- create_task | email_draft
  action_config jsonb not null default '{}'::jsonb, -- {title} lub {subject, body}
  enabled boolean not null default true,
  created_at timestamptz default now()
);

-- log wykonan - deduplikacja (jedna akcja per klucz)
create table if not exists crm_automation_runs (
  id uuid primary key default gen_random_uuid(),
  automation_id uuid not null references crm_automations(id) on delete cascade,
  run_key text not null,
  created_at timestamptz default now(),
  unique (automation_id, run_key)
);

alter table crm_automations enable row level security;
alter table crm_automation_runs enable row level security;

create policy crm_automations_owner on crm_automations for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy crm_automation_runs_owner on crm_automation_runs for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create index if not exists idx_automation_runs_key on crm_automation_runs(automation_id, run_key);

-- Seed: 4 predefiniowane reguly (wczesniej hardcoded w UI)
insert into crm_automations (name, trigger_type, trigger_days, action_type, action_config, enabled)
select * from (values
  ('Umowa wygasa za 14 dni → zadanie: odnowienie', 'contract_expiring', 14, 'create_task',
   '{"title": "Odnowienie umowy: {{firma}} — umowa wygasa {{data}}"}'::jsonb, true),
  ('Nowy lead → zadanie: oddzwoń w 24h', 'new_lead', 1, 'create_task',
   '{"title": "Oddzwoń do nowego leada: {{firma}}"}'::jsonb, true),
  ('Faktura zaległa >7 dni → szkic ponaglenia', 'invoice_overdue', 7, 'email_draft',
   '{"subject": "Przypomnienie o płatności — {{numer}}", "body": "Dzień dobry,\n\nuprzejmie przypominam o zaległej fakturze {{numer}} na kwotę {{kwota}} zł (termin minął {{data}}).\n\nProszę o uregulowanie płatności lub kontakt.\n\nPozdrawiam,\nZespół Mestio"}'::jsonb, false),
  ('Klient nieaktywny >30 dni → zadanie: check-in', 'inactive_client', 30, 'create_task',
   '{"title": "Check-in: {{firma}} — brak aktywności od 30+ dni"}'::jsonb, true)
) as v(name, trigger_type, trigger_days, action_type, action_config, enabled)
where not exists (select 1 from crm_automations);

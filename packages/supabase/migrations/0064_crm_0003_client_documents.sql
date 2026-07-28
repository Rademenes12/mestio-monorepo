-- Nowe tabele: client_documents (umowy, RODO, NDA), crm_emails (poczta/archiwum)

-- ============================================================
-- DOKUMENTY I WZORY
-- ============================================================
create table if not exists client_documents (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references crm_leads(id) on delete cascade,
  type text not null, -- umowa / dpa_rodo / polityka_prywatnosci / nda
  title text not null,
  body text not null,
  status text default 'draft', -- draft / generated / sent / signed
  signed_at timestamptz,
  created_at timestamptz default now()
);

alter table client_documents enable row level security;

create policy client_docs_owner on client_documents for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create index if not exists idx_client_docs_lead on client_documents(lead_id);

-- ============================================================
-- EMAILS (poczta/archiwum)
-- ============================================================
create table if not exists crm_emails (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references crm_leads(id) on delete set null,
  to_email text not null,
  subject text not null,
  body text not null,
  status text default 'draft', -- draft / sent / opened / replied
  sent_at timestamptz,
  sent_by text,
  created_at timestamptz default now()
);

alter table crm_emails enable row level security;

create policy crm_emails_owner on crm_emails for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create index if not exists idx_crm_emails_lead on crm_emails(lead_id);
create index if not exists idx_crm_emails_status on crm_emails(status);

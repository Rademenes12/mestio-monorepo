-- FixFlow CRM Owner — migracja inicjalna
-- Tabele CRM + RLS (dostep tylko dla konta wlasciciela)
-- UWAGA: podmien '48ffc236-5d63-4af2-94f6-d10d2470e9c7' jesli zmienisz konto owner (twoj@fixflow.app)

-- ============================================================
-- 1. LEADY / KLIENCI
-- ============================================================
create table if not exists crm_leads (
  id uuid primary key default gen_random_uuid(),
  company_name text not null,
  contact_name text,
  contact_email text,
  contact_phone text,
  nip text,
  source text default 'website', -- website / referral / cold / other
  stage text not null default 'lead', -- lead/contact/demo/offer/won/onboarding/active/risk/churned
  plan text, -- start/standard/pro/enterprise
  mrr numeric(10,2) default 0,
  estate_id uuid,
  contract_end date,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

comment on column crm_leads.stage is 'lead, contact, demo, offer, won, onboarding, active, risk, churned';

-- ============================================================
-- 2. INTERAKCJE (historia)
-- ============================================================
create table if not exists crm_interactions (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid not null references crm_leads(id) on delete cascade,
  type text not null, -- call / email / meeting / note / auto / stage_change
  summary text not null,
  created_at timestamptz default now()
);

-- ============================================================
-- 3. ZADANIA CRM
-- ============================================================
create table if not exists crm_tasks (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references crm_leads(id) on delete set null,
  title text not null,
  due_date date,
  done boolean default false,
  priority text default 'Normalny',
  created_at timestamptz default now()
);

-- ============================================================
-- 4. FAKTURY
-- ============================================================
create table if not exists crm_invoices (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid not null references crm_leads(id),
  number text not null,
  amount numeric(10,2) not null,
  currency text default 'PLN',
  status text default 'issued', -- issued / paid / overdue
  issued_at date not null,
  paid_at date,
  stripe_invoice_id text,
  ksef_status text default 'pending', -- pending / sent / confirmed / error
  ksef_reference text,
  created_at timestamptz default now()
);

-- ============================================================
-- 5. BLOG
-- ============================================================
create table if not exists blog_posts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  body text not null,
  excerpt text,
  meta_description text,
  category text,
  cover_url text,
  status text default 'draft', -- draft / scheduled / published
  publish_at timestamptz,
  published_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ============================================================
-- 6. USTAWIENIA CRM
-- ============================================================
create table if not exists crm_settings (
  key text primary key,
  value jsonb not null
);

-- ============================================================
-- 7. NEWSLETTER
-- ============================================================
create table if not exists newsletter_subscribers (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  subscribed_at timestamptz default now(),
  unsubscribed boolean default false
);

-- ============================================================
-- 8. OPINIE I POMYSLY (feedback)
-- ============================================================
create table if not exists feedback (
  id uuid primary key default gen_random_uuid(),
  source text default 'own', -- app_mobile / crm_klienta / own
  author_email text,
  category text default 'idea', -- bug / idea / complaint
  title text not null,
  description text,
  status text default 'new', -- new / in_review / planned / done / rejected
  created_at timestamptz default now()
);

-- ============================================================
-- RLS — dostep TYLKO dla platform_owner (twoj@fixflow.app)
-- ============================================================
alter table crm_leads enable row level security;
alter table crm_interactions enable row level security;
alter table crm_tasks enable row level security;
alter table crm_invoices enable row level security;
alter table crm_settings enable row level security;
alter table feedback enable row level security;
alter table newsletter_subscribers enable row level security;
alter table blog_posts enable row level security;

create policy crm_leads_owner on crm_leads for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy crm_interactions_owner on crm_interactions for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy crm_tasks_owner on crm_tasks for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy crm_invoices_owner on crm_invoices for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy crm_settings_owner on crm_settings for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy feedback_owner on feedback for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

-- newsletter: kazdy moze sie zapisac (formularz na stronie), owner zarzadza
create policy newsletter_insert_public on newsletter_subscribers for insert
  with check (true);

create policy newsletter_owner_select on newsletter_subscribers for select
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy newsletter_owner_update on newsletter_subscribers for update
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy newsletter_owner_delete on newsletter_subscribers for delete
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

-- blog: owner pisze, swiat czyta opublikowane
create policy blog_owner on blog_posts for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

create policy blog_public_read on blog_posts for select
  using (status = 'published' and (publish_at is null or publish_at <= now()));

-- ============================================================
-- INDEKSY
-- ============================================================
create index if not exists idx_crm_leads_stage on crm_leads(stage);
create index if not exists idx_crm_interactions_lead_id on crm_interactions(lead_id);
create index if not exists idx_crm_tasks_lead_id on crm_tasks(lead_id);
create index if not exists idx_crm_invoices_lead_id on crm_invoices(lead_id);
create index if not exists idx_blog_posts_status on blog_posts(status);

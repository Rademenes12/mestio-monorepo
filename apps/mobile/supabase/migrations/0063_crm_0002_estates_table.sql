-- Tworzy tabele estates (jesli nie istnieje) + RLS dla platform_owner
create table if not exists estates (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  city text,
  postal_code text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table estates enable row level security;

create policy estates_owner_read on estates for select
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

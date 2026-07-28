create table if not exists public.shared_users (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text
);

alter table public.shared_users
  add column if not exists first_name text;

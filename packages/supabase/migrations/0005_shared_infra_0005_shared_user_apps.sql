create table if not exists public.shared_user_apps (
  user_id uuid not null references auth.users(id) on delete cascade,
  app_id text not null,
  app_name text not null,
  registered_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  primary key (user_id, app_id)
);

alter table public.shared_user_apps enable row level security;

create policy "shared_user_apps_select_own"
  on public.shared_user_apps for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "shared_user_apps_insert_own"
  on public.shared_user_apps for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "shared_user_apps_update_own"
  on public.shared_user_apps for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

alter table public.shared_users enable row level security;

drop policy if exists "shared_users_select_own" on public.shared_users;
create policy "shared_users_select_own"
on public.shared_users
for select
to authenticated
using (auth.uid() = id);

drop policy if exists "shared_users_insert_own" on public.shared_users;
create policy "shared_users_insert_own"
on public.shared_users
for insert
to authenticated
with check (auth.uid() = id);

drop policy if exists "shared_users_update_own" on public.shared_users;
create policy "shared_users_update_own"
on public.shared_users
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

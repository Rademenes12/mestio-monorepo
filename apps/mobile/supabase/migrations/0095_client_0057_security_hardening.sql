-- Utwardzanie bezpieczenstwa dla CRM Klienta (audyt 09.07.2026):
-- Analogiczne do migracji 0008 z CRM Owner, dostosowane do schematow klienckich.

-- 1. Funkcja anonimizacji mieszkanca (RODO) - usuwa dane osobowe z profilu
--    Zachowuje ID, role i strukture budynku (by nie zepsuc raportow).
create or replace function anonymize_resident_profiles(target_profile_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'FORBIDDEN';
  end if;

  if not exists (
    select 1 from fixflow_user_estates
    where user_id = auth.uid() and role = 'admin'
    limit 1
  ) then
    raise exception 'FORBIDDEN: admin only';
  end if;

  update fixflow_resident_profiles
  set
    name = '[Zanonimizowano]',
    email = null,
    phone = null
  where id = target_profile_id;
end $$;

comment on function anonymize_resident_profiles(uuid) is
  'RODO: anonimizuje dane osobowe mieszkanca (imie, email, telefon). Admin-only.';

-- 2. fixflow_can_update_report search_path (jesli istnieje z CRM Owner)
do $$
begin
  if exists (
    select 1 from pg_proc where proname = 'fixflow_can_update_report'
  ) then
    execute 'alter function fixflow_can_update_report(uuid) set search_path = ''''';
  end if;
end $$;

-- 3. Nadmiarowe granty: anon/authenticated nie powinni modyfikowac danych osiedla
revoke insert, update, delete, truncate on fixflow_estates from anon, authenticated;
revoke insert, update, delete, truncate on fixflow_buildings from anon, authenticated;
revoke insert, update, delete, truncate on fixflow_stairwells from anon, authenticated;

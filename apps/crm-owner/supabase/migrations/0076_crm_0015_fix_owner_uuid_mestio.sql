-- 0015: Aktualizacja UUID platform ownera na twoj@mestio.pl
-- Stary UUID (twoj@fixflow.app): 8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8
-- Nowy UUID (twoj@mestio.pl): ac8fec82-7e45-4897-8e25-5d7d74cd9b1e

do $$
declare
  old_uuid constant text := '8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8';
  new_uuid constant text := 'ac8fec82-7e45-4897-8e25-5d7d74cd9b1e';
  pol record;
  fn record;
  new_qual text;
  new_check text;
  fn_src text;
begin
  for pol in
    select schemaname, tablename, policyname, qual, with_check
    from pg_policies
    where coalesce(qual, '') like '%' || old_uuid || '%'
       or coalesce(with_check, '') like '%' || old_uuid || '%'
  loop
    new_qual := replace(pol.qual, old_uuid, new_uuid);
    new_check := replace(pol.with_check, old_uuid, new_uuid);

    if pol.qual is not null and pol.with_check is not null then
      execute format(
        'alter policy %I on %I.%I using (%s) with check (%s)',
        pol.policyname, pol.schemaname, pol.tablename, new_qual, new_check
      );
    elsif pol.qual is not null then
      execute format(
        'alter policy %I on %I.%I using (%s)',
        pol.policyname, pol.schemaname, pol.tablename, new_qual
      );
    elsif pol.with_check is not null then
      execute format(
        'alter policy %I on %I.%I with check (%s)',
        pol.policyname, pol.schemaname, pol.tablename, new_check
      );
    end if;

    raise notice 'Naprawiono polityke: %.% / %',
      pol.schemaname, pol.tablename, pol.policyname;
  end loop;

  for fn in
    select p.oid
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prokind = 'f'
      and pg_get_functiondef(p.oid) like '%' || old_uuid || '%'
  loop
    fn_src := replace(pg_get_functiondef(fn.oid), old_uuid, new_uuid);
    execute fn_src;
    raise notice 'Naprawiono funkcje oid=%', fn.oid;
  end loop;
end $$;

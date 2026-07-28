-- 0012: Naprawa UUID platform ownera we wszystkich politykach RLS i funkcjach.
--
-- PROBLEM: konto ownera (twoj@fixflow.app) zostalo w pewnym momencie usuniete
-- i utworzone ponownie. Stary UUID '48ffc236-5d63-4af2-94f6-d10d2470e9c7'
-- (hardcodowany w migracjach 0001-0010) nie istnieje w auth.users.
-- Skutek: WSZYSTKIE polityki owner-only odrzucaly zalogowanego ownera -
-- Pipeline, Klienci, Faktury itd. byly puste mimo danych w tabelach.
--
-- FIX: dynamiczna podmiana starego UUID na aktualny we wszystkich politykach
-- RLS oraz cialach funkcji (crm_anonymize_lead, licznik faktur, sync do
-- CRM Klienta). Podejscie dynamiczne naprawia takze ewentualny drift
-- (polityki zmienione recznie w Dashboardzie).
--
-- UWAGA NA PRZYSZLOSC: jesli konto ownera znow zostanie przebudowane,
-- nalezy powtorzyc ta operacje z nowym UUID.

do $$
declare
  old_uuid constant text := '48ffc236-5d63-4af2-94f6-d10d2470e9c7';
  new_uuid constant text := '8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8'; -- twoj@fixflow.app
  pol record;
  fn record;
  new_qual text;
  new_check text;
  fn_src text;
begin
  -- 1. Polityki RLS zawierajace stary UUID
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

  -- 2. Funkcje (SECURITY DEFINER) ze starym UUID w ciele
  --    (crm_anonymize_lead, crm_next_invoice_number, fixflow_sync_* itd.)
  for fn in
    select p.oid
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.prokind = 'f' -- funkcje zwykle, wyklucza agregaty/procedury/window
      and pg_get_functiondef(p.oid) like '%' || old_uuid || '%'
  loop
    fn_src := replace(pg_get_functiondef(fn.oid), old_uuid, new_uuid);
    execute fn_src;
    raise notice 'Naprawiono funkcje oid=%', fn.oid;
  end loop;
end $$;

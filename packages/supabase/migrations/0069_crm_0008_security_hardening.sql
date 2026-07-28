-- Utwardzanie bezpieczenstwa (audyt 09.07.2026, red team + DB audytor):

-- 1. newsletter_cleanup() bylo wywolywalne przez anon (SECURITY DEFINER bez
--    REVOKE) - PostgREST domyslnie eksponuje wszystkie funkcje jako /rpc/<nazwa>.
--    Miala byc wolana tylko z pg_cron (rola postgres), nie z przegladarki.
revoke execute on function newsletter_cleanup() from public, anon, authenticated;

-- 2. fixflow_can_update_report nie mial ustawionego search_path (w przeciwienstwie
--    do 29 innych funkcji SECURITY DEFINER w tym projekcie) - defense in depth,
--    kod juz w pelni kwalifikuje nazwy tabel, ale konsystencja z reszta bazy.
alter function fixflow_can_update_report(uuid) set search_path = '';

-- 3. Nadmiarowe granty: anon/authenticated mialy TRUNCATE/DELETE na crm_invoices
--    (dane finansowe) mimo ze RLS to blokuje - usuniecie tej warstwy defense in
--    depth ogranicza blast radius w razie bledu w politykach RLS w przyszlosci.
revoke truncate, delete on crm_invoices from anon;
revoke insert, update, delete, truncate on estates from anon, authenticated;

-- 4. FK dla crm_leads.estate_id - kolumna istniala bez odniesienia do estates(id),
--    mozna bylo zapisac nieistniejacy estate_id bez zadnego bledu integralnosci.
alter table crm_leads drop constraint if exists crm_leads_estate_id_fkey;
alter table crm_leads
  add constraint crm_leads_estate_id_fkey
  foreign key (estate_id) references estates(id) on delete set null;

-- 5. Aktualizacja przestarzalego komentarza kolumny stage (Faza 7 dodala etapy
--    'contract' i 'lost', ktorych stary komentarz z migracji 0001 nie wymienial).
comment on column crm_leads.stage is
  'lead, contact, demo, offer, contract, won, onboarding, active, risk, churned, lost';

-- 6. Naprawa dryfu: migracja 0001 deklarowala newsletter_insert_public jako
--    "with check (true)" (kazdy moze sie zapisac), ale live test pokazal 401 -
--    polityka najpewniej zostala recznie zmieniona w Dashboard bez aktualizacji
--    repo. Wymuszamy zgodnosc repo <-> produkcja (repo jest zrodlem prawdy).
drop policy if exists newsletter_insert_public on newsletter_subscribers;
create policy newsletter_insert_public on newsletter_subscribers for insert
  to anon, authenticated
  with check (true);

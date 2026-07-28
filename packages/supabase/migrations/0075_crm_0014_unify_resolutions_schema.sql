-- 0014: Unifikacja schematu uchwal (resolutions) w calym ekosystemie Mestio
--
-- PROBLEM (znaleziony w sesji 14.07.2026): dwa niezalezne repozytoria
-- (CRM Klienta migracja 0053/0056, App Mobile Flutter migracja 0055) probowaly
-- stworzyc TABELE O TEJ SAMEJ NAZWIE "fixflow_resolution_votes" z INNYMI
-- kluczami obcymi:
--   - CRM Klienta zakladalo: resolution_id -> public.resolutions(id)
--   - Flutter (i faktyczny stan produkcji): resolution_id -> public.fixflow_resolutions(id)
-- Poniewaz "CREATE TABLE IF NOT EXISTS" jest bezpieczne (no-op gdy tabela juz
-- istnieje), w produkcji wygrala wersja Fluttera. Skutek: KAZDE glosowanie
-- probowane przez panel CRM Klienta konczylo sie bledem 23503 (foreign key
-- violation) - zweryfikowane empirycznie przed ta migracja.
--
-- Dodatkowo czesc migracji CRM Klienta 0056 (ALTER TABLE fixflow_resolution_votes
-- ADD COLUMN share_units/estate_id) nigdy nie zostala wypchnieta na produkcje -
-- kolumny fizycznie nie istnialy w bazie (zweryfikowane empirycznie).
--
-- ROZWIAZANIE: fixflow_resolutions / fixflow_resolution_votes staja sie
-- KANONICZNA para tabel (uzywana i przez App Mobile, i po tej migracji przez
-- CRM Klienta). Stara "resolutions" jest archiwizowana (rename, NIE drop -
-- ostroznosciowo, mimo ze jest pusta w produkcji w chwili pisania tej migracji).

-- ============================================================
-- 1. fixflow_resolutions: dodaj numer uchwaly (potrzebne przez CRM Klienta)
-- ============================================================
alter table fixflow_resolutions
  add column if not exists number text;

comment on column fixflow_resolutions.number is
  'Numer uchwaly nadawany przez zarzad, np. "U-7/2026" (opcjonalny, wyswietlany w CRM Klienta)';

-- ============================================================
-- 2. fixflow_estates: waga udzialow do glosowania (CRM Klienta liczy % z tego)
-- ============================================================
alter table fixflow_estates
  add column if not exists total_shares integer not null default 1000;

comment on column fixflow_estates.total_shares is
  'Suma udzialow w nieruchomosci wspolnej (do glosowan wazonych udzialami). Domyslnie 1000 (promile).';

-- ============================================================
-- 3. fixflow_resolution_votes: udzialy glosujacego + denormalizowany estate_id
--    + dopuszczenie "abstain" (wstrzymanie sie) obok "for"/"against"
-- ============================================================
alter table fixflow_resolution_votes
  add column if not exists share_units integer not null default 0;

comment on column fixflow_resolution_votes.share_units is
  'Udzialy glosujacego w momencie oddania glosu (kopia z fixflow_resident_profiles, do wyliczania % wazonych)';

alter table fixflow_resolution_votes
  add column if not exists estate_id uuid references fixflow_estates(id) on delete cascade;

-- Relaksacja CHECK: poprzednio tylko ('for','against'), teraz + 'abstain'
alter table fixflow_resolution_votes
  drop constraint if exists fixflow_resolution_votes_choice_check;
alter table fixflow_resolution_votes
  add constraint fixflow_resolution_votes_choice_check
  check (choice in ('for', 'against', 'abstain'));

-- Auto-uzupelnienie estate_id z rodzica przy kazdym nowym glosie (klient nie
-- musi go znac/przekazywac - mniej miejsc na blad).
create or replace function fixflow_resolution_vote_fill_estate()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.estate_id is null then
    select estate_id into new.estate_id
    from public.fixflow_resolutions
    where id = new.resolution_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_fixflow_resolution_vote_fill_estate on fixflow_resolution_votes;
create trigger trg_fixflow_resolution_vote_fill_estate
  before insert on fixflow_resolution_votes
  for each row
  execute function fixflow_resolution_vote_fill_estate();

-- Backfill dla ewentualnych istniejacych wierszy (produkcyjnie 0 w chwili pisania)
update fixflow_resolution_votes v
set estate_id = r.estate_id
from fixflow_resolutions r
where v.resolution_id = r.id and v.estate_id is null;

-- ============================================================
-- 4. Archiwizacja starej, osieroconej tabeli "resolutions" (CRM Klienta)
--    Rename zamiast DROP - ostroznosciowo, latwo cofnac jesli cos przeoczono.
-- ============================================================
alter table if exists resolutions rename to resolutions_deprecated_20260714;

comment on table resolutions_deprecated_20260714 is
  'DEPRECATED 2026-07-14: zastapiona przez fixflow_resolutions (jedyna tabela z '
  'poprawnie dzialajacym kluczem obcym z fixflow_resolution_votes). Byla pusta '
  'w produkcji w momencie migracji. Bezpieczna do usuniecia po potwierdzeniu '
  'ze CRM Klienta w pelni przeszlo na nowa tabele.';

-- ============================================================
-- 5. Napraw ranking uchwal (CRM Owner /resolutions-ranking + publiczne API
--    dla WWW) - mial wskazywac na osierocona tabele "resolutions"
-- ============================================================
create or replace function mestio_ranking_uchwal()
returns table (
  estate_name text,
  resolved_count bigint,
  avg_hours numeric
)
language plpgsql
security definer
set search_path = ''
as $$
begin
  return query
  select
    fe.name as estate_name,
    count(r.id) as resolved_count,
    round(avg(extract(epoch from (r.closed_at - r.created_at)) / 3600)::numeric, 1) as avg_hours
  from fixflow_resolutions r
  join fixflow_estates fe on fe.id = r.estate_id
  where r.status in ('passed', 'rejected')
    and r.closed_at is not null
  group by fe.id, fe.name
  having count(r.id) >= 1
  order by avg(extract(epoch from (r.closed_at - r.created_at)) / 3600);
end $$;

comment on function mestio_ranking_uchwal is
  'Publiczny ranking osiedli wg sredniego czasu glosowania uchwal. Uzywane przez strone WWW mestio.pl. '
  'Zrodlo: fixflow_resolutions (naprawione 2026-07-14, wczesniej wskazywalo na osierocona tabele resolutions).';

-- Platform-owner select na fixflow_resolutions (parytet z usunieta polityka
-- na starej tabeli - RPC powyzej i tak dziala przez SECURITY DEFINER,
-- to jest dodatkowe dla ew. bezposrednich zapytan z dashboardu ownera).
drop policy if exists resolutions_platform_owner on fixflow_resolutions;
create policy resolutions_platform_owner on fixflow_resolutions for select
  using (auth.uid() = '8b0a178e-037c-49d7-bd4d-b7d0b0f8daf8');

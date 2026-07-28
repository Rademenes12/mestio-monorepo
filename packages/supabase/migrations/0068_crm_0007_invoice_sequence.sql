-- Naprawa race condition w numeracji faktur (audyt bezpieczenstwa 09.07.2026):
-- Poprzednio numer liczony przez SELECT COUNT(*)+1 w 3 niezaleznych miejscach kodu -
-- dwa rownoczesne zadania moglyby wygenerowac ten sam numer FV/RRRR/NNN.
-- Nowe podejscie: atomowa funkcja SQL z UPSERT (blokada wiersza), + UNIQUE jako
-- druga warstwa ochrony (defense in depth - jesli ktos i tak wstawi recznie).

create table if not exists crm_invoice_counters (
  year int primary key,
  last_number int not null default 0
);

alter table crm_invoice_counters enable row level security;
create policy crm_invoice_counters_owner on crm_invoice_counters for all
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  with check (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

-- UNIQUE na numerze faktury - jesli mimo wszystko dojdzie do kolizji (np. reczny
-- insert z pominieciem funkcji), baza odrzuci duplikat zamiast go cicho przyjac.
alter table crm_invoices drop constraint if exists crm_invoices_number_key;
alter table crm_invoices add constraint crm_invoices_number_key unique (number);

create or replace function crm_next_invoice_number()
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_year int := extract(year from now())::int;
  v_next int;
begin
  if auth.uid() is distinct from '48ffc236-5d63-4af2-94f6-d10d2470e9c7' then
    raise exception 'FORBIDDEN';
  end if;

  -- UPSERT z blokada wiersza: rownoczesne wywolania sa serializowane przez Postgres,
  -- co eliminuje race condition (w przeciwienstwie do SELECT COUNT + INSERT osobno).
  insert into crm_invoice_counters (year, last_number)
  values (v_year, 1)
  on conflict (year) do update set last_number = crm_invoice_counters.last_number + 1
  returning last_number into v_next;

  return 'FV/' || v_year || '/' || lpad(v_next::text, 3, '0');
end $$;

comment on function crm_next_invoice_number is
  'Atomowa numeracja faktur - zastepuje niebezpieczny wzorzec COUNT(*)+1. Wywolywac przez supabase.rpc().';

-- Inicjalizacja licznika na podstawie istniejacych faktur (zeby nie zaczac od 1
-- i nie zderzyc sie z juz wystawionymi numerami).
insert into crm_invoice_counters (year, last_number)
select
  extract(year from issued_at)::int as year,
  count(*) as last_number
from crm_invoices
group by extract(year from issued_at)::int
on conflict (year) do update set last_number = greatest(crm_invoice_counters.last_number, excluded.last_number);

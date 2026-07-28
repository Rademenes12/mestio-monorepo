-- Fix: Ranking uchwal - dostep dla platform_owner do tabeli resolutions
-- (audyt 10.07.2026)
-- 
-- Problem: resolutions ma RLS tylko dla czlonkow osiedla (fixflow_user_estates).
-- Platform owner (UUID 48ffc...) nie nalezy do zadnego osiedla, wiec ranking
-- zawsze zwracal pusty wynik. 
--
-- Rozwiazanie: polityka bypass dla platform_owner + funkcja SECURITY DEFINER
-- dla publicznego rankingu na stronie WWW.

-- 1. Polityka dla platform_owner - pelny odczyt wszystkich uchwal
drop policy if exists resolutions_platform_owner on resolutions;
create policy resolutions_platform_owner on resolutions for select
  using (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

-- 2. Funkcja zwracajaca ranking dla strony WWW (publiczny, bez RLS)
--    Zwraca: nazwa osiedla, liczba zamknietych uchwal, sredni czas w godzinach
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
  from resolutions r
  join fixflow_estates fe on fe.id = r.estate_id
  where r.status = 'closed'
    and r.closed_at is not null
  group by fe.id, fe.name
  having count(r.id) >= 1
  order by avg(extract(epoch from (r.closed_at - r.created_at)) / 3600);
end $$;

comment on function mestio_ranking_uchwal is
  'Publiczny ranking osiedli wg sredniego czasu glosowania uchwal. Uzywane przez strone WWW mestio.pl.';

# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Wykonać read-only audit współdzielonej warstwy Supabase przed dalszą konfiguracją aplikacji.

# Kontekst

Ten projekt Supabase jest współdzielony między wieloma aplikacjami. `auth.users`, konfiguracja Auth, `shared_users`, `shared_user_apps` oraz shared Edge Functions mają globalny blast radius. Błąd w tej warstwie może zepsuć logowanie albo usuwanie konta we wszystkich aplikacjach.

Na tym etapie nie znamy jeszcze prefixu nowej aplikacji. Prefix zostanie ustalony dopiero w etapie `01_start`. Ten krok sprawdza więc stan już istniejącej, współdzielonej warstwy Supabase i wykrywa zasoby, które mogą kolidować z przyszłą aplikacją.

# Task

1. Sprawdź, czy masz działające połączenie z `Supabase MCP`.
2. Nie wykonuj żadnych migracji ani zmian w bazie w tym kroku.
3. Wylistuj wszystkie triggery na `auth.users`:

```sql
select
  t.tgname as trigger_name,
  pg_get_triggerdef(t.oid) as trigger_def,
  n.nspname as function_schema,
  p.proname as function_name,
  pg_get_functiondef(p.oid) as function_def
from pg_trigger t
join pg_proc p on p.oid = t.tgfoid
join pg_namespace n on n.oid = p.pronamespace
where t.tgrelid = 'auth.users'::regclass
  and not t.tgisinternal
order by t.tgname;
```

4. Sprawdź FK do `auth.users` i ich `ON DELETE` behavior:

```sql
select
  conrelid::regclass::text as source_table,
  conname as constraint_name,
  pg_get_constraintdef(oid) as definition
from pg_constraint
where contype = 'f'
  and confrelid = 'auth.users'::regclass
order by source_table, constraint_name;
```

5. Sprawdź minimalną konfigurację shared tabel:

```sql
select
  c.relname as table_name,
  c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in ('shared_users', 'shared_user_apps')
order by c.relname;
```

```sql
select
  schemaname,
  tablename,
  policyname,
  cmd,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('shared_users', 'shared_user_apps')
order by tablename, policyname;
```

Sprawdź jawne granty wymagane przez Supabase Data API:

```sql
select
  table_name,
  grantee,
  privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name in ('shared_users', 'shared_user_apps')
  and grantee in ('anon', 'authenticated', 'service_role')
order by table_name, grantee, privilege_type;
```

6. Sprawdź Edge Functions w projekcie.
7. Jeżeli istnieje funkcja `delete-account`, sprawdź czy ma `verify_jwt=false`.
8. Sprawdź, czy `public.handle_new_user` ma defensywny `EXCEPTION WHEN OTHERS` i `RAISE WARNING`. Funkcja może tworzyć minimalny wiersz w `public.shared_users`, ale nie może zablokować tworzenia usera w `auth.users`, jeśli shared bootstrap zawiedzie.
9. Wylistuj funkcje w `public`, które wyglądają na app-specific i nie mają jednoznacznej przestrzeni nazw istniejącej aplikacji:

```sql
select
  n.nspname as schema_name,
  p.proname as function_name
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname not in ('handle_new_user')
  and (
    p.proname ilike '%user%'
    or p.proname ilike '%profile%'
    or p.proname ilike '%signup%'
    or p.proname ilike '%cleanup%'
  )
order by p.proname;
```

# Reguły STOP

Zatrzymaj setup i nie proponuj `next`, jeśli:

- na `auth.users` istnieje trigger inny niż `on_auth_user_created`,
- `on_auth_user_created` nie wywołuje `public.handle_new_user`,
- `public.handle_new_user` nie ma defensywnego `EXCEPTION WHEN OTHERS` z `RAISE WARNING`,
- `delete-account` istnieje i ma `verify_jwt=true`,
- istniejąca tabela aplikacji ma FK do `auth.users` bez `ON DELETE CASCADE`,
- `shared_users` albo `shared_user_apps` istnieją, ale mają wyłączone RLS,
- `shared_users` albo `shared_user_apps` mają policies pozwalające na dostęp do cudzych userów.
- `shared_users` albo `shared_user_apps` są używane przez aplikację przez Data API, ale rola `authenticated` nie ma wymaganych grantów `select`, `insert`, `update`.

# Reguły WARN

Ostrzeż mnie, ale możesz zaproponować `next`, jeśli:

- znajdziesz app-specific funkcję w `public` bez jednoznacznej przestrzeni nazw, ale nie jest podpięta do `auth.users`,
- znajdziesz app-specific Edge Function bez jednoznacznej przestrzeni nazw,
- `shared_user_apps` nie zawiera jeszcze żadnych rekordów.

# Oczekiwany stan

- Jedyny app-level trigger na `auth.users` to `on_auth_user_created`.
- Trigger `on_auth_user_created` wywołuje `public.handle_new_user`.
- `public.handle_new_user` tworzy wyłącznie minimalny wiersz w `public.shared_users`.
- `public.handle_new_user` ma defensywny `EXCEPTION WHEN OTHERS`, żeby problem z `shared_users` nie blokował tworzenia usera.
- `shared_users` i `shared_user_apps` mają jawne granty `select`, `insert`, `update` dla roli `authenticated`.
- `delete-account` jest shared Edge Function i ma `verify_jwt=false`.
- Istniejące app-specific zasoby są nazwane tak, żeby nie kolidowały z innymi aplikacjami. Konkretny prefix nowej aplikacji zostanie ustalony dopiero w etapie `01_start`.

## FINISH
Poinformuj mnie o wynikach audytu. Jeżeli są blokery, opisz konkretnie co trzeba naprawić i nie proponuj `next`.

Jeżeli nie ma blokerów, zasugeruj mi napisanie `next`. Kolejny krok: `06_init-supabase-dashboard.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/06_init-supabase-dashboard.md`.

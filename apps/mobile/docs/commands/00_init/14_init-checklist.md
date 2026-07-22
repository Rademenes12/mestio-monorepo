# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Sprawdzić poprawność wykonanych kroków z `docs/commands/00_init/`.

# Task

Sprawdź poprawność wszystkich kroków.

# Checklista

## Krok 1. Utworzenie nowego git repository

- Istnieje lokalne git repository

## Krok 2. Utworzenie pliku `.env`

- `.env` istnieje
- `.env` zawiera pole `SUPABASE_PROJECT_ID=`
- `.env` zawiera pole `SUPABASE_ACCOUNT_ACCESS_TOKEN=`
- `.env` zawiera pole `PLATFORM_API_KEY=`
- `.env` zawiera pole `APP_PLATFORM_ID=`

- `.env` zawiera uzupełnione pole `SUPABASE_PROJECT_ID=`
- `.env` zawiera uzupełnione pole `SUPABASE_ACCOUNT_ACCESS_TOKEN=`
- `.env` zawiera uzupełnione pole `PLATFORM_API_KEY=`

## Krok 3. Przygotowanie plików mcp dla zakresu tego projektu.

- istnieje plik `.mcp.json`
- istnieje plik `opencode.json`
- istnieje plik `.codex/config.toml`
- istnieje plik `.agents/mcp_config.json`
- plik `.mcp.json` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`
- plik `opencode.json` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`
- plik `.codex/config.toml` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`
- plik `.agents/mcp_config.json` posiada wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z `.env`

## Krok 4. Sprawdzenie połączenia z Supabase MCP.

- Jesteś w stanie połączyć się z bazą danych Supabase przez MCP

## Krok 5. Audit współdzielonej warstwy Supabase.

- wykonano `docs/commands/00_init/05_init-supabase-shared-state-check.md`
- jedyny dozwolony trigger na `auth.users` to `on_auth_user_created`
- `on_auth_user_created` wywołuje `public.handle_new_user`
- nie ma app-specific triggerów na `auth.users`
- `delete-account` ma `verify_jwt=false`
- istniejące tabele aplikacji z FK do `auth.users` mają `ON DELETE CASCADE`
- istniejące app-specific Edge Functions mają jednoznaczną przestrzeń nazw i nie udają shared functions

## Krok 6. Konfiguracja dashboardu autentykacji w Supabase.

- W dashboardzie Supabase (Authentication → Sign In / Providers) ustawiono:
  - Allow manual linking → ON
  - Allow anonymous sign-ins → ON
  - Confirm email → OFF
- W dashboardzie Supabase (Authentication → Email → Templates → Reset Password) ustawiono template resetu hasła jako kod:
  - `<h2>Reset Password</h2>`
  - `<p>Your password reset code:</p>`
  - `<h1>{{ .Token }}</h1>`
  - `<p>Enter this code in the app to reset your password.</p>`

## Krok 7. Przygotowanie pliku `config/api-keys.json`.

- plik `config/api-keys.json` istnieje

## Krok 8. Wypełnienie pliku `config/api-keys.json`.

- plik `config/api-keys.json` posiada uzupełnioną wartość `SUPABASE_URL`
- plik `config/api-keys.json` posiada uzupełnioną wartość `SUPABASE_ANON_KEY`

## Krok 9. Utworzenie pliku `android/key.properties`.

- plik `android/key.properties` istnieje

## Krok 10. Dać mi instrukcje jak mogę wygenerować nowy plik `upload-keystore.p12` dla tej aplikacji.

- User dostał instrukcje jak wygenerować plik `upload-keystore.p12`

## Krok 11. User musi przenieść wygenerowany plik do zalecanej ścieżki dla tej aplikacji i uzupełnić path do pliku w `storeFile` w `android/key.properties`.

- plik `android/key.properties` ma wypełnione wszystkie pola, w tym poprawną ścieżkę path `storeFile` dla pliku `upload-keystore.p12`

## Krok 12. Wykonanie konfiguracji tabel Supabase dla tego projektu.

- istnieje tabela `public.shared_users` i spełnia minimalne wymagania template
- istnieje tabela `public.shared_user_apps` z kolumnami `user_id`, `app_id`, `app_name`, `registered_at`, `last_seen_at`
- obie tabele mają włączony RLS z odpowiednimi policies
- obie tabele mają jawne `GRANT select, insert, update` dla roli `authenticated`

## Krok 13. Wykonanie konfiguracji `Supabase delete account` dla tego projektu.

- istnieje wdrożona Edge Function `delete-account`
- Edge Function `delete-account` ma `verify_jwt=false`
- `Delete account` ma podpięty prawdziwy flow w aplikacji

# Podsumowanie

Poinformuj mnie o stanie. Jeżeli czegoś brakuje, spróbuj razem ze mną naprawić to za pomocą poleceń dostępnych w `docs/commands/00_init/`.

Jeżeli w trakcie tego flow zostały zmienione pliki, upewnij się, że odpowiednie zmiany zostały zapisane w commicie. Pliki z sekretami i pliki objęte `.gitignore` nie powinny trafiać do commita.

Zaktualizuj `STATE.md`: ustaw etap `init` jako `✅ done`, ustaw `Ostatni zakończony etap` na `init`, ustaw `Aktualny etap` na `start` i zostaw status etapu `start` jako `⬜ not-started`.

Nie synchronizuj etapu `init` z platformą.

Jeżeli wszystko jest okej, poinformuj mnie, że etap `init` jest zakończony i przechodzimy do etapu `start`.

Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
`Wykonaj: docs/commands/01_start.md`

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Jeśli napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/01_start.md` — nie wcześniej!

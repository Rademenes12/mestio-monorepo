# Etap `00_init`

## Stan workflow

Gdy zaczynasz ten etap, przeczytaj `STATE.md` i zaktualizuj go tak, aby wskazywał:
- `Aktualny etap`: `init`
- status etapu `init`: `🟡 in-progress`

Etap `init` jest tylko lokalny, więc nie synchronizuj go z platformą.

Jesteśmy na samym początku pracy z projektem. To jest pusty Flutter template, w którym nie ma jeszcze konkretnej aplikacji, pomysłu ani nazwy.

W tym etapie skonfigurujemy projekt, żeby był gotowy do dalszego budowania aplikacji.

Będziesz zaraz przechodził przez kolejne kroki po kolei.

# Kroki tego etapu

1. `01_init-git.md` - Przygotujemy repozytorium Git i podstawowe zależności Fluttera.
2. `02_init-env-file.md` - Przygotujemy plik `.env`.
3. `03_init-supabase-mcp-setup.md` - Przygotujemy konfigurację MCP dla Supabase.
4. `04_init-supabase-mcp-check.md` - Sprawdzimy, czy Supabase MCP działa poprawnie.
5. `05_init-supabase-shared-state-check.md` - Sprawdzimy stan współdzielonej warstwy Supabase.
6. `06_init-supabase-dashboard.md` - Ustawimy wymagane opcje w dashboardzie Supabase.
7. `07_init-api-keys-create.md` - Przygotujemy plik na klucze API aplikacji.
8. `08_init-api-keys-fill.md` - Uzupełnimy klucze Supabase dla aplikacji.
9. `09_init-android-key-properties.md` - Przygotujemy konfigurację podpisywania Androida.
10. `10_init-upload-keystore-create.md` - Przygotujemy instrukcję utworzenia keystore.
11. `11_init-upload-keystore-path.md` - Ustawimy ścieżkę do keystore w projekcie.
12. `12_init-supabase-shared-users-setup.md` - Przygotujemy współdzielone tabele użytkowników.
13. `13_init-supabase-delete-account-setup.md` - Przygotujemy obsługę usuwania konta.
14. `14_init-checklist.md` - Sprawdzimy, czy cały etap `init` jest gotowy.

# Start

Wykonaj polecenie z pliku `docs/commands/00_init/01_init-git.md`.

Nie przechodź sam do kolejnych kroków bez mojego polecenia.

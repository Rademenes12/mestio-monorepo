# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Wykonanie konfiguracji `Supabase delete account` dla tego projektu.

# Task

1. Sprawdź, czy masz działające połączenie z `Supabase MCP`.
2. Sprawdź, czy w projekcie `Supabase` istnieje wdrożona Edge Function `delete-account`.
3. Jeżeli jej nie ma albo jest nieaktualna, wdroż funkcję z pliku:
- `supabase/functions/delete-account/index.ts`
4. Przy wdrożeniu ustaw `verify_jwt=false`.
   - Funkcja sama wymaga `Authorization: Bearer <access_token>`.
   - Funkcja sama waliduje token przez `auth.getUser(token)`.
   - Nie używaj built-in `verify_jwt=true`, bo legacy verifier Supabase Edge Functions może odrzucać ES256/asymmetric JWT zanim kod funkcji się uruchomi.
   - Referencja Supabase: https://supabase.com/docs/guides/troubleshooting/edge-function-401-error-response
5. Sprawdź w `lib/features/profiles/presentation/ui/profile_screen.dart`, czy kod Fluttera ma już podpięty prawdziwy flow `Delete account` w profilu.
    - Jeżeli nie, podepnij istniejące elementy template tak, aby przycisk `Usuń konto` wykonywał realne usuwanie konta, a nie otwierał placeholder lub ekran setupu.
6. Wykorzystaj istniejące elementy, jeśli już są dostępne:
- `lib/app/profile/presentation/cubit/account_actions_cubit.dart`
- `lib/features/auth/data/repositories/auth_repository.dart`
- `lib/features/auth/data/datasources/auth_data_source.dart`
7. Nie dodawaj app-specific cleanupu do shared funkcji `delete-account`.
   - Na etapie `00_init` funkcja ma być minimalna i usuwać tylko globalne konto Supabase Auth.
   - Dane powiązane przez FK `ON DELETE CASCADE` usuną się automatycznie.
8. Jeżeli wprowadziłeś zmiany w plikach, wykonaj teraz commit.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `14_init-checklist.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/14_init-checklist.md`.

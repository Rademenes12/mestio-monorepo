# Task

Dodaj dark mode jako funkcję Pro-only.

## Zakres

- Dark theme w `MaterialApp` (`darkTheme: ThemeData...`) zgodny z `docs/DESIGN.md`. Jeżeli `DESIGN.md` nie opisuje wariantu dark — wyprowadź go z jasnego, zachowując branding.
- Preferencja `ThemeMode` per-user: w `SharedPreferences` (kluczowany po `userId`) chyba że `docs/LIMITS.md` ustala inaczej. Nie twórz nowej tabeli w Supabase bez ustalenia.
- `ThemeCubit` (globalny `@lazySingleton`) emituje aktualny `ThemeMode` dla `MaterialApp`.
- Toggle dark mode w Profile (albo w miejscu ustalonym w `docs/LIMITS.md`):
  - `session.isProUser == true` → toggle zmienia `ThemeMode`.
  - `session.isProUser == false` → toggle **nie** zmienia motywu. Tap → `showDialog` z copy z `docs/PAYWALL.md` ("Dark mode locked"). CTA emituje `openPaywall`.
- Gdy user traci Pro → `ThemeMode` wraca do `light`. Zaimplementuj to jako reakcję w `ThemeCubit` na stream z sesji (subskrypcja w konstruktorze, anulowanie w `close()`).

## Wymagania

- Stringi przez `context.l10n`.
- Testy `ThemeCubit` (`bloc_test` + `mocktail`):
  - Pro user ustawia dark → emit `ThemeMode.dark`.
  - user traci Pro → emit `ThemeMode.light`.
  - non-Pro próbuje ustawić dark → state bez zmiany, efekt `proFeatureBlocked` (albo równoważny).

## Koniec

1. `flutter analyze` — czysto.
2. Testy na zielono.
3. Commit.
4. Powiedz mi, że kolejny krok to `10_limits-integration-tests.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/10_limits-integration-tests.md` — nie podgląduj wcześniej!

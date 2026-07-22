# Task

Zaimplementuj gate na tworzenie głównej encji — **`__MAIN_ENTITY__`** — zgodnie z `docs/LIMITS.md`.

## Zakres

- `LimitPolicy` (domain, pure dart). Metoda `check({required LimitAccessState access, required int currentCount})` zwraca `LimitCheckResult.allowed` albo `LimitCheckResult.blocked(reason)`. `reason` to enum z wariantami `guestLimit`, `registeredLimit`.
- Cubit głównej encji (ten, który tworzy nowy element) przed zapisem woła `LimitPolicy.check`. Gdy `blocked` → emituje state efekt `limitHit(reason)` (wzorzec efektu jak `AccountActionsCubit.effect`) i **nie** wykonuje zapisu.
- `BlocListener` na ekranie tworzącym element obsługuje efekt:
  - `guestLimit` → `showDialog` z copy z `docs/PAYWALL.md` ("limit hit dla guest"). CTA prowadzi na rejestrację.
  - `registeredLimit` → `showDialog` z copy z `docs/PAYWALL.md` ("limit hit dla registered"). CTA zostaw jako TODO — obsługę paywalla doda krok 06.

## Wymagania

- Stringi wyłącznie przez `context.l10n` (PL/EN w ARB). Po zmianach w ARB: `flutter gen-l10n`.
- Cubit emituje tylko efekt/`errorKey`. UI mapuje na tekst.
- Testy jednostkowe `LimitPolicy`: granice 0, limit-1, limit, limit+1 dla guest/registered/Pro.
- Testy cubita (`bloc_test` + `mocktail`): happy path + 3 ścieżki (guest limit hit, registered limit hit, Pro przechodzi).

## Poza zakresem

Paywall placeholder, Pro-only feature, Pro-only screen, dark mode.

## Koniec

1. `flutter analyze` — 0 błędów/warningów/info.
2. Testy na zielono.
3. Commit.
4. Powiedz mi, że kolejny krok to `06_limits-build-paywall.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/06_limits-build-paywall.md` — nie podgląduj wcześniej!

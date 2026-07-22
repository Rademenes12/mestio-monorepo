# Task

Zaimplementuj gate na Pro-only funkcję **`__PRO_FEATURE__`** (sekcja "Funkcja Pro-only" w `docs/LIMITS.md`).

## Zakres

- Znajdź ekran i funkcję z `docs/LIMITS.md`. Jeżeli funkcja jeszcze nie istnieje — dobuduj ją z prawdziwą zawartością (nie placeholder).
- W Cubicie tego ekranu: przed wykonaniem akcji sprawdź `session.isProUser`. Gdy `false` → emituj efekt `proFeatureBlocked` (z identyfikatorem funkcji, jeśli będzie ich więcej w przyszłości).
- `BlocListener` obsługuje efekt: `showDialog` z copy z `docs/PAYWALL.md` ("Pro feature locked") spersonalizowanym dla tej funkcji. CTA dialogu emituje efekt `openPaywall` (obsługa gotowa z kroku 06).
- Gdy `session.isProUser == true` → funkcja wykonuje się normalnie, bez dialogu.

## Wymagania UX

- **Nie** otwieraj paywalla bezpośrednio po kliknięciu zablokowanej funkcji. Najpierw dialog wyjaśniający wartość tej konkretnej funkcji, dopiero jego CTA prowadzi do paywalla (zasada z `docs/LIMITS.md`).

## Wymagania

- Stringi przez `context.l10n`.
- Test cubita: "non-Pro user → `proFeatureBlocked` emitowany" + "Pro user → funkcja wykonuje się".

## Poza zakresem

Pro-only screen, dark mode.

## Koniec

1. `flutter analyze` — czysto.
2. Testy na zielono.
3. Commit.
4. Powiedz mi, że kolejny krok to `08_limits-build-pro-screen.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/08_limits-build-pro-screen.md` — nie podgląduj wcześniej!

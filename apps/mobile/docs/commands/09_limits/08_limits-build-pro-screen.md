# Task

Zaimplementuj Pro-only ekran **`__PRO_SCREEN__`** (sekcja "Ekran Pro-only" w `docs/LIMITS.md`).

## Zakres

- Znajdź ekran z `docs/LIMITS.md`. Jeżeli jeszcze nie istnieje — dobuduj go z prawdziwą zawartością opisaną w `LIMITS.md`, nie pusty placeholder.
- Wejście do ekranu (np. z nawigacji w Home/Profile) sprawdza `session.isProUser`:
  - `true` → normalna nawigacja do Pro-only ekranu.
  - `false` → nawigacja do **dedykowanego ekranu przejściowego** (osobny widget/route, **nie** dialog) z copy z `docs/PAYWALL.md` ("Pro screen locked"). CTA ekranu przejściowego emituje efekt `openPaywall` (obsługa z kroku 06).

## Wymagania UX

- Ekran przejściowy to pełny ekran, nie dialog — bo to dedykowane miejsce w nawigacji, a nie blokada inline (zasada z `docs/LIMITS.md`).

## Wymagania

- Stringi przez `context.l10n`.
- Jeżeli Pro-only ekran ma własny Cubit — dopisz dla niego testy (`bloc_test` + `mocktail`).

## Poza zakresem

Dark mode.

## Koniec

1. `flutter analyze` — czysto.
2. Testy na zielono.
3. Commit.
4. Powiedz mi, że kolejny krok to `09_limits-build-dark-mode.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/09_limits-build-dark-mode.md` — nie podgląduj wcześniej!

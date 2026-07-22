# Task

Tymczasowo obniż limity, poproś o manualny test, popraw wszystko co user zgłosi.

## Krok 1 — obniż limity

Znajdź stałe z progami (najpewniej w `LimitPolicy` albo obok).

1. **Zapamiętaj oryginalne wartości** `guestLimit` i `registeredLimit` — zaraz zapiszesz je do kroku 13.
2. Ustaw minimalne w kodzie:

```
static const int guestLimit = 1;
static const int registeredLimit = 2;
```

3. Otwórz `docs/commands/09_limits/13_limits-cleanup.md` i podmień placeholdery (Edit z `replace_all: true`):
   - `__ORIGINAL_GUEST_LIMIT__` → oryginalna wartość `guestLimit` (jako liczba).
   - `__ORIGINAL_REGISTERED_LIMIT__` → oryginalna wartość `registeredLimit` (jako liczba).

4. `flutter analyze` czysto.
5. Commit: `chore(limits): lower limits for manual verify`.

## Krok 2 — poproś mnie o test

Powiedz mi (możesz sparafrazować):

> Odpal apkę. Sprawdź:
> 1. Guest: 1. element → ok; próba 2. → dialog z CTA do rejestracji.
> 2. Profile jako guest: `Register` jest głównym CTA, `Log in` secondary, a `Buy Pro` pojawia się tylko gdy RevenueCat jest aktywny.
> 3. Zarejestruj się: możesz dodać jeszcze 1 element; próba 3. → dialog z CTA do paywalla → tap → prawdziwy RevenueCat paywall, jeśli RevenueCat jest aktywny; inaczej placeholder.
> 4. Gdy RevenueCat nie jest aktywny: Profile → Developer → "Fake Pro" ON → dodaj powyżej limitu (ok), Pro-only feature działa, Pro-only ekran otwiera się, dark mode toggle zmienia motyw.
> 5. Gdy RevenueCat jest aktywny: mock purchase przez paywall daje Pro i znosi limit.
> 6. "Fake Pro" OFF albo nowy non-Pro user → limit wraca, Pro-only blocked, dark mode toggle pokazuje dialog.
> 7. Włącz "Fake Pro", otwórz Pro-only ekran i sprawdź wzrokowo, czy layout wygląda poprawnie, nie ma pustego stanu ani brakujących stringów PL/EN.
>
> Daj znać, co działa, a co nie.

Czekaj na mój feedback.

## Krok 3 — fix loop

Gdy coś nie działa:
1. Napraw.
2. `flutter analyze` czysto.
3. Testy (jeżeli były modyfikowane cubity).
4. Commit.
5. Poproś mnie o ponowny test.

Powtarzaj aż powiem, że wszystko działa.

## Krok 4 — przejście dalej

Gdy potwierdzę, że wszystko ok:
- **Nie** przywracaj jeszcze limitów — robi to następny krok.
- Powiedz mi, że kolejny krok to `13_limits-cleanup.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/13_limits-cleanup.md` — nie podgląduj wcześniej!

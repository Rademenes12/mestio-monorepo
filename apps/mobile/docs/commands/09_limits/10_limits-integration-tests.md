# Task

Podejmuję decyzję, czy chcę tworzyć testy integracyjne dla limitów i Pro.

## Decyzja

1. Wyjaśnij mi krótko, że testy integracyjne:
   - uruchamiają aplikację na emulatorze/symulatorze albo urządzeniu,
   - klikają po UI podobnie jak użytkownik,
   - sprawdzają flow limitów i Pro end-to-end,
   - mogą wymagać mocków dla backendu, RevenueCat i zakupów.

2. Powiedz mi jasno, że testy integracyjne są opcjonalne. Mogę je pominąć i przejść do manualnej weryfikacji.

3. Uprzedź mnie o koszcie:
   - stworzenie ich może zużyć dużo tokenów,
   - uruchamianie może długo trwać,
   - emulator/symulator lub urządzenie może mocno obciążyć komputer,
   - debugowanie flaky testów bywa czasochłonne,
   - najlepiej robić to mocnym modelem AI.

4. Zapytaj mnie czy chcę teraz stworzyć testy integracyjne dla limitów i Pro?

Nie przechodź dalej, dopóki nie odpowiem `tak` albo `nie`.

## Jeśli odpowiem `nie`

Powiedz mi, że pomijamy testy integracyjne i kolejny krok to `11_limits-verify-prep.md`.

Zasugeruj mi napisanie `next`.

Gdy napiszę `next`, przejdź do `docs/commands/09_limits/11_limits-verify-prep.md` — nie podgląduj wcześniej!

## Jeśli odpowiem `tak`

Napisz testy integracyjne (`integration_test/`) dla flow limitów i Pro.

## Scenariusze

Każdy scenariusz ma być osobnym testem:

1. **Guest osiąga limit `__MAIN_ENTITY__`** — nowe konto guest → dodaj `guestLimit` elementów → próba kolejnego → dialog "limit hit dla guest" widoczny, CTA prowadzi do rejestracji.
2. **Registered osiąga limit `__MAIN_ENTITY__`** — zarejestruj konto → dodaj `registeredLimit` elementów → próba kolejnego → dialog "limit hit dla registered" widoczny, CTA otwiera paywall: przy `RevenueCatConfig.isEnabled == true` prawdziwy RevenueCat paywall, inaczej placeholder.
3. **Guest może kupić Pro z profilu przy aktywnym RevenueCat** — guest bez Pro widzi `Register` jako główne CTA, `Log in` jako secondary i `Buy Pro` jako tertiary tylko gdy `RevenueCatConfig.isEnabled == true`; tap w `Buy Pro` otwiera prawdziwy paywall.
4. **Pro znosi limit `__MAIN_ENTITY__`** — gdy RevenueCat nie jest aktywny, włącz override przez `AccountActionsCubit.setDeveloperProOverride(isPro: true)`; gdy RevenueCat jest aktywny, wykonaj mock purchase przez paywall. Następnie dodaj element powyżej limitu → zapis przechodzi bez dialogu.
5. **Pro-only feature `__PRO_FEATURE__`** — bez Pro tap → dialog Pro feature. Z Pro tap → funkcja wykonuje się.
6. **Pro-only screen `__PRO_SCREEN__`** — bez Pro wejście → ekran przejściowy. Z Pro wejście → prawdziwy ekran.
7. **Dark mode Pro-gate** — bez Pro tap w toggle → dialog (motyw bez zmiany). Z Pro tap → motyw się zmienia.

## Przygotowanie urządzenia

Przed uruchomieniem poproś mnie o:
- podłączenie urządzenia albo odpalenie emulatora/symulatora,
- potwierdzenie platformy (iOS / Android).

Potem uruchom testy: `flutter test integration_test/...` na wybranym urządzeniu.

## Fix loop

Gdy test fail'uje:
1. Napraw.
2. Uruchom `flutter analyze`.
3. Uruchom test ponownie.
4. Powtarzaj aż wszystko będzie zielone.
5. Po każdym fixie zrób commit.

## Koniec po testach

1. Wszystkie testy integracyjne na zielono.
2. `flutter analyze` czysto.
3. Commit.
4. Powiedz mi, że kolejny krok to `11_limits-verify-prep.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/11_limits-verify-prep.md` — nie podgląduj wcześniej!

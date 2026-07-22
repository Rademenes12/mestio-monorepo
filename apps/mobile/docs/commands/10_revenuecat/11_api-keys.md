# Intro

Twoim zadaniem jako agenta AI jest sprawdzić lokalne klucze RevenueCat.

CEL: `config/api-keys.json` ma uzupełnione klucze `appl_`, `goog_`, `test_`.

# Task

1. Nie proś mnie o wklejanie kluczy RevenueCat do rozmowy.

2. Przypomnij mi, że klucze mam wkleić samodzielnie w lokalnym pliku `config/api-keys.json`. To są sekrety i nie powinny trafiać do czatu.

3. Powiedz mi, gdzie znaleźć klucze w RevenueCat:
   - **RevenueCat → Apps & providers → API keys → SDK API keys**
   - iOS: klucz zaczyna się od `appl_`
   - Android: klucz zaczyna się od `goog_`
   - Test Store: klucz zaczyna się od `test_`

4. Powiedz mi, żebym uzupełnił w `config/api-keys.json`:
   - `REVENUECAT_APPLE_API_KEY`
   - `REVENUECAT_GOOGLE_API_KEY`
   - `REVENUECAT_TEST_STORE_API_KEY`

5. Gdy potwierdzę, że wartości są wpisane w pliku, przeczytaj `config/api-keys.json`.

6. Sprawdź pola:
   - `REVENUECAT_APPLE_API_KEY` zaczyna się od `appl_`
   - `REVENUECAT_GOOGLE_API_KEY` zaczyna się od `goog_`
   - `REVENUECAT_TEST_STORE_API_KEY` zaczyna się od `test_`

7. Jeżeli którejś wartości brakuje albo ma zły prefix, nie proś mnie o jej podanie w rozmowie. Powiedz mi dokładnie, które pole mam poprawić lokalnie w `config/api-keys.json`, i poczekaj na moje potwierdzenie.

8. Gdy wszystkie trzy klucze mają poprawne prefixy, powiedz mi, że kolejny krok to `12_debug-verify.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/12_debug-verify.md`.

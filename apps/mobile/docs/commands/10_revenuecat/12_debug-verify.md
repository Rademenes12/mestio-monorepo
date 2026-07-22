# Intro

Twoim zadaniem jako agenta AI jest zweryfikować RevenueCat lokalnie w debug.

CEL: `flutter analyze` jest czysty, SDK działa z Test Store, mock purchase daje Pro.

# Task

1. Uruchom `flutter analyze`. Napraw błędy, warningi i info, jeśli wystąpią.

2. Poproś mnie o całkowite zamknięcie i ponowne uruchomienie apki w debug. Klucze z `config/api-keys.json` są czytane przez `--dart-define-from-file` przy starcie/buildzie, więc po zmianie pliku potrzebny jest restart. W debug klucz `test_` ma pierwszeństwo.

3. Poproś mnie, żebym wszedł w **Profile → Dev Tools → RevenueCat** i sprawdził:
   - SDK active: Yes
   - Active key type: Test Store
   - Active SDK key: `test_...`
   - Platform key configured: Yes
   - Test Store key configured: Yes
   - Pro source: RevenueCat

4. Jeśli SDK active = No, poproś mnie, żebym sprawdził w Dev Tools:
   - czy **Platform key configured** = Yes,
   - czy **Test Store key configured** = Yes,
   - czy nie ma ostrzeżenia o brakującym Test Store key.

5. Jeśli Active key type nie jest Test Store albo Active SDK key nie zaczyna się od `test_`, popraw `REVENUECAT_TEST_STORE_API_KEY` w `config/api-keys.json`, zamknij apkę i uruchom ją ponownie.

6. Poproś mnie, żebym wykonał mock purchase przez paywall Test Store i sprawdził:
   - Profile pokazuje `Buy Pro` automatycznie, gdy RevenueCat jest aktywny i user nie ma Pro
   - dla guest `Register` pozostaje głównym CTA, a `Buy Pro` nie jest głównym CTA
   - paywall nie jest placeholderem
   - paywall zamyka się po zakupie
   - Dev Tools: Pro = Yes
   - Pro działa bez restartu apki

7. Jeśli paywall dalej pokazuje placeholder, nie poprawiaj paywalla w ciemno. Najpierw wróć do Dev Tools i sprawdź `SDK active`, `Active key type`, `Active SDK key`, `Platform key configured` i `Test Store key configured`.

8. Poproś mnie o potwierdzenie: analyze clean, SDK active, Active key type = Test Store, Active SDK key = `test_...`, mock purchase daje Pro.
9. Po potwierdzeniu powiedz mi, że kolejny krok to `13_test-scenarios.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/13_test-scenarios.md`.

# ZADANIE: 14_publish_codemagic_app_store_connect

## CEL
Włączenie **App Store Connect publishing** w Codemagic (upload buildu na TestFlight) oraz włączenie powiadomień email.

Używamy tego samego klucza **App Store Connect API Key**, który został dodany w fazie A kroku `13_publish-codemagic-ios-signing.md`.

## KROKI DO WYKONANIA:

1. Powiedz mi, żebym w Codemagic:
   - Otworzył aplikację utworzoną w kroku `08_publish-codemagic.md`.
   - Przeszedł do **Distribution** → **App Store Connect** → zaznaczył **Enable App Store Connect publishing**.
   - **App Store Connect API key (using keys from user settings)**: z dropdowna wybierz ten sam klucz, co w kroku 13 (np. `Code Magic + App Manager (Key: ...)` / `Codemagic Production Key`).
   - Zaznacz checkbox **Publish even if tests fail**.
   - Upewnij się, że **pozostałe trzy checkboxy są ODZNACZONE** (domyślnie są, więc po prostu ich nie dotykaj):
     - **Submit to TestFlight beta review**,
     - **Distribute to beta groups**,
     - **Submit to App Store review**.
   - Finalne Submit for Review zrobimy ręcznie w kroku 21, gdy już będą uzupełnione pola sklepowe.
   - Kliknij **Save changes**.

2. Powiedz mi, że gdy skończę konfigurację App Store Connect publishing, mam napisać `next`, bo będziemy przechodzić do `15_publish-first-build.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/15_publish-first-build.md`.

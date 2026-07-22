# ZADANIE: 09_publish_appstoreconnect_create_app

## CEL
Utworzenie aplikacji w **App Store Connect** (bez wypełniania pól sklepowych — te zostawiamy na krok 21).

## KROKI DO WYKONANIA:

1. Przygotuj dane, które będą potrzebne userowi:
   - Otwórz `docs/IDEA.md` i znajdź **app bundle ID** (format `com.imienazwisko.nazwaapki`).
   - Otwórz `docs/PUBLISH.md` i znajdź iOS **Name** z sekcji `### Teksty iOS (App Store)`.
   - To iOS **Name** z `docs/PUBLISH.md` będzie wartością pola **Name** w App Store Connect.

2. Ustal **SKU**: fragment po **ostatniej kropce** z bundle ID (np. dla `com.imienazwisko.nazwaapki` → `nazwaapki`).

3. Powiedz mi, żebym najpierw zarejestrował Bundle ID w Apple Developer:
   - Wejdź na [https://developer.apple.com/account/resources/identifiers/bundleId/add/bundle](https://developer.apple.com/account/resources/identifiers/bundleId/add/bundle).
   - Wypełnij tylko dwa pola:
     - **Description**: *(fragment SKU z kroku 2, np. `reasonswhy`)*
     - **Bundle ID**: upewnij się, że radio button jest ustawiony na **Explicit**, a następnie wpisz bundle ID z `docs/IDEA.md`.
   - Zakładek **Capabilities**, **App Services** oraz **Capability Requests** nie ruszaj — zostaw je tak jak są.
   - Kliknij **Continue**, a następnie **Register**.

4. Powiedz mi, żebym utworzył aplikację w App Store Connect:
   - Zaloguj się na [App Store Connect](https://appstoreconnect.apple.com/).
   - Wejdź w zakładkę **Apps**.
   - Kliknij **+** (plus) → **New App**.
   - Wypełnij pola:
     - **Platforms**: iOS
     - **Name**: *(wartość iOS **Name** z `docs/PUBLISH.md`)*
     - **Primary Language**: **English (U.S.)**
     - **Bundle ID**: wybierz z listy bundle ID zarejestrowany w kroku 3.
     - **SKU**: *(wartość SKU ustalona w kroku 2)*
     - **User Access**: Full Access
   - Kliknij **Create**.

5. Powiedz mi, że gdy skończę tworzenie aplikacji w App Store Connect, mam napisać `next`, bo będziemy przechodzić do `10_publish-googleplay-create-app.md`.

**Nic nie commituj w tym kroku** — to czysta instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/10_publish-googleplay-create-app.md`.

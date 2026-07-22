# Intro

Twoim zadaniem jako agenta AI jest utworzyć projekt RevenueCat.

CEL: Projekt RC ma entitlement `pro`, Test Store key i poprawną transfer policy.

# Task

1. Odczytaj `APP_DISPLAY_NAME` z `docs/IDEA.md` i zaproponuj jako **Project name**.

2. Odczytaj opis z `docs/IDEA.md`, wybierz jedną kategorię RC i krótko uzasadnij:
   `Books, Business, Developer Tools, Education, Entertainment, Finance, Food and Drink, Games, Graphics and Design, Health, Lifestyle, Magazines and Newspapers, Medical, Music, Navigation, News, Photo and Video, Productivity, Reference, Shopping, Social Networking, Sports, Travel, Utilities, Weather`.

3. Poinformuj mnie, że mam utworzyć projekt: **RC dropdown → + Create new project**, platforma **Flutter**.

4. Poinformuj mnie, że na ekranie **Let's get <AppName> ready!** mam:
   - kliknąć **Edit** przy **Entitlement name**
   - ustawić identifier dokładnie `pro`
   - zostawić offering/packages domyślne
   - kliknąć **Continue**

5. Poinformuj mnie, że na ekranie **Install the SDK** mam:
   - nie kopiować kodu
   - skopiować API key `test_...`
   - wpisać go do `config/api-keys.json` jako `REVENUECAT_TEST_STORE_API_KEY`
   - kliknąć **I'm ready!**

   Jeśli nie widzę klucza `test_`, poproś mnie, żebym wszedł w **Apps & providers → Configurations** albo **Project settings → Test Store** i włączył Test Store.

6. Poproś mnie, żebym ustawił transfer policy: **Project settings → Handling multiple app user IDs → Keep with original App User ID**.

7. Poproś mnie o potwierdzenie: projekt utworzony, `pro`, `test_` key zapisany, transfer policy ustawiona.
8. Po potwierdzeniu powiedz mi, że kolejny krok to `04_revenuecat-ios-config.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/04_revenuecat-ios-config.md`.

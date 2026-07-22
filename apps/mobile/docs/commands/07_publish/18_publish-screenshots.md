# ZADANIE: 18_publish_screenshots

## CEL
Zdobyć 5 surowych screenshotów aplikacji do późniejszej obróbki marketingowej.

To **nie są finalne grafiki do App Store / Google Play**. Bez marketingowych nagłówków, mockupów telefonu, ramek, gradientowych plansz i tekstów reklamowych. Finalne prompty AI powstaną w kroku 19, a techniczne przycięcie i resize w kroku 20.

## KROKI DO WYKONANIA

1. Przeczytaj `docs/PUBLISH.md`, sekcję `### Zrzuty ekranu (Screenshots)`.

2. Wypisz mi listę 5 ekranów, które trzeba uchwycić. Użyj opisów UI z `PUBLISH.md`, bez marketingowych tytułów.

3. Zapytaj mnie:
   `Czy chcesz, żebym przygotował te gotowe ekrany do screenshotowania w Developer Tools, czy chcesz oszczędzić tokeny i zrobić screenshoty ręcznie? Napisz: automatycznie albo ręcznie.`

4. Wybierz jedną ścieżkę:

   **Ścieżka A — ręcznie**
   - Powiedz mi, żebym sam uruchomił aplikację, przygotował dane i zrobił 5 surowych screenshotów zgodnie z listą z punktu 2.
   - Przypomnij, że mają to być czyste ekrany aplikacji, bez marketingowych nagłówków i bez mockupów telefonu.
   - Gdy potwierdzę, że mam 5 surowych screenshotów, zasugeruj `next`.
   - Nie modyfikuj kodu.

   **Ścieżka B — automatycznie**
   - Przygotuj dokładnie 5 ekranów źródłowych odpowiadających 5 screenshotom z `PUBLISH.md`.
   - Dla każdego opisu z `PUBLISH.md` najpierw znajdź lub zrozum odpowiadający mu prawdziwy ekran/flow w kodzie aplikacji. Dopiero potem przygotuj uproszczoną wersję tego samego typu ekranu.
   - Podmień placeholdery w gotowych plikach:
     - `lib/app/developer/ui/screenshots/screenshot_1_screen.dart`
     - `lib/app/developer/ui/screenshots/screenshot_2_screen.dart`
     - `lib/app/developer/ui/screenshots/screenshot_3_screen.dart`
     - `lib/app/developer/ui/screenshots/screenshot_4_screen.dart`
     - `lib/app/developer/ui/screenshots/screenshot_5_screen.dart`
   - Tylko UI i hardcoded przykładowe dane po angielsku.
   - Bez Cubitów, repozytoriów, data sources, streamów, `GetIt` i l10n.
   - Bez `AppBar`, przycisku back, tytułu technicznego i elementów Developer Tools.
   - To mają być **prawdziwe ekrany aplikacji w uproszczonej wersji screenshotowej**, nie plansze marketingowe.
   - Zachowaj typ ekranu, strukturę i sens interakcji. Jeśli opis mówi `formularz`, zrób uproszczony formularz. Jeśli opis mówi `Home`, zrób uproszczony Home. Jeśli opis mówi `podsumowanie`, zrób uproszczone podsumowanie.
   - **Nie twórz** posterów, hero sekcji, landing page'y, abstrakcyjnych wizualizacji, ozdobnych ilustracji, orbit, scen ani dashboardów oderwanych od prawdziwego UI.
   - **Uproszczenie** oznacza: mniej pól/list/metryk niż w realnym ekranie, większe fonty, większe odstępy, mniej tekstu i kilka dobrze dobranych przykładowych danych.
   - Unikaj drobnych etykiet, długich list, tabel, gęstych metryk i małych kontrolek. To ma dobrze wyglądać w mockupie telefonu po dodaniu marketingowego nagłówka w kroku 19.
   - Jeden ekran powinien mieć jedną główną sekcję i najwyżej 2-3 wspierające elementy.
   - Użyj `MediaQuery` albo `LayoutBuilder`, żeby responsywnie wypełnić całą wysokość i szerokość telefonu. Nie zostawiaj pustej dolnej połowy.
   - Dane mają być realistyczne i spójne między ekranami.
   - Nie ruszaj nawigacji w `developer_screen.dart`, chyba że zmieniłeś nazwy klas. Sekcja **Store screenshots** i 5 przycisków są już przygotowane. Route screenshotów ukrywa systemowy status bar / navigation bar.
   - Uruchom `flutter analyze` i napraw problemy.
   - Zacommituj zmiany z wiadomością: `feat: add store screenshot source screens`.
   - Poproś mnie, żebym uruchomił aplikację i obejrzał: **Profil → Developer Tools → Store screenshots**.
   - Jeśli coś wygląda źle, mam wskazać ekran i problem. Popraw to, uruchom `flutter analyze`, zrób kolejny commit i poproś o ponowną weryfikację.
   - Gdy potwierdzę, że 5 ekranów wygląda dobrze, powiedz mi, żebym zrobił z nich 5 surowych screenshotów i zapisał je lokalnie w kolejności `Screen 1` → `Screen 5`.
   - Zatrzymaj się, dopóki nie potwierdzę, że mam zapisane 5 surowych screenshotów. Krok 19 wymaga realnych plików screenshotów, nie tylko gotowych ekranów w Developer Tools.

## FINISH
Gdy mam 5 surowych screenshotów zapisanych lokalnie w kolejności Screen 1-5, zasugeruj mi napisanie `next`, żeby przejść do `19_publish-screenshots-ai-prompts.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/19_publish-screenshots-ai-prompts.md`.

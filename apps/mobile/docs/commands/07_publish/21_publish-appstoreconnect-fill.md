# ZADANIE: 21_publish_appstoreconnect_fill

## CEL
Wypełnienie pól sklepowych w **App Store Connect** dla tej aplikacji. Nie każ mi samodzielnie otwierać `docs/PUBLISH.md` — to Ty prowadzisz mnie pole po polu, dyktując wartości z pliku.

## ŹRÓDŁO DANYCH
- `docs/PUBLISH.md` — sekcje dotyczące iOS (App Information, Pricing, App Privacy, Age Rating, Version Information, Screenshots).
- `docs/IDEA.md` — dodatkowy kontekst, gdyby czegoś brakowało.

## KROKI DO WYKONANIA:

Otwórz `docs/PUBLISH.md` i zapoznaj się z sekcją dotyczącą iOS. 

Powiedz mi, żebym zalogował się na [App Store Connect](https://appstoreconnect.apple.com/).

1. **App Information** (menu boczne → **General** → **App Information**):
   Dyktuj po kolei z `docs/PUBLISH.md`:
   - **Name** (max 30 znaków) — sklepowa nazwa apki z PUBLISH.md.
   - **Subtitle** (max 30 znaków).
   - **Category**: Primary Category (i Secondary, jeśli PUBLISH.md podaje).
   - **Content Rights**: **No** — zaznacz "Does Not Use Third-Party Content".

2. **Pricing and Availability** (menu boczne → **Pricing and Availability**):
   - **Price**: **Free** (0).
   - **Availability**: **All Countries or Regions**.
   - Zapisz.

3. **App Privacy** (menu boczne → **App Store** → sekcja **Trust & Safety** → **App Privacy**):

   **Privacy Policy URL** (u góry strony, **nie** w App Information): wklej z PUBLISH.md.

   **Data Collection** — kliknij **Get Started** (pierwszy raz) lub **Edit**. Na pytanie "Do you or your third-party partners collect data from this app?" → **Yes, we collect data from this app**.

   **Baseline dla tego template (Supabase anonymous + `shared_users` + user-generated content w tabelach `<prefix>_*`)** — dodaj dokładnie **te 4 typy danych**, niezależnie od tego co mówi PUBLISH.md (chyba że PUBLISH.md wyraźnie wymienia inne typy — wtedy zapytaj mnie):

   | # | Data Type | Purposes | Linked to identity | Used for tracking |
   |---|---|---|---|---|
   | 1 | **Contact Info → Name** | App Functionality | Yes | No |
   | 2 | **Contact Info → Email Address** | App Functionality | Yes | No |
   | 3 | **Identifiers → User ID** | App Functionality | Yes | No |
   | 4 | **User Content → Other User Content** | App Functionality | Yes | No |

   Punkt 4 (User Content) to user-generated content lecący do Supabase (np. tasks, reasons, notes — cokolwiek user tworzy w apce, co zapisuje się w tabelach `<prefix>_*`). Pomiń **tylko** wtedy, gdy apka jest czysto read-only i user nie tworzy żadnych własnych treści zapisywanych na serwerze — zapytaj mnie.

   **⚠️ Uwaga o procesie**: dla każdego typu danych Apple prowadzi przez **5-ekranowy wizard**. Dwa środkowe ekrany to tylko definicje ("Tracking — Definitions", "Tracking — Examples") — klikasz **Next** bez wypełniania. Razem ~20 kliknięć na wszystkie 4 typy. To normalne, nie pomyłka.

   **Kolejność wizarda (per typ, zgodnie z UI Apple)**:
   1. **Purposes** — zaznacz tylko **App Functionality**. Klik **Next**.
   2. **Linked to user's identity** — po ekranie z definicjami, odpowiedź: **Yes, [data type] collected from this app are linked to the user's identity**. Klik **Next**.
   3. **Tracking — Definitions** — ekran informacyjny (definicja Tracking i Third-Party Data). Klik **Next**.
   4. **Tracking — Examples** — ekran informacyjny (przykłady trackingu). Klik **Next**.
   5. **Used for tracking** — odpowiedź: **No, we do not use [data type] for tracking purposes**. Klik **Save**.

   Powtórz wizard dla każdego z 4 typów z tabeli powyżej. Odpowiedzi dla baseline są identyczne dla wszystkich 4 typów (App Functionality / Yes / No).

   **Sanity check po dodaniu typów**: u góry sekcji Data Types powinien być napis typu `4 data types collected from this app: Name, Email Address, User ID, Other User Content`. Jeśli na liście jest dodatkowy typ spoza tabeli powyżej (np. zostawiony z poprzedniej edycji) — kliknij **Edit** obok "Data Types", odznacz nadmiarowy typ, zapisz.

   **Publish App Privacy**: po zakończeniu wszystkich 4 typów na głównej stronie App Privacy kliknij **Publish** (lub **Save** → potwierdź). Bez tego zmiany siedzą w draft i nie przejdą review.

4. **Age Rating** (menu boczne → **General** → **App Information** → sekcja **Age Rating**, w tym samym widoku co Name/Subtitle/Category/Content Rights):
   - Kliknij **Set Age Rating** / **Edit**.
   - 7-krokowy kwestionariusz:
     - Domyślnie wszystkie odpowiedzi to **No** / **None**.
     - W `docs/PUBLISH.md` sekcja **iOS Age Ratings** wymienia tylko te pozycje, gdzie trzeba odpowiedzieć inaczej niż No/None. Zmień **wyłącznie** te pozycje.
     - Jeśli PUBLISH.md mówi "Wszystkie odpowiedzi: No / None" — zostaw domyślne.

5. **Screenshots** (lewe menu → **App Store** → aktualna wersja, np. `1.0 Prepare for Submission` — sekcja Screenshots u góry strony wersji):
   - Wgraj **zestaw iOS** (iPhone 6.5") przygotowany w kroku `20_publish-screenshots-resize.md` — 5 finalnych JPG z tytułami marketingowymi. Mam je lokalnie na dysku w `assets/images/store/screenshots/ios/`.

6. **Version Information** (ta sama strona wersji, poniżej screenshotów):
   - **Promotional Text** (opcjonalne) — z PUBLISH.md, jeśli jest.
   - **Description** — wklej z PUBLISH.md.
     - **Uwaga**: Apple potrafi odrzucić description za zbyt dużą ilość znaków specjalnych (kropki ozdobne, długie myślniki, emoji w opisie). Jeśli wklejany tekst zawiera takie znaki, skonsultuj ze mną czy je zostawić.
   - **Keywords** — wklej z PUBLISH.md (oddzielone TYLKO przecinkami, bez spacji, max 100 znaków).
   - **Support URL** — z PUBLISH.md.
   - **Marketing URL** (opcjonalne w UI, ale często de facto wymagane) — z PUBLISH.md.
   - **Copyright** — z PUBLISH.md w formacie `© <rok> <Imię Nazwisko>` (np. `© 2026 Adam Smaka`). Znaczek `©` (U+00A9) jest **obowiązkowy** — sam `2026 Adam Smaka` bez `©` Apple potrafi odrzucić.

7. **App Review Information** (ta sama strona wersji, sekcja niżej):
   - **Sign-in required**: **Yes** — zaznacz tak mimo tego, że aplikacja ma **Continue as guest**. To zwiększa szansę, że review przejdzie bez odrzucenia za brak konta testowego.
   - Poproś mnie o utworzenie konta testowego w aplikacji i podanie danych do review. Mogą to być na przykład:
     - **Username, email address, or phone number**: `review@example.com`
     - **Password**: `Review123!`
   - Nie wpisuj tych przykładowych danych na ślepo. W App Store Connect muszą trafić dane realnego konta testowego, które działa w tej konkretnej aplikacji.
   - **Contact information**: wpisz swoje dane (imię, nazwisko, telefon, email).
   - **Notes**: **obowiązkowo** wklej cały blok z sekcji **App Review Information (iOS)** z `docs/PUBLISH.md` (tekst między \`\`\` a \`\`\`). Powód: Apple ma automatyczny skaner, który widzi przycisk "Log in to existing account" na Welcome i flaguje apkę jako account-based. `Sign-in required = Yes` + działające konto testowe + jasny opis guest flow zmniejszają ryzyko rejection Guideline 2.1 ("demo account required").
     - Przed wklejeniem sprawdź, że w bloku nie ma już placeholderów `{{APP_PURPOSE}}`, `{{CORE_FLOW}}`, `{{SUPPORT_EMAIL...}}`. Jeśli są — zatrzymaj się i uzupełnij.

8. **Version Release** → zostaw domyślne (Automatically release after approval) — chyba że chcę inaczej.

9. **Build** (sekcja **Build** w Version Information):
   - Kliknij **+** / **Select Build**.
   - Wybierz build z TestFlight — powinien być tam build, który wypchnął się w kroku `17_publish-second-build.md` (po ~20–30 minutach od uruchomienia).
   - Po wybraniu buildu App Store Connect często wymaga ręcznego potwierdzenia **wersji** — ustaw taki sam numer, jaki wyświetla się przy wybranym buildzie (np. `0.0.1` albo `1.0.0`, zgodnie z `pubspec.yaml` / tym, co przyszło z Codemagic). Jeśli pole pozostanie puste, Submit for Review zwróci błąd.
   - Jeśli buildu jeszcze nie ma, powiedz mi, że muszę poczekać i wrócić do tego kroku za chwilę.

10. **Export Compliance / Encryption** (zwykle pokazuje się jako "Missing Compliance" przy buildzie):
    - W kolumnie Build, przy wybranym buildzie, kliknij **Manage** przy "Missing Compliance".
    - **Does your app use encryption?** → wybierz **None** (apka korzysta tylko ze standardowego szyfrowania systemowego — HTTPS/TLS — a nie implementuje niestandardowego szyfrowania).
    - Zapisz.

11. **Gotchas do zasygnalizowania mi**:
    - Jeśli **Name** z PUBLISH.md jest już zajęty w App Store (komunikat przy tworzeniu wersji) — zaproponuj wariant z subtitle z PUBLISH.md (np. `Chess Openings: Learn and Train`), zapytaj mnie o akceptację.
    - Jeśli pojawi się pole, którego nie ma w `docs/PUBLISH.md` — zapytaj mnie, zamiast zgadywać.

12. Powiedz mi, że:
    - **Submit for Review** to jedno kliknięcie: **Add for Review** → **Submit for Review**. Zajmuje to ~48h czekania na decyzję Apple.
    - Nie klikaj Submit automatycznie. Jeśli chcę zrobić to teraz, zrobię ręcznie. Jeśli wolę poczekać (np. chcę jeszcze coś poprawić), też OK.

13. Powiedz mi, że gdy skończę wypełnianie App Store Connect, mam napisać `next`, bo będziemy przechodzić do `22_publish-googleplay-fill.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/22_publish-googleplay-fill.md`.

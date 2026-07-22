Wciel się w rolę Senior ASO Eksperta. Masz już pełen kontekst o aplikacji. 
Twoim zadaniem jest nadpisanie pliku `docs/PUBLISH.md` gotowymi tekstami marketingowymi oraz usunięcie zbędnych elementów.
Piszesz dla niezależnego programisty (indie developera). Unikaj agresywnego, korporacyjnego slangu marketingowego. Język ma być szczery, skupiony na korzyściach i w 100% zgodny z faktycznymi funkcjami aplikacji — nie wymyślaj ficzerów, których nie ma w kodzie.

### 📝 ZASADY EDYCJI I FORMATOWANIA (Rygorystyczne):

**1. Języki**
- Formularze (IARC, Data Safety, kategorie Google Play) mają zostać PO POLSKU.
- **Google Play Tagi — format `Polski (English)`**, dobrane DOKŁADNIE z listy zapisanej w `docs/PUBLISH.md` (Console wyświetla listę tagów w UI locale użytkownika — zależnie od konta może być polska lub angielska, dlatego PUBLISH.md podaje obie wersje jednocześnie, żeby user mógł wybrać właściwą). W wyjściowym PUBLISH.md każdy wybrany tag zachowaj w tym samym formacie `Polski (English)`.
- **Nie wybieraj kategorii ani tagów zdrowotnych**, chyba że aplikacja jednoznacznie i bezpośrednio dotyczy zdrowia lub medycyny. Google Play może utrudnić review aplikacjom oznaczonym jako zdrowotne.
- Teksty ASO (Title, Subtitle, Description, teksty na screeny) PO ANGIELSKU.

**2. Czystość i Formatowanie (BARDZO WAŻNE)**
- **Wyraźne oddzielenie długich tekstów:** Długie bloki tekstu (Description dla iOS i Pełny opis dla Androida) muszą być oddzielone od reszty dokumentu poziomymi liniami. Użyj `---` nad i pod opisem, oraz pustych linii, by tekst oddychał i nie zlewał się z checklistą.
- **Usuń nieużywane opcje:** Usuń z dokumentu CAŁKOWICIE wszystkie niezaznaczone tagi, kategorie i typy danych. Zostaw tylko to, co wybrałeś.
- **Placeholdery:** Wszędzie tam, gdzie brakuje maila lub adresu URL, wpisz dokładnie: `🛑 [TODO: UZUPEŁNIJ]`.

**WAŻNE: wykorzystanie danych z etapu start**
- Traktuj `APP_DISPLAY_NAME` i sekcję `Search Intents` z `docs/IDEA.md` jako materiał wejściowy do ASO.
- To Ty masz zdecydować, jak najlepiej rozłożyć frazy osobno dla:
  - iOS `Name`, `Subtitle`, `Keywords`
  - Android `Nazwa aplikacji`, `Krótki opis`, `Pełny opis`
- Nie zakładaj, że iOS i Android muszą mieć identyczny tytuł lub identyczny układ słów kluczowych.
- Nie zakładaj, że pełna główna fraza ma w całości zmieścić się w jednym polu (jest limit max 30 znaków)
- `APP_DISPLAY_NAME` z etapu start jest punktem wyjścia, ale możesz zaproponować lepsze sklepowe ułożenie słów dla każdej platformy osobno, jeśli poprawi to ASO i mieści się w limitach.

**3. Optymalizacja ASO**
- **App Name / Tytuł (iOS & Android):** Max 30 znaków. "Brand: ASO Keywords".
- **iOS Subtitle:** Max 30 znaków.
- **iOS Keywords:** Max 100 znaków. Słowa oddzielone TYLKO PRZECINKAMI (zero spacji).
- **Description (iOS/Android):** Max 4000 znaków. Naturalne słowa kluczowe. Używaj punktowania. iOS - bez znaków specjalnych. 
- **iOS Description — na samym końcu** dodaj linijkę: `Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
- **Screenshots:** Koncepcja 5 zrzutów. Format: [Opis UI] | Tytuł marketingowy na grafice. Zasugeruj się propozychami z `docs/IDEA.md` - możesz tamte propozycje tutaj przedstawić zmodyfikowane. Upenwij się tylko, aby te ekrany do screenshotów faktycznie byly zaimplementowane aktualnie w aplikacji.

**4. Formularze**

**iOS App Privacy (Data Collection):**
- Zaznacz "Yes, we collect data".
- Poniższe typy danych ZAWSZE występują w aplikacjach na tym szablonie (baseline):
  • Contact Info → Name (App Functionality + Product Personalization, Linked: Yes, Tracking: No)
  • Contact Info → Email Address (App Functionality, Linked: Yes, Tracking: No)
  • Identifiers → User ID (App Functionality, Linked: Yes, Tracking: No)
- Dodatkowo sprawdź kod i SDK — jeśli apka zbiera inne dane (np. User Content, Photos, Location), dopisz je.
- **NIE dodawaj Purchases / Purchase History** ani innych danych związanych z RevenueCat / In-App Purchases. Szablon ma kod pod RevenueCat przygotowany, ale na tym etapie apka jest **darmowa** i nic się nie kupuje — monetyzację dodamy w przyszłości i wtedy zaktualizujemy App Privacy.

**Android Data Safety (Bezpieczeństwo danych):**
- Czy aplikacja zbiera lub udostępnia typy danych? Tak.
- Zaszyfrowane podczas przesyłania? Tak.
- Metoda tworzenia konta: Nazwa użytkownika i hasło.
- Umożliwiasz prośby o usunięcie konta (w aplikacji i poza nią)? Tak. URL: `🛑 [TODO: UZUPEŁNIJ]`.
- Umożliwiasz prośby o usunięcie części danych? Tak. URL: ten sam co wyżej.
- Poniższe typy danych ZAWSZE występują (baseline). Dla każdego: Zbierane, Nie udostępniane, Nie tymczasowe. Pole Required/Optional zgodnie z poniższym (Google rozumie to jako "czy user ma wybór czy daną podać"):
  • **Dane osobowe → Nazwa** — Purposes: Zarządzanie kontem, Personalizacja — **Users can choose** (guest nie musi podawać imienia)
  • **Dane osobowe → Adres e-mail** — Purposes: Zarządzanie kontem, Funkcje aplikacji — **Users can choose** (tylko przy upgrade z gościa)
  • **Dane osobowe → Identyfikatory użytkowników** — Purposes: Zarządzanie kontem, Funkcje aplikacji — **Required** (Supabase tworzy user.id od pierwszego wejścia, user nie ma wyjścia)
  • **Aktywność w aplikacji → Inne treści wygenerowane przez użytkownika** — Purposes: Funkcje aplikacji — **Users can choose** (user decyduje czy coś tworzy)
- Dodatkowo sprawdź kod — jeśli apka zbiera inne dane (np. Photos/Videos, Files/Docs, Audio), dopisz je z odpowiednimi celami i Required/Optional w tej samej logice ("Required" tylko gdy zbiera zawsze bez wyboru usera).
- **NIE dodawaj Historii zakupów / Purchases** ani innych danych związanych z RevenueCat / In-App Purchases. Szablon ma kod pod RevenueCat przygotowany, ale na tym etapie apka jest **darmowa** — monetyzację dodamy w przyszłości i wtedy zaktualizujemy Data Safety.
- Zaznacz odpowiednie opcje w Prawach autorskich itp., na podstawie SDK znalezionych w kodzie.

**iOS Age Ratings:**
- Domyślnie wszystkie odpowiedzi to No / None. W pliku wypisz TYLKO te pozycje, w których na podstawie kodu wybrałeś coś innego niż No / None. Jeśli wszystko jest No / None, napisz jedną linijkę: "Wszystkie odpowiedzi: No / None".

### ⚙️ AKCJA KOŃCOWA:
1. Nadpisz plik `docs/PUBLISH.md`.
2. **ZACOMMITUJ ten plik do repozytorium** z wiadomością: "chore: generate initial ASO metadata and PUBLISH.md template".
3. Daj mi znać, że zacommitowałeś wstępny plik PUBLISH.md.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `03_publish-questions.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/03_publish-questions.md`.

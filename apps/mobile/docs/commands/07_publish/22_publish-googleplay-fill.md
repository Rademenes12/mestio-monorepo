# ZADANIE: 22_publish_googleplay_fill

## CEL
Wypełnienie pól sklepowych w **Google Play Console** dla tej aplikacji. Nie każ mi samodzielnie otwierać `docs/PUBLISH.md` — to Ty prowadzisz mnie pole po polu, dyktując wartości z pliku.

## ŹRÓDŁO DANYCH
- `docs/PUBLISH.md` — sekcje dotyczące Android (teksty sklepowe, kategorie, tagi, data safety) oraz sekcja 6 **App Review Information (Android)**.
- `docs/IDEA.md` — dodatkowy kontekst.

## KONTEKST
- Wypełniamy release na ścieżce **Test zamknięty - Alpha** (**Closed testing - Alpha**), nie na produkcji.
- Google Play wymaga **12 testerów przez 14 dni** w teście zamkniętym (**closed testing**), zanim dopuści release do produkcji (**production**).
- Build do releasu pochodzi z Codemagic (track `alpha`; Android mógł przejść automatem już w kroku 15/16 albo dopiero po fallbacku w kroku 17).

## KROKI DO WYKONANIA:

Otwórz `docs/PUBLISH.md` i zapoznaj się z sekcją dotyczącą Android oraz sekcją 6 (App Review Information - Android).

Powiedz mi, żebym zalogował się na [Google Play Console](https://play.google.com/console/) i wszedł w apkę utworzoną w kroku 10.

**Kolejność jest celowa** — prowadzi przez Google Play Console w tej samej sekwencji, w jakiej Console sam prowadzi: najpierw **Panel** / **Przegląd publikowanych zmian** (**Publishing overview**) i konfiguracja ścieżki, dopiero potem reszta panelu. Nie zaczynamy od strony aplikacji w sklepie.

---

### 🚀 1. TEST ZAMKNIĘTY ALPHA — KONFIGURACJA ŚCIEŻKI

Lewe menu → **Testuj i publikuj** (**Test and release**) → **Testowanie** (**Testing**) → **Test zamknięty** (**Closed testing**) → przy ścieżce **Test zamknięty - Alpha** (**Closed testing - Alpha**) kliknij **Zarządzaj ścieżką** (**Manage track**).

Przy pierwszym wejściu Console pokazuje sekcję **Skonfiguruj ścieżkę testu zamkniętego** (**Set up your track**) z zadaniami: **Wybierz kraje** (**Select countries**) i **Wybierz testerów** (**Select testers**). Zaczynamy od nich.

**Kraje/regiony (Countries/regions):**
- W sekcji **Skonfiguruj swoją ścieżkę** (**Set up your track**) kliknij **Wybierz kraje** (**Select countries**) — to przeniesie Cię na dół strony do zakładki **Kraje/regiony** (**Countries/regions**). Zakładki ścieżki to: **Wersje** (**Releases**), **Kraje/regiony** (**Countries/regions**), **Testerzy** (**Testers**).
- Tam mogą pojawić się **dwa przyciski**: **Dodaj kraje/regiony** (**Add countries/regions**) i **Dodaj i synchronizuj kraje/regiony** (**Add and sync countries/regions**).
  - Wybierz **Dodaj kraje/regiony** (**Add countries/regions**), bez synchronizacji. Opcja z synchronizacją potrafi przerzucić widok na ścieżkę **Produkcyjna** (**Production**) — wtedy trzeba wrócić do Alpha. Jeśli konto jest zweryfikowane/odblokowane, różnica praktycznie nie istnieje, ale opcja bez synchronizacji jest bezpieczniejsza.
- Jeśli widzisz pusty stan **Dodaj kraje, w których chcesz udostępniać wersje do testów zamkniętych na tej ścieżce**, kliknij **Dodaj kraje/regiony** (**Add countries/regions**).
- Po otwarciu listy możesz zobaczyć filtr **Wszystkie kraje/regiony (0)** i pole **Szukaj** (**Search**). Zaznacz wszystkie kraje → **Dodaj kraje/regiony** (**Add countries/regions**) w prawym dolnym rogu → **Zapisz** (**Save**).

**Testerzy (Testers):**
- W sekcji **Skonfiguruj swoją ścieżkę** (**Set up your track**) kliknij **Wybierz testerów** (**Select testers**), potem **Utwórz listę adresów e-mail** (**Create email list**).
- **Nazwa listy** (**List name**): np. `Alpha testers`.
- **Dodaj adresy e-mail** (**Add email addresses**): wklej emaile rozdzielone przecinkami → naciśnij **Enter** (bez tego lista nie załapie adresów).
- Prawy dolny róg → **Zapisz zmiany** (**Save changes**) → potwierdź **Utwórz** (**Create**) → **Zapisz** (**Save**).
- W zakładce **Testerzy** (**Testers**) wybierz **Listy adresów e-mail** (**Email lists**) i zaznacz listę testerów. W tabeli zobaczysz kolumny **Nazwa listy** (**List name**) i **Użytkownicy** (**Users**).
- Nie wybieraj **Grupy dyskusyjne Google** (**Google Groups**), chyba że świadomie używasz grup Google.
- Pole **URL lub adres e-mail do przesyłania opinii** służy do feedbacku od testerów. Jeśli nie mamy dedykowanego URL, wpisz email kontaktowy z PUBLISH.md.
- Sekcja **Jak testerzy mogą dołączyć do testu?** pokazuje link dopiero po opublikowaniu aplikacji. Po akceptacji release'u pojawi się tam **Dołączanie w internecie** i przycisk **Kopiuj link** (**Copy link**).
- Minimum **12 testerów** (wymóg 14-dniowego testu zamkniętego przed promocją do produkcji). Emaile dostarczysz sam — zapytaj mnie, jeśli chcesz użyć tej samej listy co w poprzedniej apce.

**Wersje (Releases):**
- Zakładka **Wersje** (**Releases**) — tam powinien być draft wypchnięty przez Codemagic po kroku 17. Jeśli nie ma draftu, kliknij **Utwórz nową wersję** (**Create new release**).
- **Pakiety aplikacji** (**App bundles**) — Console pokazuje wersję z buildu Codemagic (np. `0.0.1 (1)`).
- **Nazwa wersji** (**Release name**) — wpisz tę samą wartość, którą widzisz przy pakiecie aplikacji (np. `0.0.1`). Domyślna czasem bywa nieaktualna.
- **Informacje o wersji** (**Release notes**, per locale, między tagami `<en-US>...</en-US>` — Console sam wstawia tagi dla każdego obsługiwanego locale):
  - Wklej z PUBLISH.md sekcja Release notes (albo krótkie "Initial release" jeśli PUBLISH.md nie podaje).
  - **Limit: 500 znaków Unicode per locale.** Jeśli tekst z PUBLISH.md jest dłuższy, skróć go i zapytaj mnie o akcept.
- **Dalej** (**Next**, prawy dolny róg). Ekran recenzji pokaże listę błędów (typowo **~4 błędy** — brakujące **Treści aplikacji** (**App content**), **Informacje o aplikacji w sklepie** (**Store listing**), **Bezpieczeństwo danych** (**Data safety**) itd.). To **normalne** — te sekcje uzupełnimy w kolejnych krokach. **Zapisz** (**Save**) i wychodzimy z release'u.

---

### 📝 2. INFORMACJE O APLIKACJI

Lewe menu → **Zwiększaj liczbę użytkowników** (**Grow users**) → **Obecność w sklepie** (**Store presence**) → **Informacje o aplikacji** (**Store listings**).

**Przy pierwszym wejściu** Console pokazuje duży niebieski CTA **Utwórz domyślne informacje o aplikacji** (**Create default store listing**). Kliknij go — dopiero wtedy otworzy się formularz **Domyślne informacje o aplikacji** (**Default store listing**).

Dyktuj po kolei z PUBLISH.md:
- **Nazwa aplikacji** (**App name**, max 30 znaków).
- **Krótki opis** (**Short description**, max 80 znaków).
- **Pełny opis** (**Full description**, max 4000 znaków).

**Grafika (Graphics) — wspólny flow dla ikony, grafiki i screenshotów:**

Dla wszystkich trzech pól Console używa tego samego panelu po prawej stronie. Kroki są zawsze:
1. **Dodaj zasoby** (**Add assets**) → **Prześlij** (**Upload**) → wybierz plik(i).
2. Jeśli plik ma inny rozmiar niż wymagany, obok miniaturki pojawi się przycisk **Przytnij** (**Crop**) → otworzy się widok pełnoekranowy → **Zapisz jako kopię** (**Save as copy**), nie **Zapisz** (**Save**).
3. W panelu po prawej stronie pojawi się przycięta wersja.
4. **Dodaj** (**Add**) w prawym dolnym rogu panelu — **to** dodaje asset do pola. Łatwo pomylić to z przyciskiem **Zapisz** (**Save**), który zapisuje całą stronę.
5. Zamknij panel.

⚠️ **Nie klikaj Zapisz (Save) w prawym dolnym rogu panelu po kadrowaniu.** Zapisz zapisuje **całą stronę** informacji o aplikacji i bywa szary/nieaktywny dopóki nie ma obowiązkowych pól. Asset dodaje się przez **Dodaj** (**Add**), nie przez **Zapisz** (**Save**). **Zapisz** klikamy dopiero na końcu, kiedy wszystkie pola są gotowe.

**Konkretnie per pole:**
- **Ikona aplikacji** (**App icon**): 512×512 PNG/JPEG, do 1 MB. Źródło: `assets/images/store/icon.png`. Ikonka template'u zazwyczaj ma inny rozmiar → kadrowanie będzie potrzebne.
- **Grafika** (**Feature graphic**): 1024×500 PNG/JPEG, do 15 MB. Źródło: `assets/images/store/feature.png` zapisany w kroku 05. Jeśli pliku nie ma, powiedz mi, żebym wrócił do promptu **Google Play Feature Graphic** z `docs/PUBLISH.md`, wygenerował grafikę i zapisał ją w tej ścieżce.
- **Wideo** (**Video**, opcjonalnie) — pomiń, chyba że PUBLISH.md podaje URL YouTube.
- **Zrzuty ekranu z telefonu** (**Phone screenshots**): wgraj **zestaw Android** przygotowany w kroku `20_publish-screenshots-resize.md` — 5 JPG z tytułami marketingowymi. Pliki lokalnie w `assets/images/store/screenshots/android/`. Multi-select przy upload (wgrywa wszystkie naraz). Jeśli screenshoty już mają poprawny rozmiar (powinny mieć 1080×1920), kadrowanie pomijasz — idziesz od razu do **Dodaj** (**Add**). Kolejność możesz zmienić drag & drop po dodaniu.
- **Zrzuty ekranu z 7-calowego tabletu**, **Zrzuty ekranu z 10-calowego tabletu**, **Zrzuty ekranu Chromebooka**, **Zrzuty ekranu z Androida XR**, **Przestrzenne wideo XR**, **Nieprzestrzenny film XR** — pomiń, chyba że PUBLISH.md albo projekt zawiera dedykowane assety dla tych formatów.

Po wszystkich polach kliknij **Zapisz** (**Save**) w prawym dolnym rogu strony — teraz dopiero zapisuje całe informacje o aplikacji.

**Tłumaczenia (Manage translations)**: jeśli PUBLISH.md zawiera drugi locale (np. `pl` obok `en`):
- Kliknij **Zarządzaj tłumaczeniami** (**Manage translations**) → dodaj drugi język.
- Dla drugiego locale wypełnij analogiczne pola: **Nazwa aplikacji**, **Krótki opis**, **Pełny opis**, screenshoty.

---

### 🏷 3. USTAWIENIA SKLEPU

Lewe menu → **Zwiększaj liczbę użytkowników** (**Grow users**) → **Obecność w sklepie** (**Store presence**) → **Ustawienia sklepu** (**Store settings**).

- **Kategoria aplikacji** (**App category**) — kliknij **Edytuj** (**Edit**) przy **Kategoria aplikacji**:
  - **Aplikacja czy gra** (**App or game**): **Aplikacja** (**App**).
  - **Kategoria** (**Category**): wybierz kategorię z PUBLISH.md. W polskim UI Console pokazuje kategorie po polsku, np. `Styl życia`.
  - **Zapisz** (**Save**) / zamknij.

- **Tagi** (**Tags**) — kliknij **Zarządzaj tagami** (**Manage tags**):
  - Wybierz **do 5** tagów z listy PUBLISH.md. Console pokazuje listę tagów w UI locale użytkownika — **po polsku** albo **po angielsku**, zależnie od konta (ok. 171 pozycji).
  - PUBLISH.md zapisuje tagi w formacie `Polski (English)` — dla każdego tagu masz obie wersje w nawiasie, więc wyszukasz w Console dokładnie tę, która się wyświetla (po polsku albo po angielsku).
  - **Jeśli** w PUBLISH.md widzisz tag tylko w jednej wersji (starsze PUBLISH.md), zmapuj ręcznie z listy w PUBLISH.md i zapytaj mnie o akcept przed kliknięciem.
  - Po wybraniu → **Zastosuj** (**Apply**).

- **Dane kontaktowe w informacjach o aplikacji** (**Store listing contact details**) — kliknij **Edytuj** (**Edit**):
  - **Adres e-mail** (**Email**): email z PUBLISH.md / IDEA.md (jedyne wymagane pole).
  - **Numer telefonu** (**Phone number**) i **Strona internetowa** (**Website**) są opcjonalne — pomiń, chyba że PUBLISH.md wyraźnie je podaje.
  - **Zapisz** (**Save**).

- **Marketing zewnętrzny** (**External marketing**): zostaw włączone, czyli **Chcę reklamować moją aplikację poza Google Play**.

---

### 📜 4. ZAWARTOŚĆ APLIKACJI

**Jak wejść**:
- Lewe menu → **Monitoruj i ulepszaj** (**Monitor and improve**) → **Zasady i programy** (**Policy and programs**) → **Zawartość aplikacji** (**App content**).
- Na ekranie zobaczysz nagłówek **Zawartość aplikacji** (**App content**) i listę deklaracji wymagających uwagi.

**⚠️ Wzorzec klikania** — dla **każdej** z 10 deklaracji:
1. Kliknij nazwę deklaracji z listy.
2. Kliknij **Rozpocznij deklarację** (**Start declaration**) albo **Zarządzaj** / **Edytuj** (**Manage** / **Edit**), jeśli deklaracja była już kiedyś zapisana.
3. Wypełnij → **Zapisz** (**Save**).
4. Kliknij breadcrumb **Zawartość aplikacji** (**App content**) u góry, żeby wrócić do listy.
5. Przejdź do kolejnej.

Console pokazuje deklaracje alfabetycznie. Kolejność poniżej odpowiada temu, co widzisz w panelu.

- **Polityka prywatności** (**Privacy policy**) → **Rozpocznij deklarację** (**Start declaration**) → wklej URL z PUBLISH.md → **Zapisz** (**Save**).

- **Reklamy** (**Ads**) → **Rozpocznij deklarację** (**Start declaration**) → **Nie, moja aplikacja nie zawiera reklam** (**No, my app does not contain ads**), chyba że PUBLISH.md mówi inaczej → **Zapisz** (**Save**).

- **Dostęp aplikacji** (**App access**) → **Rozpocznij deklarację** (**Start declaration**). Ta sekcja jest skanowana przez automat Google pod kątem login UI — wklej **całą baseline z sekcji 6 `App Review Information (Android)`** w PUBLISH.md:
  - Wybierz **Dostęp do wszystkich lub niektórych funkcji aplikacji jest ograniczony** (**All or some functionality is restricted**).
  - Kliknij **Dodaj instrukcje** (**Add instructions**) albo **Zarządzaj** (**Manage**) przy istniejącej instrukcji.
  - Uzupełnij pola z baseline:
    - **Nazwa instrukcji** (**Instruction name**): `Test Account (placeholder)`
    - **Nazwa użytkownika, adres e-mail lub numer telefonu** (**Username, email address, or phone number**): na przykład `review@example.com`
    - **Hasło** (**Password**): na przykład `Review123!`
    - **Wszelkie inne informacje wymagane do uzyskania dostępu do aplikacji** (**Any other information required to access your app**): wklej tekst `Additional instructions` z PUBLISH.md. Ten tekst ma zostać po angielsku, bo Google wymaga instrukcji dostępu po angielsku.
  - Zaznacz **Zezwalaj Androidowi na używanie podanych przez Ciebie danych logowania do testowania wydajności i zgodności aplikacji** (**Allow Google to use these credentials...**).
  - Zaznacz **Do uzyskania dostępu do aplikacji nie są wymagane żadne inne informacje** (**No other information is needed to access my app**).
  - **Zapisz** (**Save**).
  - Uzasadnienie: Google Play ma automat, który widzi przycisk "Log in to existing account" na Welcome i flaguje apkę jako account-based. Placeholder credentials + notatka o Guest mode rozbrajają ten automat — tak przeszła publikacja tego template'u w praktyce. **Nie kombinuj** — wklej baseline 1:1.

- **Oceny treści** (**Content rating**, IARC questionnaire) → **Rozpocznij deklarację** (**Start declaration**) → **Rozpocznij kwestionariusz** (**Start questionnaire**):
  - **Adres e-mail** (**Email address**): Twój email.
  - **Kategoria** (**Category**): wg PUBLISH.md / IDEA.md (najczęściej: **Wszystkie inne typy aplikacji** (**All other app types**)).
  - Zaznacz **[x] Akceptuję Warunki**.
  - **Dalej** (**Next**) — w kwestionariuszu odpowiadaj wg PUBLISH.md. Baseline dla tego template: zaznacz **Nie** (**No**) przy wszystkich pytaniach, chyba że PUBLISH.md / IDEA.md wyraźnie mówi inaczej.
  - Przejdź przez grupy pytań:
    - **Pobrana aplikacja** — zawartość istotna dla oceny w pobranym pakiecie aplikacji.
    - **Udostępnianie zawartości użytkownika** — komunikacja lub wymiana treści między użytkownikami.
    - **Zawartość online** — treści dostępne z aplikacji, ale niebędące częścią początkowego pakietu.
    - **Promocja lub sprzedaż produktów bądź działań z ograniczeniami wiekowymi**.
    - **Różne** — lokalizacja udostępniana innym użytkownikom, produkty cyfrowe, nagrody pieniężne/krypto/NFT, przeglądarka/wyszukiwarka, aktualności lub edukacja.
  - **Zapisz** (**Save**) → **Dalej** (**Next**) → na ekranie **Podsumowanie** (**Summary**) kliknij **Zapisz** / **Prześlij** (**Save** / **Submit**).

- **Docelowi odbiorcy i treści** (**Target audience and content**) → **Rozpocznij deklarację** (**Start declaration**, wieloekranowy kreator):
  - Przejdź przez kroki kreatora: **Docelowy wiek** (**Target age**) → **Szczegóły aplikacji** (**App details**) → **Reklamy** (**Ads**) → **Obecność w sklepie** (**Store presence**) → **Podsumowanie** (**Summary**).
  - **Docelowa grupa wiekowa** (**Target age group**): zaznacz przedziały wiekowe wg PUBLISH.md. Baseline dla tego template: **18 lub więcej** (**18 and over**).
  - Jeśli wybrałeś **18 lub więcej** (**18 and over**), pojawi się opcjonalny checkbox **Ograniczaj dostęp do mojej aplikacji użytkownikom, których Google uzna za małoletnich** (**Restrict users that Google has determined to be minors from my app**) — **ZOSTAW NIEZAZNACZONY**. Google i tak nie promuje 18+ apek dzieciom; ten checkbox dodatkowo odetnie wszystkich użytkowników, których Google oznaczyło jako nieletnich, co może niepotrzebnie zawęzić bazę.
  - **Szczegóły aplikacji** (**App details**) → **Dalej** (**Next**).
  - **Reklamy** (**Ads**) → **Dalej** (**Next**).
  - **Obecność w sklepie** (**Store presence**) → zaznacz **Nie dodawaj mojej aplikacji do Programu aplikacji zatwierdzonych przez nauczycieli** (**Don't list my app in the Teacher Approved program**). **Czy aplikacja jest atrakcyjna dla dzieci?** (**Appeals to children?**): **Nie** (**No**).
  - **Zapisz** (**Save**).
  - *(Uwaga: Teachers program nie jest osobną sekcją w Console — jest ostatnim ekranem kreatora Target audience. Po wybraniu 18+ Console może od razu przerzucić na summary — wtedy po prostu Save.)*

- **Bezpieczeństwo danych** (**Data safety**) → **Rozpocznij deklarację** (**Start declaration**) albo **Dalej** (**Next**) na ekranie informacyjnym — wieloekranowy kwestionariusz:
  - Przejdź przez kroki kreatora: **Przegląd** (**Overview**) → **Zbieranie danych i bezpieczeństwo** (**Data collection and security**) → **Typy danych** (**Data types**) → **Wykorzystanie i przetwarzanie danych** (**Data usage and handling**) → **Podgląd** (**Preview**).

  **Zbieranie danych i bezpieczeństwo (Data collection and security):**
  - **Czy Twoja aplikacja zbiera lub udostępnia którykolwiek z wymaganych typów danych użytkownika?** (**Does your app collect or share any of the required user data types?**) → **Tak** (**Yes**).
  - **Czy wszystkie dane użytkownika zbierane przez Twoją aplikację są zaszyfrowane podczas przesyłania?** (**Is all of the user data collected by your app encrypted in transit?**) → **Tak** (**Yes**) — Supabase/HTTPS.
  - **Które z tych metod tworzenia konta są dostępne w Twojej aplikacji?** (**Account creation methods**) → zaznacz **Nazwa użytkownika i hasło** (**Username and password**). Template ma upgrade flow guest → email auth, Google Play traktuje to jako tworzenie konta. Nie zaznaczaj **Moja aplikacja nie umożliwia użytkownikom tworzenia konta**.
  - **Dodaj link, za pomocą którego użytkownicy będą mogli poprosić o usunięcie konta i powiązanych z nim danych** (**Add a link that users can use to request account and data deletion**) → **URL strony z informacjami o usunięciu konta** (**Delete account URL**): wklej z PUBLISH.md.
  - **Czy umożliwiasz użytkownikom przesyłanie próśb o usunięcie części lub całości swoich danych bez konieczności usuwania konta?** (**Do you provide a way for users to request that part or all of their data is deleted without deleting their account?**) → **Tak** (**Yes**).
  - **Dodaj link, za pomocą którego użytkownicy będą mogli poprosić o usunięcie danych** (**Add a link that users can use to request data deletion**) → **URL do strony z informacjami o usuwaniu danych** (**Data deletion URL**): wklej ten sam delete account URL z PUBLISH.md. Console akceptuje ten sam link dla obu pytań.
  - Sekcje **Dodatkowe plakietki**, **Niezależna weryfikacja bezpieczeństwa** i **Zweryfikowane płatności UPI** pomiń, chyba że PUBLISH.md wyraźnie mówi inaczej.
  - **Dalej** (**Next**).

  **Typy danych (Data types)** — baseline dla tego template (Supabase anonymous + `shared_users` + user-generated content w tabelach `<prefix>_*`). Na ekranie z kategoriami rozwiń sekcje **Dane osobowe** (**Personal info**) i **Aktywność w aplikacjach** (**App activity**) i zaznacz dokładnie **te 4 typy**:

  | # | Kategoria danych → Typ | Zbierane | Udostępniane | Przetwarzane tymczasowo | Wymagane / opcjonalne | Cele |
  |---|---|---|---|---|---|---|---|
  | 1 | **Dane osobowe → Nazwa** (**Personal info → Name**) | ✅ | ❌ | **Nie** | **Użytkownicy mogą decydować** | **Zarządzanie kontem**, **Personalizacja** |
  | 2 | **Dane osobowe → Adres e-mail** (**Personal info → Email address**) | ✅ | ❌ | **Nie** | **Użytkownicy mogą decydować** | **Zarządzanie kontem**, **Funkcje aplikacji** |
  | 3 | **Dane osobowe → Identyfikatory użytkowników** (**Personal info → User IDs**) | ✅ | ❌ | **Nie** | **Zbieranie danych jest wymagane** | **Zarządzanie kontem**, **Funkcje aplikacji** |
  | 4 | **Aktywność w aplikacjach → Inne treści użytkowników** (**App activity → Other user-generated content**) | ✅ | ❌ | **Nie** | **Użytkownicy mogą decydować** | **Funkcje aplikacji** |

  **Dlaczego takie wymagane/opcjonalne** — Google rozumie **Zbieranie danych jest wymagane** (**Required**) jako "dana jest zbierana zawsze, user nie ma wyboru". **Użytkownicy mogą decydować** (**Users can choose**) = user sam decyduje czy poda/utworzy tę daną:
  - **Nazwa**, **Adres e-mail** → w template są **Użytkownicy mogą decydować**: guest nie musi ich podawać, dopiero upgrade do konta (z poziomu profilu) prosi o imię i email.
  - **Identyfikatory użytkowników** → **Zbieranie danych jest wymagane**: Supabase tworzy `user.id` od pierwszego wejścia (anonymous login), user nie ma wyjścia — dlatego jedyny z 4 typów oznaczony jako wymagany.
  - **Inne treści użytkowników** → **Użytkownicy mogą decydować**: user sam decyduje czy utworzy tasks/reasons/notes (jak guest nic nie klika, nic się nie zapisuje).

  Punkt 4 (**Aktywność w aplikacjach → Inne treści użytkowników**) to user-generated content lecący do Supabase (tasks, reasons, notes — cokolwiek user tworzy w apce). To jest **właściwa** kategoria Google Play dla takich treści, nie **Wiadomości** (**Messages**) — Messages to dosłowne wiadomości międzyludzkie: email/SMS/chat.

  Jeśli apka trzyma **pliki/zdjęcia/audio** zamiast tekstu, zamień punkt 4 na odpowiednio **Zdjęcia i filmy** (**Photos and videos**), **Pliki dźwiękowe** (**Audio files**) lub **Pliki i dokumenty** (**Files and docs**) — zapytaj mnie. Jeśli apka jest czysto read-only i nic nie lata do Supabase od usera, pomiń punkt 4 — też zapytaj mnie.

  **Wykorzystanie i przetwarzanie danych (Data usage and handling)**: po zaznaczeniu typów i kliknięciu **Dalej** (**Next**) Google pokaże listę wybranych typów. Przy każdym typie kliknij **Rozpocznij** (**Start**) i wypełnij formularz według tabeli wyżej:
  - **Czy te dane są zbierane, udostępniane, czy jedno i drugie?** → zaznacz **Zbierane** (**Collected**), nie zaznaczaj **Udostępniane** (**Shared**).
  - **Czy te dane są przetwarzane na bieżąco?** → **Nie, te zgromadzone dane nie są przetwarzane tymczasowo** (**No, this collected data is not processed ephemerally**).
  - **Czy te dane są wymagane w przypadku Twojej aplikacji lub też użytkownicy mogą decydować o ich zbieraniu?** → wybierz wartość z kolumny **Wymagane / opcjonalne**.
  - **Dlaczego zbierasz te dane użytkownika?** → zaznacz cele z kolumny **Cele**: **Funkcje aplikacji**, **Personalizacja**, **Zarządzanie kontem** według danego typu.

  Po wypełnieniu wszystkich 4 typów kliknij **Dalej** (**Next**) → przejrzyj **Podgląd** (**Preview**) → **Zapisz** (**Save**).

  **Prześlij** (**Submit**) na końcu **Bezpieczeństwa danych** (**Data safety**) — bez tego sekcja zostaje w draft i release nie wyjdzie.

- **Identyfikator wyświetlania reklam** (**Advertising ID**) → **Rozpocznij deklarację** (**Start declaration**) → **Nie, moja aplikacja nie używa identyfikatora wyświetlania reklam** (**No, my app does not use advertising ID**) → **Zapisz** (**Save**) (baseline template — apka nie używa reklam ani SDK reklamowych).
- **Aplikacje instytucji państwowych** (**Government apps**) → **Rozpocznij deklarację** (**Start declaration**) → **Nie** (**No**) → **Zapisz** (**Save**) (baseline template).
- **Funkcje finansowe** (**Financial features**) → **Rozpocznij deklarację** (**Start declaration**) → **Moja aplikacja nie zawiera żadnych funkcji finansowych** (**My app doesn't provide any financial features**) → **Zapisz** (**Save**) (baseline template).
- **Aplikacje do dbania o zdrowie** (**Health apps**) → **Rozpocznij deklarację** (**Start declaration**) → **Moja aplikacja nie ma żadnych funkcji do dbania o zdrowie** (**My app does not have any health features**) → **Zapisz** (**Save**) (chyba że PUBLISH.md / IDEA.md wyraźnie mówi, że apka ma funkcje zdrowotne — wtedy zapytaj mnie).

---

### 🔍 5. PRZEGLĄD PUBLIKOWANYCH ZMIAN I WYSŁANIE DO SPRAWDZENIA

Dla **pierwszego release** (ten scenariusz — apka nie była jeszcze na produkcji) flow jest **dwustopniowy**:

**Krok 1 — wyślij release z Alpha tracka:**
- Lewe menu → **Testuj i publikuj** (**Test and release**) → **Testowanie** (**Testing**) → **Test zamknięty** (**Closed testing**) → przy ścieżce **Alpha** otwórz draft release przygotowany w sekcji 1.
- Kliknij **Wyświetl podgląd wersji i potwierdź ją** (**Review release**) jeśli release nie ma błędów.
- Na ekranie podsumowania kliknij **Rozpocznij pełne wdrożenie** (**Start full rollout** / **Start rollout to Alpha**) i potwierdź w dialogu.
- To jedno kliknięcie wysyła release razem z oczekującymi metadanymi, np. **Informacje o aplikacji**, **Zawartość aplikacji**, **Ustawienia sklepu**.

**Krok 2 — weryfikacja przez Przegląd publikowanych zmian:**
- Lewe menu → **Przegląd publikowanych zmian** (**Publishing overview**).
- Sprawdź sekcję **Zmiany jeszcze niewysłane do sprawdzenia** (**Changes not yet sent for review**) albo **Zmiany gotowe do wysłania do sprawdzenia** (**Changes ready to send for review**).
- Jeśli widać przycisk wysyłki, kliknij **Wyślij 13 zmian do sprawdzenia** albo analogiczny przycisk z aktualną liczbą zmian, np. **Wyślij x zmian do sprawdzenia** (**Send x changes for review**) i potwierdź.
- Jeśli widzisz komunikat **Przeprowadzam szybkie testy pod kątem typowych problemów**, poczekaj aż weryfikacja się skończy. Google może pokazywać pozostały czas, np. do 14 minut.
- Jeśli sekcja jest pusta albo zmiany zostały już wysłane, oznacza to, że rollout z Alpha załapał cały batch. To jest normalne.

Typowy czas review: kilka godzin do 7 dni (nowe konta — bliżej 7). Status release'u w Alpha zmienia się ze **W trakcie sprawdzania** (**In review**) na **Dostępna dla testerów** (**Available to testers**) po akceptacji.

---

### 👥 TESTERZY (po akceptacji review)

Powiedz mi, że:
- Po zaakceptowaniu release'u w `alpha` Google Play wygeneruje **link do testów** (**testing link**), widoczny w **Test zamknięty** (**Closed testing**) → **Alpha** → **Jak testerzy mogą dołączyć do testu?** (**How testers join**).
- Żeby dopuścić apkę do production, potrzeba **12 testerów przez 14 dni** w closed testing.
- Testerów pozyskuję z platformy **"krąg testerów"** / zewnętrznych społeczności — udostępniam im ten link do testów, każdy instaluje apkę i trzyma ją przez 14 dni.
- Dopiero po tym okresie Google Play pozwoli promować track do production.

## FINISH

Powiedz mi, że gdy skończę wypełnianie Google Play Console i wyślę zmiany do review, mam napisać `next`, bo będziemy przechodzić do `23_publish-finish.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/23_publish-finish.md`.

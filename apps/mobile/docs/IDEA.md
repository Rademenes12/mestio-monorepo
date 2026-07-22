# IDEA

## Identity
- **APP_DISPLAY_NAME**: FixFlow
- **APP_BUNDLE_ID**: `com.pawelpasik.fixflow`
- **SUPABASE_TABLE_PREFIX**: `fixflow_`
- **Autor**: Paweł Pasik

## Search Intents
Frazy, które realny użytkownik może wpisać w App Store lub Google Play szukając rozwiązania swojego problemu.
- **Primary EN**: housing cooperative maintenance report app
- **Primary PL**: Aplikacja zgłoszeń konserwacji dla spółdzielni mieszkaniowej, wspolnot mieszkaniowych, zarzadca wspolnot mieszkaniowych, administrowanie budynkiem
- **Alternative EN**: tenant fault report building manager, apartment repair tracking residents notifications, property maintenance work order mobile app, adminstration of buildings
- **Alternative PL**: zgłoś usterkę zarządcy budynku, śledzenie napraw w mieszkaniu z powiadomieniami, zlecenia serwisowe nieruchomości aplikacja mobilna
- **Why These Phrases**: Frazy celują w ultra-niszowy segment (spółdzielnie + zarządcy zewnętrzni) opisując realne czynności użytkownika — nie funkcje aplikacji. Główna fraza łączy 3 niszowe pojęcia (housing cooperative + maintenance + report), co minimalizuje konkurencję przy zachowaniu realnych intencji wyszukiwania mieszkańców i zarządców.

## Elevator Pitch
Aplikacja, która pozwala mieszkańcom błyskawicznie zgłosić awarię w budynku, a zarządcy i serwisantom — sprawnie ją obsłużyć, bez papieru i zgubionych karteczek.

## Description
To jest appka dla wspólnot mieszkaniowych i spółdzielni. Mieszkaniec robi zdjęcie, wybiera kategorię (winda, elektryka, hydraulika) i wysyła — zgłoszenie trafia od razu do zarządcy. Zarządca widzi wszystkie zgłoszenia na jednym ekranie, może przypisać serwisanta i wysłać komunikat do mieszkańców danego budynku. Serwisant dostaje zadanie, zmienia status i zamyka sprawę. Wszystko offline-first — działa nawet w piwnicy bez zasięgu.

## Product Summary
- **Co ta aplikacja robi:** Umożliwia mieszkańcom zgłaszanie awarii, zarządcom zarządzanie zgłoszeniami, a serwisantom realizację napraw — wszystko w jednej aplikacji.
- **Dla kogo jest:** Dla wspólnot mieszkaniowych z zewnętrznym zarządcą, który obsługuje wiele budynków.
- **Jaki problem rozwiązuje:** Gubienie się papierowych zgłoszeń, brak komunikacji między mieszkańcem a zarządcą, trudność w priorytetyzacji napraw.

## Niche
- **Jaka jest nisza:** Wspólnoty mieszkaniowe z zewnętrznym zarządcą nieruchomości.
- **Dla kogo dokładnie nie jest ta aplikacja:** Dla deweloperów budujących nowe osiedla, dla gigantycznych spółdzielni z własnym działem IT, dla wynajmujących pojedyncze mieszkania.
- **Dlaczego ta nisza ma sens:** Zarządca zewnętrzny obsługuje kilka budynków — potrzebuje prostego narzędzia do triażu zgłoszeń, a mieszkańcy jednego kanału komunikacji. To segment pomiędzy "jedną karteczką na tablicy" a "enterprise CRM".

## Value Proposition
- **Jaka jest główna obietnica wartości aplikacji:** Żadne zgłoszenie się nie zgubi.
- **Jaką konkretną korzyść daje użytkownikowi:** Mieszkaniec wie, czy jego awaria jest już naprawiana. Zarządca widzi wszystkie otwarte sprawy w jednym miejscu.
- **Czemu użytkownik miałby ją pobrać:** Bo przykręcanie karteczek na tablicy w windzie nie działa.
- **Jaki jest pierwszy szybki efekt / 5-minute win:** W 2 minuty od zainstalowania można zrobić zdjęcie awarii i wysłać zgłoszenie.
- **Czemu użytkownik miałby do niej wracać:** Aby sprawdzić status zgłoszenia, dostać powiadomienie o zakończeniu naprawy, zgłosić kolejną awarię.

## Differentiation
- **Czym ta aplikacja różni się od innych aplikacji tego typu:** Jest prostsza — nie ma rozbudowanego CRM, faktur, harmonogramów. Skupia się na trzech rolach (mieszkaniec → zarządca → serwisant) i jednym przepływie: zgłoś → przypisz → napraw → zamknij. Działa offline i integruje się z Trello.

## Must-Have vs Nice-to-Have

### Must-Have (jedna rzecz, ale dobrze)
- **Główna funkcja aplikacji, bez której nie ma sensu jej wydawać:** Mieszkaniec zgłasza awarię (tytuł, opis, kategoria, zdjęcie, GPS) → zarządca widzi i przypisuje serwisanta → serwisant zmienia status (Nowe → W toku → Zrealizowane). Wszystko z powiadomieniami push.

### Nice-to-Have (dalsza wizja rozwoju)
- **Pomysły na rozwój po wydaniu pierwszej wersji:**
  - Integracja z Trello (już zaimplementowana)
  - Panel ogłoszeń dla zarządcy (już zaimplementowany)
  - Wykresy i statystyki dla zarządcy
  - Załączniki wielu plików
  - Eksport danych do CSV/PDF
  - Wielojęzyczność

## Store Screenshots Plan
5 kluczowych ekranów, które będą reprezentować aplikację w App Store i Google Play.
Screenshoty to główny "opis" aplikacji w sklepie — większość użytkowników nie czyta tekstów, tylko patrzy na grafiki.
Kolejność ma znaczenie — pierwszy screenshot jest najważniejszy.

1. **Ekran**: Pulpit Mieszkańca z przyciskiem "Zgłoś Nową Awarię" i listą własnych zgłoszeń
   **Komunikat**: Pokaż, że zgłoszenie awarii zajmuje dosłownie 30 sekund — zdjęcie, kategoria, wyślij.
   **Tekst na grafice (EN)**: "Report any building issue in seconds"

2. **Ekran**: Formularz zgłoszenia awarii z wyborem kategorii i załączonym zdjęciem
   **Komunikat**: Pokaż, że aplikacja jest prosta — każdy mieszkaniec to ogarnie bez instrukcji.
   **Tekst na grafice (EN)**: "Photo, category, done. No paperwork."

3. **Ekran**: Lista zgłoszeń z widocznymi statusami (Nowe / W toku / Zrealizowane)
   **Komunikat**: Pokaż, że mieszkaniec zawsze wie, co dzieje się z jego zgłoszeniem — koniec z dzwonieniem do biura.
   **Tekst na grafice (EN)**: "Always know the status of your repair"

4. **Ekran**: Pulpit Zarządcy z kafelkami statystyk i pełną listą zgłoszeń
   **Komunikat**: Pokaż zarządcy, że ma wszystko pod kontrolą w jednym miejscu — koniec z karteczkami i telefonami.
   **Tekst na grafice (EN)**: "Manage all building issues from one dashboard"

5. **Ekran**: Portal Technika z zadaniami do realizacji i przyciskami akcji (Rozpocznij / Zakończ)
   **Komunikat**: Pokaż, że serwisant dostaje jasne zlecenie na telefon i może zamknąć sprawę jednym tapnięciem.
   **Tekst na grafice (EN)**: "Your repair queue, always in your pocket"

## Raw User Input About The App
Poniżej surowy zapis 1:1 wypowiedzi Pawła dotyczących pomysłu, kierunku i decyzji produktowych. Kolejność chronologiczna.

- "pamietaj, ze to aplikacja na telefon nie table, nie komputer wiec okno dla mieszkanca powinno skladac sie z okna dodania zgloszenia oraz pulpitu gdzie sa pokazane jego zgloszenia"
- "wedlug mnie taka grafika jak '1. Pulpit Lokatora (Dashboard)' powinna byc dla zarzadu lub administrarora ale nie mieszkaniec"
- "wedlug mnie grafika jak 'Portal Technika i Serwisanta' powinna byc dla mieszkanca, serwisanata"
- "akceptuje wszystko, napisz teraz kod aplikacji dla tego co zaproponowales"
- "Wybór niszy: Wspólnoty mieszkaniowe z zarządcą zewnętrznym"
- "1" (wybór frazy ASO: housing cooperative maintenance report app)
- "1" (wybór nazwy aplikacji: FixFlow)

# INFO
> ⚠️ To jest POCZĄTKOWY (INITIAL) pomysł na aplikację. Ten plik prawdopodobnie nie jest utrzymywany w miarę rozwoju apki i może zawierać nieaktualne informacje. Aktualny stan produktu znajdziesz w kodzie.

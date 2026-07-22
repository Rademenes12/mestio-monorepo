# FixFlow – Backlog i decyzje (do dokończenia)

Ten plik zbiera zadania zgłoszone przez użytkownika, decyzje architektoniczne i rekomendacje.
Jest źródłem prawdy dla prac POZA bieżącym etapem kursu (kurs śledzi `STATE.md`).

Aktualizuj przy każdej sesji. Ostatnia aktualizacja: 2026-06-24 (sesja 7 – duża partia feedbacku po teście admina).

---

## 🆕 Sesja 7 (2026-06-24) – feedback z testów (admin + multi-estate + role)

Zgłoszone przez użytkownika, oczekuje na decyzje i wdrożenie. Każdy punkt ma moją
rekomendację (R:) i ewentualne pytanie (Q:).

### S7.1. D (partia 2) – tłumaczenia dashboardu Zarządu/Admina
- [ ] Komunikator (form i lista), Estate (config + onboarding), Residents tab, Home zarządu,
      Dashboard tiles → PL/EN/UK przez ARB.
- R: jedna sesja na ten temat, po zamknięciu logiki S7.4 i S7.13 (żeby nie tłumaczyć dwa razy).

### S7.2. Kasowanie komunikatu przez każdą rolę Zarząd/Administrator
- [ ] Każdy użytkownik z rolą `Zarząd` LUB `Administrator` widzi przycisk usuń przy komunikacie.
      Obecnie usuwać może tylko autor (sprawdzić w `announcements` RLS + UI).
- R: rozszerzyć RLS policy `delete` o `fixflow_is_board_or_admin(auth.uid())`; w UI pokazywać
      ikonę kosza dla tej grupy (Cubit dostaje `canDelete` z bieżącej roli).

### S7.3. Bug: dodawanie kontaktu „Ochrona" nie pojawia się na liście
- [ ] Repro: profil Admin/Zarząd → Telefony → dodaj „Ochrona" → nie ma na liście.
- R: zdiagnozować w `contacts_data_source.dart` (insert/select RLS + estate filter +
      ewentualnie brak refresh streama). Najpewniej brakuje `INSERT` policy dla nowego typu
      kontaktu, albo lista nie subskrybuje stream'a po dodaniu. Sprawdzę po Twojej akceptacji.

### S7.4. Telefony – współdzielona widoczność Zarząd ↔ Mieszkaniec
- [ ] To, co Zarząd/Admin wpisze w zakładce „Telefony", MA się pokazać u Mieszkańca w jego
      zakładce „Telefony" (per osiedle).
- R: zweryfikować, że `ContactsDataSource.watch(estateId)` używa tylko `estate_id` (bez
      filtra po roli/userze) i RLS SELECT pozwala wszystkim członkom osiedla czytać.
      Edycja: tylko Zarząd/Admin (RLS WITH CHECK).

### S7.5. Przykładowe zgłoszenie – seedowanie i test cross-profile
- [ ] Wstawić 1 zgłoszenie testowe (seed migracja albo skrypt) widoczne we wszystkich
      profilach Mieszkaniec/Zarząd/Serwis/Admin tego samego osiedla.
- R: nie hardkodować w kodzie – zrobić migrację `fixflow_seed_test_report` która wstawia
      zgłoszenie do testowego osiedla (kod zaproszenia z S7.12). Łatwo cofnąć migracją w dół.
- **Bug pokrewny (S7.14)**: obecnie dodanie zgłoszenia nie pojawia się u mieszkańca w
      zakładce „Zgłoszenia". To bug do naprawienia ZANIM dodam seed – inaczej i tak nie
      zobaczymy seeda.

### S7.6. Propozycja jak ma działać zgłoszenie (e2e)
Flow który proponuję (poproszę o akceptację albo zmiany):
1. Mieszkaniec → „+ Nowe zgłoszenie" → tytuł, opis, kategoria (Hydraulika/Elektryka/...),
   lokalizacja (budynek/klatka/piętro/mieszkanie – pre-fill z profilu), zdjęcia + PDF.
2. Status początkowy: `Nowe`. Widoczne dla autora (zawsze) i dla wszystkich Zarząd/Admin/Serwis
   tego osiedla (RLS po `estate_id`).
3. Zarząd/Admin może: zmienić status (`Nowe`→`Przyjęte`→`W realizacji`→`Zamknięte`),
   przypisać Serwis, dodać komentarz wewnętrzny.
4. Serwis widzi tylko zgłoszenia przypisane do niego LUB nieprzypisane w jego specjalizacji.
5. Mieszkaniec widzi swoje zgłoszenia + zmiany statusu (timeline). Nie widzi cudzych.
6. Trello (jeśli skonfigurowane przez Zarząd): co `Nowe` zgłoszenie → karta na liście „Nowe";
   zmiana statusu w aplikacji → move karty na inną listę. Bidirectional sync NIE w v1
   (zbyt skomplikowane).
- ✅ DECYZJA: statusy zgłoszenia to `Nowe` → `W realizacji` → `Zamknięte` → `Odrzucone`
  (bez „Przyjęte" – wchodzi od razu w realizację). `Odrzucone` to terminal status równolegle
  do `Zamknięte`.

### S7.7. Multi-estate: jeden admin – wiele wspólnot (10+)
Obecnie admin ma jedno aktywne osiedle (zapamiętane lokalnie). Trzeba dodać switcher.
- R: model danych już to wspiera – `fixflow_user_estates` ma N:M.
- R: UI – w AppBar Home dashboardu dropdown z nazwą osiedla (np. „Wspólnota Słoneczna ▼"),
      tap → bottom sheet z listą osiedli + przycisk „+ Dodaj kolejne osiedle".
- R: rozróżnienie wizualne – każde osiedle dostaje **kolor akcentu** (auto z palety) +
      **kod 4-znakowy** widoczny w nagłówku. Plus nazwa pełna i adres pod nazwą.
- R: cały stan zalogowanego usera (reports/contacts/announcements/residents) reaguje na
      zmianę aktywnego osiedla – jeden global `ActiveEstateCubit` (singleton) emituje
      `estateId`, pozostałe Cubity subskrybują przez stream w repo.
- ✅ DECYZJA: ZAWSZE per-wspólnota. Brak agregatu „Wszystkie osiedla" w v1.

### S7.8. Role – „Serwisant" → „Serwis" + uniwersalność
- [ ] W rejestracji i UI zmienić etykietę roli `Serwisant` na `Serwis` (PL).
      EN: `Service`, UK: `Сервіс`.
- R: pole roli w DB (`fixflow_resident_profiles.role`) i klucz w kodzie zostają jako
      `serwis` (technical key) – tylko etykieta UI się zmienia. Cała logika (RLS,
      uprawnienia) bez zmian.
- R: dokumentacja: „Serwis" = każda firma usługowa osiedla (sprzątanie, konserwacja,
      ochrona, hydraulik, elektryk, ogrodnik...). W przyszłości można dodać sub-typy
      (`service_kind`) – ale NIE teraz (Simplicity First).
- Q: zostawiamy płaską rolę „Serwis" w v1, sub-typy na potem? (rekomenduję tak)

### S7.9. Co jeszcze brakuje – mój audyt (do akceptacji)
Rzeczy, o których wg mnie nie pomyślano, a powinny być w v1:
- Powiadomienia push gdy: nowy komunikat, zmiana statusu mojego zgłoszenia, nowe zgłoszenie
  dla Zarząd/Serwis (FCM jest, ale nie podpięty do akcji).
- Polityka prywatności + regulamin + zgody RODO (wymagane przed publikacją na sklepach).
- „Zgłoszenia anonimowe" – możliwość zgłoszenia bez podania mieszkania (np. uszkodzona
  ławka w parku). Pole `is_anonymous`.
- Historia zmian zgłoszenia (kto, kiedy, co zmienił).
- Eksport listy zgłoszeń do CSV dla Zarządu (audyt rozliczeń ze Serwisem).
- Wyszukiwarka/filtr w listach (Zgłoszenia, Mieszkańcy) – przy 100+ wpisach bez tego się
  nie da pracować.
- Rate limiting na rejestracji i RPC `join_by_code` (anti-spam).
- Tryb offline na czytanie (lista zgłoszeń, komunikaty) – obecnie tylko fallback przy
  PGRST002.
- Q: które z powyższych chcesz w v1 publish, a które na po-publish?

### S7.10. Przycisk „Usuń konto" w zakładce Profil – KAŻDA rola
- [ ] Wszystkie profile (Mieszkaniec/Zarząd/Admin/Serwis): w Profilu sekcja „Strefa
      niebezpieczna" z przyciskiem „Usuń konto" (czerwony) + dialog potwierdzenia z
      polem hasła (re-auth).
- R: backend już istnieje (Edge Function `delete-account` w shared layer). Podpiąć
      UI + flow re-auth.

### S7.11. Rejestracja – pole HASŁO
- [ ] W rejestracji (`RegisterScreen`) ma być pole „Hasło" + „Powtórz hasło" (są już,
      sprawdzić wszystkie role). Najpierw `continueAsGuest()` → potem
      `upgradeAnonymousWithEmail(email, password)`.
- R: zweryfikuję wszystkie ścieżki rejestracji (Mieszkaniec/Zarząd/Admin/Serwis) i
      poprawię tam, gdzie hasło zniknęło/jest tylko email.

### S7.12. Stały TESTOWY kod zaproszenia
- [ ] Wpisać stały kod w aktualnym osiedlu (np. `TEST1234`) i wpisać go też we wszystkich
      przykładach/seedach, żeby Ty mógł testować Mieszkaniec→Zarząd→Admin→Serwis bez
      przerywania.
- R: nie hardkoduję kodu w kodzie. Tworzę migrację `seed_test_estate` która tworzy
      osiedle „FixFlow QA" z kodem `TEST1234`. Łatwo wyłączyć przed produkcją.
- ✅ DECYZJA: kod `TEST1234` zaakceptowany.

### S7.13. Trello – pozostaje OPCJONALNE
- [x] DECYZJA POTWIERDZONA: aplikacja działa w pełni BEZ Trello. Wszystko (zgłoszenia,
      komunikaty, dane mieszkańców, kontakty) – w aplikacji + Supabase.
- [x] Trello to tylko MIRROR zgłoszeń – Zarząd/Admin może podpiąć żeby zarządzać kartami
      w Trello equivalentnie do panelu w app. Bez Trello panel w aplikacji DZIAŁA tak
      samo (statusy, przypisania, komentarze).
- [ ] Wsparcie PDF jako załącznika (obok zdjęć). Trello karty: zdjęcie inline, PDF jako
      attachment.

### S7.14. BUG: dodanie zgłoszenia nie pojawia się u Mieszkańca
- [ ] Repro: profil Mieszkaniec → „+ Nowe zgłoszenie" → zapis → wracam na listę → brak.
- R: prawdopodobne przyczyny (zdiagnozuję): (a) brak `estate_id` na insercie, (b) RLS
      SELECT wymaga `estate_id IS NOT NULL`, (c) Cubit nie subskrybuje streama – tylko
      jednorazowy fetch przy wejściu, (d) insert do tabeli niewłączonej do realtime.
- ✅ DECYZJA: agent wybiera lepszą wersję rozwiązania samodzielnie po diagnozie kodu.

### S7.16. Zmiana statusu zgłoszenia – uprawnienia + UI
- [ ] Status zgłoszenia mogą zmieniać: `Serwis` (już działa), `Zarząd`, `Administrator`.
- [ ] UI zmiany statusu = TYLKO `DropdownButton` (lista rozwijalna). Bez przycisków/chipów,
      bez modalu wyboru. Wartości: `Nowe` / `W realizacji` / `Zamknięte` / `Odrzucone`
      (zgodnie z decyzją S7.6).
- [ ] Mieszkaniec widzi status jako READ-ONLY badge (Text/Chip), bez możliwości zmiany.
- R: w UI sprawdzam rolę z `ResidentProfileModel.role`. Dropdown renderowany tylko dla
     ról `Serwis|Zarząd|Administrator`. Mieszkaniec dostaje plain text.
- R: w Cubicie `updateStatus()` już istnieje — nie zmieniam. Tylko UI rozszerzyć.

### S7.17. Komentarze wewnętrzne (board/serwis-only)
- [ ] Pole „Komentarz wewnętrzny" widoczne i edytowalne dla: `Zarząd`, `Administrator`,
      `Serwis` (czyli wszyscy poza Mieszkańcem).
- [ ] Mieszkaniec NIGDY nie widzi tych komentarzy.
- [ ] Wielu autorów może dodawać komentarze (lista, nie pojedyncze pole). Każdy wpis ma
      autora, rolę, datę.
- R: w DB istnieje już `fixflow_report_comments` z polem `is_visible_to_residents` (default
     false) → wystarczy podpiąć UI + RLS. Bez nowej migracji schemy.
- R: RLS SELECT: członkowie osiedla z rolą != `Mieszkaniec` widzą wszystko; mieszkańcy
     widzą tylko komentarze z `is_visible_to_residents = true` (przyszłościowo – v1
     mieszkaniec NIE widzi żadnych).
- R: RLS INSERT/UPDATE: tylko role != `Mieszkaniec`. Egzekwowane przez
     `fixflow_is_board_or_admin` + rozszerzenie o `Serwis`.
- R: w UI sekcja „Notatki zespołu" pod statusem zgłoszenia (tylko dla non-resident).
     Pole tekstowe + przycisk „Dodaj komentarz" → lista pod spodem.

### S7.15. Home Zarządu – kafelki bez delta („+12 ten tydzień")
- [ ] Trzy kafelki na Home (Zgłoszenia ogółem itd.) – usunąć dolny wiersz „+12 ten
      tydzień" itp. Zostaje tylko liczba i tytuł kafelka.
- R: szybka zmiana w `dashboard_screen.dart` (lub odpowiedniku) + ARB cleanup.

---

## 🆕 Sesja 2 (2026-06-24) – feedback z testów na urządzeniu

### A. Profil MIESZKANIEC – zakładka Home
- [ ] Usunąć funkcję „Dodaj zgłoszenie" z Home – ma być TYLKO w zakładce Zgłoszenia (logicznie).
- [ ] Home pokazuje wyłącznie aktywne komunikaty od administratora.
- [ ] Usunąć osobną zakładkę „Komunikator" u mieszkańca (duplikat – komunikaty są już na Home).
- [ ] W miejscu zakładki Komunikator wstawić DUŻY okrągły przycisk „Zgłoś" / duży „+" – jasne CTA.
- [ ] Skoro CTA „+" jest w bottom nav, NIE dodajemy też przycisku „Dodaj" w zakładce Zgłoszenia.

### B. Profil MIESZKANIEC – zakładka Zgłoszenia (bug)
- [ ] Po dodaniu zgłoszenia pojawia się komunikat sukcesu, ale zgłoszenie NIE pojawia się na liście u mieszkańca.
      Diagnoza: filtr `r.reporterEmail.toLowerCase() == emailToCheck` w `dashboard_screen.dart:178-184`.
      Sprawdzić czy nowo utworzone zgłoszenie ma poprawny `reporterEmail` (case + non-null).
- [ ] Po sukcesie dodania → AUTOMATYCZNIE przenieść użytkownika do zakładki Zgłoszenia.
- [ ] Pole formularza zgłoszenia „okno" (sam temat „okna") nie ma sensu – zastąpić właściwymi polami
      kontekstowymi jak przy rejestracji: budynek, klatka, piętro, numer mieszkania (te same dropdowny).
- [ ] Dane już są w profilu mieszkańca – nie duplikować w formularzu zgłoszenia. Wyciągać z profilu
      i pokazywać read-only / dopytywać tylko o lokalizację usterki (np. „mieszkanie / klatka / część wspólna").

### C. Profil ZARZĄD – crash na zakładce „Osiedle"
- [ ] Po rejestracji jako Zarząd aplikacja zawiesza się na zakładce „Osiedle".
      `dashboard_screen.dart:197` – `_buildManagerEstateTab(context)`. Sprawdzić: brak `estate_id`
      tuż po rejestracji, brak gating'u (patrz Priorytet 1.1), prawdopodobnie infinite loading
      / null pointer na świeżo założonym koncie bez osiedla.

### D. Tłumaczenia – pełna lokalizacja po wybranym języku
- [ ] Wybór języka (PL/EN/UK) na pierwszym ekranie i przy rejestracji/loginie ma sterować CAŁYM UI.
- [ ] Reguła: TEKSTY UI tłumaczone; SnackBary sukcesu/błędu (komunikaty systemowe) ZOSTAJĄ po polsku
      (tak ustalone z użytkownikiem – „komunikaty mają być po polsku").
- [ ] Audyt: grep po polskich literałach w `lib/features/**/ui/**` + `lib/app/**/ui/**`.
- [ ] Przenieść do ARB (pl/en/uk), `context.l10n`, `flutter gen-l10n`.
- [ ] Ekran startowy: pokazać picker języka PL/EN/UK (PL default).

### E. Pamięć sesji na telefonie – polityka
- [ ] Po rejestracji dane usera trzymane w pamięci telefonu (Supabase już to robi – potwierdzić manualnie).
- [ ] Wylogowanie automatyczne: rozważyć przy restarcie telefonu LUB raz na kilka dni.
      DECYZJA do potwierdzenia – rekomendacja: NIE wymuszać przy restarcie (UX), opcjonalnie wymusić
      re-login co N dni (np. 14) tylko jeśli wymagamy bezpieczeństwa.

### F. Kontakt do autora (PRZYPOMNIEĆ przy powrocie)
- [x] Już jest w Profilu (`mailto:aivolux@gmail.com`) – sesja 1. Zweryfikować, że działa na obu profilach
      (Mieszkaniec i Zarząd) i czy widoczne na pierwszy rzut oka.

### G. Responsywność / Adaptacyjność (PRZYPOMNIEĆ)
- Reguły z wytycznych użytkownika dopisane do Priorytetu 4 poniżej:
  `LayoutBuilder`, `MediaQuery`, `Flexible/Expanded`, `FractionallySizedBox`, `AspectRatio`,
  `Switch.adaptive`, `CircularProgressIndicator.adaptive`, `SafeArea`.
- `flutter_screenutil` – opcjonalnie, NIE wprowadzać teraz globalnie (ryzyko refactora).

### H. Trello – decyzja modelu (uzgodnione, do zaimplementowania w Prio 2)
- Model: jednorazowa konfiguracja przez ADMINA OSIEDLA. Mieszkaniec NIC nie konfiguruje.
- Admin pobiera z Trello 3 dane: **API Key** (https://trello.com/app-key), **Token** (link „Token"
  na tej samej stronie, scope: read+write), **List ID** kolumny „Nowe zgłoszenia"
  (np. z `https://api.trello.com/1/boards/{boardId}/lists?key=...&token=...`).
- Wpisuje raz w aplikacji → zapis do `fixflow_estates.trello_*` (pole już jest).
- Mieszkaniec dołącza KODEM ZAPROSZENIA → automatycznie spięty z osiedlem → jego zgłoszenia
  trafiają na Trello osiedla przez Edge Function (token nie opuszcza serwera).
- Kody zaproszenia: model „jeden wielokrotny kod na osiedle" (obecny) – do potwierdzenia czy
  dodajemy też jednorazowe per-mieszkanie (DB wspiera oba).

---

## 🆕 Sesja 6 (2026-06-24) – zrobione w tej sesji

- ✅ **D (partia 1 — resident-facing UX)**: tłumaczenia PL/EN/UK kluczowych ekranów.
  - ARB: ~55 nowych kluczy (nav, home mieszkańca, reports tab, profile, lock screen, banner
    osiedla, formularz zgłoszenia). `flutter gen-l10n` zaktualizowane.
  - Zamienione: bottom nav (5/6 etykiet), Home (powitanie, ogłoszenia, aktywne zgłoszenia,
    banner kodu), Reports (tytuł, empty state), Profile (sekcje, etykieta adresu, kontakt),
    LockScreen (tytuł, wszystkie labels, validators), Add Report sheet (snackbary, przycisk).
  - Dashboard manager screens (Komunikator form, Estate, Residents) i dashboard manager Home
    nadal po polsku — wymagają osobnej partii (~odłożone do sesji 7).

- ✅ **K**: Welcome → przycisk „Zarejestruj" otwiera `RegisterScreen` (email+hasło) zamiast
  bezpośredniego guest sign-in.
  - `RegisterCubit.register()`: jeśli nie ma sesji → najpierw `continueAsGuest()` (anonymous
    sign-in), potem `upgradeAnonymousWithEmail()` (auth.updateUser{email,password}). Zachowuje
    project pattern z `AGENTS.md` ("anon-first then upgrade keeps user.id stable"). Po sukcesie
    `RegisterScreen` automatycznie zamyka się (`BlocListener` na przejście isAnonymous → non-anon)
    i AppGate przeskakuje na HomeScreen → LockScreen (uzupełnienie profilu z pre-filled email).
  - Testy: dodany przypadek "no session yet" + mock dla `currentPrincipal` w setUp. Wszystkie
    4 przypadki przechodzą.

---

## 🆕 Sesja 5 (2026-06-24) – zrobione w tej sesji

- ✅ **N**: zakładka „Mieszkańcy" (Admin/Zarząd) widzi wszystkich mieszkańców.
  - Migracja: helper `fixflow_is_board_or_admin(uuid)` (SECURITY DEFINER) + RLS policy
    `Board can read all resident profiles` na `fixflow_resident_profiles`.
  - `ResidentsDataSource.getResidents()` przepisany z pustego `fixflow_residents` na
    `fixflow_resident_profiles` filtrowane po `role='Mieszkaniec' AND is_verified=true`.
  - Mapping: `name` → `firstName + lastName` (split na pierwszej spacji), `apartment`
    "Mieszkanie 14" → `apartmentNumber = "14"`. Dodane pola location: building/footbridge/floor.
  - UI: linia adresu `Budynek 1 · Klatka A · Piętro 3 · M 14`, telefon, e-mail.

- ✅ **Komunikator → DB**: in-memory `_adminNotifications` zastąpione tabelą `fixflow_announcements`.
  - Migracja: kolumny `target_label TEXT`, `estate_id UUID` (FK → estates), index na `estate_id`.
  - RLS: SELECT dla każdego authenticated gdy `is_active` + (`estate_id IS NULL` OR jest member),
    INSERT/UPDATE tylko dla `fixflow_is_board_or_admin(auth.uid())`. Dodane do publikacji realtime.
  - Nowy feature `lib/features/announcements/`: `Announcement` (freezed), `AnnouncementsDataSource`
    (Supabase CRUD + soft delete via `is_active=false`), `AnnouncementsRepository` (BehaviorSubject
    stream + refresh per `estate_id`), `AnnouncementsCubit` (subskrybuje aktywne osiedle, ładuje,
    create + delete z optimistic update).
  - Dashboard: usunięta lista in-memory, `_buildManagerAnnouncementsTab` używa cubit (BlocBuilder
    + retry przy błędzie + soft delete), `_sendBroadcastMessage` await cubit.create. Home tab
    mieszkańca: `latestNotice` z cubita (filtruje wygasłe lokalnie, server-side już filtruje
    `is_active`). Komunikaty przeżywają restart aplikacji.

- ✅ **L**: kod zaproszenia w profilu mieszkańca.
  - LockScreen: pole „Kod zaproszenia" jest OPCJONALNE dla mieszkańca (validator off),
    wymagane tylko dla Zarząd/Administrator/Serwisant.
  - Resident Home tab: banner u góry „Wpisz kod zaproszenia w Profilu…" widoczny tylko
    gdy `activeEstate == null`. Kliknięcie → setState `_currentTabIndex = 4` (Profil).
  - Resident Profile tab: nowy widget `_EstateJoinCard` — gdy brak osiedla pokazuje pole
    + przycisk „Dołącz do osiedla" (RPC `fixflow_redeem_invitation_code` przez
    `EstateMembershipCubit.redeemCode`); po sukcesie pokazuje aktywne osiedle z zielonym
    haczykiem + komunikat sukcesu (SnackBar).

---

## 🆕 Sesja 4 (2026-06-24) – zrobione w tej sesji

- ✅ **K (częściowo)**: pola **E-mail (required)** i **Telefon (opcjonalne)** w rejestracji
  mieszkańca. To naprawia też **Bug B** (filtr listy zgłoszeń wymagał e-maila do match'a).
- ✅ **M**: kolumna `phone TEXT` w `fixflow_resident_profiles` (migracja).
- ✅ **Kontakt ochrona bug**: RLS INSERT na `fixflow_emergency_contacts` wymagał `estate_id IS NOT NULL`
  + admin role. Admin bez osiedla nie mógł nic dodać. Migracja rozluźnia: globalne kontakty
  (`estate_id IS NULL`) może wstawić każdy authenticated user. Per-osiedlowe wymagają nadal admin role.
- ✅ **Komunikator (Zarząd/Admin)**: pole daty wygaśnięcia (3 dropdowny: dzień/miesiąc/rok),
  auto-hide u mieszkańca po 23:59 tego dnia (komunikat nie kasowany, tylko ukryty), przycisk
  kasowania śmietnik (każdy Zarząd/Admin może usunąć), wizualne wyszarzenie wygasłych w widoku
  admina + etykieta "Wygasa: DD.MM.YYYY (wygasł)".

> Uwaga: komunikator nadal jest in-memory (`_adminNotifications` List w State). Reset aplikacji
> kasuje wszystkie komunikaty. Migracja na DB (`fixflow_announcements` ma już `expires_at` i
> `duration_type` w schemie) — odłożone na sesję 5.

---

## 🆕 Sesja 3 (2026-06-24) – zrobione w tej sesji

- ✅ Bug C (Zarząd / Osiedle): timeout 10s w `EstateCubit` + lazy-load (nie odpala się przy rejestracji).
- ✅ Root cause C: PostgREST był 503 (PGRST002, schema cache). Wymagał restartu Supabase z dashboardu.
- ✅ A: redesign bottom nav mieszkańca (5 ikon: Home / Zgłoszenia / [+] / Telefon / Profil). Brak zakładki Komunikator.
- ✅ A: usunięto duplikaty CTA „Dodaj zgłoszenie" z Home i Reports tab.
- ✅ B2: auto-nawigacja na Zgłoszenia po wysłaniu.
- ✅ Welcome: dwa równe przyciski (gradient „Rozpoczynamy" → Login; inverse „Zarejestruj" → guest).
- ✅ Lock screen + dashboard: „Kładka" → „Klatka" we wszystkich PL stringach.
- ✅ Profil: „Adres zweryfikowany" → „Adres zamieszkania"; usunięta duplikacja `Budynek Budynek 1 · Kładka Kładka A …`.
- ✅ Profil: sekcja Kontakt/Wsparcie z `mailto:aivolux@gmail.com` (subject + body z user info).

## 🔴 Pilne / wstrzymane (wymagają decyzji)

### J. Bug B (zgłoszenie nie pojawia się na liście) — DO POWTÓRNEGO TESTU
Diagnoza: w DB (`fixflow_reports`) są tylko seed-data (`r1..r7`). Insert mieszkańca nie dotarł.
Przyczyna: podczas testów PostgREST był 503 → remote INSERT silenty zfailował, lokalny cache potem
mógł zostać nadpisany przez `refreshReports` (clearCache + remote bez nowego). Teraz PostgREST działa
— **proszę powtórzyć test dodania zgłoszenia jako mieszkaniec** i powiedzieć czy widać na liście.

### K. Email+hasło dla rejestracji mieszkańca — DECYZJA
Obecnie tylko anonymous auth (`signInAnonymously()`). User chce żeby mieszkaniec podawał e-mail
przy rejestracji (żeby wracać po wylogowaniu). Implikacja:
- Welcome → "Zarejestruj" → ekran rejestracji `email + hasło + imię`
- `auth.signUp(email, password)` zamiast anon
- `email_confirm` w Supabase auth = false (na MVP) lub magic link?
- OnboardingFlow: po rejestracji → profil → kod zaproszenia → osiedle
- Proponowane: zostawić `Continue as guest` dla pierwszego logowania, ale dodać alternatywną ścieżkę
  „Zarejestruj z e-mailem" obok. Sam guest może później upgrade'ować przez `auth.updateUser()`
  (zgodnie z `AGENTS.md` Auth section).

### L. Kod zaproszenia w profilu (nie przy rejestracji) — DECYZJA
Obecnie kod jest polem w `LockScreen` (formularz weryfikacji profilu). User chce go przenieść
do profilu jako pole „Dołącz do osiedla". Implikacja:
- Profil mieszkańca: nowa sekcja „Osiedle: (Twoje osiedle / Wpisz kod aby dołączyć)"
- Po wpisaniu kodu → RPC `fixflow_redeem_invitation_code(p_code)` (już istnieje)
- Rejestracja przestaje wymagać kodu — sam profil bez osiedla jest dozwolony do czasu wpisania kodu

### M. Pole telefonu w profilu mieszkańca — schemat
- Dodać `phone` do `fixflow_resident_profiles` (kolumna `phone TEXT`).
- UI: pole telefonu na ekranie rejestracji / w profilu.
- Lista mieszkańców u admina: pokazać telefon obok imienia.

### N. Spięcie zakładki „Mieszkańcy" (admin) z profilami mieszkańców
Obecnie zakładka Mieszkańcy u admina jest pusta. Powinna pokazywać mieszkańców powiązanych
z osiedlem admina przez `fixflow_user_estates`. JOIN: `fixflow_user_estates` ↔ `fixflow_resident_profiles`
filter po `estate_id` = aktywne osiedle admina. RLS musi pozwolić adminowi czytać profile
mieszkańców z jego osiedla (obecnie tylko własny profil — `Users can read own profile`).

---

## Priorytety dla sesji 4

1. **J** — retest bugu B (klient bez zmian, tylko sprawdzić).
2. **N** — spięcie Mieszkańcy ↔ Profile (RLS + JOIN + UI). Bez tego admin niczego nie widzi.
3. **M** — telefon w profilu (mała migracja + UI). Niski risk.
4. **K** — rejestracja email+hasło (duża zmiana, wymaga osobnej sesji).
5. **L** — kod w profilu (zależne od K, bo zmienia onboarding).
6. **D** — tłumaczenia EN/UK (kolejne partie, jak będzie czas).

## Priorytety dla sesji 3 (po powrocie użytkownika)

Kolejność proponowana (od najszybszych/najmniej ryzykownych do większych):

1. **C** – fix crash Zarząd na zakładce Osiedle (blocker dla profilu Zarząd).
2. **B** – bug „dodane zgłoszenie nie widoczne" + auto-nawigacja po dodaniu.
3. **A** – redesign bottom nav mieszkańca (usunięcie Komunikator, duży „+", usunięcie „Dodaj" z Zgłoszenia).
4. **B (pole „okno")** – zamiana na właściwe pola lokalizacji z profilu.
5. **D** – audyt + pierwsza partia tłumaczeń EN/UK (dashboard mieszkańca).
6. **H** – Trello Edge Function + UI admina (Prio 2 oryginalny).
7. **E** – polityka sesji (decyzja + ewentualny kod).

DO POTWIERDZENIA z użytkownikiem PRZED STARTEM sesji 3: czy idziemy w tej kolejności.

---

## ✅ Zrobione w sesji 2026-06-24

- **Backup**: tag `working-app-backup-2026-06-24` + branch `backup/working-app-2026-06-24`.
  Przywrócenie: `git checkout backup/working-app-2026-06-24`.
- **Fundament osiedla (estate)**:
  - DB: `fixflow_estates` (z polami Trello), `fixflow_user_estates` (user↔osiedle + rola),
    `estate_id` w `fixflow_emergency_contacts`, `fixflow_buildings`, `fixflow_invitation_codes`.
  - RPC: `fixflow_create_estate`, `fixflow_create_estate_invitation_code`, `fixflow_redeem_invitation_code`.
  - RLS per-osiedle dla kontaktów + helpery `fixflow_is_estate_member` / `fixflow_is_estate_admin`.
  - Feature `lib/features/estate/`: model, data source, repository (streamy), `EstateMembershipCubit` + testy.
  - UI: `EstateOnboardingScreen` (dołącz kodem / załóż osiedle), `EstateManagementScreen` (generuj/kopiuj kod).
- **Kontakty per-osiedle**:
  - Naprawiony bug zapisu: model wysyłał `displayOrder/isActive` zamiast `display_order/is_active`
    (dodane `@JsonKey` snake_case). To była realna przyczyna „nie zapisuje".
  - `ContactsCubit` subskrybuje aktywne osiedle i filtruje kontakty po `estate_id`.
- **Profil → Kontakt/Wsparcie**: `mailto:aivolux@gmail.com` z tematem + stopką (User ID).
- **l10n**: nowe klucze estate/support w `pl/en/uk`.

---

## 🔴 Priorytet 1 – dokończyć przepływ osiedla (krytyczne dla per-estate)

### 1.1 Gating osiedla w `AppGate`
Po zalogowaniu, jeśli user nie należy do żadnego osiedla → pokaż `EstateOnboardingScreen`.
- UWAGA: istnieje już flow weryfikacji profilu (`LockScreen`, `fixflow_resident_profiles.is_verified`)
  obsługiwany w `HomeScreen`. Trzeba zdecydować kolejność: **osiedle → profil/weryfikacja → home**.
- Ryzyko: nie zepsuć obecnej weryfikacji. Najpierw przemyśleć interakcję obu mechanizmów.
- Plik: `lib/app/router/app_gate.dart` + nowy `EstateGate`.

### 1.2 Powiązanie zgłoszeń (reports) z osiedlem
- Dodać `estate_id` do `fixflow_reports` i filtrować zgłoszenia per-osiedle.
- Migracja danych istniejących 7 zgłoszeń (przypisać do domyślnego osiedla lub zostawić NULL).

### 1.3 Migracja istniejących danych do osiedla
- Obecne `fixflow_buildings` (3), `fixflow_stairwells` (6), kontakty (8), kody (30) mają `estate_id = NULL`.
- Stworzyć „domyślne osiedle" i podpiąć istniejące dane, albo zacząć czysto.
- Decyzja użytkownika wymagana.

---

## 🟠 Priorytet 2 – Trello (bezpieczne, docelowe rozwiązanie)

### Obecny stan (do zmiany)
- KAŻDY user wpisuje klucze Trello w `dashboard_screen.dart` i trzyma w `shared_preferences`.
- Token Trello ląduje na urządzeniu mieszkańca → źle.

### Docelowy przepływ (uzgodniony z użytkownikiem)
1. **Administrator osiedla** zakłada konto/tablicę na Trello i pobiera 3 dane:
   - **API Key**: https://trello.com/app-key
   - **Token**: wygenerowany z tej samej strony (link „Token")
   - **List ID**: ID listy/kolumny „Nowe zgłoszenia" (z URL karty lub API `/1/boards/{id}/lists`)
2. Admin wpisuje je RAZ w aplikacji → zapis do `fixflow_estates.trello_*` (już gotowe pole + `EstateDataSource.updateTrelloConfig`).
3. Mieszkaniec rejestruje się kodem → dostaje `estate_id` → jego zgłoszenia trafiają na tablicę osiedla.
   Mieszkaniec NIE widzi i NIE konfiguruje Trello.

### Zadania
- [ ] UI: ekran konfiguracji Trello dla admina (3 pola + zapis przez `EstateRepository.updateTrelloConfig`).
- [ ] **Supabase Edge Function `fixflow_create_trello_card`** – wywołania Trello API po stronie serwera,
      żeby token nie był w aplikacji mieszkańca. Function czyta `trello_*` z `fixflow_estates`
      na podstawie `estate_id` zgłoszenia. (Deploy TYLKO tej funkcji.)
- [ ] Przepiąć `reports_repository.dart` (obecnie woła `trello_service.dart` lokalnie) na Edge Function.
- [ ] Usunąć stary `trello_service.dart` + pola w `dashboard_screen.dart` po migracji.

---

## 🟠 Priorytet 3 – Tłumaczenia EN/UK (duży, żmudny task)

### Stan
- Fundament gotowy: `l10n.yaml`, ARB `pl/en/uk`, `context.l10n`, wybór języka na Welcome i w Profilu.
- PROBLEM: mnóstwo tekstów hardcodowanych po polsku, zwłaszcza w
  `lib/features/reports/presentation/ui/dashboard_screen.dart` (~2700 linii) i innych ekranach.

### Zasada (uzgodniona)
- Wybór języka przy rejestracji/logowaniu steruje CAŁYM UI.
- **Komunikaty błędów / `errorKey` zostają mapowane jak dziś** – ale teksty użytkownika mają być tłumaczone.
- Język domyślny: polski; dostępne en, uk.

### Zadania
- [ ] Audyt hardcoded stringów (grep po polskich literałach w `lib/features/**/ui/**`).
- [ ] Przenieść do ARB (pl/en/uk) i użyć `context.l10n`.
- [ ] Priorytet ekranów: dashboard (reports), formularz zgłoszenia, residents, announcements.
- [ ] `flutter gen-l10n` po każdej partii.

---

## 🟡 Priorytet 4 – Responsywność i adaptacyjność (RWD dla mobile)

### Rekomendacje (na podstawie wytycznych użytkownika)
- **Responsywność**: `LayoutBuilder` / `MediaQuery` (np. `width > 600` → tablet, 2 kolumny kart).
  `Flexible`/`Expanded`, `FractionallySizedBox`, `AspectRatio`.
- **Adaptacyjność**: `Switch.adaptive`, `CircularProgressIndicator.adaptive` (iOS Cupertino / Android Material).
- **SafeArea**: audyt wszystkich ekranów (notch, wyspa, paski). Część ekranów już ma `SafeArea`.
- **flutter_screenutil**: OPCJONALNIE. Rekomendacja: NIE wprowadzać teraz globalnie (duży refactor, ryzyko).
  Rozważyć tylko jeśli pojawią się realne problemy ze skalowaniem na małych/dużych ekranach.

### Zadania
- [ ] Audyt SafeArea na wszystkich Scaffold.
- [ ] Zamiana kluczowych widgetów na `.adaptive`.
- [ ] Breakpoint tablet dla list/kart (np. GridView 2 kolumny > 600px).

---

## 🟡 Priorytet 5 – Persystencja sesji / „pamiętaj telefon"

### Stan (w dużej mierze już działa)
- `supabase_flutter` domyślnie zapisuje sesję lokalnie i odświeża token (`main.dart` ma `refreshSession`).
- Anonymous user `user.id` jest stały między sesjami (RevenueCat `appUserID` też).

### Zadania (dostrojenie)
- [ ] Potwierdzić, że po restarcie telefonu user zostaje zalogowany (test manualny).
- [ ] Rozważyć politykę „wyloguj raz na kilka dni" – domyślnie Supabase trzyma sesję długo;
      jeśli chcemy wymuszać re-login, dodać sprawdzanie wieku sesji w bootstrapie.
      Rekomendacja: NIE wymuszać częstego wylogowania (UX), chyba że wymóg bezpieczeństwa.

---

## 🟢 Priorytet 6 – Higiena / dług techniczny

- [ ] **Dead code** w `dashboard_screen.dart:192,207` (ternary `isPro ?: _buildLockedTabPlaceholder`)
      – nieosiągalne, bo `isPro` ustawione na true do testów. Posprzątać przy włączaniu realnego Pro.
- [ ] **RLS hardening starych tabel** (advisors WARN): `fixflow_buildings`, `fixflow_stairwells`,
      `fixflow_invitation_codes`, `fixflow_announcements`, `fixflow_permissions` mają policy `USING(true)`
      / `WITH CHECK(true)`. Zawęzić do członków/adminów osiedla (po wdrożeniu gatingu osiedla).
- [ ] **Residents flow**: `fixflow_residents` + `validateInvitationCode/useInvitationCode/createResident`
      to dziś martwy kod (data layer bez UI). Zdecydować: scalić z `fixflow_user_estates` czy używać obu.
- [ ] **Auth leaked password protection** (advisor WARN) – włączyć w panelu Supabase Auth.
- [ ] **json_annotation** constraint `^4.11.0` – ostrzeżenie build_runnera, rozważyć bump.

---

## Pytania otwarte do użytkownika

1. **Migracja danych**: czy istniejące budynki/kontakty/kody podpiąć pod jedno „domyślne osiedle",
   czy zaczynamy czysto (admin zakłada osiedle od nowa)?
2. **Kody zaproszeń**: zostawiamy model „jeden wielokrotny kod na osiedle" (obecny), czy także
   kody jednorazowe per-mieszkanie? (DB wspiera oba – `building_id/stairwell_id/apartment_number`.)
3. **Gating osiedla vs weryfikacja profilu**: jaka kolejność ekranów po logowaniu?
4. **Trello**: czy wdrażamy Edge Function teraz (bezpiecznie), czy tymczasowo zostawiamy zapis konfiguracji
   per-osiedle bez serwera?

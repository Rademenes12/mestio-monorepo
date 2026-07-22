# Stan pracy z kursem

`STATE.md` jest źródłem prawdy o aktualnym etapie kursu.

Aktualizuj go tylko na starcie i końcu etapu.

## Aktualny stan

- Aktualny etap: `publish`
- Ostatni zakończony etap: `test`
- Tryb pracy: przygotowanie do publikacji aplikacji w sklepach App Store i Google Play

## Sesja 17 — Dokończenie zadań kodowych: H4, H5, H6, retry testy, podział dashboardu (2026-07-16)

### ✅ H4+H5 — fixflow-cleanup abort + FCM unsubscribe (commit `5a1f4b9`)
- `deleteAccount()`: jeśli `fixflow-cleanup` fail (nie-404), abort delete (nie kontynuuj)
- `FcmService.clearSubscriptions()` przed cleanup — żadne push notification nie
  trafi po usunięciu danych
- `FcmService` wstrzyknięty do `SupabaseAuthDataSource` przez DI

### ✅ H6 — Hardcoded PL stringi → l10n (commit `34dd8c9`)
- ~30 nowych kluczy ARB (PL/EN/UK): GPS, kontakt book, composer, building dialog,
  garage dialog, search hint, board notes, actions, reporter label, etc.
- Zastąpione w: `dashboard_screen.dart`, `report_detail_screen.dart`,
  `manager_report_card.dart`, `report_status_timeline.dart`, `residents_tab.dart`

### ✅ retry() testy — 4 Cubity (commit `30a3b2d`)
- `AnnouncementsCubit`: retry reload + retry error (2 testy)
- `MaintenanceCubit`: retry reload + retry error (2 testy)
- `ResolutionsCubit`: retry reload + retry error (2 testy)
- `ReportsCubit`: retry reload + no-op guard (2 testy)
- 8 nowych testów, 168/168 total

### ✅ Podział dashboard_screen.dart (commit `0452229`)
- 4651 → 1522 linii: 12 nowych plików + 1 utils w `widgets/`
- Wszystkie prywatne widgety → publiczne klasy
- analyze = 0, testy = 168/168

### Notatka: panel.mestio.pl
- To osobny projekt Next.js, poza tym repo Flutter
- Nie mam do niego dostępu z bieżącego workspace

---

## Sesja 16 — Audyt 360° + naprawa błędów + publikacja (2026-07-15)

### Kontekst
Użytkownik poprosił o pełny audyt 360° i naprawę wszystkiego co nie działa.
Uruchomiono 6 agentów mapujących cały ekosystem, potem 4 agentów QA testujących
aplikację z perspektywy każdej roli. Znaleziono i naprawiono 7 błędów.

### ✅ Faza 1 — Audyt 360° + dokumenty prawne (commit `0f1c8ed`)
- Privacy Policy + ToS jako HTML w `docs/legal/`
- GDPR Art. 20 Data Export (`DataExportCubit` + przycisk w Profilu)
- PUBLISH.md wypełniony (App Privacy, Data Safety, IARC, ASO)
- Brand unifikowany (FixFlow → Mestio)

### ✅ Faza 2 — PUBLISH.md ASO finalny (commit `6816590`)
- Optymalizacja ASO: keywords, opisy iOS/Android, screenshots plan
- Usunięte puste opcje, clean format

### ✅ Faza 3 — Naprawa błędów QA (commity `5fab381`, `70d0494`)

**Błędy krytyczne:**
- **FAB dla admin/zarząd**: usunięto `!isManager` — admin/zarząd może teraz
  tworzyć zgłoszenia jak każda rola
- **Feedback in-app**: zamiast `mailto:` wysyła przez `fixflow_feedback` (migracja
  0061: tabela + RLS). Admin/board widzą wszystkie zgłoszenia feedbacku.
- **Manager mobile**: 7 zakładek zamiast 5 (dodane: Ogłoszenia, Mieszkańcy,
  Osiedle). Funkcje wcześniej dostępne tylko w web CRM.
- **Serwisant "Odrzucone"**: usunięto z dropdown w portalu technika (był bypass
  `canReject` guarda)

**Błędy średnie:**
- **revealBoardNotesToTech**: technik widzi notatki zarządu gdy flaga włączona
- **Error handling w portalu technika**: zamiast wiecznego spinnera — komunikat
  błędu z przyciskiem Retry
- **Hardcoded stringi**: 15+ polskich stringów w `_profileTabView` do naprawy
  w kolejnej sesji (zmapowane, nie wszystkie naprawione)

### ⬜ Pozostałe

| # | Zadanie |
|---|---|
| **C5** | iOS signing — `DEVELOPMENT_TEAM` nadal pusty |
| **C8** | Screenshoty sklepowe |
| **Web** | Wdrożyć HTML na `mestio.pl` |
| **H5** | Push pending migrations na produkcję |
| **H6** | Hardcoded stringi PL → l10n (zmapowane ~20 lokalizacji) |

### ✅ Faza 4 — Security hardening (commit `1c3944d`)
- **B1**: "Message to Board" FAB — już nie TODO, otwiera kompozytor zgłoszenia
- **B2**: `removeReport` guard — tylko admin/zarząd lub własne zgłoszenie
- **B3/B7**: Technik nie może zamknąć zgłoszenia z portalu bez potwierdzenia
- **B4**: `setReportPriority`/`setReportCategory` — guard roli w cubit
- **B5**: `submitCsatRating` — tylko Mieszkaniec
- **B6**: FAB pokazuje SnackBar gdy brak aktywnego osiedla

### ✅ Faza 5 — L10n cleanup (commit `d16149b`)
- Danger zone section używa teraz `deleteAccountSectionTitle` i `deleteAccountPermanentWarning`
- Pozostałe hardcoded stringi (GPS, fallback name/email) — zmapowane do osobnego tasku

### Commity: `0f1c8ed`, `6816590`, `5fab381`, `70d0494`, `1c3944d`, `d16149b`

## Sesja 15 — Audyt ekosystemu + kompleksowe naprawy (2026-07-11)

### Kontekst
Użytkownik poprosił o pełną analizę stanu aplikacji i naprawę wszystkiego co się
da. Uruchomiono 6 agentów `explore` równolegle, każdy analizował inny aspekt
ekosystemu (architektura Flutter, Supabase, testy, CI/CD, UI/UX, bezpieczeństwo).
Na podstawie raportów zidentyfikowano i naprawiono problemy w 3 kategoriach.

### KRYTYCZNE — naprawione

- **Niespójność nazw pakietów** (com.pawelpasik.fixflow vs mestio):
  Firebase, Gradle, MainActivity.kt — zarejestrowano nowe aplikacje Firebase
  (`Mestio Android`/`Mestio iOS`) pod `com.pawelpasik.mestio`, pobrano nowe
  google-services.json/GoogleService-Info.plist, zaktualizowano
  firebase_options.dart, przeniesiono MainActivity.kt do poprawnego katalogu
  pakietu. Zweryfikowane: `flutter build apk --debug` — przechodzi.

- **Widmowe migracje Supabase** (0053/0054):
  Tabela `fixflow_resident_spaces` i funkcja `fixflow_estate_health_index` były
  oznaczone jako "applied" w historii migracji, ale NIGDY faktycznie nie
  wykonane na produkcji (ten sam wzorzec co trigger push notifications z sesji
  12 — `migration repair` bez wykonania SQL). Zweryfikowane przez
  `supabase db query --linked`. Odtworzone od zera w migracji 0058.

- **Funkcje SECURITY DEFINER** z `search_path = public`:
  `fixflow_report_content` (0027) i `fixflow_estate_health_index` (0054) —
  naprawione na `search_path = ''` + `public.`-qualified table refs w tej samej
  migracji 0058.

- **Bug w `_parseHealthColor`**: zmienna `raw` była nieużywana, kolor zawsze
  zwracał stałą `#FF` (nie ten hex co podano). Naprawione: `int.parse('FF$raw')`

- **Schema drift**: 3 kolumny istniały na produkcji, ale nigdy nie były w
  migracjach (`tech_notes`, `reveal_board_notes_to_tech`, `verification_code`).
  Dodane jako `ADD COLUMN IF NOT EXISTS` w migracjach 0059/0060.

- **Skradziony keystore**: plik `upload-keystore.p12` (SHA256 zgodny z
  `-COMPROMISED-DO-NOT-USE.p12`) usunięty z workspace root.

### WYSOKIE — naprawione

- **Testy Cubitów**: 22/22 (100%, wcześniej 15/22 = 68%). Dodano testy dla:
  `EstateCubit`(reports) 18 testów, `ConnectivityCubit` 5, `ResidentsCubit` 7,
  `ResidentSpacesCubit` 9, `ForgotPasswordCubit` 6, `ResetPasswordCubit` 10,
  `ReportContentCubit` 4. 160 testów łącznie (wcześniej 101), wszystkie
  przechodzą.

- **Bugfix przy pisaniu testu**: `ResidentsCubit` nigdy nie ładował danych
  gdy aktywne osiedle było `null` od startu (warunek `newEstateId !=
  _currentEstateId` był fałszywy bo oba były `null`). Dodano flagę
  `_hasLoadedOnce`.

- **Metody `Widget _buildX()`**: 0 w całym projekcie (wcześniej 17+).
  W dashboard_screen.dart wydzielono 8 nowych widgetów (`_LockedTabPlaceholder`,
  `_StairwellTile`, `_BuildingCard`, `_EstateContent`, `_ManagerEstateTab`,
  `_ReportTile`, `_ResidentReportsTab`, `_EstateSwitcherAppBar`),
  `_ManagerAnnouncementsTab` jako StatefulWidget. W pozostałych plikach
  rename z `_build*` na `_*`. Dashboard: 4623 → 4623 linii (samych linii
  nie ubyło, ale kod jest teraz w widgetach zamiast 12 metod).

- **l10n — hardcoded stringi**: ~50 naprawionych. Dodano ~60 nowych kluczy
  PL/EN/UK. Wszystkie 3 języki kompletne (bez ostrzeżenia `untranslated`).
  Naprawiono brakujący klucz `noReportsMatchingFilter` (uk).

- **SafeArea**: dodano `SafeArea(top:false)` do 4 ekranów auth (login/register/
  forgot_password/reset_password).

- **SnackBar dla błędów**: 3 miejsca zamienione na inline `SelectableText`
  (profile_screen, dashboard_screen, report_content_dialog).

### MEDIUM — naprawione

- **Sentry**: usunięte z pubspec.yaml (nigdy nie zainicjalizowane, Crashlytics
  już pokrywa crash reporting).
- **Dependabot**: `.github/` nie istnieje (zgłoszony przez CI/CD agenta),
  ale Dependabot był już skonfigurowany w sesji 12c.

### ŚREDNIE — zidentyfikowane, NIE naprawione (wymaga decyzji użytkownika)

- **iOS signing**: `DEVELOPMENT_TEAM=""`, Codemagic `--no-codesign`. Wymaga
  Apple Developer certyfikatów + App Store Connect API key.
- **Monolityczny `dashboard_screen.dart`**: wciąż 4623 linii w jednym pliku
  (ale metody `_buildX` już wyeliminowane, a wyodrębnione widgety nadal są
  w tym samym pliku zgodnie z AGENTS.md: "male prywatne widgety w tym samym
  pliku").

### ŚREDNIE — naprawione (sesja dodatkowa, po sesji 15)

- **`EstateRepository` duplicate**: `features/estate/` i `features/reports/`
  miały dwie różne klasy o identycznej nazwie `EstateRepository`/
  `EstateDataSource` (członkostwo w osiedlu vs. struktura budynków/klatek —
  różna funkcjonalność, tylko nazwa kolidowała). Przeniesiono wariant
  budynków/klatek do `features/estate/data/` jako `EstateStructureRepository`/
  `EstateStructureDataSource`; `features/reports` korzysta teraz z tej
  kanonicznej lokalizacji. Commit `5804450`.
- **`ContactsCubit` bypassuje Repository**: dodano `ContactsRepository`/
  `ContactsRepositoryImpl` (`lib/features/contacts/data/repositories/`),
  `ContactsCubit` wstrzykuje teraz repository zamiast `ContactsDataSource`
  bezpośrednio. Commit `8263dd3`.
- **Martwy kod**: usunięto `InvitationCode` (model) oraz
  `validateInvitationCode`/`useInvitationCode` z `ResidentsRepository`/
  `ResidentsDataSource` — zweryfikowano zero wywołań w całym repo przed
  usunięciem (zastąpione przez RPC `fixflow_redeem_invitation_code` z
  migracji 0045, używane via `EstateRepository.redeemInvitationCode()`).
  Commit `f5c2174`.
- Zweryfikowane: `flutter analyze` = 0 issues, `flutter test` = 160/160.

### ⬜ iOS .ipa + App Store (wymaga dostępu — pozostawione dla użytkownika)

- Skonfigurować `ios_signing` w Codemagic + Apple Developer certyfikaty
- App Store Connect API key
- Wypełnić PUBLISH.md (screenshots, Data Safety, kategorie)
- 5 screenshotów iOS + 4 Android

### Commity: `1d75682`..`bfd1959` (12 commitów)

> ## Na wznowienie — komenda `dalej` (2026-07-11)

### Zadania, które mogę zrobić samodzielnie

1. **Dokończyć podział `dashboard_screen.dart`** — przenieść wyodrębnione widgety
   do osobnych plików w `lib/features/reports/presentation/ui/widgets/`.
2. ✅ **`EstateRepository` duplicate naprawiony** — wariant budynków/klatek
   przeniesiony do `features/estate/data/` jako `EstateStructureRepository`
   (patrz sekcja "ŚREDNIE — naprawione" wyżej). Commit `5804450`.
3. **Dodać brakujące `retry()` scenariusze** do istniejących testów (8 Cubitów).
4. ✅ **Martwy kod usunięty** (`InvitationCode` model + `validateInvitationCode`/
   `useInvitationCode` z `ResidentsRepository`). Commit `f5c2174`.
5. ✅ **`ContactsRepository` dodany** — `ContactsCubit` wstrzykuje teraz
   repository zamiast `ContactsDataSource` bezpośrednio. Commit `8263dd3`.
6. **Dodać testy integracyjne** (jeśli user wyrazi zgodę — AGENTS.md zabrania
   bez zgody).
7. **Naprawić `fixflow_report_internal_notes.report_id`** — zmienić z TEXT na
   UUID (wymaga nowej migracji Supabase).
8. **Zaktualizować nieużywane skrypty seed** — `seed_demo_data.sql`,
   `seed_demo_account.sql` są niezgodne z aktualnym schematem.

### Zadania wymagające Twojego dostępu / decyzji

9. **iOS signing**: Skonfiguruj certyfikat Apple Developer, dodaj
   `DEVELOPMENT_TEAM` w `ios/Runner.xcodeproj/project.pbxproj`, dodaj
   `ios_signing` block w `codemagic.yaml`.
10. **App Store Connect API key**: Wygeneruj w App Store Connect → dodaj do
    Codemagic → dodaj `publishing.app_store_connect` w `codemagic.yaml`.
11. **Wypełnić `docs/PUBLISH.md`**: Screenshots (5 iOS + 4 Android), App Store
    category, Data Safety questionnaire, App Privacy details.
12. **Włączyć potwierdzanie emaila** w Supabase (Dashboard → Authentication →
    Sign In / Providers → Confirm email).
13. **Zweryfikować że `https://mestio.pl/privacy-policy` i
    `/terms-of-service` istnieją** (live URL).
14. **Unieważnić stary klucz Apple Sign In** jeśli nie został jeszcze
    zrotowany (Apple Developer → Keys → AuthKey_9WYFKJKCDC).
15. **Usunąć stare aplikacje Firebase**: `myapp (android)` i `myapp (ios)` z
    projektem `com.pawelpasik.fixflow` są już zbędne (nowe: `Mestio Android`/
    `Mestio iOS` pod `com.pawelpasik.mestio`). Firebase Console → Project
    settings → Your apps → usuń stare.

## Sesja 14 — Redesign z prototypu Mestio (2026-07-09)

### Kontekst
Użytkownik podał prototyp HTML nowego designu (`FixFlow.dc.html`, marka "Mestio").
Zrobiono pełne porównanie prototyp vs aplikacja (agent `explore`), potem wdrożono
cały zidentyfikowany braki zakres w podanej kolejności, małymi commitami z
`flutter analyze`/`flutter test` przed każdym.

### ✅ Zrobione w tej sesji
- **Uchwały (głosowanie)** — nowy feature end-to-end: migracja `0055`
  (`fixflow_resolutions` + `fixflow_resolution_votes`, RLS, RPC
  `fixflow_list_resolutions` z ukrytym tally do momentu głosu), feature Flutter
  (model/datasource/repo/cubit+testy/UI), nowa zakładka "Uchwały" dla
  mieszkańca i zarządu (mobile + web CRM sidebar)
- **Detal zgłoszenia**: wymóg wiadomości do mieszkańca przed zamknięciem/
  odrzuceniem (inline warning, nie snackbar); zmiana kategorii przez zarząd
  (`setReportCategory` + audit trail); sekcja PDF/załączników (naprawiono
  pre-existing bug — PDF trzymał lokalną ścieżkę urządzenia zamiast Storage)
- **Composer**: toggle "Oznacz jako pilne" (zarząd/administrator/ochrona,
  mapowany na `ReportPriority.high` + SLA), pole "Inne — informacja dla
  zarządu" (`additionalInfo`, wcześniej tylko w DB, nigdzie nieużywane)
- **Powiadomienia**: dzwonek w AppBar + panel wyprowadzony klient-side z
  już załadowanych zgłoszeń (bez nowej tabeli)
- **Feedback modal**: "Zgłoś uwagę" w profilu otwiera teraz modal z typami
  Błąd/Pomysł/Pytanie (wcześniej: goły `mailto:`)
- **Konserwacja prewencyjna**: nowy feature (tabela istniała od migracji
  `0021`, zero UI) + migracja `0056` naprawiająca DWA pre-existing bugi w
  RLS tej tabeli (polityka pisania łapała tylko `role='admin'`, wykluczając
  `board`/Zarząd; i brakował całkowicie `GRANT ... TO authenticated`)
- **Lista zgłoszeń**: liczniki na chipach filtrów, badge "Po terminie"
  (SLA overdue) i progress bar statusu na `ManagerReportCard`
- 7 commitów, wszystkie z testami cubitów (bloc_test/mocktail) i
  `flutter analyze` = tylko 4 pre-existing issues (niezmienione)

### ✅ Dogrywka — 3 pominięte różnice (ten sam dzień)
- **Czat vs notatki wewnętrzne**: rozdzielone na dwa osobne widgety —
  `CorrespondenceSection` (chat bubbles, wszyscy, zawsze `is_internal=false`)
  i `TeamNotesSection` (amber box, tylko staff, zawsze `is_internal=true`).
  Ten sam stream `fixflow_report_comments`, bez migracji. Usunięty stary
  `report_comments_section.dart`, podpięte w `report_detail_screen.dart`
  i `technician_portal_screen.dart`.
- **Galeria wielu zdjęć**: composer akumuluje zdjęcia (miniatury + usuwanie)
  zamiast zastępować jedno; pierwsze zostaje `photoPath` (cover, bez zmian
  gdzie indziej), reszta trafia do `fixflow_report_images` (migracja `0057`
  — naprawiono brak polityki INSERT dla mieszkańca, była tylko dla staffu).
  Nowy `_GalleryCard` w detalu zgłoszenia.
- **Target ogłoszeń ze struktury osiedla**: composer ładuje realne
  budynki/klatki (`EstateCubit`, ten sam lazy-load co zakładka Osiedle)
  zamiast hardcodowanej listy "Budynek 1/2/3, Klatka A/B/C". Zapisuje
  `scope_type/scope_building_id/scope_stairwell_id` (kolumny z migracji
  `0032`, nigdy wcześniej niezapisywane). Filtrowanie po stronie mieszkańca
  wg zasięgu NIE zaimplementowane (profile mieszkańców nadal wolny tekst
  lokalizacji, nie ID budynku/klatki) — udokumentowane w modelu.
- Dodane pierwsze testy `AnnouncementsCubit` (wcześniej 0 testów).
- Migracje `0055`-`0057` wdrożone na Supabase.

### ⬜ Świadomie odłożone (poza zakresem tej sesji)
- Struktura lokalizacji w rejestracji z prawdziwych danych osiedla (nadal
  hardcodowane listy budynków/klatek/pięter w `lock_screen.dart`)
- Filtrowanie ogłoszeń po zasięgu (scope) po stronie mieszkańca — wymaga
  najpierw powiązania profilu mieszkańca z `building_id`/`stairwell_id`
  zamiast wolnego tekstu
- `ProfileScreen` (bogaty, nieużywany plik) — pozostaje odłączony

## Sesja 13 — Do zrobienia na kolejną sesję (2026-07-06)

### ✅ Zrobione w tej sesji

- **Sign in with Apple**: usunięty martwy kod (cubit, repo, datasource, pubspec, entitlement)
- **Seed test users**: migracja `0052_seed_test_users.sql` — 5 kont testowych z profilami + osiedlem
- **Audyt 4-agentowy**: 3 role (bezpieczeństwo, RODO, release) + techniczny end-to-end
- **BLOKER B1-B3**: welcome_screen/register_screen/lock_screen — hardcodowane polskie stringi → l10n
- **BLOKER B3**: linki Privacy Policy + Terms of Service na Welcome screen
- **BLOKER B2**: register_screen consent z klikalnymi linkami (współdzielony ConsentText)
- **WYSOKIE H2**: `search_path = ''` w `fixflow_regenerate_invitation_code` (0041)
- Commity: `ed4e14c`, `f9d4c3c`, `48bf89d`

### ⬜ BLOKERY do zrobienia (poza kodem, wymagają dostępu)

| # | Zadanie | Opis |
|---|---|---|
| **B4** | iOS .ipa w CI | Skonfiguruj `ios_signing` w Codemagic + Apple Developer certyfikaty + App Store Connect API key |
| **PUB** | Wypełnić PUBLISH.md | Screenshots (5 dla iOS + 4 dla Android), Android kategoria/tagi, Data Safety questionnaire, App Privacy details dla iOS |

### ⬜ WYSOKIE do rozważenia

| # | Zadanie | Plik |
|---|---|---|
| **H4** | fixflow-cleanup failure → abort delete | `auth_data_source.dart:220-227` |
| **H5** | FCM unsubscribe przy delete account | `auth_data_source.dart:216` — dodać `fcmService.clearSubscriptions()` przed cleanup |
| **H6** | Wypełnić PUBLISH.md kwestionariusz prywatności | Brakuje: Physical Address, Precise Location, Photos, User ID |

### ⬜ ŚREDNIE (bezpieczeństwo/architektura, nieblokujące)

| # | Zadanie |
|---|---|
| **M3** | Skonsolidować dwa mechanizmy offline (outbox + isSynced) — ryzyko duplikatów zgłoszeń |
| **M5** | Ograniczyć UPDATE własnej roli w `fixflow_resident_profiles` (trigger lub column-level GRANT) |
| **M6** | Zacieśnić WITH CHECK w `reports_update_board` dla nieradminów |
| **M7** | Wyczyścić REVIEW_NOTES.md: usunąć SiwA, ujednolicić adres support |

### ⬜ PRZYPOMNIENIA (z wcześniejszych sesji)

- **Włączyć potwierdzanie emaila** w Supabase (Dashboard → Authentication → sign in/providers)
- Sprawdzić istnienie `https://fixflow.app/privacy-policy` i `/terms-of-service` (live URL-e)

## Sesja 12c — Przepisanie historii + rotacja klucza Android + RevenueCat safety net

Realizacja `FixFlow_WERYFIKACJA_4_DECYZJE.md` (folder wsadów 6).

### ✅ Punkt 1 — historia gita przepisana (zgoda użytkownika)
- Użyto **BFG Repo-Cleaner** (nie `filter-repo`/`filter-branch` — brak Pythona w środowisku,
  BFG zweryfikowany jako w pełni równoważny dla tego przypadku: usuwanie plików po nazwie)
- Backup: pracowano na `git clone --mirror`, oryginalne repo nietknięte do force-push
- Usunięte ze WSZYSTKICH branchy/tagów (main + 3 backup/feature branche + 4 tagi):
  `upload-keystore.p12`, `docs/APPLE_AUTH_CREDENTIALS.md`, `generate-apple-jwt.js`
- Force-push wykonany na `origin` (github.com/Rademenes12/zglosawarie)
- **Nowy SHA main po przepisaniu: `7b69e12`** (treść identyczna z poprzednim `8af09e3`,
  zmieniony tylko hash wskutek przepisania przodków)
- Zweryfikowane: `git log --all -- <plik>` = puste dla wszystkich 3 plików; próba dostępu do
  starego obiektu blob = `error: malformed object name` (fizycznie nieodzyskiwalne lokalnie)
- **Nowy keystore Android wygenerowany** (`upload-keystore-2026-07-04.p12`, RSA 2048,
  ważny do 2053) — odkryto, że aktywny keystore używany do buildów był TYM SAMYM plikiem
  co skompromitowany (identyczny rozmiar/data), więc samo przepisanie historii by nie
  wystarczyło. `android/key.properties` zaktualizowany, stary klucz oznaczony
  `-COMPROMISED-DO-NOT-USE`. Zweryfikowane: `.apk`/`.aab` budują się i są podpisane nowym
  certyfikatem (`CN=FixFlow`, nie starym `CN=Pawel`). Aplikacja nigdy nie była publikowana,
  więc nie jest wymagany "upload key reset" w Google Play Console.
- Klucz Apple Sign In: użytkownik zajmie się rotacją samodzielnie (nie wykonane przeze mnie)
- `codemagic.yaml` sprawdzony — odwołuje się tylko do zmiennych `CM_*` (Codemagic UI),
  nie do plików w repo, więc nie ma nieaktualnych referencji do naprawienia w kodzie;
  **przypomnienie**: jeśli w Codemagic UI był wgrany stary keystore jako sekret, trzeba
  go tam ręcznie podmienić (poza zasięgiem tej sesji)

### ✅ Punkt 2 — RevenueCat: zostaje, zabezpieczony przed przypadkowym włączeniem
- Nowy test `test/core/config/revenuecat_config_test.dart` — asercja że
  `RevenueCatConfig.fixflowB2bMode == true`; `codemagic.yaml` uruchamia `flutter test`
  przed każdym buildem, więc to realnie failuje CI przy próbie zmiany flagi
- `docs/DATA_SAFETY.md` doprecyzowany: jawna notatka że kod RevenueCat istnieje w repo
  (zamrożony na przyszłość), ale jest całkowicie wyłączony flagą — z odniesieniem do testu
  ochronnego (`docs/REVIEW_NOTES.md` miał już poprawny opis z poprzedniej sesji)

### ✅ Punkt 3 — Dependabot
- `.github/dependabot.yml` dodany (pub + github-actions, weekly). "Dependabot alerts"
  w ustawieniach repo włącza użytkownik ręcznie po swojej stronie.

## Sesja 12b — Wzmocnienie bezpieczeństwa (po audycie)

Kontynuacja Sesji 12 na prośbę "co proponujesz aby zwiększyć bezpieczeństwo".

### 🔴 Dodatkowy wyciek znaleziony i naprawiony
Podczas skanowania CAŁEJ historii gita (nie tylko bieżącego drzewa) pod kątem innych
sekretów poza kluczem keystore: **2 aktualnie śledzone pliki zawierały prawdziwy klucz
prywatny Apple Sign In** (`docs/APPLE_AUTH_CREDENTIALS.md`, `generate-apple-jwt.js` —
Key ID `9WYFKJKCDC`, Team ID `C56BBGX99U`, klucz .p8). Oba usunięte z drzewa (nie tylko
z historii — wciąż tam są, jak keystore). Dodano `*.p8`/`*_CREDENTIALS.*` do `.gitignore`.
Rekomendacja: unieważnić ten klucz w Apple Developer (Sign in with Apple i tak już usunięty
z apki, więc nie trzeba go zastępować).

### ✅ Wdrożone wzmocnienia (5 punktów z propozycji, za zgodą)
- Migracje `0047`-`0048`: **naprawa push notifications** (pg_net nie było włączone +
  zła autoryzacja + zły parsing klucza Firebase + **sam trigger w ogóle nie istniał
  w bazie** mimo migracji 0013 oznaczonej jako zastosowana — zweryfikowane end-to-end
  prawdziwym FCM messageId). Klucz service_role w Supabase Vault, nie w repo.
- Migracja `0049`: `REVOKE INSERT/UPDATE/DELETE/TRUNCATE` na `fixflow_subscriptions` dla
  `authenticated` (defense-in-depth, RLS już blokowało) + trigger anonimizujący
  `user_name`/`user_role` w `fixflow_report_events` po usunięciu konta
- Migracja `0050`: `fixflow_reports.reporter_user_id` (`DEFAULT auth.uid()`) — `fixflow-cleanup`
  usuwa teraz po stabilnym ID, nie tylko po e-mailu (zmiana e-maila nie zostawia już
  osieroconych danych po "Usuń konto")
- Migracja `0051`: `terms_accepted_at` w `fixflow_resident_profiles` + obowiązkowy checkbox
  zgody z klikalnymi linkami w `lock_screen.dart` (wcześniej zgoda była tylko w
  `register_screen.dart`, nigdy nie zapisywana do bazy)
- Re-autentykacja hasłem przed usunięciem konta (`AccountActionsCubit.deleteAccount`) —
  pomijana dla gości anonimowych (nie mają hasła), używa zwykłego `signInWithPassword`
  (nie zepsutego `reauthenticate()`/OTP)

### ⬜ Pozostało do Twojej decyzji
- Rotacja klucza keystore Android (Google Play Console → upload key reset)
- Unieważnienie klucza Apple Sign In (Apple Developer → Keys)
- Przepisanie historii gita, żeby trwale usunąć oba sekrety (destrukcyjne, force-push)
- Zawężenie GRANT-ów na pozostałych ~20 tabelach `fixflow_*` (wszystkie mają pełne
  uprawnienia ALL dla `authenticated`, RLS je gates — zrobione tylko dla `fixflow_subscriptions`
  jako najbardziej oczywisty przypadek; reszta wymaga analizy per-tabela żeby nie zepsuć
  realnych zapisów klienta)

## Sesja 12 — Wsady FixFlow (kroki 1-2) + audyt 3-rolowy + krytyczne naprawy

### Kontekst
Realizacja planu z 4 folderów wsadów (`C:\Users\fortu\OneDrive\Desktop\wsad\Nowy folder (5)\1-4`),
zgodnie z ustaloną kolejnością (krok 1 → krok 2 → krok 3), plus CRM web (decyzja: Flutter Web
w tym samym repo) i pełny audyt 3-rolowy przed publikacją. Sesja przebiegła bez nadzoru
("wychodzę, zrób ile się da") — commity małe, każdy z `flutter analyze`/`flutter test` przed.

### ✅ Krok 1 — MASTER_BUILD (zrobione)
- Migracja `0044`: estate lifecycle (`status`, `owner_company_id`, `fixflow_estate_active()`)
- Serwisant: 3 zakładki (Pulpit·Kontakty·Profil) + l10n zamiast hardcoded stringów
- Zarząd mobile: odchudzony do 4 zakładek; **CRM web** (sidebar `_CrmSidebar`, `kIsWeb`) przejmuje
  Komunikaty/Mieszkańcy/Osiedle na przeglądarce
- Upgrade zależności pod Flutter Web: Firebase (core 4/messaging 16/crashlytics 5), geolocator 14,
  file_picker 8.3 (stare wersje używały `dart:html`/`package:js`, niekompatybilne z Flutter 3.44 web)
- 2 bugfixy profilu: `ResidentProfileModel` tolerancja NULL dla ról biurowych (były `required
  String`), `ReportsRepository.getResidentProfile` zmieniony z cache-first na remote-first
  (stary cache nigdy nie widział zmian roli/weryfikacji z serwera)

### ✅ Krok 2 — Rejestracja + kody per rola (zrobione)
- Migracja `0045`: kody per rola (resident/technician/security/admin/board), `fixflow_join_requests`,
  limity (admin/board ≤5, resident ≤4/lokal), `fixflow_peek_invitation_code`,
  redeem v2 zwraca `{status: joined|pending}`, `fixflow_approve/reject_join_request`
- `fixflow_is_estate_admin` naprawiony: tylko admin/board = biuro (było: każdy != resident)
- `lock_screen.dart` przepisany: rola **zawsze z kodu**, nie z dropdowna (zamykał lukę
  "każdy może się mianować zarządem"); ekran "Oczekuje na akceptację" dla ról biurowych
- CRM web: karty kodów per rola (kopiuj/rotuj) + lista próśb o dołączenie (akceptuj/odrzuć)
- Migracja `0046`: countdown umowy ("Umowa aktywna do") w profilu, z `v_fixflow_estate_contract`
  (wąski widok, bez ID Stripe dla zwykłych mieszkańców)

### ✅ Szybkie poprawki
- Usunięty przycisk "Sign in with Apple" z Welcome (na życzenie)
- Dodany brakujący przycisk "Kontynuuj jako gość" (był w `AGENTS.md`/l10n, ale nigdy niepodłączony
  pod UI — martwy kod `WelcomeCubit.continueAsGuest()`)

### 🔴 Audyt 3-rolowy (bezpieczeństwo/RODO/release) — krytyczne naprawy
Pełny audyt z realnymi testami SQL/REST (nie tylko przegląd kodu). Wyniki:

**RLS i izolacja najemcy — CZYSTO.** Test wycieku (mieszkaniec osiedla A → dane osiedla B):
0 wierszy przy SELECT, 0 zmian przy UPDATE/DELETE. Wszystkie tabele `fixflow_*` mają RLS,
zero polityk `qual=true`. Wszystkie funkcje `SECURITY DEFINER` mają `search_path`. Storage
prywatny + polityki po `estate_id` w ścieżce. `fixflow_subscriptions` niezapisywalne przez
`authenticated` (RLS, mimo szerokich GRANT-ów - do doprecyzowania kiedyś, niski priorytet).

**🔴 KRYTYCZNY BUG (naprawiony, migracje `0047`-`0048`): push notifications nigdy nie działały.**
Łańcuch 4 niezależnych błędów: (1) `pg_net` nigdy nie było włączone, (2) funkcja wysyłała
`anon key` zamiast tokenu użytkownika/service_role — Edge Function wymaga realnej sesji,
(3) parsowanie klucza prywatnego Firebase padało na literalnych `\n`, (4) **sam trigger
`fixflow_report_change` w ogóle nie istniał w bazie** mimo że migracja 0013 była oznaczona
jako "applied" (prawdopodobnie `migration repair` z Sesji 9 zsynchronizowało historię bez
wykonania SQL). Naprawione i zweryfikowane end-to-end (realny INSERT zgłoszenia → prawdziwy
FCM messageId). Klucz service_role przechowany w Supabase Vault (nie w repo).

**🔴 BLOKER bezpieczeństwa (częściowo naprawiony): `upload-keystore.p12` był zacommitowany
w Git i wypchnięty na GitHub.** Zdjęty ze śledzenia + `.gitignore` (`*.p12`, `key.properties`),
ale **wciąż jest w historii commitów** — wymaga Twojej decyzji: (a) rotacja klucza w Google
Play Console ("upload key reset"), (b) czy przepisywać historię gita (force-push, niszczące).

**Znaleziska WYSOKIE (niezaimplementowane, wymagają Twojej decyzji):**
- `codemagic.yaml` nie produkuje podpisanego `.ipa` (tylko niepodpisany `.app`) — potrzebne
  certyfikaty Apple Developer w Codemagic, nie mam do nich dostępu
- Brak zrzutów ekranu / store metadata (fastlane, screenshots)
- `RevenueCat`/przycisk "Kup Pro" w pełni zaimplementowany, zablokowany jedną flagą
  (`RevenueCatConfig.fixflowB2bMode`) — ryzyko jeśli ktoś ją kiedyś przełączy
- `fixflow_reports` czyszczone przy usuwaniu konta po `reporter_email` (tekst), nie po
  stabilnym ID — zmiana e-maila może zostawić osierocone zgłoszenia
- `lock_screen.dart` (zbiera imię/telefon/adres) nie ma odniesienia do zgody RODO — zgoda
  jest tylko w `register_screen.dart`, bez trwałego zapisu daty/faktu w bazie

**Naprawione podczas audytu:** sprzeczności w `DATA_SAFETY.md` (retencja: "natychmiast" vs
"90 dni"), nieaktualne `REVIEW_NOTES.md`/`PUBLISH.md` (martwy guest button, zły format kodu,
stare wersje iOS/Android, fałszywe "brak wersji web"), `--obfuscate --split-debug-info`
dodane do CI, `CFBundleLocalizations` uzupełnione o en/uk.

### ⬜ Nie zrobione w tej sesji (świadomie odłożone)
- Krok 3 pełne wdrożenie `FixFlow_AKTYWACJA_KONTA.md` — w większości dotyczy osobnej strony
  WWW (Next.js), poza zakresem tego repo Flutter
- Rotacja klucza keystore + decyzja o przepisaniu historii git (wymaga Ciebie)
- Podpisywanie iOS w CI (wymaga certyfikatów Apple Developer)
- Zrzuty ekranu / dokończenie `docs/PUBLISH.md` (kategorie, Data Safety questionnaire)
- Migracja `reporter_email` → stabilny `reporter_user_id` w `fixflow_reports`

### 🔄 SESJA — WZNOWIENIE (komenda `dalej`)

### Kontekst
Przeprowadzono pełny audyt aplikacji (3 role: inżynier bezpieczeństwa, radca prawny/RODO,
release manager). Naprawiono **2 BLOKERY + 7 HIGH + 5 MEDIUM**. Build release z R8 działa
(67.1MB), `flutter analyze` = 0 issues, testy 72/72.

### ✅ Naprawione (zacommitowane)
- BLOKER: wersja `1.0.0+1` (`pubspec.yaml`)
- BLOKER: `codemagic.yaml` (CI/CD: analyze+test+.aab+.ipa)
- HIGH #1: `retry()` na `getRemoteReports` (reliability)
- HIGH #2: `fcm_service.dart` wysyła JWT sesji (nie anon key)
- HIGH #3: limity zapytań (reports 500, announcements 200, residents 1000)
- HIGH #4: 6 metod `reports_cubit.dart` emituje `errorKey`
- HIGH #5: migracja `0034` — report_images resident SELECT + DELETE policies
- HIGH #6: checkbox zgody TOS/Privacy w `register_screen.dart`
- HIGH #7: migracja `0035` — `fixflow_blocked_users` + UI blokowania w report_content_dialog
- MEDIUM: `SET search_path` na 3 funkcjach (0031, 0032)
- MEDIUM: `fixflow-cleanup` kasuje `content_reports`
- MEDIUM: konflikt polityk `report_comments` (0034)
- MEDIUM: R8 minifikacja + `proguard-rules.pro`
- FIX: Kotlin build — przywrócony KGP 2.2.20 (built-in Kotlin niekompatybilny)

### ⏳ POZOSTAŁO DO ZROBIENIA — wdrożenia (wymagają dostępu do Supabase/Codemagic)

**Wdrożenia Supabase (push migracji):**
1. ⬜ Wdrożyć migracje `0029`–`0041` na Supabase (`supabase db push`)
2. ⬜ Deploy `fixflow-cleanup` Edge Function (kasuje content_reports)
3. ⬜ Zweryfikować `https://fixflow.app/privacy-policy` i `/terms-of-service` istnieją (live)
4. ⬜ Podpiąć `codemagic.yaml` do Codemagic + wpisać sekrety

### ✅ Zrobione — audyt + CRM (sesja bieżąca)

**Audyt (STATE.md 5-10):**
5. ✅ `docs/DATA_SAFETY.md` — zaktualizowany do natychmiastowego kasowania (GDPR)
6. ✅ URL mismatch `REVIEW_NOTES.md` — `/terms` → `/terms-of-service`
7. ✅ `com.android.vending.BILLING` usunięty z AndroidManifest
8. ✅ `runZonedGuarded` w `main.dart` (async errors → Crashlytics)
9. ✅ Filtrowanie zablokowanych userów w listach komentarzy
10. ✅ `authorId` wpięty do `showReportContentDialog`

**CRM — rezygnacja z Trello + Firma/Umowa/Kod:**
- ✅ Usunięty Trello: model, datasource, repository, service, UI, DI
- ✅ Nowa sekcja Firma/Umowa/Kod w Profilu (`_EstateCompanySection`)
- ✅ Estate model rozszerzony o `company_name`, `admin_name/email/phone`, `hide_resident_contacts`
- ✅ Migracje `0038` (nowe kolumny), `0039` (drop `fixflow_estate_secrets`)
- ✅ RODO toggle: `hide_resident_contacts` + kolumnowa funkcja maskująca (`0040`)
- ✅ Kod zaproszenia bezterminowy + regeneracja (`0041`)

## ⚠️ PRZYPOMNIENIE PRZED PUBLIKACJĄ

**Włączyć potwierdzanie emaila w Supabase:**
- Dashboard → Authentication → Sign In / Providers
- Włączyć toggle "Confirm email"
- To zapewni że użytkownicy potwierdzą email przed pierwszym logowaniem
- **Status: WYŁĄCZONE na czas testów**

## Etapy

| Status | Etap | Plik komendy |
| --- | --- | --- |
| `✅ done` | `init` | `docs/commands/00_init.md` |
| `✅ done` | `start` | `docs/commands/01_start.md` |
| `✅ done` | `home` | `docs/commands/02_home.md` |
| `✅ done` | `redesign` | `docs/commands/03_redesign.md` |
| `✅ done` | `plan` | `docs/commands/04_plan.md` |
| `✅ done` | `build` | `docs/commands/05_build.md` |
| `✅ done` | `test` | `docs/commands/06_test.md` |
| `🟡 in-progress` | `publish` | `docs/commands/07_publish.md` |
| `⬜ not-started` | `onboarding` | `docs/commands/08_onboarding.md` |
| `⬜ not-started` | `limits` | `docs/commands/09_limits.md` |
| `⬜ not-started` | `revenuecat` | `docs/commands/10_revenuecat.md` |
| `⬜ not-started` | `review` | `docs/commands/11_review.md` |
| `⬜ not-started` | `finalize` | `docs/commands/12_finalize.md` |

## Sesja 8 — Fazy 0-4 (zakończone)

### Faza 0 — Fundament ✅
- Backup bazy + migracje w repo (`supabase/migrations/`)

### Faza 1 — Bezpieczeństwo bazy ✅
- `estate_id` na `fixflow_reports` + RLS per-osiedle
- RLS na `fixflow_buildings`, `fixflow_stairwells`, `fixflow_invitation_codes`
- Widok `v_fixflow_residents_by_estate`
- Bucket `fixflow-report-photos` (private)
- FK + RLS na `fixflow_report_comments`, `fixflow_report_images`
- `fcm_token` na `fixflow_resident_profiles`

### Faza 2 — Rdzeń produktu ✅
- `assigned_to_user_id` na `fixflow_reports` (przypisanie do technika)
- Zdjęcia w Supabase Storage + signed URLs
- Status jako enum (`new/in_progress/closed/rejected`) + `ReportStatus` w Dart
- UI refaktoryzowany na `resolvedStatus`

### Faza 3 — Niezawodność ✅
- `lib/core/reliability/` — `reliability_core.dart`, `connectivity_service.dart`, `app_bootstrap.dart`, `report_outbox.dart`
- Crashlytics error handler w `main.dart`
- `ReportOutbox` podpięty do `ReportsCubit` (offline-first)
- Edge Function `send-notification` (FCM push)

### Faza 4 — Blokery sklepów ✅ (częściowo)
- Edge Function `fixflow-cleanup` (usuwa wszystkie dane usera przed `delete-account`)
- Purpose strings iOS (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSLocationWhenInUseUsageDescription`)
- Android permissions (`CAMERA`, `LOCATION`, `READ_MEDIA_IMAGES`, `POST_NOTIFICATIONS`)

### Do dokończenia przed publish:
- ✅ Deploy Edge Functions (`send-notification`, `fixflow-cleanup`, `delete-account`) — **wszystkie 3 ACTIVE**
- ✅ Firebase credentials w Supabase secrets (`FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`)
- ⏳ Moderacja treści + zgłaszanie (duży feature)
- ⏳ App Privacy labels + Data Safety (konfiguracja w Store Console)
- ⏳ Demo accounts w notatkach recenzji

## Sesja 9 — notatka do wznowienia (komenda `dalej`)

### Zadania bazowe (zakończone ✅)
1. ✅ Migracja 0014 wdrożona na Supabase (polityki RLS dla `fixflow_reports`, `fixflow_report_comments`, `fixflow_report_images`).
   - Historia migracji zsynchronizowana (`migration repair` 0001–0014).
   - Usunięto stare konfliktujące polityki (`reports_update_board`, `reports_update_assigned_tech`, `report_images_*_estate_members`).
2. ✅ Cold start aplikacji na emulatorze Android (`Pixel 4`).
3. ✅ Test dodawania zgłoszenia przez Ochronę — **działa przez REST API**.
   - Testowe konto: `ochrona.api.test@example.com` / `TestOchrona123!`, rola `Ochrona`, osiedle `FixFlow QA`.
   - Testowe zgłoszenie: `test-report-ochrona-001` w bazie.
4. ✅ Naprawiono bug: `EstateMembershipCubit` w `HomeScreen` był leniwy → aktywne osiedle nie było ładowane. Fix: `lazy: false`. Commit `ca46ead`.

### Konfiguracja MCP (w tle)
- ✅ Nowy token Supabase wpisany do `.mcp.json`.
- ✅ Klucz Firebase service account skopiowany do `keys/` (w `.gitignore`).
- ✅ `firebase-mcp-server` skonfigurowany w `.mcp.json` i w `C:\Users\fortu\.antigravity\mcp_config.json`.
- ⏳ **Po restarcie Antigravity IDE sprawdzić, czy błędy MCP zniknęły.**

### Wdrożenie redesignu z `docs/redesign_blueprint.md`
**Commit `a65d861` — zrobione:**
- ✅ Ukrycie ustawień Trello dla ról 非 Zarząd/Administrator.
- ✅ Dynamiczne avatary z inicjałami (dashboard_screen.dart, technician_portal_screen.dart).

**Sesja 10 — zrobione:**
1. ✅ Podział `dashboard_screen.dart` na tabsy (`resident_home_tab.dart`, `manager_home_tab.dart`, `security_dashboard_tab.dart`)
   - Commit `effb841`
2. ✅ 3-krokowy stepper w `lock_screen.dart` (krok lokalizacji tylko dla Mieszkańca)
   - Commit `d2a6fca`
3. ✅ Ujednolicenie nazw statusów przez l10n we wszystkich widokach
   - Commit `ebdf9ad`
4. ✅ Ujednolicenie tła (`AppColors.lightCanvas`), kart, avatara (auth screens + technician portal)
    - Commit `f9cb56c`

## Sesja 11 — Implementacja planu redesignu (zrobione ✅)

### Faza 1: Design System ✅
- Paleta kolorów, fonty offline, `AppTheme` z fontami
- `ReportStatus.color` na nowe tokeny

### Faza 2: Migracja DB ✅
- `0020_fixflow_report_enhancements.sql` (priority, sla_deadline, csat_rating, audit_trail, company_name)
- `ReportPriority` enum z SLA, `ReportModel` rozszerzony, `companyName` w profilu

### Faza 3: Nawigacja ✅
- FAB (azure→blueprint) zamiast dummy tab dla Mieszkańca/Ochrony
- Zarząd: tab Zgłoszenia, kontakty w Profilu

### Faza 4: Rejestracja ✅
- `companyName` w lock_screen dla Serwisanta

### Faza 5: Widok szczegółów zgłoszenia ✅
- `ReportDetailScreen` (stepper, priorytet/SLA, CSAT, audit trail, komentarze, akcje)
- `setReportPriority` + `submitCsatRating` w cubit
- L10n keys PL/EN/UK + onTap we wszystkich listach
- Commity: `ea200a0`

### Faza 6: Struktura osiedla ✅
- Migracja `0021` (building_type, maintenance_schedules z RLS)
- `buildingType` w BuildingModel, isGarage getter
- UI: ikona garażu, odznaka GARAŻ, osobne "+ Budynek"/"+ Garaż"
- Commity: `51648da`

### Do wdrożenia na Supabase:
- ⬜ Migracja `0020` — push na produkcję
- ⬜ Migracja `0021` — push na produkcję

**Sesja 10 — kontynuacja (testowanie + bugfixy):**
1. ✅ Ulepszony dialog Dodaj kontakt — lepsze opisy pól + opcjonalny e-mail.
   - Commit `301bae1`
2. ✅ Fix: rola staffu (`Administrator`, `Zarząd`, `Serwisant`, `Ochrona`) była zapisywana dosłownie w `fixflow_user_estates.role`, przez co RLS dla admina nie przepuszczała. Teraz staff dostaje `admin`, a `Mieszkaniec` dostaje `resident`.
   - Commit `21bf166`
3. ✅ Fix: serwisant nie widział zgłoszeń — portal technika teraz pokazuje też nieprzypisane zgłoszenia serwisowe i automatycznie przypisuje je przy zmianie statusu.
   - Commit `25df464`
4. ✅ Diagnostyka w Edge Function `delete-account` — zwraca szczegóły błędu Supabase w odpowiedzi.
   - Commit `a89a477`
5. ✅ Migracje: normalizacja ról w `fixflow_user_estates` + nowa tabela `fixflow_announcements` z RLS i realtime.
   - Commit `30b272c`

**Sesja 10 — kolejna runda bugfixów (zrobione):**
6. ✅ Fix: zmiana statusu zgłoszenia przez serwisanta nie przenosiła go między zakładkami, bo aktualizowano tylko pole `status`, a nie `status_enum`. Teraz oba pola są synchronizowane.
   - Commit `94490d8`
7. ✅ Fix: rejestracja — telefon obowiązkowy dla wszystkich ról, e-mail przenosi się na ekran lock screen (`didUpdateWidget`), a po zapisie profilu nie ma już wyścigu z ponownym ładowaniem danych.
   - Commit `641c8ed`
8. ✅ UI: kafelki kategorii w formularzu zgłoszenia zamienione na rozwijaną listę (oszczędność miejsca) + lokalizacja.
   - Commit `c3d5b3f`
9. ✅ Fix: administrator nie mógł dodać kontaktu — dodano migrację `0018` z RLS dla `fixflow_emergency_contacts`.
   - Commit `ad6267e`
10. ✅ Migracja `0017` (struktura osiedla: klatki A–Z, piętra -6..+20, wejścia do garażu) wdrożona na produkcję wraz z `0018`.

**Do zrobienia / blokuje deployment:**
1. ✅ Deploy Edge Functions (`send-notification`, `fixflow-cleanup`, `delete-account`) — wszystkie ACTIVE, `delete-account` wdrożone z `--no-verify-jwt`.
2. ✅ Firebase credentials w Supabase secrets (`FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`).
3. ✅ Zastosowano migracje `0015`, `0016`, `0017`, `0018` na produkcyjnej bazie.
4. ✅ Ujednolicenie kart w pozostałych ekranach (profile_screen.dart — lokalne stałe `_kCanvas` zamiast `AppColors`).
5. ⬜ Retest po ostatnich poprawkach: dodawanie budynku przez administratora, ogłoszenia mieszkańca, rejestracja ochrony, dodawanie kontaktu, zmiana statusu zgłoszenia przez serwisanta.
6. ✅ **Przypisanie użytkownika do zgłoszenia (imię + rola, dynamicznie) — zaimplementowano i przetestowano**
   - Wymagania: w karcie zgłoszenia (dla Zarządu/Administratora) dodano dynamiczny dropdown przypisania personelu osiedla.
   - Technicznie:
     - Rozszerzono `ReportModel` o pola `assignedToName` oraz `assignedToRole` w bazie (migracja 0019) i modelu.
     - Zaktualizowano schemat SQLite (wersja 6) wraz z onUpgrade.
     - Dodano `ResidentsRepository` oraz metodę `getEstateStaff` filtrującą rolę != 'Mieszkaniec'.
     - W `ManagerReportCard` wdrożono `_AssignmentDropdown`.
     - Dodano lokalizację (PL/EN) i pełne testy jednostkowe cubita (`reports_cubit_test.dart`).

> Na wznowienie użyj komendy `dalej` — zacznij od tej sekcji.

## Etap `build` — Zadania ✅ ZAKOŃCZONE

Wszystkie zadania z backlogu (Sesja 7) zostały zaimplementowane:

| # | Ref | Zadanie | Status |
|---|-----|---------|--------|
| 1 | S7.7 | Multi-estate switcher — dropdown w AppBar, `ActiveEstateCubit` singleton, streamy | ✅ |
| 2 | S7.17 | Komentarze wewnętrzne (board/serwis-only) — UI + RLS, tabela `fixflow_report_comments` istnieje | ✅ |
| 3 | S7.2 | Kasowanie komunikatu — rozszerzyć RLS delete o `fixflow_is_board_or_admin()`, ikona kosza | ✅ |
| 4 | S7.12 | Stały testowy kod zaproszenia — migracja `0011_seed_test_estate.sql` z kodem `TEST1234` | ✅ |

> Szczegóły: `docs/BACKLOG.md` (sekcja "Sesja 7").

## Etap `publish` — Kolejka zadań

| # | Ref | Zadanie | Status |
|---|-----|---------|--------|
| 1 | D2 | Tłumaczenia — pełna lokalizacja PL/EN/UK (dashboard Zarządu, Komunikator, Estate, Residents) | ⬜ |
| 2 | S7.13 | Trello — OPCJONALNE, PDF jako załącznik | ⬜ |

## Etap `onboarding` — Kolejka zadań

| # | Ref | Zadanie | Status |
|---|-----|---------|--------|
| 1 | S7.10 | Usuń konto w Profilu — ✅ DONE (fixflow-cleanup + re-auth) | ✅ |
| 2 | S7.11 | Rejestracja — pole HASŁO — ✅ DONE (anon → upgrade flow) | ✅ |

## Szczegółowy postęp `redesign`

- ✅ Konfigurator struktury osiedla (budynki + klatki schodowe) z trybem offline
- ✅ Tryb offline: lokalne dane gdy Supabase niedostępny (PGRST002)
- ✅ Obsługa CRUD budynków i klatek w trybie offline
- ✅ Fundament osiedla (estate): tabele `fixflow_estates` + `fixflow_user_estates`, RPC tworzenia/dołączania
- ✅ Kontakty per-osiedle (filtr `estate_id`) + naprawa zapisu (JSON snake_case)
- ✅ Feature `estate` (model/datasource/repository/cubit) + testy `EstateMembershipCubit`
- ✅ UI: onboarding osiedla (dołącz kodem / załóż) + zarządzanie kodem zaproszenia
- ✅ Profil: sekcja Kontakt/Wsparcie (mailto:aivolux@gmail.com)
- ⬜ Gating osiedla w AppGate (osiedle → weryfikacja → home) — patrz `docs/BACKLOG.md`
- ⬜ Trello per-osiedle przez Edge Function — patrz `docs/BACKLOG.md`
- ⬜ Tłumaczenia EN/UK hardcoded stringów — patrz `docs/BACKLOG.md`
- ⬜ Responsywność/adaptacyjność + SafeArea audit — patrz `docs/BACKLOG.md`
- ⬜ Dynamiczne dropdowny w rejestracji mieszkańców z danych osiedla
- ⬜ Dynamiczny wybór odbiorcy w Komunikatorze z struktury osiedla

## Szczegółowy postęp `build`

- ✅ S7.16 — Status zgłoszenia jako enum (`ReportStatus`), UI refaktoryzowany na `resolvedStatus`
- ✅ S7.10 — Usuń konto — Edge Function `fixflow-cleanup` + re-auth flow
- ✅ S7.11 — Rejestracja hasło — anon → upgrade flow działa
- ✅ Push notifications — Edge Function `send-notification` (FCM)
- ✅ Offline queue — `ReportOutbox` podpięty do `ReportsCubit`
- ✅ S7.7 — Multi-estate switcher (dropdown w AppBar) — już zaimplementowany
- ✅ S7.17 — Komentarze wewnętrzne (board/serwis-only) — już zaimplementowany
- ✅ S7.2 — Kasowanie komunikatu (RLS expansion) — już zaimplementowany
- ✅ S7.12 — Testowy kod zaproszenia `TEST1234` — migracja `0011_seed_test_estate.sql`

> Pełna lista zadań, decyzji i rekomendacji: `docs/BACKLOG.md`.

## Statusy

- `⬜ not-started`
- `🟡 in-progress`
- `✅ done`

## Synchronizacja platformy

Po zmianie `STATE.md` synchronizuj także status na platformie z kursem `12 Apps Challenge`.

Etap `init` jest tylko lokalny. Nigdy nie synchronizuj go z platformą.

Endpoint: `PATCH /user/apps/${APP_PLATFORM_ID}/stage`. Używaj krótkiej nazwy etapu, np. `start`, `home`, `redesign`.

Mapowanie statusów:

- `🟡 in-progress` -> `in_progress`
- `✅ done` -> `done`
- `⬜ not-started` -> `not_started`

Zmienne `PLATFORM_API_KEY` oraz `APP_PLATFORM_ID` powinny być dostępne w pliku `.env`. W innym przypadku pomiń sync z platformą.

Przykład dla etapu `start` i statusu `in_progress`:

```bash
curl -sS -X PATCH "https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user/apps/${APP_PLATFORM_ID}/stage" \
  -H "X-API-Key: ${PLATFORM_API_KEY}" \
  -H "X-Template-Version: v2.2" \
  -H "Content-Type: application/json" \
  -d '{"stage":"start","status":"in_progress","template_version":"v2.2"}'
```

Jeżeli sync się nie uda, zgłoś to krótko i kontynuuj lokalnie.

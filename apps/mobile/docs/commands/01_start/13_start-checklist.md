# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Sprawdzić poprawność wykonanych kroków z `docs/commands/01_start/`.

# Task

Sprawdź poprawność wszystkich kroków.

# Checklista

## Krok 1. Zebranie danych o mnie

- Endpoint `GET /apps-api/user` zwraca moje dane
- Pole `agent_interview_about` jest wypełnione i zatwierdzone przeze mnie

## Krok 2. Zapoznanie się ze strukturą `docs/IDEA.md`

- Agent zapoznał się ze strukturą pliku `docs/IDEA.md`

## Krok 3. Ustalenie pomysłu na aplikację

- Zatwierdziłem pomysł na aplikację

## Krok 4. Zawężenie grupy docelowej

- Wybrałem konkretną grupę docelową lub świadomie zdecydowałem się na wersję globalną

## Krok 5. Ustalenie Search Intents

- Wybrałem long-tail keyword
- Istnieje główna fraza w wersji angielskiej i polskiej
- Istnieją dodatkowe warianty / pokrewne frazy w wersji angielskiej i polskiej
- Frazy są niszowe (nie ogólne)
- Frazy brzmią jak naturalne wyszukiwania użytkownika w App Store / Google Play

## Krok 6. Ustalenie nazwy aplikacji

- Wybrałem `APP_DISPLAY_NAME`
- Nazwa aplikacji pasuje do niszy i charakteru produktu

## Krok 7. Utworzenie pliku `docs/IDEA.md`

- Plik `docs/IDEA.md` istnieje i jest wypełniony
- Sekcja `Identity` zawiera realne dane (nie placeholdery)
- Sekcja `Search Intents` zawiera główną frazę i dodatkowe warianty
- Sekcje `Elevator Pitch`, `Description`, `Product Summary`, `Niche`, `Value Proposition`, `Differentiation` są wypełnione
- `Differentiation` mówi konkretnie, czym ta aplikacja różni się od innych aplikacji tego typu
- Sekcja `Must-Have vs Nice-to-Have` jasno oddziela główną funkcję od dalszej wizji
- Sekcja `Store Screenshots Plan` zawiera 5 ekranów z komunikatem i tekstem EN na grafice
- Sekcja `Raw User Input About The App` zawiera moje dosłowne wypowiedzi z rozmowy o pomyśle na aplikację
- Moje wypowiedzi są zapisane 1:1, bez parafrazy i w kolejności chronologicznej
- Plik jest zacommitowany

## Krok 8. Ustawienie App Bundle ID

- `APP_BUNDLE_ID` w `docs/IDEA.md` nie zawiera `com.imienazwisko.appname` ani `com.example`
- `android/app/build.gradle.kts` zawiera poprawny `namespace` i `applicationId`
- `MainActivity.kt` ma poprawny `package` i leży we właściwym folderze
- `ios/Runner.xcodeproj/project.pbxproj` zawiera poprawny `PRODUCT_BUNDLE_IDENTIFIER`
- Zmiany są zacommitowane

## Krok 9. Ustawienie nazwy aplikacji

- `CFBundleDisplayName` i `CFBundleName` w `ios/Runner/Info.plist` mają nową nazwę
- `android:label` w `android/app/src/main/AndroidManifest.xml` ma nową nazwę
- `MaterialApp(title:)` w `lib/app/app.dart` ma nową nazwę
- Stara nazwa `XII` nie występuje w tych plikach
- Zmiany są zacommitowane

## Krok 10. Aktualizacja AGENTS.md i CLAUDE.md

- Sekcja `## App Context` w `AGENTS.md` zawiera opis aplikacji (nie placeholder)
- Placeholder `<supabase_table_prefix>` jest podmieniony na właściwy prefix
- Zmiany są zacommitowane

## Krok 11. Tożsamość aplikacji w `shared_user_apps`

- Plik `lib/features/profiles/data/datasources/shared_user_apps_data_source.dart` ma podmienione placeholdery `<app_id>` i `<app_name>`
- Wartości odpowiadają `__SUPABASE_TABLE_PREFIX__` i `__APP_DISPLAY_NAME__` z `docs/IDEA.md`
- Zmiany są zacommitowane

## Krok 12. Dodanie aplikacji do platformy

- Endpoint `POST /apps-api/user/apps` zwrócił `id`
- Request `POST /apps-api/user/apps` wysłał `template_version: "v2.2"` i pełną treść `docs/IDEA.md` w polu `idea_md`
- Plik `.env` zawiera pole `APP_PLATFORM_ID` z wartością zwróconą przez endpoint
- Po zapisaniu `APP_PLATFORM_ID` wykonano jednorazowy sync `stage: "start"`, `status: "in_progress"` z `X-Template-Version: v2.2` i `template_version: "v2.2"`

# Podsumowanie

Poinformuj mnie o stanie. Jeżeli czegoś brakuje, spróbuj razem ze mną naprawić to za pomocą poleceń dostępnych w `docs/commands/01_start/`.

Jeżeli w trakcie tego flow zostały zmienione pliki, upewnij się, że odpowiednie zmiany zostały zapisane w commicie. Pliki z sekretami i pliki objęte `.gitignore` nie powinny trafiać do commita.

Zaktualizuj `STATE.md`: ustaw etap `start` jako `✅ done`, ustaw `Ostatni zakończony etap` na `start`, ustaw `Aktualny etap` na `home` i zostaw status etapu `home` jako `⬜ not-started`.

Jeżeli wszystko jest okej, poinformuj mnie, że etap `start` jest zakończony i przechodzimy do etapu `home`.

Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
`Wykonaj: docs/commands/02_home.md`

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Jeśli napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/02_home.md` — nie wcześniej!

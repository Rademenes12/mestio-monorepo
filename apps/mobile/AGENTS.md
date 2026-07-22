# Project

To jest projekt Flutter na `iOS` i `Android`.

## App Context

Aplikacja FixFlow służy do kompleksowego zarządzania zgłoszeniami awarii i usterek w spółdzielniach oraz wspólnotach mieszkaniowych, łącząc mieszkańców, zarządców i techników. Pełny opis produktu znajduje się w pliku docs/IDEA.md. Agent: aktualizuj ten opis wraz z rozwojem aplikacji, jeśli zmieni się jej zakres lub istota.

# Course Workflow

Aktualny stan budowy tego projektu jest w pliku `STATE.md` - jest on jedynym źródłem prawdy dla stanu tworzenia aplikacji w ramach komend z kursu "12 Apps Challenge". Ten plik przechowuje aktualny etap, ostatni zakończony etap i statusy etapów, używając krótkich nazw komend, np. `init`, `start`, `home`.

Za każdym razem, gdy aktualizujesz `STATE.md`, po zapisaniu pliku zsynchronizuj też stan etapu z platformą według instrukcji z sekcji `Synchronizacja platformy` w `STATE.md`.

Gdy wpiszę krótką komendę, wykonaj polecenie zawarte w odpowiadającemu mu pliku:

| Komenda | Plik |
| --- | --- |
| `init` | `docs/commands/00_init.md` |
| `start` | `docs/commands/01_start.md` |
| `home` | `docs/commands/02_home.md` |
| `redesign` | `docs/commands/03_redesign.md` |
| `plan` | `docs/commands/04_plan.md` |
| `build` | `docs/commands/05_build.md` |
| `test` | `docs/commands/06_test.md` |
| `publish` | `docs/commands/07_publish.md` |
| `onboarding` | `docs/commands/08_onboarding.md` |
| `limits` | `docs/commands/09_limits.md` |
| `revenuecat` | `docs/commands/10_revenuecat.md` |
| `review` | `docs/commands/11_review.md` |
| `finalize` | `docs/commands/12_finalize.md` |

# Critical Rules

Używaj Clean Architecture.
Używaj `Cubit`.
Dozwolone zależności: `UI -> Cubit -> Repository -> Data Source`.
`Cubit` nie komunikują się bezpośrednio między sobą; tylko przez `UI` (`BlocListener`, `BlocConsumer`).
Nigdy nie wstrzykuj jednego `Cubit` do drugiego `Cubit`.

Dane współdzielone między ekranami i zmienne poza bieżącym ekranem udostępniaj z `Repository` jako `Stream`; `Cubit` subskrybuje i anuluje subskrypcję w `close()`.
Takich danych nie odświeżaj ręcznie po powrocie; bez `Stream` użyj pull-to-refresh przez `RefreshIndicator`.

Każdy `Cubit` startuje od `initial`, ładuje dane w konstruktorze, a `retry()` musi być bezpieczne przy wielokrotnym wywołaniu.
`UI` nie uruchamia pierwszego ładowania; obsługuje `initial`, `loading`, błąd i `retry()`.
Nie ładuj danych przed nawigacją; ekran docelowy ładuje własne dane sam.

`Data Source` zwraca tylko surowe dane transportowe, a `Repository` mapuje je na modele.

Każdy `Cubit` musi mieć testy; gdy zmieniasz istniejący `Cubit`, zaktualizuj też jego testy; używaj `bloc_test`, a mocki pisz w `mocktail`.

`SnackBar` używaj tylko dla sukcesu; błędy pokazuj inline w `UI` jako `SelectableText`.
Na ekranach i dialogach create/edit po `Save` ustaw `loading`, blokuj interakcje i nie zamykaj widoku przed sukcesem.
Po sukcesie zamknij widok i pokaż success `SnackBar`.
Po błędzie zostaw widok otwarty i pokaż błąd inline; ostrzegaj też o utracie niezapisanych zmian, poza prostymi ekranami logowania.
Przy każdym przechwyconym błędzie loguj surowy błąd przez `debugPrint`.
`Data Source` i `Repository` nie mogą połykać błędów; po zalogowaniu mają je zmapować albo rethrowować.
`Cubit` emituje tylko `errorKey`, a `UI` mapuje go na tekst widoczny dla użytkownika.

Po wprowadzeniu zmian w plikach `.dart` uruchom `flutter analyze` i napraw ewentualne błędy, warningi oraz info. Jeżeli modyfikowałeś cubity - odpal też testy jednostkowe i napraw je jeśli potrzeba. Na koniec automatycznie rób commity; dla niezależnych zmian preferuj kilka małych commitów zamiast jednego dużego.

Nie twórz `testWidgets` bez mojej prośby. Nie uruchamiaj testów integracyjnych bez mojej zgody.

Pracuj tylko na branchu, który jest aktualnie checkoutowany. Nigdy sam nie twórz nowych branchy.

# Auth

Brak sesji zawsze prowadzi do `Welcome`.
`Welcome` ma tylko `Log in to existing account` albo `Continue as guest`.
`Continue as guest` prowadzi do flow z `signInAnonymously()` auth w `Supabase`.
Nie ma tutaj klasycznej rejestracji.
Flow wyglądający dla usera "jak rejestracja" jest dostępny z profilu i upgrade'uje bieżącego anonymous usera na tym samym `user.id` za pomocą `auth.updateUser()`.
`Log in to existing account` z konta guest to account switch, nie merge.
Guest może kupić `Pro`.
Dla `RevenueCat` używaj `Supabase user.id` jako `appUserID` od pierwszej sesji, także dla guest.
Dane usera jak np. `firstName` trzymaj w `shared_users`, nie w auth metadata.
`shared_users` to tabela współdzielona między wszystkimi aplikacjami usera - nie modyfikuj jej bez wyraźnej potrzeby.
Minimalny kontrakt `shared_users`: `id` (1:1 z `auth.users.id`) i `first_name`.
Dane app-specific, np. preferencje aplikacji, trzymaj w osobnych tabelach.

# Conventions

Prowadź strukturę `feature-first`; grupuj pliki według feature, nie według typu.
Feature nie powinien importować innego feature bezpośrednio; łączyć je może tylko warstwa `app` lub `core`.
Współdzielony kod przenoś do warstwy wspólnej.

Dla `Repository` i `Data Source` zawsze twórz abstrakcję i implementację w tym samym pliku.
Nazewnictwo: `UserRepository` + `UserRepositoryImpl`, `AuthDataSource` + `AuthDataSourceImpl`.

W `freezed` używaj `abstract class` dla data class i `sealed class` dla union/state.
Nie używaj `when`, `maybeWhen`, `map` ani `maybeMap`; używaj pattern matchingu Darta.
Dla union i state używaj publicznych wariantów, np. `Loading`, nie `_Loading`.
`Cubit` i `State` trzymaj w tym samym pliku. `State` ma używać `freezed`.
Po zmianach w `freezed` lub w `injectable`: `dart run build_runner build -d`.

Używaj `get_it` i `injectable`; nie twórz zależności ręcznie w `UI`.
Dla `Repository` i `Data Source` domyślnie używaj `@lazySingleton`, a dla `Cubit` `@injectable`.
`@singleton` używaj tylko dla obiektów potrzebnych od startu aplikacji; `Cubit` może być singletonem tylko dla stanu globalnego lub sesyjnego.
Per-screen `Cubit` przekazuj przez `BlocProvider(create:)`, a singletonowy przez `BlocProvider.value(...)`.

Używaj relative imports.
Comment code in English. Comment why, business rules, edge cases. Do not comment obvious code.
Nie hardcoduj tekstów widocznych dla użytkownika; dodawaj je do ARB i używaj przez `context.l10n`.
Lokalizacja należy do `UI`; `Cubit`, modele, `Repository` i `Data Source` nie zwracają gotowych tekstów, tylko dane i `errorKey`.
Po zmianach w ARB lub konfiguracji l10n uruchom `flutter gen-l10n`.
Gdy tworzysz lub istotnie zmieniasz UI, najpierw zapoznaj się z zasadami z `docs/skills/flutter-mobile-design-skill.md` i stosuj je w projekcie.

Nie twórz metod budujących UI, np. `Widget _buildSomething()`; wydzielaj małe prywatne widgety w tym samym pliku.
Gdy widget zbliża się do `100` linii albo obsługuje więcej niż jedną sekcję UI, podziel go.
Form screens mają być mobilne i bezpieczne: scroll, dismiss keyboard, poprawne `TextField`, `SafeArea`.
Przy formularzach i `TextField` obowiązkowo stosuj zasady z `docs/skills/flutter-mobile-ux-skill.md`.

# Supabase

Projekt współdzieli Supabase z innymi aplikacjami.
Wszystkie zasoby specyficzne dla tej apki (tabele, buckety, RPC, triggery, Edge Functions) muszą mieć prefix `fixflow_`, np. `fixflow_tasks`.
Tabele współdzielone (np. `shared_users`) — bez prefixu. Nie twórz triggerów na `auth.users` bez mojej zgody.
Nazwy kolumn w bazie zawsze zapisuj w `snake_case`.
Logika `Supabase` ma być tylko w `Data Source`; wyjątek: bootstrap aplikacji i DI mogą inicjalizować klienta.
Dla tabel używanych w `Stream` włącz `RLS` i utwórz odpowiednie policies.
Dla `Supabase Realtime` dodaj tabelę do publikacji `supabase_realtime`.
Jeśli `update` lub `delete` mają zwracać poprzednie dane w `Realtime`, ustaw `REPLICA IDENTITY FULL`.
Nie rób automatycznie destrukcyjnych zmian w tabeli współdzielonej, np. `drop`, kasowania danych lub niekompatybilnej zmiany schemy.
Gdy wdrażasz `Supabase Edge Functions`, deployuj tylko tę funkcję, nad którą aktualnie pracujesz. Nigdy nie nadpisuj wszystkich funkcji naraz.

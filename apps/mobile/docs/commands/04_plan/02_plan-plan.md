# INTRO

Okej więc jeżeli rozumiesz już jak działa aplikacja i widzisz, jak działa Supabase Auth, twoim zadaniem będzie ułożenie planu, aby doprowadzić tę aplikację od A do Z, tak aby działała na naszej architekturze.

Na tym etapie nie piszesz jeszcze żadnego kodu! Tworzymy tylko dokładny plan implementacyjny!

CEL: Aplikacja musi robić jedną główną rzecz ale DOBRZE. Nie przeginaj ze scope. Ma to być proste MVP, które działa. DZIAŁA DOBRZE. 

Plan musi obejmować przede wszystkim implementację sekcji `### Must-Have` oraz ekrany `## Store Screenshots Plan` z pliku `docs/IDEA.md`

Plan powinien zawierać w sobie implementację całej aplikacji. 
- kolejne ekrany z utrzymaniem stylu zdefiniowanego w `lib/features/home/ui/home_screen.dart` (opisany dodatkowo w `docs/DESIGN.md`)
- cubity + test jednostkowe (rozważ TDD - najpierw testy, później cubity)
- nowa struktura tabel w supabase database z użyciem zalogowanego identyfikatora użytkownika, jawnych minimalnych `GRANT` dla Data API i polityki RLS
- spięcie tego wszystkiego w aktualnej architekturze z użyciem repositories i data sources
- każdy interaktywny widget i kontener danych musi mieć stabilny `Key`, aby był w przyszłości testowalny integracyjnie
- lokalizację wszelkich stringów na pl/en
itp. 

Każdy plan schemy Supabase musi zawierać mini-checklistę: `create table`, explicit `GRANT` dla tabel/funkcji/sekwencji, `enable row level security`, policies, indeksy, publikację Realtime jeśli ekran używa streamu, `REPLICA IDENTITY FULL` jeśli `update`/`delete` mają zwracać poprzednie dane, oraz smoke test przez rolę klienta używaną przez aplikację.

Nie planuj na razie testów integracyjnych.

**Trzymaj się zasad opisanych w `AGENTS.md`.**

Na tym etapie nie mam ograniczeń względem mojego tieru (guest / registered / pro). Gość nie ma żadnych limitów. Rejestracja daje mi tylko taki benefit, że moje dane będą przypisane do konta i ich nie stracę po usunięciu aplikacji. Zakupu konta `pro` na tym etapie jeszcze nie implementujemy. Pro tier nie powinien być w żadnym miejscu jeszcze wspominany. Dojdzie w przyszłości.

Upewnij się, że ekrany działają na streamach, albo łatwo je odświeżyć aby nie było sytuacji że wchodzimy kilka ekranów głębiej, zmieniamy coś, wracamy parę razy wstecz na stacku, a tam wyświetlają się nieaktualne dane.

Upewnij się, że wszelkie operacje dodawania, edycji i usuwania będą obsłużone bez problemu.

W miejscach gdzie mają wyświetlać się elementy zaplanuj ładne empty states gdy jeszcze nic nie jest dodane.

Pamiętaj, aby ograć obsługę błędów zarówno w UI jak i w Debug Console przez debugPrint.

**Po implementacji tego planu aplikacja powinna być gotowa do wypuszczenia na produkcję.** 

Nie może być w niej jeszcze jakichś elementów to-do do zrobienia na później. Brak fake data, wszystko ma być już oparte na bazie danych.

Rzeczy powiązane z Supabase zalecaj w tym planie wprowadzać przez Supabase MCP.

# TASK

Przygotuj pełny plan implementacyjny głównego MVP i zapisz go w całości w nowym, utworzonym przez Ciebie pliku `docs/IMPL_PLAN.md`.

Na końcu przedstaw jego skróconą wersję mnie.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `03_plan-baby-steps.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/04_plan/03_plan-baby-steps.md`.

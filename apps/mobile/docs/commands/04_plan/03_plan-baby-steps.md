# TASK

Rozbij teraz ten plan `docs/IMPL_PLAN.md` na wiele małych kroków / oddzielnych pliczków .md.

Najpierw zaktualizuj `docs/commands/05_build.md` tak, aby stał się manifestem wykonawczym etapu `05_build`. `docs/IMPL_PLAN.md` jest pełnym planem produktu i architektury, ale `docs/commands/05_build.md` ma opisywać kolejność wykonawczą baby stepów.

Manifest `docs/commands/05_build.md` musi zawierać:
- cel etapu build,
- sposób pracy z baby stepami,
- informację, że każdy krok może być wykonany w świeżej rozmowie przez agenta, który nie zna historii poprzednich rozmów,
- założenie, że świeży agent może polegać tylko na aktualnym stanie repo, `docs/IMPL_PLAN.md`, manifeście `docs/commands/05_build.md` i treści swojego baby stepu,
- kolejność baby stepów,
- wspólne decyzje architektoniczne i kontrakty między krokami,
- zależności między krokami,
- zasady weryfikacji,
- informację, które kroki są `parallel-safe`, jeśli jakiekolwiek naprawdę są. Nie oznaczaj kroku jako `parallel-safe`, jeśli może dotykać tych samych plików, zmieniać ten sam kontrakt albo zależeć od niezatwierdzonego wyniku innego kroku.

Każdy pojedynczy krok implementacyjny powinien być niezależny i dokładnie technicznie opisany w oddzielnym pliku .md w folderze `docs/commands/05_build/`.

Każdy baby step musi być możliwy do wykonania w świeżej rozmowie przez agenta, który nie zna historii poprzednich rozmów. Krok może zakładać tylko to, że wcześniejsze baby stepy zostały już wykonane i zacommitowane. Dlatego każdy plik kroku musi zawierać:
- link do `docs/IMPL_PLAN.md`,
- link do `docs/commands/05_build.md`,
- cel kroku,
- wymagany kontekst z planu,
- założenia o wcześniejszych wykonanych krokach,
- zależności od poprzednich kroków,
- zakres plików, które prawdopodobnie trzeba zmienić,
- rzeczy poza zakresem tego kroku,
- szczegóły implementacyjne,
- komendy weryfikacyjne,
- oczekiwany commit message,
- ścieżkę do kolejnego kroku.

Każdy krok będzie musiał kończyć się commitem, więc każdy krok musi przechodzić `flutter analyze` bez problemu.

Każdy krok (każdy osobny plik .md w /05_build/) ma kończyć się podsumowaniem tego, co udało się dokonać, i zaleceniem dla mnie, abym napisał `next`, a dopiero po `next` ma przechodzić do kolejnego pliku. Ścieżka do kolejnego pliku ma być podana po zaleceniu napisania `next` (podobnie jak w tym pliku).

Nazwij je w formacie `0x_build-STH.md` — gdzie `STH` to krótki tytuł danego kroku, a `0x` to numer kroku np. `01`, `02` czy `03`, np. `01_build-adding-screen.md`.

Nie ma limitu kroków. Zrób ich tyle ile potrzebujesz.

Ostatni baby step w `docs/commands/05_build/` ma mieć sekcję `## FINISH`, która:
- aktualizuje `STATE.md`: ustawia etap `build` jako `✅ done`, ustawia `Ostatni zakończony etap` na `build`, ustawia `Aktualny etap` na `test` i upewnia się, że etap `test` ma status `⬜ not-started`;
- po napisaniu `next` prowadzi do `docs/commands/06_test.md`.

## FINISH

Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `04_plan-prepare-tests.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/04_plan/04_plan-prepare-tests.md`.

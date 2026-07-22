# TASK

Wypełnij sekcję `## SCENARIUSZE TESTOWE` w pliku `docs/commands/06_test/01_test-manual.md` krótką listą najważniejszych scenariuszy manualnych na podstawie `docs/IMPL_PLAN.md`.

Skup się tylko na głównych ścieżkach użytkownika i najważniejszych błędach. Nie wypisuj wszystkich kombinacji i przypadków brzegowych. Łącz podobne przypadki w jeden scenariusz i pisz zwięźle. Nie zmieniaj pozostałych sekcji tego pliku.

## LINKOWANIE I COMMIT

1. Upewnij się, że ostatni baby step w `docs/commands/05_build/` po napisaniu `next` prowadzi do `docs/commands/06_test.md`.
2. Uruchom `git status`.
3. Zacommituj wszystkie zmiany z etapu `plan`, nie tylko zmiany z tego pliku. Obejmuje to także:
   - `docs/IMPL_PLAN.md`
   - baby steps utworzone w `docs/commands/05_build/`
   - scenariusze manualne w `docs/commands/06_test/01_test-manual.md`
   - inne pliki `.md` zmienione w trakcie etapu `04_plan`
4. Nie commituj przypadkowych zmian spoza etapu `plan`. Jeśli `git status` pokazuje takie zmiany, wypisz je osobno i zapytaj mnie co z nimi zrobić.

## FINISH

Gdy skończysz, daj znać mi, ile scenariuszy manualnych dodałeś i czy ostatni baby step prowadzi do `docs/commands/06_test.md`.

Zaktualizuj `STATE.md`: ustaw etap `plan` jako `✅ done`, ustaw `Ostatni zakończony etap` na `plan`, ustaw `Aktualny etap` na `build` i zostaw status etapu `build` jako `⬜ not-started`.

Poinformuj mnie, że etap `plan` jest zakończony i przechodzimy do etapu `build`.

Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
`Wykonaj: docs/commands/05_build.md`

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Jeśli napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/05_build.md` — nie wcześniej!

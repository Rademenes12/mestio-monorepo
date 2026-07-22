# ZADANIE: 06_test_integration_run

## CEL
Uruchomienie testów integracyjnych z priorytetem dla urządzenia fizycznego.

## KROKI DO WYKONANIA:
1. Najpierw sprawdź, jakie urządzenia są dostępne do uruchomienia testów integracyjnych.
2. Sprawdź, czy istnieje katalog `integration_test/` i czy zawiera pliki `*_test.dart`.
3. Jeśli nie istnieje żaden plik `integration_test/*_test.dart`, zatrzymaj się: testy integracyjne nie zostały utworzone. Cofnij się do `04_test-integration-create.md` i nie uznawaj testów z `test/` ani `test/integration/` za testy integracyjne.
4. Jeśli nie ma żadnego dostępnego urządzenia, zatrzymaj się i powiedz mi, żebym przygotował emulator/symulator albo fizyczne urządzenie podłączone kablem.
5. Jeśli dostępne jest urządzenie fizyczne i emulator/symulator, priorytetowo korzystaj z urządzenia fizycznego.
6. Z emulatora/symulatora skorzystaj dopiero wtedy, gdy urządzenie fizyczne nie działa poprawnie, jest zablokowane, wyłączone albo z innego powodu nie da się na nim uruchomić testów.
7. Uruchom testy integracyjne na wybranym urządzeniu, np. `flutter test integration_test/ -d <device_id>`.
8. Nie zastępuj tego polecenia przez `flutter test test/`, `flutter test test/integration/` ani zwykłe testy widgetowe.
9. Jeśli jakieś testy nie przechodzą — napraw kod lub testy, uruchom `flutter analyze`, ponów testy.
10. Powtarzaj aż wszystkie testy przejdą.
11. Jeśli były poprawki — zacommituj.
12. Poinformuj mnie o wynikach. Zasugeruj mi napisanie `next`.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `07_test-finish.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/06_test/07_test-finish.md`.

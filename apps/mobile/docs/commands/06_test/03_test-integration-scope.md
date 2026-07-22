# ZADANIE: 03_test_integration_scope

## CEL
Wybieramy zakres testów integracyjnych, zanim zaczniesz je tworzyć.

## KROKI DO WYKONANIA:
1. Powiedz mi, że im większy zakres testów integracyjnych wybiorę, tym więcej tokenów zużyje ich stworzenie, więcej czasu zajmie debugowanie i dłużej będą uruchamiać się na emulatorze/symulatorze albo urządzeniu.
2. Zaproponuj trzy zakresy:
   - `mało` - 1-2 testy integracyjne: absolutnie najważniejszy happy path i ewentualnie jedna krytyczna nawigacja.
   - `domyślnie` - 3-5 testów integracyjnych: główne flow, kluczowa nawigacja i maksymalnie jeden krytyczny błąd repo.
   - `dużo` - 6-10 testów integracyjnych: główne flow, ważny CRUD, auth, krytyczne błędy i najważniejsze edge case'y.
3. Zarekomenduj `domyślnie` jako najlepszy balans między pewnością a kosztem.
4. Zapytaj mnie: `Jaki zakres testów integracyjnych wybierasz: mało, domyślnie czy dużo?`
5. Nie twórz jeszcze testów.
6. Po moim wyborze utwórz katalog `docs/working/06_test/`, jeśli nie istnieje.
7. Zapisz wybór do `docs/working/06_test/integration_scope.md` w krótkiej formie:

```md
# Integration Test Scope

Scope: mało|domyślnie|dużo

Notes:
- ...
```

8. Jeśli moja odpowiedź nie jest jasna, dopytaj. Nie wybieraj zakresu samodzielnie.
9. Po zapisaniu pliku powiedz mi, że kolejny krok to `04_test-integration-create.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/06_test/04_test-integration-create.md`.

# ZADANIE: 04_test_integration_create

## CEL
Tworzysz najważniejsze testy integracyjne na podstawie gotowej aplikacji i scenariuszy manualnych.

## KROKI DO WYKONANIA:
1. Przeczytaj scenariusze manualne z `docs/commands/06_test/01_test-manual.md`.
2. Przeczytaj `docs/working/06_test/integration_scope.md`.
3. Jeśli `docs/working/06_test/integration_scope.md` nie istnieje albo nie zawiera wyboru `mało`, `domyślnie` lub `dużo`, zatrzymaj się i wróć do `docs/commands/06_test/03_test-integration-scope.md`.
4. Przejrzyj gotowy kod aplikacji, szczególnie:
   - główne flow UI,
   - `Key` używane w widgetach,
   - dependency injection,
   - repositories i data sources,
   - sposób mockowania backendu w testach.
5. Utwórz testy integracyjne TYLKO DLA **NAJWAŻNIEJSZYCH** SCENARIUSZY, które da się sensownie zamockować:
   - główny happy path,
   - kluczowe CRUD,
   - najważniejszą nawigację,
   - podstawowy auth flow,
   - 1-2 najważniejsze błędy repo, jeśli są naprawdę krytyczne.
6. Dopasuj liczbę testów do wybranego zakresu:
   - `mało` - maksymalnie 1-2 testy integracyjne.
   - `domyślnie` - maksymalnie 3-5 testów integracyjnych.
   - `dużo` - maksymalnie 6-10 testów integracyjnych.
7. Testy mają działać w 100% na mocked backendzie z użyciem `mocktail`. Nie mogą używać realnej sieci ani realnego backendu.
8. Utwórz je wyłącznie w rootowym katalogu `integration_test/`, np. `integration_test/app_integration_test.dart`.
9. Nie twórz testów integracyjnych w `test/`, `test/integration/` ani `test/widget/`. Testy w tych katalogach są zwykłymi testami widgetowymi/unitowymi i nie kończą tego kroku.
10. Każdy plik testu integracyjnego musi importować `package:integration_test/integration_test.dart` i wywołać `IntegrationTestWidgetsFlutterBinding.ensureInitialized();` przed testami.
11. Testy integracyjne mogą używać `testWidgets`, ale muszą być uruchamialne przez `flutter test integration_test/ -d <device_id>`.
12. Wyrzuć przykładowy `integration_test/counter_test_example.dart`, jeśli istnieje.
13. Nie twórz golden testów.
14. Nie próbuj pokrywać wszystkiego. Scenariusze drugorzędne, rzadkie edge case'y, regresje wizualne, prawdziwy offline na urządzeniu i soft keyboard zostaw testom manualnym.
15. Każdy `testWidgets` musi mieć explicit timeout, np.:

```dart
testWidgets('name', (tester) async {
  // ...
}, timeout: const Timeout(Duration(seconds: 60)));
```

16. Każde `tester.pumpAndSettle()` musi mieć jawny timeout końca ustawiania, np.:

```dart
await tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 10),
);
```

17. Nigdy nie wywołuj `pumpAndSettle()` bez trzeciego argumentu.
18. Timery debounce w cubitach skróć w testach do zera albo kilku ms przez konstruktor testowy.
19. Nie uruchamiaj jeszcze testów integracyjnych.
20. Uruchom `flutter analyze`.
21. Napraw błędy, warningi i info.
22. Zacommituj utworzone testy i ewentualne zmiany wspierające testowalność.
23. Podsumuj, jaki zakres wybrałem i jakie testy integracyjne powstały, podając ścieżki plików z `integration_test/`.
24. Powiedz mi, że kolejny krok to `05_test-setup.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/06_test/05_test-setup.md`.

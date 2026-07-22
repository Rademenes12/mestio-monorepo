# ZADANIE: 10_home_verify

## CEL
Zweryfikować finalny Home, zakończyć etap `home` i przygotować przejście do etapu `redesign`.

## KROKI DO WYKONANIA
1. Sprawdź, czy istnieje `docs/DESIGN.md`.
2. Sprawdź, czy finalny Home jest w:

```text
lib/features/home/ui/home_screen.dart
```

3. Sprawdź, czy cały sandbox wariantów został usunięty i nie istnieje:

```text
lib/features/home/ui/temporary_widgets/
```

4. Poproś mnie o uruchomienie aplikacji i przetestowanie:
   - finalnego ekranu Home,
   - dostępu do Profilu,
   - gestów i interakcji Home.
5. ZATRZYMAJ SIĘ i czekaj na feedback.
6. Jeśli coś nie działa, napraw problem, uruchom `flutter analyze`, wykonaj commit i poproś o ponowny test.
7. Gdy wszystko jest okej, uruchom `flutter analyze` i napraw błędy, warningi oraz info.
8. Zaktualizuj `STATE.md`: ustaw etap `home` jako `✅ done`, ustaw `Ostatni zakończony etap` na `home`, ustaw `Aktualny etap` na `redesign` i zostaw status etapu `redesign` jako `⬜ not-started`.
9. Wykonaj commit.

## FINISH
Poinformuj mnie, że etap `02_home` jest zakończony i przechodzimy do etapu `redesign`.

Zasugeruj otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:

```text
Wykonaj: docs/commands/03_redesign.md
```

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.
Gdy napiszę `next`, dopiero wtedy zapoznaj się z `docs/commands/03_redesign.md`.

# ZADANIE: 08_home_clean_up

## CEL
Przenieść wybrany wariant Home z sandboxu do finalnego ekranu aplikacji, zintegrować theme i usunąć sandbox wariantów.

## KROKI DO WYKONANIA
1. Przeczytaj:
   - `docs/DESIGN.md`
   - `docs/working/02_home/variant_manifest.md`
   - `AGENTS.md`
2. Sprawdź `chosen` i `chosen_path`. Jeśli ich nie ma, wróć do `docs/commands/02_home/06_home-choose.md`.
3. Przeczytaj wybrany plik z `chosen_path`.
4. Przeczytaj plan wybranego wariantu:

```text
docs/working/02_home/plans/home_variant_<letter>.md
```

5. Zaimplementuj wybrany Home w:

```text
lib/features/home/ui/home_screen.dart
```

6. Najważniejsze: musi działać dostęp do Profilu. Reszta może być placeholderem, bottom sheetem albo lokalnym stanem, bo nadal pracujemy nad presentation layer.
7. Jeśli wybrany wariant ma lokalny theme wrapper albo własne `ThemeData`, przenieś lub zintegruj je w istniejącym miejscu globalnego theme aplikacji, obecnie `lib/app/app.dart`, tak aby kolejne ekrany mogły korzystać ze stylu z `docs/DESIGN.md`.
8. Przenoś kod uważnie: unikaj chaotycznego copy-paste, nazw tymczasowych i martwych importów. Szerszy refactor Home jest osobnym kolejnym krokiem.
9. Usuń cały folder:

```text
lib/features/home/ui/temporary_widgets/
```

10. Upewnij się, że nie zostaje żaden plik z sandboxu jako finalny artefakt.
11. Uruchom `flutter analyze` i napraw błędy, warningi oraz info.
12. Wykonaj commit.
13. Poinformuj mnie o zmianach.

## FINISH
Powiedz, że kolejny krok to `09_home-refactor.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/09_home-refactor.md`.

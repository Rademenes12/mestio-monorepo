# ZADANIE: 09_home_refactor

## CEL
Zrefaktorować finalny Home po przeniesieniu wybranego wariantu z sandboxu.

## KROKI DO WYKONANIA
1. Przeczytaj:
   - `AGENTS.md`, szczególnie `Critical Rules` i `Conventions`
   - `docs/DESIGN.md`
   - `docs/working/02_home/variant_manifest.md`
2. Przejrzyj finalny Home w:

```text
lib/features/home/ui/home_screen.dart
```

3. Zrefaktoruj Home zgodnie z aktualnymi zasadami projektu:
   - popraw jakość kodu,
   - usuń martwy kod, martwe importy i tymczasowe nazwy,
   - podziel zbyt duże widgety na małe prywatne widgety w tym samym pliku albo osobne pliki, jeśli rozmiar i odpowiedzialność tego wymagają,
   - nie twórz metod budujących UI typu `Widget _buildSomething()`,
   - utrzymaj styl z `docs/DESIGN.md` i globalnego theme.
4. Wydziel hardcodowane fake data Home do lokalnych stałych, modeli albo helper structures w presentation layer, tak żeby późniejsze podpięcie Cubit/Repository było prostsze.
5. Nie dodawaj logiki backendowej, Supabase, Cubitów, Repository, Data Source ani domain logic.
6. Nie zmieniaj flow auth/profile/delete.
7. Uruchom `flutter analyze` i napraw błędy, warningi oraz info.
8. Wykonaj commit.
9. Poinformuj mnie o zmianach.

## FINISH
Powiedz, że kolejny krok to `10_home-verify.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/10_home-verify.md`.

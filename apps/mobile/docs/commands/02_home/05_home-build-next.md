# ZADANIE: 05_home_build_next

## CEL
Zaimplementować pierwszy kompletny wariant Home ze statusem `pending`.

## KROKI DO WYKONANIA
1. Przeczytaj `docs/working/02_home/variant_manifest.md`.
2. Znajdź pierwszy wariant ze statusem `pending`.
3. Jeśli nie ma żadnego `pending`, przejdź do sekcji `WSZYSTKIE GOTOWE`.
4. Przeczytaj plan:

```text
docs/working/02_home/plans/home_variant_<letter>.md
```

5. Przed kodowaniem sprawdź sekcje `Hierarchy contract`, `Anti-noise`, `Anty-klon` i `Don't make me think`. Jeśli ten wariant jest podobny do innego, Home ma za dużo równoważnych elementów albo styl osłabia fokus, popraw plan tego wariantu przed implementacją.

6. Zaimplementuj wariant w pliku:

```text
lib/features/home/ui/temporary_widgets/variants/home_variant_<letter>.dart
```

7. Główny gest z planu ma działać realnie, nie tylko wyglądać jak gest:
   - swipe: użyj `Dismissible`, `PageView` albo `GestureDetector`,
   - expand/collapse: użyj lokalnego stanu i animacji,
   - drag/reorder: użyj `Draggable`, `DragTarget` albo `ReorderableListView`,
   - long press: obsłuż `onLongPress`,
   - bottom sheet: otwieraj prawdziwy sheet.
8. Jeśli gest z planu jest zbyt ciężki, uprość go, ale zachowaj inny model interakcji niż w pozostałych wariantach.
9. Home ma mieć jeden dominujący fokus i jedno główne CTA. Pozostałe informacje pokaż jako drugorzędne skróty albo przenieś do sub-ekranów/bottom sheetów z planu.
10. Wariant ma być kompletnym styled Home z zamockowanymi, przykładowymi danymi:
   - ma mieć własną paletę i typografię,
   - ma stosować `ThemeData` zgodnie z planem,
   - ma być w Light Mode,
   - CTA ma mieć treatment z planu,
   - spacing, komponenty i motion mają wspierać fokus,
   - nie dodawaj ozdobników, kart ani tekstów, które zwiększają szum bez celu.
11. Podłącz wariant w `lib/features/home/ui/temporary_widgets/home_variant_registry.dart`. Registry ma pokazywać opisową nazwę wariantu z manifestu i działać horyzontalnie dla `1`, `3`, `5` i `10` wariantów.
12. Jeśli trzeba, podepnij preview shell w `lib/features/home/ui/home_screen.dart`. Nie ruszaj produkcyjnego flow bardziej niż to konieczne do preview.
13. Używaj tylko temporary widgets i sandboxu:

```text
lib/features/home/ui/temporary_widgets/
```

14. Nie przenoś jeszcze wybranego Home do finalnego `home_screen.dart` poza preview shell i nie usuwaj sandboxu.
15. Zaktualizuj `docs/working/02_home/variant_manifest.md`: ustaw status tego wariantu na `done`.
16. Uruchom `flutter analyze` i napraw błędy, warningi oraz info.
17. Wykonaj commit tylko dla tego wariantu, registry i aktualizacji manifestu.

## WSZYSTKIE GOTOWE
Jeśli wszystkie warianty mają status `done`, nie implementuj nic więcej. Poinformuj mnie, że wszystkie warianty Home są gotowe.

## FINISH
Jeśli po tym kroku są jeszcze warianty `pending`, poinformuj mnie, który wariant został zbudowany. Powiedz mi, że kolejny krok to ponownie `05_home-build-next.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next` i są jeszcze warianty `pending`, przejdź ponownie do `docs/commands/02_home/05_home-build-next.md`.

Jeśli wszystkie warianty mają status `done`, powiedz mi, że kolejny krok to `06_home-choose.md` i zasugeruj mi napisanie `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/06_home-choose.md`.

Jeśli wszystkie warianty mają status `done`, a ja od razu napiszę wybór, np. `Wybieram B` albo samą literę `B`, przejdź do `docs/commands/02_home/06_home-choose.md` i wykonaj go z tą odpowiedzią.

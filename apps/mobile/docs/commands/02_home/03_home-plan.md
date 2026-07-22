# ZADANIE: 03_home_plan

## CEL
Zaproponować tyle kompletnych konceptów głównego ekranu Home, ile wybrałem w manifeście. Nie pisz jeszcze kodu.

## ZASADY UI/UX
Przed planowaniem przeczytaj:

- `docs/IDEA.md`
- `docs/skills/flutter-mobile-ux-skill.md`
- `docs/skills/flutter-mobile-design-skill.md`

Zasady:

- Każdy wariant jest kompletny: layout, behavior, UX, hierarchia i visual direction.
- Ekran ma wyglądać jak wypełniona aplikacja stałego użytkownika, nie puste demo.
- Używaj fake data z konkretnymi nazwami, liczbami i datami.
- Możesz użyć lokalnego stanu (`setState`, lokalne zmienne) do pokazania interakcji.
- Nie używaj Cubitów, Repository ani backendu.
- W temporary widgets możesz używać hardcoded stringów, bez ARB i `context.l10n`.
- Jeśli wariant ma dodatkowe zakładki, pokazuj w nich proste placeholdery.
- Jeśli potrzebne są sub-ekrany, przygotuj maksymalnie 2-3 kluczowe.
- Każdy wariant musi mieć działający dostęp do `lib/features/profiles/presentation/ui/profile_screen.dart`.
- Nie używaj stałego zestawu wariantów dla każdej apki. Warianty mają wynikać z `docs/IDEA.md`.
- Uwzględnij `style_notes` z manifestu.
- Każdy wariant ma być w Light Mode. Dark Mode będzie osobnym feature Pro w przyszłości.
- Każdy wariant powinien mieć własny opis `ThemeData`.
- Stosuj zasadę `Don't make me think`: po 2 sekundach user ma wiedzieć, gdzie patrzeć i co kliknąć.
- Home nie jest raportem ani dashboardem. Home ma odpowiedzieć: co user ma zrobić teraz?
- Home ma mieć jeden dominujący fokus i jedno główne CTA.
- Nie dawaj wielu elementów o tej samej wadze. Jeśli wszystko jest ważne, nic nie jest ważne.
- Szczegóły, historię, statystyki, ustawienia, mniej ważne informacje itp przenoś do osobnych ekranów, bottom sheetów albo detail screenów.
- Każdy wariant może mieć 1-3 wspierające ekrany lub bottom sheety, jeśli dzięki temu Home będzie prostszy.
- Tekst na Home ogranicz do minimum. Preferuj krótkie etykiety, liczby, statusy, ikony i czytelne akcje.
- Styl ma wspierać fokus, nie dodawać szum. Unikaj ozdobników, które nie pomagają użytkownikowi.
- Każdy wariant musi mieć jasny `Hierarchy contract`: co jest najważniejsze, jak wygląda CTA, co zostaje drugorzędne.
- Każdy wariant musi określić paletę, typografię, spacing, komponenty, motion i treatment głównego CTA.

## KROKI DO WYKONANIA
1. Przeczytaj `docs/working/02_home/variant_manifest.md`.
2. Z `docs/IDEA.md` wypisz krótko:
   - co user robi najczęściej,
   - jakie dane są najważniejsze na Home,
   - jaka metafora pasuje do tej apki,
   - czym ta apka różni się od podobnych tego typu.
3. Zaproponuj dokładnie tyle konceptów, ile wskazuje `count`.
4. Użyj etykiet z `labels`, zawsze od `A` w górę, ale każdej literze dodaj opisową nazwę, np. `A - Swipe deck decyzji`.
5. Każdy wariant musi być fundamentalnie inny:
   - inna organizacja treści,
   - inna gęstość informacji,
   - inna główna interakcja,
   - inna hierarchia wizualna,
   - inny układ przestrzenny,
   - inna paleta / typografia / spacing / motion,
   - inny treatment głównego CTA.
6. Dla każdego konceptu pokaż tabelę:

```text
wariant | nazwa | dlaczego pasuje do tej apki | archetyp | gęstość | główny gest | pierwszy fokus wzroku | visual direction | ThemeData | CTA treatment | hierarchy contract | anti-noise | czego ten wariant NIE robi
```

7. Gest z tabeli musi być możliwy do zaimplementowania w kompletnym wariancie Home. Jeśli wariant wygląda na przesuwalny, rozwijany albo przeciągalny, później ma to działać.
8. Porażka, jeśli:
   - dwa warianty są podobne,
   - różnicę widać dopiero po przyglądaniu się,
   - wszystkie warianty są listą, kartami albo dashboardem,
   - wariant nie wynika z `docs/IDEA.md`,
   - gest jest tylko narysowany, ale nie da się go realnie użyć,
   - Home wygląda jak raport z wieloma kartami tej samej wagi,
   - user nie wie, co jest główną akcją,
   - ekran wymaga czytania wielu zdań,
   - większość informacji można było przenieść do oddzielnych screenów,
   - styl różni się tylko kolorem przycisku,
   - styl osłabia główny fokus,
   - wariant dodaje szum, żeby wyglądać bogato.
9. Nawet przy `3` wariantach każdy ma być wyraźnie innym podejściem.
10. Pokaż mi propozycje. Nie rekomenduj jednego wariantu.
11. ZATRZYMAJ SIĘ i czekaj na `next`.

## FINISH
Poinformuj mnie, że koncepty są gotowe. Powiedz mi, że kolejny krok to `04_home-prepare.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/04_home-prepare.md`.

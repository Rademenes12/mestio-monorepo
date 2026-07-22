# ZADANIE: 04_home_prepare

## CEL
Zapisać szczegółowy plan implementacji każdego wariantu Home do plików roboczych.

## KROKI DO WYKONANIA
1. Przeczytaj `docs/working/02_home/variant_manifest.md`.
2. Utwórz katalog `docs/working/02_home/plans/`.
3. Zaktualizuj `docs/working/02_home/variant_manifest.md`, dodając opisowe nazwy wariantów, np.:

```md
titles:
- A: Swipe deck decyzji
- B: Timeline postępu
```

4. Dla każdej etykiety z `labels` utwórz plan:

```text
docs/working/02_home/plans/home_variant_<letter>.md
```

Przykład: `docs/working/02_home/plans/home_variant_a.md`.

5. Każdy plan ma zawierać:
   - cel wariantu,
   - opisową nazwę wariantu,
   - dlaczego pasuje do tej konkretnej apki,
   - archetyp, gęstość i pierwszy fokus wzroku,
   - jedno główne CTA,
   - visual direction,
   - `ThemeData` notes,
   - paletę kolorów,
   - typografię,
   - komponenty i spacing,
   - kształty, głębię i motion,
   - treatment głównego CTA,
   - informacje zostawione na Home,
   - informacje przeniesione na sub-ekrany lub bottom sheety,
   - strukturę plików,
   - układ ekranu,
   - fake data,
   - nawigację,
   - główny gest i mikrointerakcje,
   - sub-ekrany lub placeholdery,
   - sposób podpięcia do preview,
   - kryteria akceptacji.
6. W każdym planie dodaj sekcję `Hierarchy contract`:
   - co jest wizualnie najważniejsze,
   - jak wygląda główne CTA,
   - co jest drugorzędne,
   - czego styl nie może podbić do tej samej wagi.
7. W każdym planie dodaj sekcję `Anti-noise`:
   - czego nie dodajesz tylko po to, żeby design wyglądał bogato,
   - jak ograniczasz nadmiar tekstu,
   - jak styl wspiera fokus i główne CTA,
   - czym ten wariant różni się od pozostałych.
8. W każdym planie dodaj sekcję `Anty-klon`:
   - czym ten wariant różni się od pozostałych,
   - czego ten wariant celowo nie robi,
   - jaki gest musi działać po implementacji.
9. W każdym planie dodaj sekcję `Don't make me think`:
   - co user ma zobaczyć jako pierwsze,
   - co user ma zrobić jako pierwsze,
   - które informacje celowo ukrywasz poza Home.
10. Nie pisz jeszcze kodu aplikacji.
11. Wykonaj commit z planami.

## FINISH
Poinformuj mnie, że plany wariantów Home są gotowe. Powiedz mi, że kolejny krok to `05_home-build-next.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/05_home-build-next.md`.

# ZADANIE: 07_home_document_design

## CEL
Udokumentować wybrany kierunek Home w `docs/DESIGN.md`.

To jest dokument bazowy dla finalnego Home i późniejszego etapu `redesign`.

## KROKI DO WYKONANIA
1. Przeczytaj `docs/working/02_home/variant_manifest.md`.
2. Sprawdź `chosen` i `chosen_path`. Jeśli ich nie ma, wróć do wyboru wariantu w `docs/commands/02_home/06_home-choose.md`.
3. Przeczytaj wybrany plik z `chosen_path`.
4. Przeczytaj plan wybranego wariantu:

```text
docs/working/02_home/plans/home_variant_<letter>.md
```

5. Utwórz albo nadpisz `docs/DESIGN.md`.
6. Opisz krótko i konkretnie:
   - wybrany wariant Home i jego nazwę,
   - kierunek wizualny,
   - kolory,
   - typografię,
   - spacing,
   - komponenty,
   - kształty, głębię i motion,
   - mikrointerakcje,
   - primary focus,
   - primary CTA,
   - CTA treatment,
   - hierarchy contract,
   - secondary surfaces,
   - anti-noise rules,
   - czego nie robić na kolejnych ekranach,
   - zasady dla kolejnych ekranów,
   - wytyczne pod przyszły Dark Mode jako feature Pro.
   - itp
7. Dokument ma wynikać z wybranego wariantu Home i jego stylu.
8. Nie usuwaj sandboxu, nie kopiuj wariantu do `home_base.dart` i nie przenoś Home do `lib/features/home/ui/home_screen.dart`. To zrobi `docs/commands/02_home/08_home-clean-up.md`.
9. Wykonaj commit.
10. Poinformuj mnie, co zostało zapisane.

## FINISH
Powiedz, że kolejny krok to `08_home-clean-up.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/08_home-clean-up.md`.

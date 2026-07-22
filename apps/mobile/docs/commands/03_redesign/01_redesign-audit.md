# ZADANIE: 01_redesign_audit

## CEL
Przygotować roboczy audyt dla etapu `redesign`: jaki styl opisuje `docs/DESIGN.md`, jak wygląda finalny Home, które ekrany auth/profile trzeba dopasować i gdzie są ryzyka.

## KROKI DO WYKONANIA
1. Przeczytaj `docs/DESIGN.md`. Jeśli plik nie istnieje, zatrzymaj się i wróć do `docs/commands/02_home/07_home-document-design.md`.
2. Przeczytaj `docs/working/02_home/variant_manifest.md`.
3. Sprawdź `chosen` i `chosen_path`. Jeśli ich nie ma, zatrzymaj się i wróć do `docs/commands/02_home/06_home-choose.md`.
4. Przeczytaj finalny Home w:

```text
lib/features/home/ui/home_screen.dart
```

5. Sprawdź, czy sandbox wariantów został usunięty. Jeśli nadal istnieje, zatrzymaj się i wróć do `docs/commands/02_home/10_home-verify.md`:

```text
lib/features/home/ui/temporary_widgets/
```

6. Przeczytaj plan wybranego wariantu:

```text
docs/working/02_home/plans/home_variant_<letter>.md
```

7. Przejrzyj istniejące ekrany template'u do dopasowania, w szczególności:
   - `lib/features/auth/presentation/ui/welcome_screen.dart`
   - `lib/features/auth/presentation/ui/login_screen.dart`
   - `lib/features/auth/presentation/ui/forgot_password_screen.dart`
   - `lib/features/auth/presentation/ui/reset_password_screen.dart`
   - `lib/features/auth/presentation/ui/register_screen.dart`
   - `lib/features/profiles/presentation/ui/profile_screen.dart`
   - `lib/app/profile/presentation/ui/delete_account_confirmation_screen.dart`
8. Jeśli w repo są inne powierzchnie auth/profile/upgrade, dopisz je do audytu.
9. Utwórz katalog `docs/working/03_redesign/`.
10. Utwórz `docs/working/03_redesign/audit.md`.
11. Audyt ma zawierać:
   - wybrany wariant Home i `chosen_path`,
   - ścieżkę planu Home,
   - ścieżkę finalnego Home,
   - krótkie streszczenie `docs/DESIGN.md`,
   - listę ekranów do dopasowania,
   - listę plików, które prawdopodobnie będą edytowane,
   - co wymaga `docs/skills/flutter-mobile-design-skill.md`,
   - co wymaga `docs/skills/flutter-mobile-ux-skill.md`,
   - ryzyka dla flow auth/profile,
   - plan commitów dla kolejnych kroków.
12. Nie planuj ani nie wykonuj refactoru Home.
13. Nie zmieniaj jeszcze kodu Flutter.

## FINISH
Poinformuj mnie, że audyt jest gotowy. Powiedz, że kolejny krok to `02_redesign-auth-screens.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/03_redesign/02_redesign-auth-screens.md`.

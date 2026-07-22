# ZADANIE: 02_redesign_auth_screens

## CEL
Dopasować istniejące ekrany auth do stylu opisanego w `docs/DESIGN.md`, bez zmiany flow auth.

## KROKI DO WYKONANIA
1. Przeczytaj:
   - `docs/DESIGN.md`
   - `docs/working/03_redesign/audit.md`
   - `AGENTS.md`
   - `docs/skills/flutter-mobile-design-skill.md`
   - `docs/skills/flutter-mobile-ux-skill.md`
2. Dopasuj wizualnie istniejące ekrany auth, jeśli występują w repo:
   - Welcome Screen: `lib/features/auth/presentation/ui/welcome_screen.dart`
   - Logowanie: `lib/features/auth/presentation/ui/login_screen.dart`
   - Przypomnienie hasła: `lib/features/auth/presentation/ui/forgot_password_screen.dart`
   - Reset hasła: `lib/features/auth/presentation/ui/reset_password_screen.dart`
   - Rejestracja / upgrade konta: `lib/features/auth/presentation/ui/register_screen.dart`
   - inne powierzchnie auth/upgrade znalezione w audycie.
3. Styl ma być zgodny z `docs/DESIGN.md`:
   - kolory,
   - typografia,
   - spacing,
   - kształty i komponenty,
   - treatment CTA,
   - empty/error/loading surfaces,
   - mikrointerakcje tam, gdzie są naturalne.
4. Nie zmieniaj zasad auth z `AGENTS.md`.
5. Nie zmieniaj logiki Supabase/Auth poza tym, co jest konieczne do zachowania aktualnego działania.
6. Przy formularzach zachowaj mobilną ergonomię: scroll, dismiss keyboard, poprawne `TextField`, `SafeArea`, widoczne błędy inline.
7. Uruchom `flutter analyze` i napraw błędy, warningi oraz info.
8. Wykonaj commit.
9. Poinformuj mnie o zmianach.

## FINISH
Powiedz, że kolejny krok to `03_redesign-profile-screens.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/03_redesign/03_redesign-profile-screens.md`.

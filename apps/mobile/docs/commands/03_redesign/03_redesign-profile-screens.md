# ZADANIE: 03_redesign_profile_screens

## CEL
Dopasować Profile, Delete Account i pozostałe powierzchnie profilowe do stylu opisanego w `docs/DESIGN.md`, bez zmiany logiki konta.

## KROKI DO WYKONANIA
1. Dopasuj wizualnie istniejące powierzchnie profilowe, jeśli występują w repo:
   - Profile Screen: `lib/features/profiles/presentation/ui/profile_screen.dart`
   - Delete Account: `lib/app/profile/presentation/ui/delete_account_confirmation_screen.dart`
   - upgrade konta z profilu,
   - inne powierzchnie profilu wskazane w audycie.
2. Styl ma być zgodny z `docs/DESIGN.md`:
   - kolory,
   - typografia,
   - spacing,
   - kształty i komponenty,
   - treatment CTA,
   - empty/error/loading surfaces,
   - mikrointerakcje tam, gdzie są naturalne.
3. Nie zmieniaj flow profilu, upgrade'u konta ani usuwania konta.
4. Przy formularzach i dialogach zachowaj zasady z `AGENTS.md`: loading po `Save`, blokada interakcji, sukces przez `SnackBar`, błędy inline jako `SelectableText`.
5. Uruchom `flutter analyze` i napraw błędy, warningi oraz info.
6. Wykonaj commit.
7. Poinformuj mnie o zmianach.

## FINISH
Powiedz, że kolejny krok to `04_redesign-verify.md` i zasugeruj napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/03_redesign/04_redesign-verify.md`.

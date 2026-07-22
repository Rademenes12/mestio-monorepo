# Redesign Audit - Stage 03

Ten dokument stanowi plan wdrożenia i audytu dla etapu `redesign`. Zapewnia spójność wizualną między nowo wdrożonym Pulpitem (Dashboard) a ekranami pomocniczymi (logowanie, rejestracja, profil, usuwanie konta).

---

## 🎨 Wybrany Wariant i Design

- **Wybrany Wariant Home:** Wariant E (Premium Light/Card Layout) zintegrowany w `dashboard_screen.dart`.
- **Ścieżka finalnego Home:** `lib/features/reports/presentation/ui/dashboard_screen.dart` (dostępny przez `lib/features/home/ui/home_screen.dart`).
- **Krótkie streszczenie `docs/DESIGN.md`:**
  - **Paleta barw:** Brandowy *Electric Indigo* (`#5E5CE6`) oraz *Cyan Glow* (`#0A84FF`) jako akcenty. Statusy: *Amber Alert* (`#FF9F0A`) i *Neon Mint* (`#30D158`).
  - **Tła i karty:** Jasne tła marmurowe (`#F5F7FA`) z białymi kartami (`#FFFFFF`), zaokrąglonymi na poziomie `16.0` (karty) lub `12.0` (przyciski/inputy) oraz subtelnymi cieniowaniami i obramowaniami (opacity 8%).
  - **Siatka:** Spójna 8-punktowa siatka (spacingi 8, 16, 24, 32, 48), minimalne touch targety `48.0`.
  - **Typografia:** Bezszeryfowy font geometryczny (Outfit/Inter). Nagłówki `28sp Bold`, sekcje `18sp SemiBold`.

---

## 📱 Ekrany do Dopasowania (Redesign Scope)

1. **`lib/features/auth/presentation/ui/welcome_screen.dart`**
   - Zmiana tła z czystej bieli na subtelny gradient/szary marmur.
   - Dopasowanie przycisku "Kontynuuj jako gość" (Electric Indigo) oraz "Zaloguj się" (stylized outlined).
   - Wyrównanie ikony aplikacji (zaokrąglenia, cienie).
2. **`lib/features/auth/presentation/ui/login_screen.dart`**
   - Redesign formularza logowania – ramki pól tekstowych, ikony wiodące.
   - Płaski, premium wygląd kart z zaokrąglonymi rogami `16.0`.
   - Zintegrowanie spójnego zachowania klawiatury i scrolla.
3. **`lib/features/auth/presentation/ui/forgot_password_screen.dart`**
   - Dostosowanie do spójnego brandingu.
   - Wyraźne błędy inline.
4. **`lib/features/auth/presentation/ui/reset_password_screen.dart`**
   - Spójny wygląd i spacingi.
5. **`lib/features/auth/presentation/ui/register_screen.dart`**
   - Ekran rejestracji/zabezpieczenia konta gościa.
6. **`lib/features/profiles/presentation/ui/profile_screen.dart`**
   - Dodatkowe widoki profilowe (ustawienia, wylogowanie).
7. **`lib/app/profile/presentation/ui/delete_account_confirmation_screen.dart`**
   - Bezpieczne usuwanie konta (spójne przyciski ostrzegawcze Coral).

---

## 📐 Wymagania UX & Design (Skills checklist)

- **`flutter-mobile-design-skill.md`:**
  - Koniec z domyślnymi kolorami i ostrymi krawędziami.
  - Spójna hierarchia typograficzna i wysoki kontrast.
  - Wszystkie przyciski z wysokością co najmniej `48.0` logical px.
- **`flutter-mobile-ux-skill.md`:**
  - Bezpieczny scroll dla formularzy (uniknięcie przepełnienia ekranu klawiaturą).
  - Dismiss keyboard (`GestureDetector` z `FocusScope.of(context).unfocus()`).
  - Błędy i loading states prezentowane inline w bezpiecznych miejscach, nie w popupach.

---

## ⚠️ Ryzyka i Zagrożenia

- **Overflow przy otwartej klawiaturze:** Formularze na ekranach logowania i resetu hasła mogą powodować błędy `RenderFlex overflow` na mniejszych urządzeniach (np. iPhone SE). Zabezpieczenie: stosowanie `SingleChildScrollView` oraz `SafeArea`.
- **Integracja stanu sesji:** Zmiana ról użytkowników (Mieszkaniec / Zarządca) musi poprawnie aktualizować layout tabów bez wycieków stanu.

---

## 📅 Plan Commitów

1. `feat(redesign): audit and prepare docs/working/03_redesign/` (obecny krok).
2. `feat(redesign): redesign auth screens (welcome, login, reset, forgot, register)` (krok 02).
3. `feat(redesign): redesign profile screens and delete account flows` (krok 03).
4. `feat(redesign): finalize verification, clean imports and run tests` (krok 04).

# Propozycja Nowego Designu Ekranów Startowych (Auth Flow Redesign)

Dokument zawiera porównanie obecnego stanu z makietą użytkownika oraz kompletną propozycję spójnego wyglądu dla całego przepływu startowego: **Rozpocznij (Welcome) / Logowanie (Login) / Rejestracja (Register)**.

---

## 🎨 1. Porównanie i Analiza Różnic (Makieta vs Nasza Implementacja)

### Zdjęcie Budynku (Header)
- **Makieta**: Zdjęcie nowoczesnego, białego budynku z ciemnymi wnękami okiennymi i szklanymi balkonami, wykonane pod dużym kątem z dołu.
- **Wygenerowane tło**: Bardzo zbliżone – jasny, nowoczesny budynek mieszkalny z niebieskim niebem.
- **Rekomendacja**: Wygenerowane tło wygląda bardzo profesjonalnie i pasuje do klimatu FixFlow.

### Logotyp (Logo & Wordmark)
- **Makieta**: Logo (dwie okrągłe strzały w kolorach niebieskim i zielonym ze śrubokrętem w środku) **nie ma żadnego białego tła (karty/okręgu)**. Znajduje się bezpośrednio na białym tle, na które nachodzi dolny fade zdjęcia. Napis **FIXFLOW** jest umieszczony pod spodem, z zieloną literą **L** (`FIXF` - ciemny, `L` - zielony, `OW` - ciemny).
- **Nasza poprzednia implementacja**: Logo było zamknięte w białym okręgu z cieniami (styl karty/badge).
- **Rekomendacja**: Usuwamy biały okrąg tła z logotypu. Logo i napis "FIXFLOW" powinny pływać bezpośrednio na jasnym tle/fade zdjęcia, co nada aplikacji jeszcze lżejszy i bardziej nowoczesny wygląd premium (flat clean).

### Przycisk "Rozpocznij" i Akcje Dolne
- **Makieta**: Płaski, mocno zaokrąglony (pill shape, radius 28) przycisk z gradientem od niebieskiego (`#0A84FF`) do fioletowego (`#5E5CE6`). Na samym dole prosta linia tekstu `Zaloguj się | Zarejestruj`.
- **Wdrożona wersja**: Zgodna z makietą.

---

## 📐 2. Propozycja Spójnego Wyglądu Ekranów Startowych (Welcome / Login / Register)

Aby aplikacja wyglądała spójnie i luksusowo, proponujemy ujednolicenie wszystkich ekranów wejściowych według poniższego schematu.

### 📱 A. Ekran Powitalny (`WelcomeScreen`)
Zgodnie z zaakceptowanymi poprawkami z makiety:
- **Góra**: Zdjęcie budynku (48% wysokości) z płynnym przejściem w biel.
- **Środek**: Logo FixFlow bezpośrednio na białym tle (bez białej tarczy/koła). Tytuł **"Witaj w FixFlow"** w pogrubionym, ciemnym węgielnym kolorze (`#1A1A24`).
- **Dół**: Gradientowy przycisk **"Rozpocznij"** (Logowanie jako gość, które kieruje do Rejestracji Lokatora). Pod nim dolne linki: `Zaloguj się` (otwiera ekran logowania) i `Zarejestruj` (automatycznie loguje jako gość i otwiera ekran Rejestracji Lokatora).

---

### 🔑 B. Ekran Logowania (`LoginScreen`)
Obecny ekran logowania to standardowy formularz na szarym/białym tle. Proponujemy dopasowanie go do stylu ekranu powitalnego:
1. **Brandowy Header**: Na samej górze ekranu małe, estetyczne zdjęcie budynku (ok. 25% wysokości) z tym samym gradientowym przejściem w biel, a pod nim mały napis **FIXFLOW**. Dzięki temu użytkownik od razu czuje, że jest w tej samej aplikacji.
2. **Karta Logowania**:
   - Nagłówek: **"Zaloguj się na konto"** (rozmiar 24, Bold).
   - Podtytuł: "Użyj adresu e-mail i hasła, aby się zalogować."
3. **Pola Tekstowe (Inputs)**:
   - Zamiast standardowych Material Design, użyjemy nowoczesnych pól z delikatnym szarym tłem (`#F5F7FA`), zaokrąglonymi rogami (`radius 12`) i subtelnym obramowaniem (aktywne pole podświetlane na kolor brandowy `#0A84FF`).
   - Ikony wiodące (koperta dla e-maila, kłódka dla hasła).
4. **Przycisk Akcji**:
   - Taki sam gradientowy przycisk **"Zaloguj się"** (Cyan Glow -> Electric Indigo).
5. **Nawigacja wsteczna / Reset**:
   - Subtelny link "Zapomniałeś hasła?" pod polem hasła.
   - Płaski przycisk "Wróć" na samym dole lub standardowa, elegancka, przezroczysta strzałka wstecz w lewym górnym rogu.

---

### 📝 C. Ekran Rejestracji / Zabezpieczenia Konta (`RegisterScreen`)
Dla użytkowników, którzy rejestrują konto lub zabezpieczają konto gościa:
1. **Brandowy Header**: Taki sam jak na ekranie logowania (25% wysokości, zdjęcie + mini logo).
2. **Karta Formularza**:
   - Nagłówek: **"Stwórz konto"** lub **"Zabezpiecz konto"** (w zależności od tego, czy użytkownik ma już dane gościa).
3. **Pola Tekstowe**:
   - Ten sam styl co w logowaniu: zaokrąglone rogi `12`, delikatne tło `#F5F7FA`, ikony pomocnicze.
4. **Przycisk Akcji**:
   - Gradientowy przycisk **"Zarejestruj się"** / **"Zapisz dane"**.
5. **Informacje pomocnicze**:
   - Subtelny opis wyjaśniający, że rejestracja powiąże zgłoszenia i historię awarii z adresem e-mail.

---

## 🛠️ Zmiany techniczne do wdrożenia

| Plik | Zakres zmian |
| --- | --- |
| `lib/features/auth/presentation/ui/welcome_screen.dart` | Usunięcie białego okręgu z logo, dopasowanie spacingów, upewnienie się o 100% zgodności z makietą. |
| `lib/features/auth/presentation/ui/login_screen.dart` | Dodanie nagłówka z budynkiem, dodanie stylizowanych zaokrąglonych pól tekstowych (input decoration), gradientowy przycisk. |
| `lib/features/auth/presentation/ui/register_screen.dart` | Dodanie nagłówka z budynkiem, stylizowane zaokrąglone pola tekstowe, gradientowy przycisk. |
| `lib/features/auth/presentation/ui/forgot_password_screen.dart` | Dostosowanie pól i przycisków do nowego stylu. |
| `lib/features/auth/presentation/ui/reset_password_screen.dart` | Dostosowanie pól i przycisków do nowego stylu. |

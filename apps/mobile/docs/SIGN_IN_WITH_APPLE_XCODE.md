# 🍏 Sign in with Apple - Xcode Configuration

**Źródło:** Apple Developer Documentation (2026)

---

## PRZED STARTEM: Co musisz mieć

- ✅ macOS z zainstalowanym Xcode (najnowsza wersja)
- ✅ Apple Developer Account (darmowy wystarczy do testów, płatny $99/rok do publikacji)
- ✅ Zalogowany w Xcode swoim Apple ID (Xcode → Settings → Accounts)

---

## Krok 1: Otwórz projekt Flutter w Xcode

### 1.1 Znajdź folder iOS
```
C:\12appsChallange\apps5\ios\
```

### 1.2 Otwórz WORKSPACE (nie project!)
**WAŻNE:** Musisz otworzyć `Runner.xcworkspace`, NIE `Runner.xcodeproj`

- Kliknij prawym na `Runner.xcworkspace` → **Open With → Xcode**
- LUB przeciągnij `Runner.xcworkspace` na ikonę Xcode w Docku

**Dlaczego workspace?** Flutter używa CocoaPods, który wymaga workspace.

---

## Krok 2: Nawigacja do konfiguracji projektu

### 2.1 Lewy panel (Navigator)
Po lewej stronie zobaczysz **Navigator Area** (panel plików).

Na samej górze tego panelu jest **niebieski folder** z ikoną projektu i napisem **"Runner"**.

👉 **Kliknij na ten niebieski Runner** (to jest root projektu, nie folder z kodem)

### 2.2 Główny widok (Editor Area)
Po kliknięciu na Runner, w środkowym panelu (Editor Area) zobaczysz **Project Editor** z zakładkami:
- General
- **Signing & Capabilities** 👈 Tu idziemy
- Resource Tags
- Info
- Build Settings
- itd.

### 2.3 Sidebar (Targets)
W **lewej części** Project Editor zobaczysz listę:
```
PROJECT
  Runner

TARGETS
  Runner  👈 Upewnij się że to jest zaznaczone
```

👉 **Kliknij na Runner w sekcji TARGETS** (jeśli nie jest zaznaczony)

### 2.4 Zakładka Signing & Capabilities
👉 **Kliknij zakładkę "Signing & Capabilities"** u góry Project Editor

---

## Krok 3: Dodaj Sign in with Apple Capability

### 3.1 Znajdź przycisk "+ Capability"
W zakładce **Signing & Capabilities** zobaczysz:

**Na górze:** Toolbar z przyciskiem **"+ Capability"** (po lewej stronie)

```
┌─────────────────────────────────────────────────────┐
│  + Capability    All  Debug  Release   [filtr]      │  👈 Toolbar
├─────────────────────────────────────────────────────┤
│  Signing (Debug)                                    │
│    Automatically manage signing  ☑                  │
│    Team: Twój Team                                  │
│    Bundle Identifier: com.pawelpasik.fixflow        │
└─────────────────────────────────────────────────────┘
```

👉 **Kliknij "+ Capability"**

### 3.2 Capabilities Library
Otworzy się **modalne okno** (library) z listą dostępnych capabilities:

```
┌────────────────────────────────────────────┐
│  Capabilities        [Search field]        │
├────────────────────────────────────────────┤
│  ☐ Access WiFi Information                 │
│  ☐ App Groups                              │
│  ☐ Apple Pay                               │
│  ☐ ...                                     │
│  ☐ Push Notifications                      │
│  ☐ Sign in with Apple          👈 TO!      │
│  ☐ Siri                                    │
│  ...                                       │
└────────────────────────────────────────────┘
```

**Szukaj:** Możesz wpisać "Sign" w search field u góry

👉 **Kliknij dwa razy (double-click) na "Sign in with Apple"**

LUB

👉 **Przeciągnij "Sign in with Apple" z library na obszar Signing & Capabilities**

### 3.3 Capability dodane!
Okno library zamknie się, a w Signing & Capabilities zobaczysz nową sekcję:

```
┌─────────────────────────────────────────────────────┐
│  Signing (Debug)                                    │
│    ...                                              │
├─────────────────────────────────────────────────────┤
│  ☑ Sign in with Apple                               │  👈 DODANE!
│    [Edit]                                           │
└─────────────────────────────────────────────────────┘
```

**NIE MUSISZ** klikać "Edit" - domyślna konfiguracja jest OK.

---

## Krok 4: Weryfikacja

### 4.1 Sprawdź Bundle ID
W sekcji **Signing (Debug)** i **Signing (Release)** upewnij się że:

```
Bundle Identifier: com.pawelpasik.fixflow  ✅
```

Jeśli widzisz błąd "No account for team" - dodaj swój Apple ID:
- Xcode → Settings → Accounts → + → Sign in with Apple ID

### 4.2 Sprawdź Team
```
Team: Twoje Imię Nazwisko (Personal Team)
```

Jeśli nie ma teamu - wybierz z dropdownu.

### 4.3 Sprawdź Entitlements
Xcode automatycznie utworzył plik `Runner/Runner.entitlements` z:

```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

**Nie musisz tego ręcznie edytować** - Xcode zrobił to za Ciebie.

---

## Krok 5: Build Test (opcjonalny)

### 5.1 Wybierz symulator
U góry Xcode, w toolbarze wybierz:
```
Runner > iPhone 15 (lub inny symulator)
```

### 5.2 Build projekt
```
Product → Build  (Cmd+B)
```

**Jeśli build się udał:** ✅ Capability jest poprawnie skonfigurowane!

**Jeśli są błędy:** 
- "Provisioning profile doesn't match" - normalne, naprawimy przy release build
- Inne błędy - zobacz sekcję Troubleshooting poniżej

## Krok 3: Zweryfikuj Bundle ID

Upewnij się że w sekcji **Signing & Capabilities** → **Signing**:
- **Bundle Identifier**: `com.pawelpasik.fixflow`
- **Team**: Twój Apple Developer Team

## Krok 4: Build projekt (opcjonalnie)

Możesz spróbować zbudować projekt żeby sprawdzić czy nie ma błędów:
- Wybierz symulator iOS (np. iPhone 15)
- Kliknij **Product → Build** (Cmd+B)

**Jeśli są błędy provisioning profile** - to normalne, naprawimy to później przy pierwszym buildzie produkcyjnym.

## ✅ Gotowe!

Xcode dodał capability. Możesz zamknąć Xcode.

**Następny krok:** Konfiguracja Supabase Auth (zrobi AI).

---

## Troubleshooting

### "No signing certificate found"
- Normalne na tym etapie
- Naprawimy przy konfiguracji Codemagic (CI/CD)

### "Capability requires paid developer account"
- Potrzebujesz **Apple Developer Program** ($99/rok)
- Bez tego Sign in with Apple nie zadziała na prawdziwym urządzeniu
- Na symulatorze zadziała

### "Provisioning profile doesn't include Sign in with Apple"
- Xcode automatycznie zaktualizuje profil
- Lub zrób to manualnie w Apple Developer Console

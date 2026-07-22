# 📱 Tworzenie aplikacji w App Store Connect - Instrukcja krok po kroku

## Dane z projektu

Z plików `docs/IDEA.md` i `docs/PUBLISH.md`:

| Parametr | Wartość |
|----------|---------|
| **Bundle ID** | `com.pawelpasik.fixflow` |
| **SKU** | `fixflow` |
| **App Name** | `FixFlow` |
| **Primary Language** | English (U.S.) |

---

## Krok 1: Zarejestruj Bundle ID w Apple Developer

1. Wejdź na: https://developer.apple.com/account/resources/identifiers/bundleId/add/bundle

2. Wypełnij pola:
   - **Description**: `fixflow`
   - **Bundle ID**: upewnij się, że radio button jest na **Explicit**, a następnie wpisz:
     ```
     com.pawelpasik.fixflow
     ```

3. **Capabilities** - ZAZNACZ te opcje:
   - [ ] **Sign in with Apple** (WYMAGANE - implementujemy to w następnym kroku!)
   - [ ] **Push Notifications**

4. Sekcje **App Services** i **Capability Requests** zostaw bez zmian.

5. Kliknij **Continue**, a następnie **Register**.

---

## Krok 2: Utwórz aplikację w App Store Connect

1. Zaloguj się na: https://appstoreconnect.apple.com/

2. Wejdź w zakładkę **Apps**

3. Kliknij **+** (plus) → **New App**

4. Wypełnij pola:

| Pole | Wartość |
|------|---------|
| **Platforms** | ☑ iOS |
| **Name** | `FixFlow` |
| **Primary Language** | English (U.S.) |
| **Bundle ID** | Wybierz z listy: `com.pawelpasik.fixflow` |
| **SKU** | `fixflow` |
| **User Access** | Full Access |

5. Kliknij **Create**

---

## Krok 3: Wypełnij podstawowe informacje (opcjonalne - możesz to zrobić później)

Po utworzeniu aplikacji zobaczysz panel z wieloma sekcjami. Na razie **NIE MUSISZ** ich wypełniać - to zrobimy później zgodnie z instrukcją `21_publish-appstoreconnect-fill.md`.

Możesz zamknąć App Store Connect.

---

## ✅ Gotowe!

Aplikacja FixFlow została utworzona w App Store Connect.

**Bundle ID** `com.pawelpasik.fixflow` jest teraz zarejestrowany z **Sign in with Apple** capability.

**Następny krok:** Implementacja Sign in with Apple w kodzie Flutter.

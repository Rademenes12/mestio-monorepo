# 🍏 Supabase - Sign in with Apple Configuration

## ⚠️ UWAGA: Musisz to zrobić RĘCZNIE

Apple wymaga konfiguracji w Apple Developer Console + Supabase Dashboard.

---

## CZĘŚĆ 1: Apple Developer Console (Services ID)

### Krok 1: Utwórz Services ID

1. Wejdź na: https://developer.apple.com/account/resources/identifiers/list/serviceId

2. Kliknij **+** (plus) aby dodać nowy identifier

3. Wybierz **Services IDs** → Continue

4. Wypełnij:
   ```
   Description: FixFlow Auth
   Identifier: com.pawelpasik.fixflow.auth
   ```

5. Zaznacz checkbox **Sign in with Apple**

6. Kliknij **Configure** obok "Sign in with Apple"

7. W oknie konfiguracji:
   
   **Primary App ID:**
   ```
   com.pawelpasik.fixflow
   ```
   
   **Website URLs:**
   - **Domains and Subdomains:**
     ```
     rtyywhbisjaxlpjcugdk.supabase.co
     ```
   
   - **Return URLs:**
     ```
     https://rtyywhbisjaxlpjcugdk.supabase.co/auth/v1/callback
     ```

8. Kliknij **Done** → **Continue** → **Register**

---

### Krok 2: Utwórz Key dla Sign in with Apple

1. Wejdź na: https://developer.apple.com/account/resources/authkeys/list

2. Kliknij **+** (plus)

3. **Key Name:**
   ```
   FixFlow Sign in with Apple Key
   ```

4. Zaznacz **Sign in with Apple**

5. Kliknij **Configure** obok "Sign in with Apple"

6. Wybierz **Primary App ID:**
   ```
   com.pawelpasik.fixflow
   ```

7. Kliknij **Save** → **Continue** → **Register**

8. **WAŻNE:** Pobierz klucz (.p8 file)
   - Kliknij **Download**
   - Zapisz jako `AuthKey_XXXXXXXXXX.p8`
   - **NIE ZGUB TEGO PLIKU** - nie będziesz mógł go ponownie pobrać!

9. Zanotuj:
   - **Key ID**: (10 znaków, np. `ABC123DEFG`)
   - **Team ID**: (znajdź w prawym górnym rogu - 10 znaków)

---

## CZĘŚĆ 2: Supabase Dashboard

### Krok 3: Skonfiguruj Apple Provider

1. Wejdź na: https://supabase.com/dashboard/project/rtyywhbisjaxlpjcugdk/auth/providers

2. Znajdź **Apple** w liście providerów

3. Kliknij **Enable** lub **Configure**

4. Wypełnij pola:

   **Application ID (Services ID):**
   ```
   com.pawelpasik.fixflow.auth
   ```
   
   **Secret Key (Private Key):**
   - Otwórz plik `AuthKey_XXXXXXXXXX.p8` w notatniku
   - Skopiuj **CAŁĄ ZAWARTOŚĆ** (łącznie z `-----BEGIN PRIVATE KEY-----`)
   - Wklej do pola
   
   **Key ID:**
   ```
   [Twój Key ID z kroku 2.9]
   ```
   
   **Team ID:**
   ```
   [Twój Team ID z kroku 2.9]
   ```

5. **Callback URL (redirect URL):** (powinien być automatycznie wypełniony)
   ```
   https://rtyywhbisjaxlpjcugdk.supabase.co/auth/v1/callback
   ```

6. Kliknij **Save**

---

## ✅ Weryfikacja

Po zapisaniu w Supabase Dashboard powinieneś zobaczyć:
- ☑ Apple provider **Enabled**
- 🟢 Status: Active

---

## 🚨 Troubleshooting

### "Invalid client" error
- Sprawdź czy Services ID = `com.pawelpasik.fixflow.auth`
- Sprawdź czy Return URL w Apple Developer = Supabase callback URL

### "Invalid grant" error
- Sprawdź czy plik .p8 jest kompletny (z BEGIN/END)
- Sprawdź Key ID i Team ID

### "Redirect URI mismatch"
- Upewnij się że domena w Apple Developer = `rtyywhbisjaxlpjcugdk.supabase.co`
- Return URL = `https://rtyywhbisjaxlpjcugdk.supabase.co/auth/v1/callback`

---

## 📝 Podsumowanie - co musisz mieć:

- [ ] Services ID utworzone: `com.pawelpasik.fixflow.auth`
- [ ] Services ID skonfigurowane z domeną Supabase
- [ ] Key (.p8) pobrane i zapisane bezpiecznie
- [ ] Key ID i Team ID zanotowane
- [ ] Apple provider włączony w Supabase Dashboard
- [ ] Wszystkie pola wypełnione poprawnie

**Gdy to zrobisz, napisz "done" - wtedy przejdę do implementacji kodu.**

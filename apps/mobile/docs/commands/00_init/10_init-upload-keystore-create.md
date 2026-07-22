# ⚠️ KROK INSTRUKCYJNY
- Możesz sam uruchomić tylko bezpieczne sprawdzenie `keytool -help`.
- NIE uruchamiaj `keytool -genkeypair`.
- NIE generuj pliku sam.
- Pokaż mi jedną komendę generującą. Ja ją odpalę.
- **STOP** i czekaj na mój dosłowny `next`.

# CEL
Dać mi komendę do wygenerowania `upload-keystore.p12`.

# Task
1. Wykryj mój system.
2. Sprawdź, czy działa systemowy `keytool`:
   - macOS/Linux: `keytool -help`
   - Windows PowerShell: `keytool -help`

3. Jeśli systemowy `keytool` nie działa, sprawdź `keytool` z Android Studio JBR:
   - macOS:
     ```bash
     /Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool -help
     ```
   - Windows PowerShell:
     ```powershell
     & "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -help
     ```
   - Linux:
     ```bash
     ~/android-studio/jbr/bin/keytool -help
     ```

4. Jeśli żaden wariant nie działa, powiedz mi, żebym zainstalował Android Studio, uruchomił terminal ponownie i wrócił do tego kroku. Nie proponuj instalowania osobnego JDK jako pierwszej opcji.

5. Jeśli znalazłeś działający `keytool`, pokaż mi **jedną** komendę do uruchomienia — tę, która pasuje do mojego systemu i do działającej ścieżki.

**macOS / Linux, gdy działa systemowy `keytool`:**
```bash
keytool -genkeypair -v -keystore ~/upload-keystore.p12 -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**macOS, gdy działa `keytool` z Android Studio:**
```bash
/Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin/keytool -genkeypair -v -keystore ~/upload-keystore.p12 -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Linux, gdy działa `keytool` z Android Studio:**
```bash
~/android-studio/jbr/bin/keytool -genkeypair -v -keystore ~/upload-keystore.p12 -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Windows PowerShell, gdy działa systemowy `keytool`:**
```powershell
keytool -genkeypair -v -keystore $env:USERPROFILE\upload-keystore.p12 -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Windows PowerShell, gdy działa `keytool` z Android Studio:**
```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkeypair -v -keystore $env:USERPROFILE\upload-keystore.p12 -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Powiedz mi, żebym przy generowaniu pliku użył hasła, które podałem w `android/key.properties` dla `storePassword` lub `keyPassword` (powinny być te same wartości).

## FINISH
Jeśli komenda generująca `upload-keystore.p12` wywali się po mojej stronie — pomóż zdiagnozować, ale nadal **nie uruchamiaj `keytool -genkeypair` sam**.

Czekaj na mój dosłowny `next`. Powiedz mi, że kolejny krok to `11_init-upload-keystore-path.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/11_init-upload-keystore-path.md`.

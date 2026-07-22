# ZADANIE: 08_publish_codemagic

## CEL
Użytkownik konfiguruje Codemagic CI/CD dla swojej aplikacji.

## KROKI DO WYKONANIA:

1. Powiedz mi, że teraz pora skonfigurować Codemagic, żeby buildy iOS i Android działały automatycznie.

2. Poproś mnie, żebym najpierw dodał aplikację w Codemagic:
   - Zaloguj się na swoje konto **Codemagic**.
   - Wejdź w zakładkę **Applications**.
   - Kliknij przycisk **Add application**.
   - Jako provider wybierz **GitHub** i kliknij **Select Repository**, żeby przejść dalej.
   - Z listy repozytoriów wybierz to, którego nazwa została ustalona w kroku `07_publish-github.md` (fragment po ostatniej kropce z app bundle ID z `docs/IDEA.md`).
   - W polu **Project Type** zaznacz **Flutter (via Workflow Editor)**.
   - Potwierdź wybór niebieskim przyciskiem **Finish: Add application**.

3. Po dodaniu aplikacji poproś mnie, żebym otworzył sekcję **Environment variables** i w polu **Variable name** wpisał:
   ```
   API_KEYS_BASE64
   ```
   (wartość wkleję w następnym kroku).

4. Wykryj system operacyjny użytkownika (np. `uname -s` dla macOS/Linux; jeśli to Windows — rozpoznasz po środowisku). **Pokaż tylko jedną komendę** — tę, która pasuje do systemu użytkownika. Nie wklejaj obu wariantów.

   Jeśli macOS:
   ```sh
   base64 -i config/api-keys.json | pbcopy
   ```

   Jeśli Windows:
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("config\api-keys.json")) | Set-Clipboard
   ```

   Jeśli Linux (fallback):
   ```sh
   base64 -w0 config/api-keys.json | xclip -selection clipboard
   ```

   Poproś mnie, żebym uruchomił tę jedną komendę w terminalu projektu — wygenerowana wartość trafi do schowka. Następnie wkleiłem ją jako wartość zmiennej `API_KEYS_BASE64` w Codemagic i zapisał.

5. Poproś, żeby w dashboardzie Codemagic wykonał następujące kroki:

   - W **Post-clone script** dodał:
     ```sh
     flutter pub get
     ```
   - W **Pre-build script** dodał:
     ```sh
     #!/bin/sh
     mkdir -p config
     echo "$API_KEYS_BASE64" | base64 --decode > config/api-keys.json
     ```
   - W **Build** ustawił **Mode** na `Release`.
   - W **Build -> Build arguments** dodał dla iOS i Android:
     ```sh
     --dart-define-from-file=config/api-keys.json --build-name=0.0.$(($PROJECT_BUILD_NUMBER + 9)) --build-number=$(($PROJECT_BUILD_NUMBER + 9))
     ```
   - Na końcu kliknął **Save changes**.

6. Powiedz mi, że gdy skończę konfigurację Codemagic, mam napisać `next`, bo będziemy przechodzić do `09_publish-appstoreconnect-create-app.md`.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/09_publish-appstoreconnect-create-app.md`.

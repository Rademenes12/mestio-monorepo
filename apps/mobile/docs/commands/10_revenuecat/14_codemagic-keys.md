# Intro

Twoim zadaniem jako agenta AI jest zamknąć etap RevenueCat.

CEL: Codemagic ma aktualne klucze, repo jest sprawdzone, etap jest podsumowany.

# Task

1. Rozpoznaj mój system operacyjny (np. `uname -s` dla macOS/Linux; jeśli to Windows, rozpoznaj po środowisku). Pokaż mi tylko jedną komendę — tę, która pasuje do mojego systemu. Nie uruchamiaj tej komendy samodzielnie.

   Jeśli macOS:
   ```sh
   base64 -i config/api-keys.json | pbcopy
   ```

   Jeśli Windows:
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("config\api-keys.json")) | Set-Clipboard
   ```

   Jeśli Linux:
   ```sh
   base64 -w0 config/api-keys.json | xclip -selection clipboard
   ```

2. Poproś mnie, żebym uruchomił pokazaną komendę w terminalu projektu, wkleił wynik ze schowka w **Codemagic → App → Environment Variables → API_KEYS_BASE64** i kliknął **Save**.

3. Uruchom `git status`.

4. Jeśli są zmiany w kodzie po fixach, uruchom `flutter analyze`, napraw problemy i zrób commit.

5. Wyświetl dokładnie:

   > RevenueCat gotowy. SDK działa w debug przez Test Store; offering + paywall + entitlement skonfigurowane; Codemagic ma aktualne klucze. Następny produkcyjny build z Codemagic wejdzie od razu na store.

6. Nie pisz, że apka jest gotowa do sklepów.

7. Powiedz mi, że kolejny krok to `15_codemagic-build.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/15_codemagic-build.md`.

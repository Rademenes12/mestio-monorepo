# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Przygotowanie plików mcp dla zakresu tego projektu.

# Task

1. Sprawdź czy istnieją pliki: `.mcp.json`, `opencode.json`, `.codex/config.toml`, `.agents/mcp_config.json`.
2. Jeżeli nie, utwórz je na podstawie: `.mcp.example.json`, `opencode.example.json`, `.codex/config.example.toml`, `.agents/mcp_config.example.json`.
3. Jeżeli istniały, sprawdź ich zawartość i upewnij się, że zawierają w sobie strukturę dla `supabase mcp`.
4. WAŻNE: We wszystkich czterech plikach podmień klucze `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` na wartości podane w `.env`.
5. Nie wypisuj tokena w odpowiedzi, logach ani podsumowaniu.

## FINISH
Poinformuj mnie o rezultatach. Poproś mnie o zrestartowanie sesji, ale wytłumacz, że muszę wrócić do **tej samej rozmowy**, a nie zaczynać nowej od zera. Podaj mi konkretną komendę resume albo instrukcję wznowienia sesji dla narzędzia, w którym aktualnie pracujecie, np.:

- OpenCode: zamknij sesję → `opencode --continue`
- Codex CLI: zamknij sesję → `codex resume --last`
- Claude Code: `/exit` → `claude --continue`
- Google Antigravity CLI:
  1. Wpisz `/mcp` i sprawdź lub odśwież konfigurację MCP dla Supabase.
  2. Konfiguracja projektowa dla Antigravity CLI znajduje się w `.agents/mcp_config.json`.
  3. Użyj minimalnej konfiguracji z `serverUrl` i `headers.Authorization` oraz placeholderami zamiast prawdziwych sekretów:

     ```json
     {
       "mcpServers": {
         "supabase": {
           "serverUrl": "https://mcp.supabase.com/mcp?project_ref=SUPABASE_PROJECT_ID",
           "headers": {
             "Authorization": "Bearer SUPABASE_ACCOUNT_ACCESS_TOKEN"
           }
         }
       }
     }
     ```
  4. Po zmianie konfiguracji przeładuj MCP przez `/mcp` albo zamknij CLI.
  5. Żeby wrócić do tej samej rozmowy, otwórz terminal w katalogu projektu i uruchom `agy --continue` albo `agy`, a potem w TUI wpisz `/resume`. Jeżeli CLI po zamknięciu wypisał dokładną komendę resume, użyj jej. Dla konkretnej sesji można użyć `agy --conversation <session-id>`.
- Codex App:
  1. Wejdź w `Ustawienia -> Ustawienia -> Konfiguracja`.
  2. Skopiuj ścieżkę do folderu z bieżącym projektem, w którym działa Codex.
  3. Wybierz `User config` i kliknij `Open config.toml`.
  4. Na końcu pliku dopisz wpis dla tego projektu, używając skopiowanej ścieżki. Przykłady:

  * **macOS**:

    ```toml
    [projects."/Users/adamsmaka/development/apps/app2"]
    trust_level = "trusted"
    ```
  * **Windows**:

    ```toml
    [projects.'\\?\C:\12appschallenge\apps\app2']
    trust_level = "trusted"
    ```

  5. Zapisz plik, zrestartuj Codex i wróć do tej samej rozmowy.

Zasugeruj mi napisanie `next`. Kolejny krok: `04_init-supabase-mcp-check.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/04_init-supabase-mcp-check.md`.

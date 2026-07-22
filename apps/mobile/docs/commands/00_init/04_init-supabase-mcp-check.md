# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Sprawdzenie połączenia z Supabase MCP.

# Task

1. Sprawdź czy istnieją pliki: `.mcp.json`, `opencode.json`, `.codex/config.toml`, `.agents/mcp_config.json`.
2. Sprawdź czy mają wartości `SUPABASE_PROJECT_ID` oraz `SUPABASE_ACCOUNT_ACCESS_TOKEN` z pliku `.env`.
3. Jeżeli tak, spróbuj połączyć się z Supabase MCP. Pobierz listę projektów / tabel. Zobacz czy otrzymujesz wyniki.
4. Jeżeli połączenie nie działa, zatrzymaj się na tym kroku i pomóż mi je naprawić. Sprawdź ze mną wartości w `.env`, sprawdź czy zostały przepisane do plików MCP, każ mi zrestartować sesję i wrócić do **tej samej rozmowy**, a potem ponów test połączenia.
5. Jeżeli dalej nie działa, doradź mu, jak moze naprawić konfigurację `Supabase MCP`, `project_ref`, `access token` albo restart klienta MCP.
6. Dopóki nie uzyskasz działającego połączenia i realnych wyników z MCP, nie proponuj i nie zezwalaj na `next`. Nie przechodź do kolejnego kroku.

Jeżeli pliki istniały, a nie masz połączenia, podaj mu konkretną komendę resume dla narzędzia, w którym aktualnie pracujecie:

- OpenCode: zamknij sesję → `opencode --continue`
- Codex: zamknij sesję → `codex resume --last`
- Claude Code: `/exit` → `claude --continue`
- Google Antigravity CLI: zamknij sesję → `agy --continue`

Jeżeli połączenie nadal nie istnieje, nie pozwalaj iść dalej. Cofnij mnie do poprzednich kroków, pomagaj mi je poprawić i każ wrócić tutaj dopiero po naprawie konfiguracji.

## FINISH
Jeżeli Supabase MCP działa i udało się pobrać realne wyniki, poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `05_init-supabase-shared-state-check.md`.

Jeżeli Supabase MCP nie działa, zatrzymaj się na tym kroku, opisz co nie działa i co mam zrobić dalej. W takiej sytuacji nie proponuj `next`.

Do `docs/commands/00_init/05_init-supabase-shared-state-check.md` przejdź dopiero wtedy, gdy Supabase MCP działa i napiszę `next`.

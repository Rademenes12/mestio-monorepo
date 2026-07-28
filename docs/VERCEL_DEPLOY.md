# Deploy Mestio na Vercel

## Jak to wygląda

```
┌──────────────────────────────────────────────────┐
│                 GitHub                            │
│     ┌──────────────────────────────┐              │
│     │  mestio-monorepo             │              │
│     │  ├── apps/web/    ← strona   │              │
│     │  ├── apps/crm-owner/         │              │
│     │  ├── apps/crm-client/        │              │
│     │  └── apps/mobile/  (Flutter) │              │
│     └────────┬─────────────────────┘              │
│              │ git push                           │
└──────────────┼────────────────────────────────────┘
               │
    ┌──────────┴──────────┐
    │      VERCEL          │
    │                      │
    │  ┌──────────────┐   │
    │  │  Projekt #1   │   │  →  mestio.pl
    │  │  apps/web     │   │
    │  └──────────────┘   │
    │                     │
    │  ┌──────────────┐   │
    │  │  Projekt #2   │   │  →  crm.mestio.pl
    │  │  apps/crm-    │   │
    │  │  owner        │   │
    │  └──────────────┘   │
    │                     │
    │  ┌──────────────┐   │
    │  │  Projekt #3   │   │  →  panel.mestio.pl
    │  │  apps/crm-    │   │
    │  │  client       │   │
    │  └──────────────┘   │
    └─────────────────────┘
```

## 3 projekty, 1 repo, 3 domeny

W Vercel tworzysz **3 osobne projekty**, ale wszystkie podpięte pod **to samo repozytorium GitHub**.

### Krok po kroku:

1. **Pushnij monorepo na GitHub**
2. **Vercel → Add New Project** → wybierz `mestio-monorepo`
3. **Vercel zapyta "która appka?"** → wybierz `apps/web` → ustaw domenę `mestio.pl`
4. **Zrób to samo jeszcze 2 razy**:
   - Drugi projekt → `apps/crm-owner` → domena `crm.mestio.pl`
   - Trzeci projekt → `apps/crm-client` → domena `panel.mestio.pl`

### Zmienne środowiskowe (Vercel → Settings → Environment Variables):

W każdym projekcie musisz dodać:

| Zmienna | Wartość |
|---------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://legeebmbpzjlbgjsnwpd.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | twój anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | twój service role key |

### Co dalej?

Jak już zrobisz deploy, wrzucę Ci do każdej appki poprawne domeny (CORS, callbacki OAuth itp.)

# Deploy Mestio na Vercel

## Jak to wygląda — po scaleniu

```
┌──────────────────────────────────────────────────┐
│                 GitHub                            │
│     ┌──────────────────────────────┐              │
│     │  mestio-monorepo             │              │
│     │  └── apps/web/               │              │
│     │      ├── /         (strona)  │              │
│     │      ├── /owner/*  (CRM)     │              │
│     │      ├── /client/* (panel)   │              │
│     │      └── /login    (auth)    │              │
│     └────────┬─────────────────────┘              │
│              │ git push                           │
└──────────────┼────────────────────────────────────┘
               │
    ┌──────────┴──────────┐
    │      VERCEL          │
    │  jeden projekt       │
    │  apps/web            │
    │  → mestio.pl         │
    │                      │
    │  /owner → crm        │
    │  /client → panel     │
    │  /login → logowanie  │
    └─────────────────────┘
```

## Deployment (1 projekt)

1. **Vercel → Add New Project** → wybierz `mestio-monorepo`
2. **Root Directory:** `apps/web`
3. **Branch:** `fix/production-builds`
4. **Framework:** Next.js (auto wykryje)

## Zmienne środowiskowe

Dodaj w Vercel → Settings → Environment Variables:

| Zmienna | Wartość |
|---------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://legeebmbpzjlbgjsnwpd.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlZ2VlYm1icHpqbGJnanNud3BkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUxODc0NDcsImV4cCI6MjEwMDc2MzQ0N30.d5FMTEMry8c04xB7HPDNs0tdy4KT-zuAzDun8xMeuEY` |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlZ2VlYm1icHpqbGJnanNud3BkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NTE4NzQ0NywiZXhwIjoyMTAwNzYzNDQ3fQ.yLXTc8ejZC-P4STZbtJgHuLKfuMoomhLK4wV2edORTc` |

## Po deployu

- `mestio.pl` → strona WWW
- `mestio.pl/owner/dashboard` → CRM Owner
- `mestio.pl/client/reports` → CRM Client
- `mestio.pl/login` → logowanie dla wszystkich

## Uwagi

- Stary projekt CRM Client na Vercel można usunąć (teraz wszystko w jednym)
- Mobile (Flutter) osobno — nie Vercel

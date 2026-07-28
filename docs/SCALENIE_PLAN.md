# Scalanie 3 appek w jedną

## Cel
- Jedno Next.js `apps/web` → `mestio.pl`
- Login w prawym rogu → rola Owner lub Client
- Osobno: mobile (Flutter)

## Struktura po scaleniu

```
mestio.pl (apps/web)
│
├── /              → strona WWW (blog, kontakt, cennik)
├── /login         → logowanie
├── /owner/*       → CRM Owner (estates, customers, tasks, pipeline...)
├── /client/*      → CRM Client (tasks, resolutions, invoices...)
└── /api/*         → API routes
```

## Plan działania

1. Skopiować dashboardowe route'y z crm-owner do apps/web jako `/owner/*`
2. Skopiować dashboardowe route'y z crm-client do apps/web jako `/client/*`
3. Połączyć auth/middleware (jedno logowanie, dwie role)
4. Połączyć wspólne pakiety (types, ui, design-tokens)
5. Zrobić layout z loginem w prawym górnym rogu
6. Usunąć apps/crm-owner i apps/crm-client
7. Zaktualizować Turborepo config
8. Deploy na Vercel

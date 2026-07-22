# 🚀 Vercel Deploy — Instrukcja

## 1. Przygotowanie

### Zmienne środowiskowe (dla każdej app)

W panelu Vercel → Settings → Environment Variables dodaj:

```
NEXT_PUBLIC_SUPABASE_URL=https://rtyywhbisjaxlpjcugdk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
STRIPE_SECRET_KEY=sk_live_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
NEXT_PUBLIC_SITE_URL=https://www.mestio.pl
NEXT_PUBLIC_ADMIN_URL=https://admin.mestio.pl
NEXT_PUBLIC_CLIENT_URL=https://panel.mestio.pl
```

## 2. Deploy — 3 osobne projekty

### Projekt 1: mestio-website
- **Repo:** `Rademenes12/mestio-monorepo`
- **Root Directory:** `apps/web`
- **Framework:** Next.js
- **Build Command:** `cd ../.. && npm run build`
- **Domena:** `www.mestio.pl`

### Projekt 2: fixflow-crm-owner
- **Repo:** `Rademenes12/mestio-monorepo`
- **Root Directory:** `apps/crm-owner`
- **Framework:** Next.js
- **Build Command:** `cd ../.. && npm run build`
- **Domena:** `admin.mestio.pl`

### Projekt 3: mestio-crm-client
- **Repo:** `Rademenes12/mestio-monorepo`
- **Root Directory:** `apps/crm-client`
- **Framework:** Next.js
- **Build Command:** `cd ../.. && npm run build`
- **Domena:** `panel.mestio.pl`

## 3. Domeny

W DNS (gdzie masz domenę mestio.pl) dodaj rekordy CNAME:

```
www.mestio.pl → CNAME → cname.vercel-dns.com
admin.mestio.pl → CNAME → cname.vercel-dns.com
panel.mestio.pl → CNAME → cname.vercel-dns.com
```

## 4. Flutter (mobile)

Aplikacja Flutter nie działa na Vercel. Do deploy na iOS/Android użyj:
- **Codemagic** (CI/CD dla Flutter)
- **Fastlane** (automatyzacja publikacji)
- Lub ręcznie przez Android Studio / Xcode

## 5. Testowanie

Po deploy:
1. Sprawdź czy wszystkie strony ładują się poprawnie
2. Przetestuj logowanie przez Supabase
3. Sprawdź czy Stripe działa (test mode)
4. Zweryfikuj RLS policies

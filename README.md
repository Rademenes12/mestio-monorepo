# 🏗️ Mestio Monorepo

**Jeden terminal. Jeden `npm install`. Trzy aplikacje. Wspólne komponenty.**

Ekstrakcja 4 osobnych repozytoriów → monorepo Turborepo z Next.js 16.

---

## 📦 Struktura

```
mestio-monorepo/
├── apps/
│   ├── web/              ← mestio.pl (landing, blog, checkout Stripe)
│   ├── crm-owner/        ← panel właściciela (dashboard, klienci, faktury)
│   └── crm-client/       ← panel klienta/zarządu (zgłoszenia, lokatorzy)
├── packages/
│   ├── ui/               ← 9 współdzielonych komponentów + hook WebGL
│   ├── design-tokens/    ← kolory, spacing, radius, shadows, transitions
│   ├── supabase/         ← jeden klient Supabase + typy DB
│   ├── types/            ← współdzielone TypeScript types
│   └── config/           ← tailwind, tsconfig, eslint bazowy
├── tests/
│   ├── roles.spec.ts     ← testy ról (Owner, Client, Tenant)
│   └── ticket-flow.spec.ts ← testy flow zgłoszeń
├── turbo.json
└── playwright.config.ts
```

---

## 🎨 Design Tokens

Wszystkie 3 aplikacje + Flutter używają identycznych tokenów:

| Token | Wartość | Opis |
|-------|---------|------|
| `bg` | `#0A0A1A` | Tło strony |
| `card` | `#1C182B` | Karty/panels |
| `primary` | `#8864F0` | Akcenty, przyciski |
| `primary-light` | `#4DA3FF` | Gradienty, akcenty drugorzędne |
| `glass-bg` | `rgba(28,24,43,0.6)` | Tło glassmorphism |
| `glass-blur` | `12px` | Rozmycie glassmorphism |

---

## 🚀 Szybki start

```bash
# 1. Instalacja
npm install

# 2. Skopiuj .env.example → .env.local i uzupełnij klucze
cp .env.example .env.local

# 3. Development (wszystkie 3 appki równolegle)
npm run dev

# 4. Pojedyncze appki
npm run dev:web        # mestio.pl na localhost:3000
npm run dev:crm-owner   # panel właściciela na localhost:3001
npm run dev:crm-client  # panel zarządu na localhost:3002
```

---

## 🧪 Testy

```bash
# Wszystkie testy e2e (Playwright)
npm run test:e2e

# Tylko testy ról
npm run test:e2e:roles

# Tylko flow zgłoszeń
npm run test:e2e:ticket-flow

# UI mode (debugowanie)
npm run test:e2e:ui
```

### Macierz testów

| Test | Opis | Bez auth | Z auth |
|------|------|----------|--------|
| `roles.spec.ts` | 👑 Owner, 🏢 Client, 🏠 Tenant | ✅ | ✅ |
| `ticket-flow.spec.ts` | 🎫 Pełny lifecycle zgłoszenia | ✅ | 🔜 |

---

## 🔧 Komendy

| Komenda | Opis |
|---------|------|
| `npm run dev` | Dev wszystkie 3 appki |
| `npm run build` | Build wszystkie 3 appki |
| `npm run build:web` | Build tylko website |
| `npm run lint` | Lint wszystkie pakiety |
| `npm run typecheck` | Typecheck wszystkie pakiety |
| `npm run clean` | Wyczyść cache + node_modules |
| `npm run test:e2e` | Playwright E2E |

---

## 📦 Pakiety `@mestio/*`

### `@mestio/ui`
Współdzielone komponenty React:

- **Layout:** `Sidebar`, `Navbar`, `Footer`
- **Auth:** `LoginForm`, `SignupForm`
- **UI:** `WaveAnimation`, `Card`, `StatusBadge`
- **Hooks:** `useWebGLBackground`

```tsx
import { Sidebar, Navbar, Footer, LoginForm, WaveAnimation } from '@mestio/ui'
```

### `@mestio/supabase`
Jeden klient Supabase dla całego ekosystemu:

```ts
import { supabase } from '@mestio/supabase'
import type { Ticket, Property, User } from '@mestio/supabase/types'
```

### `@mestio/design-tokens`
Tokeny dla Next.js i Flutter:

```ts
import { colors, spacing, shadows } from '@mestio/design-tokens'
// colors.primary → '#8864F0'
// colors.bg → '#0A0A1A'
```

---

## 🗺️ Historia migracji

| Repo | Status |
|------|--------|
| `mestio-website` | ✅ → `apps/web/` |
| `mestio-crm-owner` (fixflow-crm-owner) | ✅ → `apps/crm-owner/` |
| `mestio-crm-klienta` | ✅ → `apps/crm-client/` |
| `mestio-next` (szkic Next.js 14) | ✅ → `packages/ui/` (7 komponentów) |
| `zglosawarie` (Flutter) | 🔗 Osobne repo, używa tych samych tokenów |

---

## 🔐 Zmienne środowiskowe

Skopiuj `.env.example` → `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=https://rtyywhbisjaxlpjcugdk.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<klucz>
SUPABASE_SERVICE_ROLE_KEY=<klucz>
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
RESEND_API_KEY=re_...
```

---

## 🚢 Deployment

Każda appka deployowana osobno z tego samego repo:

```bash
# Vercel
cd apps/web && vercel --prod
cd apps/crm-owner && vercel --prod
cd apps/crm-client && vercel --prod
```

---

## 📝 Konwencje

- **Next.js 16** z App Router i Turbopack
- **TypeScript** strict mode
- **Tailwind CSS** v4 z `@mestio/config`
- **Playwright** dla testów E2E
- Komponenty UI przyjmują props zamiast importować app-specific contexty
- Jeden `npm install` dla wszystkiego (Turborepo workspaces)

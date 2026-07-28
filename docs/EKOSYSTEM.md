# 🌐 MESTIO — Przewodnik po ekosystemie

## 📋 Czym jest Mestio?

System do zarządzania zgłoszeniami w osiedlach mieszkaniowych.
Mieszkańcy zgłaszają awarie przez **aplikację mobilną**,
zarządca ogarnia je w **panelu CRM**, a osiedla mają swój **panel kliencki**.

---

## 📱 4 APLIKACJE

### 1. crm-owner (Next.js) — TWOJA apka (właściciel platformy)
- **Gdzie:** `apps/crm-owner/`
- **Co robi:** **Twoje narzędzie.** Widzisz wszystkie osiedla, zgłoszenia, zarządzasz platformą, raporty KPI, pipeline
- **Framework:** Next.js (React, TypeScript)
- **Strony:** 37 routek (dashboard, pipeline, osiedla, budynki, lokale, raporty...)
- **Uruchomienie:** `cd apps/crm-owner && npm run dev` → http://localhost:3001
- **Status:** ✅ działa, to jest twoje centrum dowodzenia

### 2. crm-client (Next.js) — panel dla administratorów osiedli
- **Gdzie:** `apps/crm-client/`
- **Co robi:** Panel dla adminów i zarządów poszczególnych osiedli — widzą swoje zgłoszenia, uchwały, ranking
- **Uruchomienie:** `cd apps/crm-client && npm run dev` → http://localhost:3002
- **Status:** ✅ działa

### 3. mobile (Flutter) — aplikacja mieszkańca
- **Gdzie:** `apps/mobile/`
- **Co robi:** Mieszkaniec zgłasza awarię, głosuje w uchwałach, widzi ogłoszenia
- **Framework:** Flutter (Dart)
- **Uruchomienie:** `cd apps/mobile && flutter run --dart-define-from-file=config/api-keys.json`
- **Konfiguracja:** `config/api-keys.json` (Supabase URL + klucz anonimowy)
- **Status:** ✅ gotowe, czeka na VS Code

### 4. web (Next.js) — strona firmowa Mestio
- **Gdzie:** `apps/web/`
- **Co robi:** Strona www Mestio, blog, cennik (Stripe), kontakt
- **Strony:** 24 strony
- **Uruchomienie:** `cd apps/web && npm run dev` → http://localhost:3000
- **Status:** ✅ działa

---

## 🗄️ WSPÓLNA BAZA DANYCH — Supabase

**Jeden projekt** dla wszystkich 4 aplikacji:
- **Projekt:** `legeebmbpzjlbgjsnwpd`
- **URL:** https://legeebmbpzjlbgjsnwpd.supabase.co
- **59 tabel** w bazie

| Kategoria | Ilość | Opis |
|-----------|-------|------|
| `fixflow_*` | 32 tabele | Główna logika: zgłoszenia, uchwały, ogłoszenia, mieszkańcy |
| `crm_*` | 10 tabel | CRM klienckie: leady, faktury, pipeline |
| `estate_*` | 3 tabele | Zarządzanie nieruchomościami: osiedla, budynki, lokale |
| inne | 14 tabel | Auth, storage, funkcje pomocnicze |

---

## 🧩 PAKIETY WSPÓŁDZIELONE (8)

Wszystkie w `packages/`:

| Pakiet | Zawartość |
|--------|-----------|
| `supabase/` | Klient Supabase + typy TypeScript (3291 linii) |
| `design-tokens/` | Kolory, fonty, spacing (dark theme #0A0A1A) |
| `ui/` | Wspólne komponenty React |
| `types/` | Wspólne typy TypeScript |
| `config/` | Wspólna konfiguracja |
| `shared-ui/` | Dodatkowe komponenty |
| `shared-types/` | Dodatkowe typy |
| `shared-utils/` | Funkcje pomocnicze |

---

## 🔧 ZEWNĘTRZNE USŁUGI

| Usługa | Do czego | Status |
|--------|----------|--------|
| **Supabase** | Baza danych, logowanie, RLS, storage | ✅ skonfigurowane |
| **Stripe** | Płatności (cennik na stronie web, pipeline CRM) | ✅ jest w kodzie |
| **RevenueCat** | Płatności w mobilce | ❌ **USUNIĘTE** — appka w pełni darmowa |

---

## 🔄 JAK TO DZIAŁA

```
Mieszkaniec (mobile)
    │
    ▼ zgłasza awarię
┌──────────────────────┐
│  Supabase            │  ← wspólna baza dla WSZYSTKICH
│  fixflow_reports     │
│  fixflow_resolutions │
│  fixflow_users       │
└──────┬───────────────┘
       │
       ├──→ CRM Owner (zarządca): widzi wszystko, zarządza
       │    http://localhost:3001
       │
       ├──→ CRM Client (osiedle): widzi swoje zgłoszenia
       │    http://localhost:3002
       │
       └──→ Web (www): strona firmowa
            http://localhost:3000
```

---

## 🚀 JAK URUCHOMIĆ W VS CODE

1. **Otwórz folder** `/opt/data/mestio-monorepo` w VS Code

2. **Uruchom terminal w VS Code** i wpisz:

   ```bash
   # CRM Owner (najważniejsze — panel zarządcy)
   cd apps/crm-owner && npm run dev
   # otwórz http://localhost:3001

   # Web (strona firmowa)
   cd apps/web && npm run dev
   # otwórz http://localhost:3000

   # CRM Client (panel osiedla)
   cd apps/crm-client && npm run dev
   # otwórz http://localhost:3002

   # Mobile (Flutter) — potrzebuje Flutter SDK
   cd apps/mobile
   flutter run --dart-define-from-file=config/api-keys.json
   ```

3. **Wszystkie 3 Next.js appki** mogą działać jednocześnie (różne porty)

---

## 🧹 CO JESZCZE JEST DO ZROBIENIA

- [ ] Uruchomić Fluttera w VS Code (potrzebny Flutter SDK)
- [ ] Uzupełnić dane legalne (NIP, IOD) na stronie web
- [ ] Ewentualnie wdrożyć Edge Function `send-notification` na Supabase
- [ ] RevenueCat usuwany — sub-agent kończy pracę

---

> **Podsumowanie:** Wszystko jest w jednym miejscu (`/opt/data/mestio-monorepo`).
> Baza danych żyje na Supabase (cloud). W VS Code odpalisz 3 Next.js apki od razu.
> Flutter potrzebuje osobnego SDK. Creds są skonfigurowane. Wersja płatna usunięta.

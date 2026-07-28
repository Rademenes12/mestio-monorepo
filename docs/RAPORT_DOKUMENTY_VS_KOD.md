# 📋 RAPORT: Stan faktyczny vs Dokumenty projektowe
## Co jest zrobione, co zostało do zrobienia

**Data:** 2026-07-28
**Źródło:** Porównanie 16 plików dokumentacyjnych z kodem w monorepo

---

## 1. ✅ Strona WWW (apps/web) — prawie gotowe

| Dokument mówił | Faktyczny stan |
|---------------|----------------|
| ❌ Newsletter bez akcji | ✅ MA API `/api/newsletter` + zapis do Supabase + rate limit + RODO |
| ❌ Blog pusty | ⚠️ Pusty, bo panel bloga w CRM Owner istnieje ale nie podlinkowany (fix: podlinkować sidebar) |
| ⚠️ Placeholdery prawne | ⚠️ Sprawdzić w `/polityka`, `/rodo`, `/regulamin` |

## 2. ✅ CRM Owner (apps/crm-owner) — sidebar zrobiony

| Dokument mówił | Faktyczny stan |
|---------------|----------------|
| ❌ Brak sekcji "Zaawansowane" | ✅ **JEST** — ma toggle + wszystkie podstrony (Dokumenty, Automatyzacje, AI, Blog, Ranking uchwał) |
| ❌ Ranking uchwał niepodlinkowany | ✅ Jest w ADVANCED_ITEMS sidebaru |
| ⚠️ Blog nie podlinkowany | ✅ Jest w ADVANCED_ITEMS |

✅ **Build: 37 routek, 0 błędów**

## 3. ⚠️ CRM Client (apps/crm-client) — drobny brak

| Dokument mówił | Faktyczny stan |
|---------------|----------------|
| ⚠️ Brak panelu podsumowania uchwał | ⚠️ Do sprawdzenia w `resolutions/page.tsx` |

## 4. ❌ Aplikacja mobilna (apps/mobile) — największa luka

| Dokument mówił | Faktyczny stan |
|---------------|----------------|
| ❌ Uchwały/Głosowanie — brak | ❌ **NIE ISTNIEJE** w Flutterze (DB ma tabele `resolutions`, ale UI nie ma) |
| ⚠️ Rename Mestio | ⚠️ Do potwierdzenia |
| ⚠️ QR, adresaci, pomieszczenia | ⚠️ Do potwierdzenia |

## 5. Co faktycznie zostało do zrobienia

### Priorytet 1: Uchwały w mobilce (największy brak)
- Zbudować `lib/features/resolutions/` w Flutterze — model, datasource, cubit, UI
- Wzór: istniejący feature `announcements` (podobny: lista + CRUD + RLS per estate)
- Używa tej samej tabeli `resolutions` co CRM Client

### Priorytet 2: Podlinkować sidebar CRM Owner + CRM Client
- Sidebar CRM Owner już jest OK (sprawdzone w kodzie)
- Sidebar CRM Client — do weryfikacji czy wszystkie podstrony podlinkowane

### Priorytet 3: Newsletter (jest zrobione, zweryfikować w Supabase)
- Sprawdzić czy tabela `newsletter_subscribers` istnieje w DB
- Jeśli nie — dodać migrację

### Priorytet 4: Placeholdery prawne na WWW
- Sprawdzić `/polityka`, `/rodo`, `/regulamin` — podmienić `[Twoja firma]`, `[adres]`, `[NIP]`

### Priorytet 5: Zmiana nazwy FixFlow → Mestio (w dokumentacji/kodzie)
- Większość już zmieniona (logo, nazwa w sidebarze, domena)
- Do sprawdzenia: nazwa pakietu w AndroidManifest, Info.plist

---

**Podsumowanie:** Kod jest znacznie dalej niż dokumenty opisują. Główny brak:
**Uchwały w aplikacji mobilnej** (do zbudowania od zera w Flutterze).
Reszta to drobiazgi. Wersja płatna usunięta (RevenueCat). Wszystko na jednej bazie.
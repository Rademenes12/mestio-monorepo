# CRM Owner (fixflow-crm-owner) — braki względem prototypu

Kontekst: porównano prototyp UI (`FixFlow_CRM_Owner.dc.html`) z realnym kodem repo
`fixflow-crm-owner`. Poniżej konkretne różnice do naprawienia.

## 1. Brak sekcji „Zaawansowane" w sidebarze

Prototyp ma w sidebarze zwijaną sekcję **„Zaawansowane"** (przycisk z chevronem, rozwija
dodatkową grupę linków pod głównymi). W realnym `src/components/Sidebar.tsx` tej sekcji
nie ma — jest tylko płaska lista: Pulpit, Klienci, Pipeline, Poczta, Faktury, Osiedla,
Opinie i pomysły, Ustawienia.

Sekcja „Zaawansowane" w prototypie zawiera:
- **Dokumenty** (i wzory)
- **Automatyzacje**
- **AI Asystent**
- **Ranking uchwał**
- **Blog**

### Ważne: część tych stron już istnieje w kodzie, ale nie jest podlinkowana
W `src/app/(dashboard)/` już istnieją strony:
- `automations/page.tsx`
- `ai/page.tsx`
- `documents/page.tsx`
- `blog/page.tsx`

I mają tytuły zdefiniowane w `src/app/(dashboard)/layout.tsx` (`PAGE_TITLES`), ale **żaden
link w `Sidebar.tsx` do nich nie prowadzi** — więc są zbudowane, ale niedostępne z UI.

**Zadanie:** dodać w `Sidebar.tsx` zwijaną sekcję „Zaawansowane" (stan otwarte/zamknięte,
strzałka obraca się przy rozwinięciu — jak w prototypie) z linkami do:
`/documents`, `/automations`, `/ai`, `/blog`.

## 2. Całkowicie brakująca funkcja: „Ranking uchwał"

Nie istnieje ani strona, ani żadna wzmianka w kodzie. W prototypie to pozycja w sekcji
„Zaawansowane" nawigacji.

**Zadanie:** zaprojektować i zbudować nową stronę `/resolutions-ranking` (lub podobny path)
w `src/app/(dashboard)/`, dodać tytuł w `PAGE_TITLES`, dodać link w sidebarze.
Zawartość: (do ustalenia z projektantem/PM — prototyp nie ma jeszcze szczegółowego widoku
tego ekranu, tylko pozycję w menu).

## 3. Do zweryfikowania (nie sprawdzone w tym przeglądzie)

Sprawdzono tylko **istnienie plików** stron `/documents`, `/automations`, `/ai`, `/blog` —
nie ich zawartość. Zweryfikować czy faktycznie renderują pełną treść (nie tylko szkielet/
placeholder) zgodną z prototypem, skoro nigdy nie były używane przez brak linku w menu.

## 4. Poza zakresem tego przeglądu

Ten dokument dotyczy WYŁĄCZNIE różnic prototyp UI ↔ kod CRM Owner (nawigacja/strony).
Nie obejmuje audytu bezpieczeństwa, RODO, Stripe, Supabase RLS ani innych repo
(`zglosawarie`, `fixflow-crm-klienta`, `fixflow-website`) — te były przedmiotem
osobnego przeglądu.

# Aplikacja mobilna (zglosawarie / Mestio) — braki względem prototypu

Porównano prototyp `FixFlow.dc.html` (mobile) z realnym kodem repo `zglosawarie`
(`lib/features/`).

## 1. Brak funkcji Uchwały/Głosowania — CAŁKOWICIE

To największy brak. Prototyp mobilny ma pełną zakładkę **„Uchwały"** (dostępną dla
Mieszkańca i Zarządu): lista uchwał ze statusem (w trakcie/zakończona/odrzucona),
głosowanie Za/Przeciw/Wstrzymuję się, frekwencja, termin głosowania, tworzenie nowej
uchwały przez Zarząd.

W realnym kodzie Fluttera (`lib/features/`) **nie ma żadnego folderu ani wzmianki**
dotyczącej uchwał/głosowania — sprawdzono cały katalog `lib/` pod kątem słów
"resolution/uchwal/voting/vote" — zero trafień związanych z tą funkcją.

Tymczasem **CRM Klienta (panel przeglądarkowy dla zarządu) już ma tę funkcję**
zaimplementowaną (`resolutions/page.tsx`, tabela `resolutions` w Supabase) — więc
backend/model danych częściowo istnieje, ale nie ma go w aplikacji mobilnej wcale.
Mieszkaniec nie może dziś zagłosować z telefonu.

**Zadanie:** zbudować feature `lib/features/resolutions/` (model, datasource, cubit, UI)
analogicznie do istniejących features (`announcements` to dobry wzorzec — podobny
kształt: lista + tworzenie + RLS per estate), podłączony do tej samej tabeli `resolutions`,
której już używa CRM Klienta.

## 2. Do potwierdzenia — funkcje zgłoszone jako zrobione w ostatniej sesji

Wg raportu z sesji budowy (4 commity) niedawno dodano: rename → Mestio, adresaci
zgłoszeń dla Ochrony/Serwisanta, QR + speed-dial FAB, pomieszczenia mieszkańca
(komórka/piwnica/parking/garaż). Nie weryfikowano tych zmian w tym przeglądzie (nie było
ich jeszcze w stanie repo sprawdzonym tutaj, albo nie sprawdzano ponownie) — do
potwierdzenia w kolejnym pull kodu.

## 3. Poza zakresem tego przeglądu

Ten plik dotyczy WYŁĄCZNIE różnicy prototyp UI (mobile) ↔ funkcje w kodzie Fluttera.
Osobny, wcześniejszy przegląd bezpieczeństwa/RODO/compliance tego repo (klucze w gicie,
RLS, tłumaczenia UK, itd.) został już przekazany w rozmowie — nie powtórzono go tutaj.

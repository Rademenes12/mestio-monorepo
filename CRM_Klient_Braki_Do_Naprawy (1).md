# CRM Klient (fixflow-crm-klienta) — braki względem prototypu

Porównano prototyp `FixFlow_Panel CRM klient.dc.html` z realnym kodem repo
`fixflow-crm-klienta`.

## 1. Nawigacja — OK, zgodna z prototypem

Sidebar (`src/app/(app)/layout.tsx`) ma te same pozycje co prototyp: Pulpit, Tablica
spraw, Kontakty, Telefony, Zadania, Komunikaty, Uchwały, Osiedle, Ustawienia. Brak
rozbieżności tutaj — w przeciwieństwie do CRM Owner, nic nie trzeba dodawać do menu.

## 2. Uchwały — brakuje panelu podsumowania głosowania

Prototyp ma w zakładce „Uchwały" panel boczny z podsumowaniem: liczba głosowań w
trakcie/zakończonych, średnia frekwencja, oraz skrócony wynik (pasek Za/Przeciw) dla
każdej uchwały.

W realnym kodzie (`src/app/(app)/resolutions/page.tsx`) tego panelu **nie ma** — jest
tylko lista uchwał jedna pod drugą, z tekstowym „Za: X · Przeciw: Y" w rogu karty. Brak:
- panelu bocznego z podsumowaniem (liczba otwartych/zamkniętych, średnia frekwencja),
- wizualnego paska głosów (Za/Przeciw) per uchwała,
- wyświetlania głosów wstrzymujących się (`votes_abstain` — pole istnieje w typie
  `Resolution`, ale nigdzie nie jest pokazywane w UI).

**Zadanie:** dodać panel podsumowania (sidebar lub górna sekcja) do `resolutions/page.tsx`,
zgodnie z układem w prototypie, wliczając wstrzymujących się.

### Uwaga dot. bazy danych
Kod ma wbudowany fallback: jeśli zapytanie do tabeli `resolutions` zwróci błąd, strona
pokazuje komunikat „Tabela uchwał nie istnieje jeszcze w bazie — uruchom migrację". 
**Do sprawdzenia:** czy ta migracja została faktycznie wdrożona na produkcyjnej bazie
Supabase, czy strona obecnie pokazuje ten fallback.

## 3. Dobra wiadomość: „Zdrowie osiedla" już zaimplementowane

To odpowiada na wcześniejsze pytanie o funkcję **B2 (wskaźnik zdrowia osiedla)** z sesji
budowy aplikacji mobilnej — okazuje się, że **już istnieje** w panelu CRM Klienta
(`src/app/(app)/page.tsx`, Pulpit): wylicza `healthScore` z terminowości SLA i procentu
wykonanych zadań, pokazuje etykietę „Dobry stan / Wymaga uwagi / Krytyczny" z kolorem.
Nie trzeba tego budować od nowa w aplikacji mobilnej — rozważcie tylko, czy chcecie
tę samą metrykę pokazać też tam, czy wystarczy w CRM.

## 4. Poza zakresem tego przeglądu

Nie sprawdzano zawartości: `/announcements`, `/contacts`, `/phones`, `/tasks`, `/estate`,
`/settings` — porównano tylko strukturę nawigacji i zakładkę Uchwały (bo tam był ostatnio
zgłoszony brak). Jeśli chcecie pełny przegląd pozostałych zakładek, dajcie znać.

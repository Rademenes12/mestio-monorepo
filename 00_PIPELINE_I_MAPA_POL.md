# Mestio — Pipeline i mapa powiązań pól między systemami

## 1. Przepływ zgłoszenia usterki (główny pipeline)

```
Mieszkaniec (Aplikacja mobilna)
  → dodaje zgłoszenie: kategoria, opis, zdjęcie, lokalizacja (ręcznie/GPS), PDF, priorytet (nie może ustawić)
  → status: "Nowe"
  ↓
Zarząd / Administrator (widzą w Aplikacji mobilnej ORAZ w CRM Klienta → zakładka "Tablica spraw")
  → mogą: nadać priorytet, zmienić status na "Odrzucone" (tylko oni), przypisać serwisanta
  → status: "W realizacji" + pole "Przypisany serwisant"
  ↓
Serwisant (Aplikacja mobilna → zgłoszenia przypisane do niego)
  → komentuje / dodaje info o postępie (korespondencja w zgłoszeniu)
  → wraca do Zarządu/Administratora
  ↓
Zarząd / Administrator
  → zamyka zgłoszenie: status "Zamknięte"

Równolegle: Ochrona może dodać zgłoszenie kierowane do "Zarząd/Admin + Serwis"
(nigdy do siebie) — trafia zawsze do wiadomości Zarządu i Administratora.
```

Statusy (kolory z systemu projektowego): Nowe `#3E7BD6`, W realizacji `#F2A900`,
Zamknięte `#2E9E6B`, Odrzucone `#6B7A90`.

### Gdzie żyje to samo zgłoszenie w różnych systemach
- **Aplikacja mobilna**: `FixFlow.dc.html` — karta zgłoszenia, filtr po statusie.
- **CRM Klienta**: `FixFlow_Panel_CRM_klient.dc.html` — zakładka "Tablica spraw",
  ten sam rekord, więcej miejsca (korespondencja, historia, priorytet).
- **CRM Mój**: NIE widzi pojedynczych zgłoszeń mieszkańców — to dane osiedla klienta,
  poza zakresem Twojego panelu sprzedażowego.

## 2. Pipeline sprzedażowy (CRM Mój — osobny, nie mylić z powyższym)

```
Lead (formularz na Stronie WWW /zamow)
  → CRM Mój: Pipeline → "Nowy kontakt"
  → "Oferta" → "Demo" → "Szykowanie umowy" → "Wygrana" (podpisana umowa)
                                            ↘ "Przegrana"
  → po "Wygrana": generujesz kod zaproszenia Administratora dla tego klienta
  → klient aktywny → ... → "Koniec umowy" (churn, po wypowiedzeniu)
```

Po "Wygrana": karta klienta w CRM Moim dostaje pola: nazwa firmy, dane do faktury,
osoby reprezentujące (z stanowiskiem — trafiają na wygenerowaną umowę), data
ważności umowy (widoczna też w Ustawieniach CRM Klienta i w profilu Administratora
w aplikacji).

## 3. Mapa pól — jak te same dane nazywają się/żyją w różnych systemach

| Dane | CRM Mój (Ty) | CRM Klienta (Zarządca) | Aplikacja mobilna |
|---|---|---|---|
| Nazwa firmy zarządzającej | Karta klienta → "Nazwa firmy" | Ustawienia → "Nazwa firmy zarządzającej" | Profil Administratora (wyświetlane, nieedytowalne) |
| Data końca umowy | Karta klienta → "Umowa do" | Ustawienia → "Umowa ważna do" (odliczanie dni) | — (nie pokazywane mieszkańcowi) |
| Kod zaproszenia | Generujesz per klient + rola po wyborze osiedla z listy | Ustawienia → 4 kody (Mieszkaniec auto / Administrator, Ochrona, Serwis — wymagają akceptacji) | Ekran rejestracji → pole "Kod zaproszenia" |
| Struktura osiedla (budynek/klatka/piętro/garaż) | — (poza zakresem) | Zakładka "Osiedle" — buduje ją Administrator/Zarząd (widok drzewkowy) | Rejestracja Mieszkańca — wybiera z gotowej struktury (nie tworzy jej) |
| Komórka/piwnica/miejsce postojowe mieszkańca | — | Widoczne w karcie kontaktu (dodane przez admina LUB zgłoszone przez mieszkańca) | Profil Mieszkańca — może dodać sam lub poprosić administratora |
| Kontakt telefoniczny mieszkańca | — | Zakładka "Kontakty mieszkańców" (może ukryć/pokazać dane osobowe przed Zarządem — RODO) | Profil (mieszkaniec wpisuje sam) |
| Telefony alarmowe/serwisowe | — | Zakładka "Telefony" — dodaje Admin/Zarząd | Zakładka "Telefony" (widoczna dla wszystkich ról, tylko odczyt poza Adminem/Zarządem) |
| Uchwała + głosowanie | — | Zakładka "Uchwały" — tworzy Admin/Zarząd, ustawia termin, widzi % frekwencji wg udziałów | Zakładka "Uchwały" — Mieszkaniec głosuje Za/Przeciw/Wstrzymuję się |
| Udział w nieruchomości (do liczenia głosów) | — | Karta kontaktu mieszkańca — Admin wpisuje ręcznie: udział / suma udziałów osiedla | — (nie edytowalne przez mieszkańca) |
| Priorytet zgłoszenia | — | Ustawia Zarząd/Admin/Ochrona (NIE mieszkaniec) | To samo pole, tylko podgląd dla mieszkańca |
| Komunikat/ogłoszenie | — | Tworzy Admin/Zarząd — z datą wygaśnięcia (po niej znika) + wybór grupy odbiorców (blok/klatka/piętro) | Wyświetlane na górze listy zgłoszeń, znika automatycznie po dacie |
| Uwagi/feedback od użytkownika | Trafiają do CRM Mojego → zakładka na sugestie/feedback | — (nie przechodzi przez CRM Klienta) | Pole "Wyślij uwagę" w profilu każdej roli |
| Zadanie cykliczne (np. przegląd budowlany) | — | Zakładka "Zadania" — Zarząd ustawia cykl (co X tygodni/miesięcy/lat) | Widoczne jako zadanie/zgłoszenie systemowe |

## 4. Zasady dostępu do danych osobowych (RODO)

- Administrator może ukryć dane kontaktowe (telefon/e-mail) mieszkańca przed Zarządem
  (oczko widoczne/ukryte w karcie kontaktu w CRM Klienta).
- CRM Mój nie przechowuje danych osobowych mieszkańców — tylko dane firmy klienta
  (zarządcy) i osób kontaktowych po stronie zarządcy.
- Po zakończeniu współpracy (koniec umowy + okres karencji, np. 90 dni) dane osiedla
  i mieszkańców powinny być usuwane z systemu — zgodnie z zasadą minimalizacji danych.

## 5. Role i ich unikalne kody zaproszeń

Każda rola ma osobny kod generowany przez CRM Klienta (Ustawienia), z osobną zasadą
akceptacji:
- **Mieszkaniec** — kod nadawany z góry, dołączenie natychmiastowe (auto).
- **Administrator, Ochrona, Serwisant** — kod nadawany z góry, ale dołączenie wymaga
  ręcznej akceptacji przez uprawnioną rolę wyżej w hierarchii (Zarząd akceptuje
  Administratora i inne role; Administrator akceptuje Mieszkańca/Ochronę/Serwis).

Nikt nie "awansuje się sam" — rola jest zawsze przypisana z góry przez kod, nie przez
wybór użytkownika podczas rejestracji.

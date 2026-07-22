# 🔧 SCENARIUSZ TESTOWY — FixFlow 4 role

## Przygotowanie (przed testem)
1. Uruchom aplikację na emulatorze/telefonie
2. Wrzuć migracje na Supabase: `supabase db push`
3. Utwórz konta auth w Supabase Dashboard (Authentication → Users → Add User):
   - `test-mieszkaniec@fixflow.app` / Test123!
   - `test-zarzad@fixflow.app` / Test123!
   - `test-serwisant@fixflow.app` / Test123!
   - `test-ochrona@fixflow.app` / Test123!
4. Uruchom seed: wklej zawartość `supabase/seed_test_data.sql` w SQL Editor w Supabase Dashboard
5. W Dashboard, znajdź UUID każdego użytkownika i zaktualizuj:
   - `fixflow_resident_profiles.id` dla każdego profilu na prawdziwy auth.users.id
   - `fixflow_user_estates.user_id` dla każdego na prawdziwy auth.users.id
   - `fixflow_reports` → `reporter_email` na `test-ochrona@fixflow.app` dla report-004

---

## 🟢 ROLA 1: MIESZKANIEC (Jan Kowalski)
**Login:** test-mieszkaniec@fixflow.app / Test123!

### Krok 1 — Logowanie i ekran główny
- [ ] Uruchom apkę → kliknij "Log in" → wpisz email i hasło
- [ ] Zobaczysz pulpit mieszkańca z powitaniem "Dzień dobry, Jan Kowalski"
- [ ] Zobaczysz listę swoich zgłoszeń (3 raporty testowe)

### Krok 2 — Dodaj nowe zgłoszenie
- [ ] Kliknij FAB (+) → "Dodaj zgłoszenie"
- [ ] Wybierz kategorię: "Elektryka"
- [ ] Wpisz tytuł: "Gniazdko nie działa w salonie"
- [ ] Wpisz opis: "Gniazdko przy kanapie przestało działać. Iskrzyło przy włączaniu."
- [ ] Opcjonalnie: zrób zdjęcie (ikona aparatu)
- [ ] Kliknij "Wyślij zgłoszenie"
- [ ] **Sprawdź:** SnackBar "Zgłoszenie zostało dodane!"
- [ ] **Sprawdź:** nowe zgłoszenie pojawia się na liście ze statusem "Nowe"

### Krok 3 — Śledź status zgłoszenia
- [ ] Kliknij zgłoszenie "Winda nie działa" (status: W realizacji)
- [ ] **Sprawdź:** stepper pokazuje "Nowe ✓ → W realizacji ⏳ → Zamknięte ○"
- [ ] **Sprawdź:** widoczne komentarze publiczne (2 od zarządcy i serwisanta)
- [ ] **Sprawdź:** NIE widzisz komentarza "Zespół techniczny - proszę o kontakt..." (to internal)
- [ ] **Sprawdź:** NIE widzisz sekcji "Notatki zarządu" ani "Notatki serwisowe"

### Krok 4 — Oceń zakończone zgłoszenie (CSAT)
- [ ] Kliknij zgłoszenie "Żarówka na klatce przepalona" (status: Zamknięte)
- [ ] **Sprawdź:** na dole sekcja "Oceń zgłoszenie" z gwiazdkami ★★★★☆
- [ ] Kliknij 5 gwiazdek → "Wyślij"
- [ ] **Sprawdź:** gwiazdki znikają (rating został zapisany)

### Krok 5 — Ogłoszenia
- [ ] Na pulpicie mieszkańca sprawdź sekcję "Najnowsze ogłoszenie"
- [ ] **Sprawdź:** widoczne ogłoszenie "Przegląd instalacji gazowej"

### Krok 6 — Kontakty
- [ ] Przejdź do zakładki "Telefony"
- [ ] **Sprawdź:** widoczne 4 kontakty alarmowe (Administracja, Serwis, Ochrona, Gazowe)

### Krok 7 — Sprawdź uprawnienia (negatywne)
- [ ] **Sprawdź:** NIE masz przycisków zmiany statusu
- [ ] **Sprawdź:** NIE masz zakładki "Ogłoszenia" (do tworzenia)
- [ ] **Sprawdź:** NIE masz zakładki "Mieszkańcy"
- [ ] **Sprawdź:** NIE masz zakładki "Osiedle"

---

## 🔵 ROLA 2: ZARZĄDCA (Anna Zarządca)
**Login:** test-zarzad@fixflow.app / Test123!

### Krok 1 — Pulpit zarządcy
- [ ] Wyloguj się (Profil → Wyloguj) → zaloguj jako zarządca
- [ ] **Sprawdź:** pulpit z metrykami KPI i listą wszystkich zgłoszeń osiedla
- [ ] **Sprawdź:** widzisz zgłoszenia mieszkańca, serwisanta i ochrony

### Krok 2 — Przypisz serwisanta
- [ ] Kliknij zgłoszenie "Cieknący kran w kuchni" (status: Nowe)
- [ ] **Sprawdź:** sekcja "Przypisz do" z dropdownem
- [ ] Wybierz "Tomasz Serwis (Serwisant)"
- [ ] **Sprawdź:** przypisanie zapisane, audit trail pokazuje "Przypisano do: Tomasz Serwis"
- [ ] **Sprawdź:** zgłoszenie nadal ma status "Nowe" (dopóki serwisant nie zmieni)

### Krok 3 — Zmień status na Odrzucone
- [ ] Otwórz zgłoszenie "Podejrzana osoba na terenie osiedla" (od Ochrony)
- [ ] Kliknij "Odrzucone" w przyciskach akcji
- [ ] **Sprawdź:** status zmieniony, stepper pokazuje stan odrzucony

### Krok 4 — Dodaj ogłoszenie
- [ ] Przejdź do zakładki "Ogłoszenia"
- [ ] Kliknij przycisk dodawania ogłoszenia
- [ ] Wpisz tytuł: "Zebranie wspólnoty"
- [ ] Wpisz treść: "Zapraszamy na zebranie w piątek o 18:00 w świetlicy."
- [ ] Wybierz datę wygaśnięcia (np. za 7 dni)
- [ ] Kliknij "Publikuj"
- [ ] **Sprawdź:** ogłoszenie pojawia się na liście

### Krok 5 — Dodaj notatkę zarządu
- [ ] Otwórz zgłoszenie "Cieknący kran w kuchni"
- [ ] **Sprawdź:** widoczna sekcja "Notatki zarządu" z tekstem

### Krok 6 — Zarządzaj kontaktami
- [ ] Przejdź do zakładki "Kontakty" / "Telefony"
- [ ] Kliknij "+" aby dodać kontakt
- [ ] Wpisz: "Hydraulik dyżurny", telefon "48123123123", kategoria "Serwis"
- [ ] Kliknij "Dodaj"
- [ ] **Sprawdź:** nowy kontakt na liście

### Krok 7 — Zarządzaj strukturą osiedla
- [ ] Przejdź do zakładki "Osiedle"
- [ ] **Sprawdź:** widoczna lista budynków (Budynek A, Budynek B)
- [ ] Kliknij Budynek A → widoczne klatki schodowe
- [ ] Kliknij "+" aby dodać nową klatkę

---

## 🟠 ROLA 3: SERWISANT (Tomasz Serwis)
**Login:** test-serwisant@fixflow.app / Test123!

### Krok 1 — Portal serwisanta
- [ ] Wyloguj → zaloguj jako serwisant
- [ ] **Sprawdź:** widzisz portal serwisanta z zakładkami statusów
- [ ] **Sprawdź:** widzisz przypisane zgłoszenia (report-002 "Winda nie działa")

### Krok 2 — Zmień status zgłoszenia
- [ ] Kliknij "Winda nie działa"
- [ ] Kliknij przycisk "Zamknięte" (lub zmień status)
- [ ] **Sprawdź:** status się zmienił, audit trail zaktualizowany
- [ ] **Sprawdź:** NIE widzisz przycisku "Odrzucone" (tylko zarząd może)

### Krok 3 — Przejmij nieprzypisane zgłoszenie
- [ ] Znajdź zgłoszenie bez przypisanego technika (lub dodaj nowe jako mieszkaniec)
- [ ] Kliknij w nie → zmień status na "W realizacji"
- [ ] **Sprawdź:** serwisant został automatycznie przypisany

---

## 🔴 ROLA 4: OCHRONA
**Login:** test-ochrona@fixflow.app / Test123!

### Krok 1 — Pulpit ochrony
- [ ] Wyloguj → zaloguj jako ochrona
- [ ] **Sprawdź:** pulpit "Obchód: Ochrona" z przyciskami patrolowymi
- [ ] **Sprawdź:** karta "ZGŁOŚ DLA ZARZĄDU"

### Krok 2 — Zgłoś incydent
- [ ] Kliknij "ZGŁOŚ DLA ZARZĄDU" lub FAB
- [ ] Wybierz kategorię
- [ ] Wpisz tytuł: "Hałas na klatce B"
- [ ] Wyślij
- [ ] **Sprawdź:** zgłoszenie trafia na listę

### Krok 3 — Sprawdź kontakty alarmowe
- [ ] Przejdź do zakładki "Telefony"
- [ ] **Sprawdź:** widoczne kontakty (read-only)

### Krok 4 — Sprawdź uprawnienia (negatywne)
- [ ] **Sprawdź:** NIE widzisz przycisków zmiany statusu w szczegółach zgłoszenia
- [ ] **Sprawdź:** NIE widzisz zakładki "Ogłoszenia", "Mieszkańcy", "Osiedle"

---

## ✅ Lista kontrolna po teście

Po przejściu wszystkich scenariuszy sprawdź:
- [ ] 4 role mają różne widoki pulpitu
- [ ] Mieszkaniec widzi tylko swoje zgłoszenia i komentarze publiczne
- [ ] Mieszkaniec NIE widzi notatek serwisowych ani zarządu
- [ ] Zarządca widzi wszystkie zgłoszenia i może przypisywać/zmieniać status
- [ ] Serwisant widzi przypisane zadania i może zmieniać status
- [ ] Notatki wewnętrzne (is_internal=true) nie są widoczne dla mieszkańca
- [ ] FCM powiadomienia wysyłane przy zmianie statusu

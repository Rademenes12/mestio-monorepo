# Mestio (dawniej FixFlow) — opis ekosystemu

## Po co to powstało

Mestio to system do zarządzania zgłoszeniami usterek i codziennym życiem wspólnoty
mieszkaniowej/osiedla. Problem, który rozwiązuje: dziś mieszkaniec zgłasza usterkę
telefonicznie/mailowo do zarządcy, informacja ginie, serwisant nie wie co ma zrobić,
zarząd nie ma przeglądu statusu spraw, a zarządca (firma zarządzająca nieruchomościami)
prowadzi wszystko ręcznie w Excelu/Trello. Mestio zastępuje to jednym połączonym
ekosystemem, w którym zgłoszenie przepływa automatycznie między rolami, a firma
zarządzająca (klient biznesowy — zarządca/wspólnota) ma jeden panel do zarządzania
osiedlem, zamiast rozproszonych narzędzi.

Model biznesowy: B2B. Klientem płacącym jest firma zarządzająca nieruchomościami
(zarządca/administrator wspólnoty), nie pojedynczy mieszkaniec. Mieszkaniec, ochrona
i serwisant korzystają z aplikacji za darmo, bo dostęp opłaca zarządca.

## Cztery systemy — po co każdy istnieje

1. **Aplikacja mobilna** (`1_Aplikacja_Mobilna`) — dla 4 ról używających telefonu:
   Mieszkaniec, Zarząd/Administrator (tryb mobilny, na obchodzie), Serwisant, Ochrona.
   Tu zgłasza się usterki, głosuje nad uchwałami, czyta ogłoszenia, sprawdza kontakty.

2. **CRM Klienta** (`2_CRM_Klienta`) — panel przeglądarkowy dla Zarządu/Administratora
   danego osiedla. To „biurowa" wersja tych samych danych co w aplikacji, ale z
   większą przestrzenią: budowa struktury osiedla (budynki/klatki/piętra/garaże),
   zarządzanie kontaktami, tworzenie uchwał, komunikatów, zadań cyklicznych.
   Zastępuje potrzebę używania zewnętrznych narzędzi (np. Trello) przez zarządcę.

3. **CRM Mój** (`3_CRM_Moj`) — panel właściciela produktu (Ciebie). Tu zarządzasz
   sprzedażą Mestio innym firmom zarządzającym: leady, pipeline sprzedażowy, umowy,
   faktury, poczta z klientami, generowanie kodów zaproszeń dla nowych klientów,
   automatyzacje mailingowe. To NIE jest widoczne dla klientów — to Twoje narzędzie
   pracy jako dostawcy systemu.

4. **Strona WWW** (`4_Strona_WWW`) — publiczna strona marketingowa Mestio: opis
   produktu, cennik, blog, formularz kontaktowy/rejestracyjny dla nowych klientów
   (firm zarządzających), dokumenty prawne (RODO, regulamin, polityka prywatności).
   To punkt wejścia dla nowego klienta biznesowego, zanim dostanie dostęp do CRM Klienta.

5. **Wspólny backend** (`0_Wspolne_Backend`) — dokumentacja wspólna dla wszystkich
   czterech systemów: jak wygląda aktywacja konta, jak wdrożyć całość, zmiana nazwy
   FixFlow→Mestio, ogólne materiały budowy.

## Jak systemy się łączą (skrót)

Ty (właściciel) → sprzedajesz przez `4_Strona_WWW` → nowy klient (firma zarządzająca)
ląduje w Twoim `3_CRM_Moj` jako lead → po podpisaniu umowy generujesz mu kod
zaproszenia administratora → klient loguje się do `2_CRM_Klienta` i tym samym kodem
loguje się jako Administrator w `1_Aplikacja_Mobilna` → administrator generuje osobne
kody dla Zarządu/Ochrony/Serwisanta/Mieszkańców → wszyscy używają `1_Aplikacja_Mobilna`
na co dzień, a administrator/zarząd dodatkowo `2_CRM_Klienta` do cięższej pracy
biurowej.

Szczegółowy przepływ zgłoszenia i mapę pól między systemami patrz:
`00_PIPELINE_I_MAPA_POL.md`.

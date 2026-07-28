# Strona WWW (fixflow-website) — braki względem prototypu

Porównano prototyp `FixFlow_Website.dc.html` z realnym kodem repo `fixflow-website`.

## 1. Strony i cennik — zgodne z prototypem

Strony istnieją i odpowiadają prototypowi: strona główna (Hero/Problem-Solution/
Funkcje/Jak to działa/Cennik/Poleceni/Blog teaser/FAQ/CTA), `/zamow` (rejestracja),
`/blog` + `/blog/[slug]`, `/kontakt`, `/polityka`, `/rodo`, `/regulamin`, `/sukces`.
Plany cenowe (Start 79 zł / Standard 179 zł / Pro 349 zł / Enterprise wycena) i ich
funkcje zgadzają się 1:1 z prototypem.

## 2. Blog — pusty, bo zależny od CRM Owner (patrz osobny plik braków)

`/blog` pobiera artykuły z tabeli Supabase `blog_posts` (`published = true`). Obecnie
prawdopodobnie **pusty**, bo:
- panel do publikowania artykułów (`/blog` w CRM Owner) istnieje w kodzie, ale nie jest
  podlinkowany w sidebarze CRM Owner (patrz `CRM_Owner_Braki_Do_Naprawy.md`, punkt 1) —
  więc nikt nie mógł tam nic opublikować.
- Strona ma poprawny fallback („Brak dostępnych artykułów…"), więc to nie crash, tylko
  pusta treść w praktyce.

**Zadanie:** naprawić dostęp do panelu bloga w CRM Owner (patrz plik CRM Owner) — to
odblokuje też stronę WWW.

## 3. Formularz newslettera na `/blog` — niedziałający

Sekcja „Chcesz taki artykuł co tydzień?" ma pole e-mail i przycisk „Zapisz się", ale
**przycisk nie ma żadnej akcji podpiętej** (brak `onClick`, brak zapisu do bazy/serwisu
mailingowego). To wygląda na ukończone, ale nic nie robi po kliknięciu.

**Zadanie:** podpiąć zapis adresu e-mail (nowa tabela Supabase np. `newsletter_subscribers`,
albo integracja z zewnętrznym serwisem mailingowym) + potwierdzenie sukcesu dla usera.

## 4. Poza zakresem tego przeglądu

Nie sprawdzano szczegółowo: `HeroSection`, `FeaturesSection`, `HowItWorksSection`,
`ReferralSection`, `FaqSection`, `/kontakt`, `/zamow` (formularz), stron prawnych
(`/polityka`, `/rodo`, `/regulamin`) — treść tekstowa może wymagać uzupełnienia danych
firmy (NIP, adres — w prototypie to pola-placeholdery `[Twoja firma]`, `[adres]` itd.,
sprawdzić czy w realnym kodzie są już uzupełnione realnymi danymi, czy nadal placeholdery).

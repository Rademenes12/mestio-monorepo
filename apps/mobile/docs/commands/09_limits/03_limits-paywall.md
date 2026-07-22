# Intro

Propozycja limitów i modelu Pro została zaakceptowana. Zanim przejdziesz do planowania implementacji, twoim zadaniem jest przygotowanie copy sprzedażowego na paywall.

To jest rola eksperta od sprzedaży, nie inżyniera. Pisz językiem korzyści, ale **konkretnie**. Nie poetycko, nie metaforycznie. User ma w 2 sekundy zrozumieć co dostanie i co ma zrobić.

**Zakazy:**
- Bez wzmianek o triale ("7 dni za darmo", "darmowy okres") — nie jest ustalony.
- Bez cen — nie są ustalone.
- Bez metaforycznych CTA ("Otwórz każdą stronę", "Daj sobie więcej miejsca"). CTA = czysty czasownik akcji.

Na tym etapie to copy ma być użyte w placeholderze flow zakupu Pro, który działa jako fallback, gdy RevenueCat nie jest aktywny. Po skonfigurowaniu RevenueCat prawdziwy paywall przejmuje flow zakupu.

---

# Task

Utwórz nowy plik `docs/PAYWALL.md` i zapisz w nim kompletny copy paywalla.

Plik powinien zawierać:

## Headline

Jedno zdanie pod ikoną na paywallu. Konkretne wyliczenie co Pro odblokowuje — bez metafor.

Szablon: "Nielimitowane [encja], [funkcja Pro-only], [ekran Pro-only] i dark mode — w Pro."

Przykład EN: "Unlimited chess openings, advanced filters, progress insights and dark mode — in Pro."

Podaj wersję **PL** i **EN**.

## What's included

4-6 benefitów. Każdy benefit:
- **Title** — rzeczownikowy, konkretny, 2-4 słowa. **Nie** poetycki. Przykłady dobrze: "Nielimitowane postanowienia", "Zaawansowane filtry", "Dark mode". Przykłady źle: "Pełna półka", "Napisz ten list".
- **Subtitle** — 1 zdanie, zaczyna się od konkretu (co user dostaje), nie od metafory.

Benefity pokrywają:
- Unlimited [główna encja] — zdjęcie limitu
- [Ekran Pro-only] — dostęp do zablokowanego ekranu
- [Funkcja Pro-only] — odblokowanie zablokowanej funkcji
- Dark Mode
- (opcjonalnie 1-2 dodatkowe, jeśli naprawdę pasują)

Wersje **PL** i **EN**.

## Copy na dialogi i ekrany przejściowe

Copy dialogów/ekranów przejściowych ma być **szablonowe, nie bespoke**. Nie wymyślaj różnych tytułów i CTA dla każdego przypadku — użyj jednego wzorca konsekwentnie.

### Wzorzec dla blokad prowadzących do **rejestracji** (guest limit hit)

Slot-based. Podmieniasz TYLKO sloty w `{}`, reszta zostaje **dosłownie** taka jak tutaj.

- **Title (PL)**: `Osiągnąłeś limit {ENTITY_NAME_PL_GEN}.`
- **Title (EN)**: `You've reached the {ENTITY_NAME_EN} limit.`
- **Body (PL)**: `Zarejestruj darmowe konto, aby {GUEST_BENEFIT_PL}.`
- **Body (EN)**: `Create a free account to {GUEST_BENEFIT_EN}.`
- **CTA primary**: `Zarejestruj się` / `Create free account`
- **CTA secondary**: `Jeszcze nie` / `Not yet`

Wypełnienie slotów:
- `{ENTITY_NAME_*_GEN}` — nazwa encji w dopełniaczu liczby mnogiej (PL: `postanowień`, `nawyków`; EN po prostu plural).
- `{GUEST_BENEFIT_*}` — 1 konkretna korzyść z rejestracji. Format: **bezokolicznik + rzeczownik**. Np. `dodać więcej postanowień`, `zapisać dane na stałe`, `synchronizować między urządzeniami`. Bez przymiotników ocennych, bez metafor.

Zero wzmianki o Pro w samym dialogu limitu dla guest. Profil może osobno pokazywać `Buy Pro`, ale tylko gdy `RevenueCatConfig.isEnabled == true && !isPro`; w takim układzie `Register` pozostaje głównym CTA dla guest.

### Wzorzec dla blokad prowadzących do **Pro** (registered limit hit, Pro feature, Pro screen, Dark mode)

Slot-based. Podmieniasz TYLKO sloty w `{}`, reszta zostaje **dosłownie** taka jak tutaj.

- **Title (PL)**: `Odblokuj {WHAT_IS_BLOCKED_PL_ACC}.`
- **Title (EN)**: `Unlock {WHAT_IS_BLOCKED_EN}.`
- **Body (PL)**: `Zrób upgrade do Pro, aby {PRO_BENEFIT_PL}.`
- **Body (EN)**: `Upgrade to Pro to {PRO_BENEFIT_EN}.`
- **CTA primary**: `Zrób upgrade do Pro` / `Upgrade to Pro`
- **CTA secondary**: `Jeszcze nie` / `Not yet`

Wypełnienie slotów:
- `{WHAT_IS_BLOCKED_*_ACC}` — nazwa tego, co jest zablokowane, w bierniku (PL: `więcej postanowień`, `Achievements`, `Zaawansowane filtry`, `Dark mode`).
- `{PRO_BENEFIT_*}` — 1 konkretna korzyść. Format: **bezokolicznik + rzeczownik**. Np. `dodawać bez limitu`, `widzieć swoje statystyki`, `używać ciemnego motywu`. Bez przymiotników ocennych, bez metafor.

### Zakres copy

Napisz copy zgodne z oboma wzorcami dla wszystkich przypadków:

- **Limit hit (guest)** — dla każdej limitowanej encji. Wzorzec rejestracyjny.
- **Limit hit (registered)** — dla każdej limitowanej encji. Wzorzec Pro.
- **Pro screen locked** — wzorzec Pro. Tu ekran przejściowy, nie dialog — ale copy ten sam szablon.
- **Pro feature locked** — wzorzec Pro.
- **Dark mode locked** — wzorzec Pro.

Tytuł i body zmieniają TYLKO konkret ([encja]/[funkcja]/[ekran]) i korzyść. CTA są **identyczne** we wszystkich przypadkach tego samego wzorca. To nie jest miejsce na kreatywność — to jest miejsce na konsekwencję.

Wersje **PL** i **EN** dla każdego.

## Copy do placeholdera zakupu Pro

Przygotuj też krótkie copy dla placeholdera flow zakupu Pro:
- tytuł
- body
- główny CTA lub tekst zamknięcia

To copy ma działać dobrze jeszcze przed integracją RevenueCat.

## Wytyczne tonu

- **Konkret nad poetyką.** Rzeczowniki wprost, bez metafor. User w 2 sekundy rozumie co dostanie.
- **Benefit, nie strata.** "Zrób upgrade, aby X" — nie "Bez Pro stracisz X".
- **Bez FOMO, bez wykrzykników, bez CAPS LOCK na CTA.** Język pewny, nie krzyczący.
- **CTA = czasownik akcji + rzeczownik.** "Zrób upgrade do Pro", "Zarejestruj się". Nie "Otwórz każdą stronę", nie "Daj sobie więcej".
- **Spójność nad różnorodnością.** Ten sam wzorzec CTA w każdym dialogu tego samego typu.
- Osobowość brandu z `docs/IDEA.md` może podbarwić ton body, ale **nie może** rozmydlić CTA ani zamienić tytułów w metafory.

---

# Finish

Po zapisaniu `docs/PAYWALL.md`:

1. Commit: `docs(limits): add PAYWALL.md`.
2. Przedstaw mi podsumowanie — headline + lista benefitów.
3. Powiedz mi, że kolejny krok to `04_limits-plan.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do wykonania polecenia zawartego w `docs/commands/09_limits/04_limits-plan.md` — nie podgląduj tego pliku wcześniej!

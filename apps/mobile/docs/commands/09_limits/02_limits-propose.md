# Intro

Na podstawie eksploracji z poprzedniego kroku znasz już aplikację, jej ekrany, główną encję i stan dark mode. Teraz twoim zadaniem jest zaproponować mi konkretny plan limitów i modelu Pro.

**Nie pytaj mnie otwartymi pytaniami.** Zaproponuj gotowe, konkretne rozwiązania, które zaakceptuję lub skoryguję.

---

# Zasady UX

Zanim zaproponujesz cokolwiek, zinternalizuj te zasady. Są niepodlegające dyskusji:

### Model limitów

- `Guest` i `Registered` to typy konta
- `Pro` to dodatkowy płatny access layer, który może mieć zarówno guest, jak i registered
- Logika limitów ma więc działać na 3 stanach dostępu:
  - **Guest bez Pro** — najmniejszy limit (wystarczający, żeby poczuć wartość, ale nie żeby być zadowolonym)
  - **Registered bez Pro** — większy limit (darmowa rejestracja)
  - **Pro** — bez limitów

### Dark mode

Dark mode jest **Pro-only**. To ustalenie biznesowe, nie propozycja. Nie proponuj alternatyw ani "dark mode dla wszystkich".

---

# Task

Przygotuj i przedstaw mi kompletną propozycję limitów i modelu Pro. Użyj poniższej struktury:

## A. Limit na główną encję

Na podstawie eksploracji zaproponuj:
- Nazwa encji (np. "przepisy", "nawyki", "notatki")
- Limit dla gościa: X (dobierz sensownie — ma wystarczyć na poznanie apki, ale nie na pełne korzystanie)
- Limit dla zarejestrowanego: X+
- Limit dla Pro: bez limitu
- Typ limitu: ilościowy (ile elementów). Zaproponuj trwały, bez resetu czasowego, chyba że zarządzę inaczej.

## B. Ekran Pro-only

Zaproponuj jeden ekran, który będzie dostępny tylko dla Pro:
- Który istniejący ekran zablokować, albo jaki nowy ekran dodać (np. statystyki, insights, zaawansowane ustawienia)
- Krótko uzasadnij, dlaczego właśnie ten ekran ma być częścią oferty Pro

## C. Funkcja Pro-only

Zaproponuj jedną funkcję w istniejącym ekranie, która będzie zablokowana dla non-Pro:
- Która akcja/feature (np. zaawansowane sortowanie, filtry, eksport, duplikowanie)
- Krótko uzasadnij, dlaczego właśnie ta funkcja ma być częścią oferty Pro

## D. Wytyczne copy

Zaproponuj:
- Ton komunikacji w dialogach i ekranach przejściowych (dopasuj do osobowości apki z `docs/IDEA.md` oraz z `docs/PUBLISH.md`)
- Styl języka: pozytywny, zorientowany na korzyści, bez straszenia

---

# Finish

Przedstaw całą propozycję w czytelnej formie.

Poczekaj na mój feedback. Mogę:
- Zaakceptować (napiszę `next`)
- Skorygować poszczególne punkty
- Poprosić o alternatywne propozycje

Gdy zaakceptuję propozycję (napiszę `next`), zanim przejdziesz do kolejnego kroku wykonaj:

1. **Podmień placeholdery produktowe** w downstream stepach. Dla każdego z poniższych plików użyj `Edit` z `replace_all: true`:
   - `docs/commands/09_limits/05_limits-build-policy.md`
   - `docs/commands/09_limits/07_limits-build-pro-feature.md`
   - `docs/commands/09_limits/08_limits-build-pro-screen.md`
   - `docs/commands/09_limits/10_limits-integration-tests.md`

   Podmień tymi zaakceptowanymi wartościami z sekcji A/B/C propozycji:
   - `__MAIN_ENTITY__` → nazwa głównej encji w mianowniku liczby mnogiej (np. `postanowienia`, `nawyki`, `przepisy`).
   - `__PRO_SCREEN__` → nazwa Pro-only ekranu (np. `Achievements`, `Statystyki`).
   - `__PRO_FEATURE__` → nazwa Pro-only funkcji (np. `Zaawansowane filtry`, `Eksport`).

2. Commit: `docs(limits): fill product placeholders after proposal accepted`.

3. Przejdź do wykonania polecenia zawartego w `docs/commands/09_limits/03_limits-paywall.md` — nie podgląduj tego pliku wcześniej!

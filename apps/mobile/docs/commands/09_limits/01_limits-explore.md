## Eksploracja

Przeanalizuj projekt krok po kroku. **Nie implementuj niczego. Nie modyfikuj żadnego pliku.**

### 1. Zrozum aplikację

Przeczytaj `docs/IDEA.md` — dowiedz się:
- Co robi aplikacja i dla kogo
- Jaką wartość daje użytkownikowi
- Jaka jest główna aktywność użytkownika (co robi najczęściej)

### 2. Zmapuj ekrany i funkcje

Przejrzyj `lib/features/` — dla każdego feature:
- Jakie ekrany istnieją
- Co użytkownik może na nich robić (CRUD, interakcje)
- Które ekrany/funkcje mają największą wartość dla użytkownika

### 3. Zidentyfikuj główną encję

To najważniejszy punkt. Znajdź **główny element**, w którym użytkownik tworzy, dodaje lub zbiera dane w aplikacji. To będzie obiekt, który zlimitujemy dla gościa i dla zarejestrowanego, a odblokujemy dopiero dla konta `pro`.

Szukaj w Modelach, Repozytoriach, Data source'ach, sprawdź tabele Supabase, Cubitach — jakie operacje CRUD istnieją.

### 4. Sprawdź dark mode

Przejrzyj:
- czy jest `darkTheme` w `MaterialApp`
- czy istnieją pliki z ciemnym motywem
- Czy gdziekolwiek jest `ThemeMode` albo przełącznik motywu

### 5. Zweryfikuj model dostępu

Sprawdź `lib/app/session/models/user_session_model.dart` oraz `lib/app/session/models/user_tier.dart`.

Zweryfikuj, czy model rozdziela:
- typ konta: `guest` albo `registered`
- status `Pro` jako osobną nakładkę
- stan dostępu do limitów wyliczany z tych dwóch rzeczy

### 6. Wytypuj kandydatów

Na podstawie eksploracji zidentyfikuj:
- **Kandydata na ekran Pro-only** — ekran z dużą wartością, ale nie kluczowy dla podstawowego użytkowania (np. statystyki, insights, zaawansowane ustawienia)
- **Kandydata na funkcję Pro-only** — konkretna akcja w istniejącym ekranie (np. sortowanie, filtry, eksport)

Kandydaci mogą być już zaimplementowani (użyjemy istniejących do stworzenia limitów) lub możesz sam je wymyśleć do implementacji i mi zaproponować.

---

## Podsumowanie

Gdy skończysz eksplorację, przedstaw mi zwięzłe podsumowanie, a następnie zaleć napisanie `next`.

Gdy napiszę `next`, przejdziesz do wykonania polecenia zawartego w `docs/commands/09_limits/02_limits-propose.md` — nie podglądaj tego pliku wcześniej!

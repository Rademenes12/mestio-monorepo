Zapoznaj się z plikiem: `docs/IDEA.md` gdzie jest opisany pomysł na tę aplikację.

Przejrzyj kod i dowolne pliki źródłowe jakie trzeba znać, aby przygotować ekrany onboardingu dla tej aplikacji.

# Technikalia

## Current First Launch Experience

Aplikacja działa na zasadzie, że gdy użytkownik pierwszy raz ją uruchamia to ląduje zawsze na Welcome Screen.

Tam ma do wyboru dwie opcje:
- Kontynuuj jako gość
- Zaloguj się na istniejące konto

Gdy wybierze opcję pierwszą, aplikacja zakłada mu pod spodem konto Supabase gościa wraz z uid i przenosi na Home Screen - główny ekran aplikacji. Z tego ekranu łatwo może przejść do Profilu i ustawić swoje imię (wciąż bez rejestracji) lub np. się zupgradować do pełnego konta.

Gdy wybierze logowanie, ląduje najpierw na ekranie logowania gdzie musi podać swoje dane. Jak się zaloguje, dopiero ląduje na ekranie Home Screen, ale jako już pełnoprawny, zarejestrowany i zalogowany użytkownik.

## Timing zapisu (wpływa na UX)

Ekrany onboardingu tylko zbierają dane w pamięci. Dopiero **CTA na ekranie potwierdzenia** na końcu flow tworzy konto gościa (przenosimy to z aktualnego przycisku "Kontynuuj jako gość" na Welcome — ten przycisk ma teraz jedynie otwierać flow onboardingu) i uruchamia zapis zebranych danych. Do tego momentu żaden wewnętrzny stan aplikacji (auth, session, DB) się nie zmienia, user może swobodnie cofać się i edytować pola.

Dlaczego to istotne na tym etapie: UX w kolejnym kroku musi wiedzieć, że confirmation screen to osobny ekran z własnym CTA (nie Minimal Setup), bo to tam dzieje się faktyczny zapis.

# Zbierz materiały

Zrozum o co chodzi w tej aplikacji. Zamiast się mnie pytać, postaraj sam sobie odpowiedzieć na pytania.

Z `docs/IDEA.md` wyciągnij konkretnie:
- jaki **problem** apka rozwiązuje (potrzebne do wizualizacji w onboardingu),
- jakie **rozwiązanie** proponujemy (potrzebne do wizualizacji),
- czym apka **różni się od innych aplikacji tego typu** (potrzebne do krótkiego ekranu kontrastu po przywitaniu),
- co jest **pierwszym elementem domenowym** (do Minimal Setup na końcu flow),
- czy jest gdzieś w apce miejsce, w którym imię usera dodaje wartość poza samym onboardingiem (copy na Home, listy w achievementach, profil itd.) — to wpłynie na ramę użycia imienia później, ale **nie decyduje o tym, czy pytać o nie w onboardingu**. Imię zbieramy niezależnie, bo pełni dwie role w samym flow: (1) lekka inwestycja usera na pierwszym ekranie, która zwiększa commitment, (2) payoff na ekranie Preview ("Cześć, [imię]!") pokazujący, że apka już usera słyszy. To są standardowe wzorce z `docs/skills/onboarding-skill.md` i stosujemy je nawet jeśli imię nigdzie indziej w apce się nie pojawia.

Ostatecznie podeślij mi podsumowanie tego co zrozumiałeś do potwierdzenia.

Napisz, żebym Cię skorygował jeżeli coś jest nie tak, albo zasugeruj mi napisanie `next`, jeżeli wszystko się zgadza. Kolejny krok: `03_onboarding-ux.md`.

Gdy napiszę `next`, przejdź do `docs/commands/08_onboarding/03_onboarding-ux.md`.

Dobra teraz załóż czapkę Flutter Developera i zaimplementuj te ekrany rozpisane w `docs/ONBOARDING.md` razem z podstawową architekturą, na której dopniemy zapis w następnym kroku. Sam presentation layer + cubit trzymający stan. Nie musi jeszcze wyglądać — wykorzystaj podstawowe widgety Fluttera.

Poinformuj mnie gdy skończysz i przypomnij mi, że to na razie szkielet — wyglądem zajmiemy się w `05_onboarding-design.md`, a podpięciem auth/DB w `06_onboarding-finalize.md`.

Zahardcoduj stringi w UI po Polsku. Oznacz je tylko `// L10N`, potłumaczymy je w finalizacji. Nie pisz jeszcze testów — testy cubita dopiszemy w 06 razem z logiką zapisu.

Wymagania techniczne:
- `PageView` z **swipe disabled**. Nawigacja tylko przez przyciski Dalej/Wstecz.
- **Klawiatura musi się chować**, gdy user przechodzi dalej. Tap w "Dalej" (lub action klawiatury Done/Next na ostatnim polu ekranu) → `FocusScope.of(context).unfocus()` + dopiero potem nawigacja na kolejny ekran. Bez tego systemowa klawiatura wisi na pół ekranu i psuje cały onboarding. Dotyczy każdego ekranu z `TextField` (Imię, Minimal Setup). Stosuj zasady z `docs/skills/flutter-mobile-ux-skill.md`.
- `OnboardingCubit` jako globalny `@lazySingleton` (`get_it`/`injectable`) — **nie** per-route `BlocProvider`, bo ma przeżyć nawigację aż na Home w kroku 06. Rejestrowany lazy w handlerze przycisku "Kontynuuj jako gość" na Welcome, jeszcze przed nawigacją na pierwszy ekran onboardingu.
- `OnboardingCubit` trzyma zebrane dane (imię, pierwszy element domenowy, itd.) w `State` (`freezed`) + ma settery wołane z kolejnych ekranów (`setName`, `setField…`). Stan dla flow zapisu (`creatingGuest`, `persisting`, itd.) dodamy w 06 — na razie wystarczy `idle` ze zbieranymi polami.
- **Żadnych calli do auth/DB.** CTA na ekranie potwierdzenia po kliknięciu ma zamknąć cały onboarding i wrócić do ekranu Welcome + wykonać `cubit.reset()` — metodę zerującą stan do świeżego `OnboardingState()` (imię/resolution/reasons puste) — żeby dało się przetestować flow w kółko. Tworzenie konta gościa + batch-save wchodzą w 06, a `cubit.reset()` będzie tam re-używane przez top-level listener po zakończeniu submit-u.
- Po kliknięciu CTA na ostatnim ekranie ekranie onboardingu **nie wolno wrócić do pierwszego ekranu onboardingu** tylko do Welcome Screen. Jeżeli onboarding składa się z kilku routes albo jest osobnym flow na stacku, użyj stabilnego route name/predicate dla Welcome albo zastąp stack tak, żeby po zakończeniu widoczny był Welcome.
- Dopiero później przerobimy to tak, że będzie logował anonimowaego użytkownika, pokazywał jeszcze paywall i przechodził do głównego ekranu Home. Na razie testujemy samo flow onboardingu.

Jak to zrobisz, zasugeruj mi, abym odpalił aplikację, dał feedback co do tego flow i jeżeli wszystko się zgadza to zatwierdził go napisaniem `next`. Kolejny krok: `05_onboarding-design.md`.

Gdy napiszę `next`, przejdź do `docs/commands/08_onboarding/05_onboarding-design.md`.

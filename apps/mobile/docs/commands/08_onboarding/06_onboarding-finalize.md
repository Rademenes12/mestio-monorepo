Dobrze, więc teraz dopinamy flow. Szkielet z `OnboardingCubit` zbierającym dane + ekranami już jest (z 04), wygląd też (z 05). Teraz dokładamy logikę zapisu, żeby onboarding działał od-do i był gotowy na produkcję.

# Kiedy dzieje się zapis

Ekrany onboardingu już teraz zbierają dane do stanu `OnboardingCubit`. Dopiero **CTA na ekranie potwierdzenia** (np. "Zaczynamy!" / "Let's go!" — CTA ma energetyzować, nie być czysto funkcyjne) odpala flow:

1. CTA → `loading`. Cubit woła `authRepository.continueAsGuest()`.
   - **Błąd**: inline error pod CTA (`SelectableText`), CTA wraca do klikalnego, user zostaje na confirmation, retry. Auth się nie zmienił.
   - **Sukces**: Supabase emituje sesję, `SessionNavigationObserver` czyści pushed routes, a `AppGate` pokazuje Home. Cubit (globalny singleton) żyje dalej.
2. Już **po przejściu na Home** cubit leci z batch-save zebranych danych do Supabase (imię → `shared_users`, pierwszy element domenowy → odpowiednia tabela z prefixem apki — jeśli user użył "Skip" na Minimal Setup, pierwszego elementu nie ma, zapisujemy tylko imię).
   - **Sukces** → bez SnackBara. Cubit emituje końcowy stan, top-level listener woła `cubit.reset()` (czyszczenie stanu do `OnboardingState()`).
   - **Błąd** → czerwony SnackBar z komunikatem, listener woła `cubit.reset()` (jedna próba, bez auto-retry). User zostaje na Home, apka działa, najwyżej wpisane pole trzeba dopisać ręcznie.

Priorytet: jak najszybciej wpuścić usera do apki. Rzadki błąd batch-save to akceptowalna cena za to, że nie trzymamy usera na loaderze confirmation czekając na pełny zapis.

# Co konkretnie dopisujemy

- **Rozszerz `OnboardingState`** o stany flow zapisu: `creatingGuest`, `guestCreationFailed(errorKey)`, `persisting`, `persistSuccess`, `persistFailed(errorKey)` (obok dotychczasowego `idle`).
- **Metoda `submit()`** w cubicie — odpalana z CTA confirmation. Sekwencja: `creatingGuest` → `continueAsGuest()` → (sukces) `persisting` → batch-save → `persistSuccess`/`persistFailed`. Błędy w fazie 1 emitują `guestCreationFailed` i cubit wraca do `idle` po retry.
- **CTA confirmation**: zamień dotychczasowy `popUntil` do Welcome na `cubit.submit()`. Podczas `creatingGuest` CTA pokazuje spinner (20x20 `CircularProgressIndicator`) i jest disabled, Wstecz zablokowane. `guestCreationFailed` → inline `SelectableText` pod CTA (NIGDY `SnackBar` — tu user jest jeszcze na confirmation).
- **`BlocListener<OnboardingCubit, OnboardingState>` w `lib/app/app.dart`** (równolegle do `app_gate`, wewnątrz MaterialApp — tak, żeby miał dostęp do `ScaffoldMessenger`, ale nad Navigatorem). Reaguje na `persistSuccess` → `cubit.reset()` bez SnackBara, `persistFailed(errorKey)` → czerwony SnackBar + `cubit.reset()`. Listener musi siedzieć wysoko, bo confirmation screen zniknie ze stacku po sign-in zanim batch-save się zakończy. **Świadomy wyjątek** od reguły z `AGENTS.md` / `CLAUDE.md` „błędy tylko inline" — po nawigacji na Home inline nie ma gdzie.
- **`BlocProvider<OnboardingCubit>.value(value: getIt<OnboardingCubit>())`** nad tym listenerem **tworzy instancję cubita eagerly przy starcie appki** (bo `@lazySingleton` instantiuje się przy pierwszym `getIt<T>()`). To nie problem — cubit jest tani, nie trzyma streamów ani subskrypcji, a eager creation jest ceną za top-level listener. Welcome button handler nie musi już sam wołać `getIt<OnboardingCubit>()` — instancja istnieje od startu aplikacji. `BlocProvider<OnboardingCubit>.value` w `OnboardingScreen` (z 04) zostaje — nadal jest scope'em flow, referuje do tej samej instancji.
- **Reset po zakończeniu**: top-level listener po `persistSuccess` albo `persistFailed` woła `cubit.reset()`, który emituje świeży `OnboardingState()` (imię/resolution/reasons puste, status `idle`). Kolejny onboarding (np. po sign-out → Welcome → Continue as guest) startuje od zera.
- **Batch-save jako jedna operacja** — utwórz jeden RPC w Supabase wywoływany przez `supabase.rpc()`. Nie dwa sekwencyjne calle, bo przy połowicznej porażce zostanie brudny stan (np. `shared_users` ma imię, pierwszy element domenowy się nie zapisał). Nazwij RPC z prefixem aplikacji, dodaj `grant execute on function public.<prefix>_...(...) to authenticated`, ustaw bezpieczny `search_path`, zweryfikuj `SECURITY DEFINER`/`SECURITY INVOKER` i przetestuj call jako authenticated guest.
- **Errory `errorKey`**: cubit emituje tylko klucze, mapowanie na tekst przez `context.l10n`.
- **Lokalizacja**: wszystkie stringi z 04 (oznaczone `// L10N`) przenieś do ARB i użyj `context.l10n`. Uruchom `flutter gen-l10n`.
- **Testy cubita**: `bloc_test` + `mocktail` na `AuthRepository` i tę repo, do której leci batch-save. Pokryj: happy path, błąd `continueAsGuest()`, błąd batch-save, retry po `guestCreationFailed`.

# Pozostałe

Jeżeli `authRepository.continueAsGuest()` wciąż wisi na przycisku Welcome — wyrzuć go stamtąd, `continueAsGuestButtonLabel` ma tylko otwierać flow onboardingu (już powinno to być wyczyszczone z 04, ale zweryfikuj).

Nie dodawaj nigdzie osobnej flagi ukończenia onboardingu — stan wynika jednoznacznie z utworzenia guest session w kroku 1 powyżej.

Home pokaże pierwszy element normalnym streamem z repo, gdy batch-save wyląduje w DB (Supabase Realtime). Bez optimistic insertów, bez highlight animacji.

Uruchom `flutter analyze` i testy cubita. Dopnij wszystko na produkcję.

Jak to zrobisz, zasugeruj mi, abym odpalił aplikację i sprawdził czy wszystko działa. Jeżeli tak, kolejnym krokiem będzie pokazanie paywalla po onboardingu.

Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
`Wykonaj: docs/commands/08_onboarding/07_onboarding-paywall.md`

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Gdy napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/08_onboarding/07_onboarding-paywall.md` — nie wcześniej!

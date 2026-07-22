Dopinamy jednorazowy paywall po zakończeniu onboardingu.

# Cel

Po ostatnim CTA onboardingu:

1. najpierw musi udać się `signInAnonymously` / `continueAsGuest`,
2. `SessionNavigationObserver` ma wyczyścić pushed routes,
3. `AppGate` ma pokazać `HomeScreen`,
4. dopiero po pierwszym renderze Home pokaż paywall przez gotowy `PostAuthPaywallBlocListener`.

Nie pokazuj paywalla z ostatniego ekranu onboardingu. Listener ma być w `lib/app/app.dart`.

# Pliki

Najpierw sprawdź:

- `lib/app/app.dart`
- `lib/app/router/app_gate.dart`
- `lib/app/navigation/session_navigation_observer.dart`
- `lib/app/paywall/presentation/paywall_presenter.dart`
- `lib/app/paywall/presentation/post_auth_paywall_listener.dart`
- aktualne pliki `OnboardingCubit`

# Implementacja

1. W `OnboardingState` dodaj getter `shouldShowPostOnboardingPaywall`.

2. Getter ma zwracać `true` tylko dla statusu `OnboardingStatus.persisting`.

3. W `lib/app/app.dart` zaimportuj `PostAuthPaywallBlocListener`.

4. Owiń `AppGate` gotowym `PostAuthPaywallBlocListener<OnboardingCubit, OnboardingState>`.

5. `listenWhen` ma reagować tylko na zmianę `shouldShowPostOnboardingPaywall` z `false` na `true`.

6. Nie wywołuj tutaj `RevenueCatUI`, `PaywallPresenter`, `Navigator.popUntil` ani `ScaffoldMessenger` bezpośrednio. To jest już w `PostAuthPaywallBlocListener`.

# Weryfikacja

Sprawdź ręcznie:

- onboarding → anonymous auth success → Home → placeholder paywall, gdy RevenueCat nie jest aktywny,
- onboarding → anonymous auth success → Home → prawdziwy paywall, gdy RevenueCat jest aktywny,
- zamknięcie paywalla zostawia usera na Home,
- login istniejącego konta nie pokazuje paywalla,
- sign-out/sign-in nie pokazuje paywalla ponownie,
- błąd anonymous auth zostawia usera na confirmation i nie pokazuje paywalla.

Uruchom `flutter analyze` i testy `OnboardingCubit`.

Na końcu zrób commit.

Zaktualizuj `STATE.md`: ustaw etap `onboarding` jako `✅ done`, ustaw `Ostatni zakończony etap` na `onboarding`, ustaw `Aktualny etap` na `limits` i zostaw status etapu `limits` jako `⬜ not-started`.

Powiedz mi, że ukończyliśmy etap `08_onboarding` i kolejny etap to `09_limits`.

Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
`Wykonaj: docs/commands/09_limits.md`

Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Gdy napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/09_limits.md` — nie wcześniej!

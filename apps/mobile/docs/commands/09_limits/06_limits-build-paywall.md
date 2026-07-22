# Task

Podłącz istniejący `PaywallPresenter` do flow limit-hit z kroku 05.

## Kontekst

- `PaywallPresenter` już istnieje: `lib/app/paywall/presentation/paywall_presenter.dart`.
- `ProPurchasePlaceholderScreen` już istnieje: `lib/app/paywall/ui/pro_purchase_placeholder_screen.dart`.
- Wzorzec użycia: `lib/features/profiles/presentation/ui/profile_screen.dart` (`BlocListener` na `AccountActionsEffectOpenPaywall` → `presentIfNeeded` → switch na `PaywallPresentationResult`).
- Placeholder jest tylko fallbackiem, gdy `RevenueCatConfig.isEnabled == false`; po skonfigurowaniu RevenueCat `presentIfNeeded` otwiera prawdziwy RevenueCat paywall.
- Profile CTA `Buy Pro` pojawia się automatycznie tylko gdy `RevenueCatConfig.isEnabled == true && !session.isProUser`. Guest też może kupić Pro, ale `Register` pozostaje głównym CTA.

## Zakres

- Cubit głównej encji (ten z kroku 05): zastąp TODO — po kliknięciu CTA w dialogu `registeredLimit` emituj efekt `openPaywall`.
- `BlocListener` na ekranie obsługuje `openPaywall`: `await getIt<PaywallPresenter>().presentIfNeeded(context: context)`.
- Obsłuż `PaywallPresentationResult`:
  - `purchased` / `restored` → zielony SnackBar z `l10n.proEnabledSnackbar`.
  - `error` → inline `SelectableText` z `messageForErrorKey(l10n, 'purchase_error')` (błąd SnackBarem **nie pokazujemy** — reguła z CLAUDE.md).
  - `notPresented` / `cancelled` / `placeholderShown` → no-op.
- **Nie wywołuj `RevenueCatUI.presentPaywallIfNeeded` poza `PaywallPresenter`.**

## Wymagania

- Stringi przez `context.l10n`.
- Test cubita: dopisz scenariusz "registered limit hit → user tapuje CTA → efekt `openPaywall` emitowany".

## Poza zakresem

Pro-only feature, Pro-only screen, dark mode.

## Koniec

1. `flutter analyze` — czysto.
2. Testy na zielono.
3. Commit.
4. Powiedz mi, że kolejny krok to `07_limits-build-pro-feature.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/07_limits-build-pro-feature.md` — nie podgląduj wcześniej!

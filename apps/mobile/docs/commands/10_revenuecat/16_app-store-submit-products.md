# Intro

Twoim zadaniem jako agenta AI jest dopiąć produkty Apple do aktualnej wersji aplikacji.

CEL: 3 produkty Apple są wybrane w sekcji In-App Purchases and Subscriptions aktualnej iOS App Version.

# Task

1. Użyj Apple Product ID utworzonych w kroku `06_apple-products.md`. Nie wracaj do `docs/IDEA.md` tylko po to, żeby ponownie odczytać prefix.

2. Poproś mnie, żebym w App Store Connect otworzył aktualną **iOS App Version**.

3. Poproś mnie, żebym w sekcji **In-App Purchases and Subscriptions** kliknął **Select In-App Purchases or Subscriptions**.

4. Poproś mnie, żebym zaznaczył:
   - `Pro Monthly` / Apple monthly Product ID z kroku 06
   - `Pro Yearly` / Apple yearly Product ID z kroku 06
   - `Pro Lifetime` / Apple lifetime Product ID z kroku 06

5. Poproś mnie, żebym kliknął **Done**.

6. Powiedz mi, że Google Play nie ma analogicznego wybierania produktów na ekranie release. Dla Google wystarczy, że subscription/base plans i one-time product są aktywne, a build z Billing SDK trafi na track.

7. Poproś mnie o potwierdzenie: 3 produkty Apple są wybrane w aktualnej wersji aplikacji.

8. Zaktualizuj `STATE.md`: ustaw etap `revenuecat` jako `✅ done`, ustaw `Ostatni zakończony etap` na `revenuecat`, ustaw `Aktualny etap` na `review` i zostaw status etapu `review` jako `⬜ not-started`.
9. Powiedz mi, że etap `10_revenuecat` jest zakończony i przechodzimy do etapu `11_review`.
10. Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
   `Wykonaj: docs/commands/11_review.md`
11. Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/11_review.md` — nie wcześniej!

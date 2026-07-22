# Intro

Twoim zadaniem jako agenta AI jest spiąć produkty sklepów i Test Store w RevenueCat.

CEL: RC widzi 9 produktów, każdy daje entitlement `pro`, lifetime jest Non-Consumable.

# Task

1. Użyj produktów utworzonych w krokach `06_apple-products.md` i `07_google-products.md`.

   Podawaj mi konkretne Product ID ustalone wcześniej w tej rozmowie. Nie wracaj do `docs/IDEA.md` tylko po to, żeby ponownie odczytać prefix.

2. Poproś mnie, żebym wszedł w **Product catalog → Products → Import** i zaimportował:
   - iOS: Apple monthly Product ID, Apple yearly Product ID, Apple lifetime Product ID z kroku 06
   - Google: Google subscription Product ID z base plan `monthly`, Google subscription Product ID z base plan `annual`, Google lifetime Product ID z kroku 06 (Non-consumable)

3. Poproś mnie, żebym wszedł w entitlement `pro`, kliknął przycisk `Attach` i dodał wszystkie produkty:
   - 3 Google
   - 3 iOS
   Mam zaznaczyc wszystkie i kliknąć `Attach`.

4. Poproś mnie o potwierdzenie: 9 produktów (3 testowe), wszystkie attached do `pro`, wszystkie lifetime są Non-Consumable.
5. Po potwierdzeniu powiedz mi, że kolejny krok to `09_revenuecat-offering.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/09_revenuecat-offering.md`.

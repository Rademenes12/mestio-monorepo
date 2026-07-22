# Intro

Twoim zadaniem jako agenta AI jest przeprowadzić mnie przez produkty Google Play.

CEL: W Google Play istnieje subskrypcja `pro` z 2 base plans i lifetime one-time product.

# Task

1. Użyj Product ID ustalonych w poprzednim kroku `06_apple-products.md`.

   Dla Google Play używamy:
   - Subscription Product ID: Google subscription Product ID ustalone w kroku 06
   - Lifetime Product ID: Google lifetime Product ID ustalone w kroku 06

   Base plan ID zostają krótkie: `monthly` i `annual`, bo są unikalne tylko wewnątrz jednej subskrypcji. Podawaj mi konkretne Product ID do wklejenia, nie placeholdery ani nazwy zmiennych.

2. Poproś mnie, żebym wszedł w **Play Console → Monetize with Play → Products → Subscriptions → Create subscription** i utworzył subskrypcję:
   - Product ID: Google subscription Product ID ustalone w kroku 06
   - Name: `Pro`
   - Benefits: `Unlimited access`, `All Pro features`, `Priority updates`

3. Poproś mnie, żebym dodał base plan monthly:
   - Base plan ID: `monthly`
   - Type: Auto-renewing
   - Billing period: 1 month (P1M)
   - Availability: All countries and regions
   - Price: USD, `$9.99`
   - **Activate**

4. Poproś mnie, żebym dodał base plan annual:
   - Base plan ID: `annual`
   - Type: Auto-renewing
   - Billing period: 1 year (P1Y)
   - Availability: All countries and regions
   - Price: USD, `$39.99`
   - **Activate**

5. Poproś mnie, żebym utworzył lifetime w **Products → One-time products → Create one-time product**:
   - Product ID: Google lifetime Product ID ustalone w kroku 06
   - Name: `Pro Lifetime`
   - Description (required): `Full access to all Pro features forever.`
   - Age rating: All ages
   - Purchase option ID: `buy`
   - Purchase option: Buy
   - Availability: All countries and regions
   - Price: USD, `$99.99`
   - **Activate**

6. Poproś mnie, żebym uzupełnił **Monitor and improve → Policy and programs → App content → Actioned → Data safety → Manage → Next → Next → Financial info → Purchase history → Next**:
   - Collected: Yes
   - Shared: No
   - Processed ephemerally: No
   - Purpose: Analytics / Fraud prevention / Account management
   - Required: Data collection is required

## FINISH

Gdy skończę, powiedz mi, że kolejny krok to `08_revenuecat-products.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/08_revenuecat-products.md`.

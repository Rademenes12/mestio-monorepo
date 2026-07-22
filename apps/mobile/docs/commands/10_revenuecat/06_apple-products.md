# Intro

Twoim zadaniem jako agenta AI jest przeprowadzić mnie przez produkty Apple.

CEL: W App Store Connect istnieją 2 subskrypcje i 1 lifetime IAP.

# Task

1. Otwórz `docs/IDEA.md` i odczytaj `SUPABASE_TABLE_PREFIX`.

   Użyj `SUPABASE_TABLE_PREFIX` jako prefixu Product ID dla produktów sklepowych. Nie używaj generycznych Product ID typu `pro_monthly`, `pro_yearly`, `pro_lifetime`, bo Apple może odrzucić Product ID użyte już w innej aplikacji na koncie.

   Na podstawie `SUPABASE_TABLE_PREFIX` ustal i zapamiętaj na resztę etapu `10_revenuecat`:
   - Apple monthly Product ID: `<SUPABASE_TABLE_PREFIX>pro_monthly`
   - Apple yearly Product ID: `<SUPABASE_TABLE_PREFIX>pro_yearly`
   - Apple lifetime Product ID: `<SUPABASE_TABLE_PREFIX>pro_lifetime`
   - Google subscription Product ID: `<SUPABASE_TABLE_PREFIX>pro`
   - Google monthly base plan ID: `monthly`
   - Google annual base plan ID: `annual`
   - Google lifetime Product ID: `<SUPABASE_TABLE_PREFIX>pro_lifetime`

   Przykład dla `SUPABASE_TABLE_PREFIX` = `nazwaapki_`:
   - Apple monthly Product ID: `nazwaapki_pro_monthly`
   - Apple yearly Product ID: `nazwaapki_pro_yearly`
   - Apple lifetime Product ID: `nazwaapki_pro_lifetime`
   - Google subscription Product ID: `nazwaapki_pro`
   - Google lifetime Product ID: `nazwaapki_pro_lifetime`

   Zweryfikuj, że najdłuższy Product ID mieści się w limicie Google Play 40 znaków, bo te same ID lifetime będziemy później używać też po stronie Google.

2. Poproś mnie, żebym wszedł w **App Store Connect → Apps → app → Monetization → Subscriptions → Create Subscription Group** i utworzył grupę:
   - Reference Name: `Pro`
   - Localization: English (U.S.)
   - Localization Display Name: `Pro`

3. Poproś mnie, żebym w grupie `Pro` utworzył monthly:
   - Reference Name: `Pro Monthly`
   - Product ID: Apple monthly Product ID ustalone w punkcie 1
   - Duration: 1 Month
   - Availability: All countries and regions
   - Subscription Price: United States (USD), `$9.99`
   - Localization: English (U.S.)
   - Display Name: `Monthly Pro`
   - Description: `Full access to all Pro features, billed monthly.`
   - Review Notes: `This subscription unlocks all Pro features. Users can subscribe from the profile screen.`

4. Poproś mnie, żebym w tej samej grupie utworzył yearly:
   - Reference Name: `Pro Yearly`
   - Product ID: Apple yearly Product ID ustalone w punkcie 1
   - Duration: 1 Year
   - Availability: All countries and regions
   - Subscription Price: United States (USD), `$39.99`
   - Localization: English (U.S.)
   - Display Name: `Yearly Pro`
   - Description: `Full access to all Pro features, billed annually.`
   - Review Notes: `This subscription unlocks all Pro features. Users can subscribe from the profile screen.`

5. Poproś mnie, żebym w **Monetization → In-App Purchases → + → Non-Consumable** utworzył lifetime:
   - Reference Name: `Pro Lifetime`
   - Product ID: Apple lifetime Product ID ustalone w punkcie 1
   - Availability: All countries and regions
   - Price: United States (USD), `$99.99`
   - Localization: English (U.S.)
   - Display Name: `Lifetime Pro`
   - Description: `Full access to all Pro features forever.`
   - Review Notes: `This is a one-time purchase that unlocks all Pro features permanently.`

## FINISH

Gdy skończę, powiedz mi, że kolejny krok to `07_google-products.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/07_google-products.md`.

# Intro

Twoim zadaniem jako agenta AI jest zweryfikować offering RevenueCat.

CEL: Offering `default` jest Current i ma 3 packages z produktami iOS/Google/Test Store.

# Task

1. Użyj produktów utworzonych w krokach `06_apple-products.md` i `07_google-products.md`.

   Podawaj mi konkretne Product ID ustalone wcześniej w tej rozmowie. Nie wracaj do `docs/IDEA.md` tylko po to, żeby ponownie odczytać prefix.

2. Poproś mnie, żebym wszedł w **Product catalog → Offerings** i sprawdził, czy istnieje offering `default`.

3. Jeśli nie istnieje, poproś mnie, żebym utworzył **New offering → Identifier `default`**.

4. Poproś mnie, żebym wszedł w offering `default`, kliknął **Edit** i w zakładce **Packages** ustawił produkty w dropdownach:
   - `$rc_monthly` → Test Store `Monthly (monthly)` + App Store `Pro Monthly` z Apple monthly Product ID + Play Store Google subscription Product ID z base plan `monthly`
   - `$rc_annual` → Test Store `Yearly (yearly)` + App Store `Pro Yearly` z Apple yearly Product ID + Play Store Google subscription Product ID z base plan `annual`
   - `$rc_lifetime` → Test Store `Lifetime (lifetime)` + App Store `Pro Lifetime` z Apple lifetime Product ID + Play Store Google lifetime Product ID

5. Poproś mnie, żebym kliknął **Save**.
6. Po potwierdzeniu powiedz mi, że kolejny krok to `10_revenuecat-paywall.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/10_revenuecat-paywall.md`.

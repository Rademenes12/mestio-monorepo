# Etap `10_revenuecat`

## Stan workflow

Gdy zaczynasz ten etap, przeczytaj `STATE.md` i zaktualizuj go tak, aby wskazywał:
- `Aktualny etap`: `revenuecat`
- status etapu `revenuecat`: `🟡 in-progress`

Aplikacja ma już zaimplementowane główne funkcje MVP i jest opublikowana na sklepy Google Play i App Store. Ma już zaplanowane limity, paywall i funkcje Pro, których nie można jeszcze kupić (mamy paywall placeholder). 

Zakupy nie są jeszcze spięte produkcyjnie. W tym etapie skonfigurujemy RevenueCat i produkty sklepowe.

Będziesz zaraz przechodził przez kolejne kroki po kolei.

# Konwencja Product ID

Produkty sklepowe w App Store Connect i Google Play nie mogą używać generycznych Product ID typu `pro_monthly`, `pro_yearly`, `pro_lifetime`.

Na potrzeby Product ID używaj `SUPABASE_TABLE_PREFIX` z `docs/IDEA.md` jako prefixu produktów sklepowych.

Przykład:
- `SUPABASE_TABLE_PREFIX`: `nazwaapki_`
- Apple Product IDs: `nazwaapki_pro_monthly`, `nazwaapki_pro_yearly`, `nazwaapki_pro_lifetime`
- Google Product IDs: `nazwaapki_pro`, `nazwaapki_pro_lifetime`
- Google base plan IDs: `monthly`, `annual`

Product ID ustal raz przy tworzeniu produktów Apple w kroku `06_apple-products.md`, zapamiętaj w kontekście tej rozmowy i używaj tych samych wartości w kolejnych krokach etapu `10_revenuecat`. Nie odczytuj `docs/IDEA.md` ponownie w każdym kroku tylko po to, żeby odzyskać ten sam prefix.

# Kroki tego etapu

1. `01_apple-prereqs.md` - Sprawdzimy wymagania Apple.
2. `02_google-prereqs.md` - Sprawdzimy wymagania Google.
3. `03_revenuecat-project.md` - Utworzymy projekt RevenueCat.
4. `04_revenuecat-ios-config.md` - Dodamy konfigurację iOS.
5. `05_revenuecat-android-config.md` - Dodamy konfigurację Androida.
6. `06_apple-products.md` - Utworzymy produkty Apple.
7. `07_google-products.md` - Utworzymy produkty Google.
8. `08_revenuecat-products.md` - Podepniemy produkty w RevenueCat.
9. `09_revenuecat-offering.md` - Skonfigurujemy offering.
10. `10_revenuecat-paywall.md` - Skonfigurujemy paywall RevenueCat.
11. `11_api-keys.md` - Uzupełnimy klucze RevenueCat.
12. `12_debug-verify.md` - Sprawdzimy zakupy w debug.
13. `13_test-scenarios.md` - Przetestujemy scenariusze zakupowe.
14. `14_codemagic-keys.md` - Uzupełnimy klucze w Codemagic.
15. `15_codemagic-build.md` - Wypchniemy zmiany i uruchomimy build w Codemagic.
16. `16_app-store-submit-products.md` - Podepniemy produkty Apple do wersji.

# Start

Wykonaj polecenie z pliku `docs/commands/10_revenuecat/01_apple-prereqs.md`.

Nie przechodź sam do kolejnych kroków bez mojego polecenia.

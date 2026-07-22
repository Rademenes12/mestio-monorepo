# Intro

Twoim zadaniem jako agenta AI jest utworzyć paywall i uzupełnić screenshoty Apple.

CEL: Paywall jest Published, a 3 produkty Apple mają App Review Screenshot.

# Task

1. Przeczytaj `docs/PAYWALL.md`. Jeśli plik nie istnieje, zatrzymaj się i poproś mnie o utworzenie copy paywalla przed konfiguracją RevenueCat.

2. Użyj Apple Product ID utworzonych w kroku `06_apple-products.md`. Nie wracaj do `docs/IDEA.md` tylko po to, żeby ponownie odczytać prefix.

3. Wyciągnij z `docs/PAYWALL.md` angielskie copy do RevenueCat:
   - headline
   - 4-6 benefitów z title + subtitle
   - CTA dla Pro

4. Poproś mnie, żebym wszedł w **RC → Paywalls → New paywall** i utworzył paywall. Template dowolny. Settings:
   - Offering: `default`
   - Name: `<AppName> Paywall`

5. Podaj mi konkretne teksty z `docs/PAYWALL.md` do wklejenia w edytorze paywalla:
   - headline
   - benefit titles
   - benefit subtitles
   - CTA

6. Poproś mnie, żebym ustawił kolory/obrazki i dopilnował widocznych elementów:
   - Terms of Use
   - Privacy Policy
   - auto-renewal info dla subskrypcji

7. Poproś mnie, żebym kliknął **Publish Paywall**. Podkreśl: samo Save/Draft nie wystarczy.

8. Poproś mnie, żebym wygenerował screenshot z paywalla (**Paywall settings → Generate screenshot**, jeśli dostępne).

9. Poproś mnie, żebym wgrał screenshot w App Store Connect do:
   - Apple monthly Product ID z kroku 06
   - Apple yearly Product ID z kroku 06
   - Apple lifetime Product ID z kroku 06

10. Poproś mnie, żebym sprawdził w App Store Connect czy produkty nie mają missing metadata.

11. Poproś mnie o potwierdzenie: paywall Published, screenshoty w 3 produktach Apple, brak missing metadata.
12. Po potwierdzeniu powiedz mi, że kolejny krok to `11_api-keys.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/11_api-keys.md`.

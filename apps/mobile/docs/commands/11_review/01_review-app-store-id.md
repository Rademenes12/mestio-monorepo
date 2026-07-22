# Intro

Twoim zadaniem jako agenta AI jest uzyskać ode mnie App Store ID aplikacji.

CEL: Masz numeryczne Apple ID aplikacji z App Store Connect, gotowe do użycia w implementacji review.

# Task

1. Poproś mnie, żebym w App Store Connect wszedł w **Apps → moja aplikacja → App Information** i skopiował wartość **Apple ID**.

2. Wyjaśnij krótko, że chodzi o numeryczne App Store ID, a nie Bundle ID, SKU ani Apple Developer App ID.

3. Poproś mnie, żebym wkleił to ID w rozmowie. To nie jest sekret. W późniejszej implementacji zostanie wpisane jako app-specific stała w kodzie.

4. Gdy podam ID, sprawdź czy wygląda jak liczby bez liter i spacji. Jeśli nie, zatrzymaj się i poproś mnie o poprawne Apple ID.

5. Zapamiętaj tę wartość w rozmowie jako numeryczne Apple ID aplikacji dla kolejnych kroków.

6. Poproś mnie o potwierdzenie: numeryczne Apple ID przyjęte.
7. Po potwierdzeniu powiedz mi, że kolejny krok to `02_review-positive-actions.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/11_review/02_review-positive-actions.md`.

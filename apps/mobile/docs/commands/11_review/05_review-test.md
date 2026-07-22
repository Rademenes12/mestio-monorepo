# Intro

Twoim zadaniem jako agenta AI jest powiedzieć mi, jak przetestować in-app review.

CEL: Wiem, jak sprawdzić implementację mimo limitów Apple/Google.

# Task

1. Przeczytaj implementację review w kodzie.

2. Przedstaw mi konkretną instrukcję testową dla tej aplikacji:
   - jaką akcję mam wykonać
   - ile razy mam ją wykonać, jeśli jest licznik
   - że w debug mode powinien pokazać się debug alert
   - że w release/profile debug alert nie ma się pokazać
   - gdzie sprawdzić, że tracking zadziałał, jeśli prompt się nie pokaże

3. Wyjaśnij krótko ograniczenia:
   - debug alert sprawdza tylko naszą logikę, nie natywny prompt Apple/Google
   - `requestReview()` może nic nie pokazać mimo poprawnego wywołania
   - iOS i Android mają własne limity
   - TestFlight/debug może zachowywać się inaczej niż produkcja
   - Google Play review najlepiej testować z buildem z tracka testowego

4. Podaj jak przetestować dwa oddzielne flow:
   - positive action → `ReviewPresenter.maybeRequestReview(...)` → debug placeholder albo natywny prompt
   - Profil → `Rate this app` / `Oceń aplikację` → `ReviewPresenter.openStoreListing()`

5. Podaj jak przetestować pozostałe akcje w Profilu:
   - `Send feedback` / `Wyślij opinię`

6. Nie proponuj testowania przez pre-prompt ani ręczne wymuszanie natywnego dialogu w produkcyjnym kodzie.

7. Uruchom `git status` i poinformuj mnie, czy repo jest czyste.

8. Powiedz mi, że kolejny krok to `06_review-finish.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/11_review/06_review-finish.md`.

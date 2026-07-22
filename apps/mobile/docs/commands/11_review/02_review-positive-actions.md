# Intro

Twoim zadaniem jako agenta AI jest wybrać najlepsze momenty na prośbę o review w tej konkretnej aplikacji.

CEL: Wiadomo, które pozytywne akcje mają wywoływać `ReviewPresenter.maybeRequestReview(...)`.

# Task

1. Przeczytaj `docs/skills/flutter_in_app_review_skill.md`, ale użyj go tylko do zasad App Store / Google Play i anty-patternów.

2. Przeczytaj `docs/IDEA.md`.

3. Przejrzyj kod aplikacji i znajdź realne akcje sukcesu:
   - utworzenie albo zapisanie głównej encji
   - ukończenie ważnego zadania
   - odblokowanie lub użycie wartościowej funkcji
   - powrót do aplikacji po kilku udanych użyciach

4. Nie wybieraj momentów negatywnych ani neutralnych:
   - pierwszy start
   - onboarding
   - błąd
   - anulowany zakup
   - ekran płatności
   - zwykłe otwarcie ekranu

5. Nie proponuj pre-promptu typu `Czy podoba Ci się aplikacja?`.

6. Przedstaw mi krótką propozycję:
   - 1-3 wybrane positive actions
   - konkretne pliki/miejsca w kodzie, gdzie warto podpiąć tracking
   - krótki powód dla każdego miejsca
   - warunki bezpieczeństwa, np. tylko po sukcesie i nie po retry błędu

7. Poproś mnie o akceptację albo korektę listy positive actions.
8. Gdy zaakceptuję propozycję, powiedz mi, że kolejny krok to `03_review-implement.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/11_review/03_review-implement.md`.

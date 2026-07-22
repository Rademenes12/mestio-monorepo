# Intro

Twoim zadaniem jako agenta AI jest podpiąć gotowy mechanizm in-app review.

CEL: Aplikacja używa istniejącego `ReviewPresenter`, ma wpisane Apple ID i review jest podpięte pod zaakceptowane positive actions.

# Task

1. Upewnij się, że masz numeryczne Apple ID aplikacji z rozmowy. Jeśli go nie masz, zatrzymaj się i poproś mnie o numeryczne Apple ID z App Store Connect.

2. Przeczytaj:
   - `docs/skills/flutter_in_app_review_skill.md`
   - `lib/app/review/presentation/review_presenter.dart`
   - `lib/app/review/config/review_config.dart`

3. Nie implementuj review od zera. Ten template ma już gotowe:
   - `ReviewPresenter`
   - debug placeholder dla review

4. Wpisz numeryczne Apple ID w `ReviewConfig.appStoreId`. To nie jest sekret i nie trafia do `.env`.

5. Podepnij `ReviewPresenter.maybeRequestReview(...)` tylko w zaakceptowanych positive actions z poprzedniego kroku:
   - tylko po udanym zakończeniu akcji
   - nigdy przy błędzie
   - nigdy podczas onboardingu, paywalla ani aktywnego formularza
   - ustaw czytelny `triggerName`, np. `task_created`

6. Nie wywołuj bezpośrednio:
   - `InAppReview.instance`
   - `requestReview()`
   - `openStoreListing()`

   Z UI wolno używać tylko `ReviewPresenter`.

7. Dodaj w Profilu dwie niezależne akcje:
   - `Rate this app` / `Oceń aplikację` → `ReviewPresenter.openStoreListing()`
   - `Send feedback` / `Wyślij opinię` → istniejący kanał feedbacku albo prosty mailto/formularz

8. Wszystkie nowe teksty widoczne w UI dodaj do ARB i używaj przez `context.l10n`.

9. Jeśli projekt ma centralny handler błędów/crashy/płatności, podepnij tam `ReviewPresenter.markCriticalErrorOccurred()`. Jeśli nie ma, zostaw metodę gotową do użycia i napisz to w podsumowaniu.

10. Uruchom wymagane komendy:
   - `flutter gen-l10n`, jeśli zmieniłeś ARB
   - `dart run build_runner build -d`, jeśli zmieniłeś injectable/freezed
   - `flutter analyze`
   - testy jednostkowe zmienionych Cubitów, jeśli dotyczy

11. Napraw błędy, warningi i info.

12. Zrób commit.

13. Podsumuj:
   - gdzie wpisane jest Apple ID
   - które positive actions wywołują `ReviewPresenter.maybeRequestReview(...)`
   - gdzie są akcje w Profilu
   - czy `markCriticalErrorOccurred()` zostało gdzieś podpięte
   - jakie testy uruchomiłeś

## FINISH

Gdy skończysz, powiedz mi, że kolejny krok to `04_review-debug-mode.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/11_review/04_review-debug-mode.md`.

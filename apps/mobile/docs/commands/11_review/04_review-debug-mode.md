# Intro

Twoim zadaniem jako agenta AI jest sprawdzić debugowy podgląd in-app review.

CEL: W debug mode `ReviewPresenter` pokazuje kontrolowany placeholder, a poza debug mode używa natywnego `requestReview()`.

# Task

1. Przeczytaj:
   - `lib/app/review/presentation/review_presenter.dart`
   - miejsca, w których w poprzednim kroku podpiąłeś `ReviewPresenter.maybeRequestReview(...)`

2. Nie buduj nowego placeholdera i nie pokazuj dialogu bezpośrednio z ekranu. Debugowy placeholder ma przechodzić wyłącznie przez `ReviewPresenter`.

3. Sprawdź, że w `ReviewPresenter`:
   - jest warunek `kDebugMode`
   - w debug mode nie wywołuje prawdziwego `requestReview()`
   - w debug mode nie blokuje placeholdera przez natywne `isAvailable()`
   - w debug mode pokazuje prywatny dialog z `ReviewPresenter`
   - poza debug mode wywołuje prawdziwe `requestReview()`

4. Sprawdź, że placeholder nie pokazuje się po każdej akcji, tylko po spełnieniu warunków z `ReviewPresenter`.

5. Jeśli coś jest źle, popraw `ReviewPresenter`. Nie dodawaj obejścia w konkretnym ekranie.

6. Uruchom wymagane komendy:
   - `flutter gen-l10n`, jeśli zmieniłeś ARB
   - `dart run build_runner build -d`, jeśli zmieniłeś injectable/freezed
   - `flutter analyze`
   - testy jednostkowe zmienionych Cubitów, jeśli dotyczy

7. Napraw błędy, warningi i info.

8. Jeśli wprowadziłeś zmiany, zrób commit.

9. Podsumuj:
   - gdzie jest warunek `kDebugMode`
   - jaki dialog zobaczę w debug mode
   - dlaczego release nadal używa prawdziwego review promptu
   - jakie testy uruchomiłeś

## FINISH

Gdy skończysz, powiedz mi, że kolejny krok to `05_review-test.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/11_review/05_review-test.md`.

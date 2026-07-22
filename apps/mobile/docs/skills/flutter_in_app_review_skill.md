---
name: in-app-review-flutter
description: Policy and usage guide for native in-app review prompts and store review links in this Flutter template.
last-verified: 2026-05-08
target-platforms: ios, android
required-flutter-sdk: ">=3.0.0"
---

# In-App Review dla Fluttera

Ten skill opisuje zasady używania review promptu w aplikacjach budowanych na tym template.

Nie jest instrukcją implementacji nowej architektury. W tym template gotowy mechanizm jest w `ReviewPresenter`, a konkretne kroki podpięcia są w `docs/commands/11_review/`.

## Najważniejsza zasada

Nie pytamy użytkownika, czy lubi aplikację. Nie robimy pre-promptu. Nie dzielimy użytkowników na zadowolonych i niezadowolonych przed pokazaniem review.

Najpierw użytkownik musi dostać realną wartość z aplikacji. Dopiero wtedy aplikacja może poprosić system o pokazanie natywnego review promptu.

## Dwa różne flow

Są dwa osobne mechanizmy i nie wolno ich mieszać.

### Native in-app review prompt

To systemowy prompt App Store albo Google Play.

Używamy go po pozytywnej akcji użytkownika, bez osobnego przycisku. System może go pokazać albo zignorować. Aplikacja nie wie, czy prompt faktycznie został pokazany, czy użytkownik wystawił ocenę.

W tym template nie wywołujemy natywnego API bezpośrednio z ekranu. Zawsze przechodzimy przez `ReviewPresenter`.

### Rate this app w profilu

To jawna akcja użytkownika, która otwiera stronę aplikacji w sklepie.

Ten flow nadaje się do przycisku w profilu, ustawieniach albo podobnym miejscu. Nie podlega takiej samej kwocie jak natywny prompt, bo użytkownik sam poprosił o przejście do sklepu.

W profilu warto mieć też osobną akcję feedbacku. Feedback nie zastępuje review i nie może być bramką przed review.

## Co jest dobrą positive action

Dobra positive action to moment po zakończonej, wartościowej akcji. Przykłady:

- użytkownik zapisał ważną encję w aplikacji
- ukończył zadanie, lekcję, poziom albo proces
- dostał gotowy wynik przetwarzania, eksportu albo AI
- skutecznie użył głównej funkcji kilka razy
- wrócił do aplikacji po kilku udanych użyciach

Im bliżej realnie dostarczonej wartości, tym lepiej.

## Czego nie traktujemy jako positive action

Nie podpinamy review po akcjach neutralnych, technicznych albo ryzykownych:

- pierwszy start aplikacji
- onboarding
- logowanie albo utworzenie konta
- przyznanie uprawnień
- pokazanie paywalla
- zakup lub subskrypcja w trakcie przetwarzania
- anulowany zakup
- błąd, crash, retry albo odzyskiwanie po błędzie
- zwykłe otwarcie ekranu
- zamknięcie formularza feedbacku

Jeśli nie wiadomo, czy dany moment jest pozytywny, nie używamy go.

## Zasady App Store i Google Play

Wymagane:

- używaj natywnego mechanizmu review dla iOS i Androida
- proś o review oszczędnie
- wywołuj prompt po tym, jak użytkownik używał aplikacji wystarczająco długo
- nie przerywaj użytkownikowi aktywnego zadania
- zapisuj własne próby wywołania promptu, bo platformy nie mówią, czy prompt został pokazany
- dla stałego przycisku w profilu używaj przejścia do strony sklepu, nie natywnego promptu

Zakazane:

- custom dialog typu `Czy podoba Ci się aplikacja?`
- pytanie `Czy ocenisz aplikację na 5 gwiazdek?`
- review gating, czyli zadowolony użytkownik do sklepu, niezadowolony do feedbacku
- przycisk, który bezpośrednio wywołuje natywny prompt
- prompt na starcie aplikacji lub podczas onboardingu
- prompt po błędzie, nieudanej płatności, anulowaniu albo frustracji użytkownika
- nagrody, unlocki albo inne benefity za review
- modyfikowanie, przykrywanie albo automatyczne zamykanie karty Google Play review
- fallback do sklepu, gdy natywny prompt się nie pokaże

## Apple ID

Numeryczne Apple ID jest potrzebne do otwierania strony aplikacji w App Store.

To nie jest sekret. Można je znaleźć w App Store Connect w informacjach o aplikacji. Jest też częścią publicznego adresu App Store.

W tym template Apple ID trafia do konfiguracji review, nie do `.env`.

## Testowanie

Test review promptu nie daje pełnej gwarancji.

Na Androidzie natywny prompt wymaga aplikacji dostępnej przez Google Play i urządzenia z Play Store. Google może nie pokazać promptu przez kwoty albo stan konta testowego.

Na iOS zachowanie zależy od środowiska. Lokalny debug, TestFlight i produkcja mogą zachowywać się inaczej. Produkcyjny system sam decyduje, czy prompt pokaże.

Dlatego w tym template debug mode używa kontrolowanego placeholdera. Placeholder służy tylko do sprawdzenia logiki aplikacji: czy review byłoby wywołane w odpowiednim miejscu.

## Czego nie da się wiarygodnie zmierzyć

Nie zakładaj, że aplikacja wie:

- czy prompt był widoczny
- czy użytkownik kliknął gwiazdki
- czy wystawił ocenę
- jaką ocenę wystawił
- czy zamknął prompt

Można mierzyć tylko własne próby wywołania review i miejsca, z których te próby zostały uruchomione.

## Jak używać tego w template

W etapie `docs/commands/11_review/` agent powinien:

- wybrać 1-3 realne positive actions
- wpisać Apple ID w konfiguracji review
- podpiąć gotowy `ReviewPresenter`
- nie implementować review od zera
- nie wywoływać natywnego API bezpośrednio z UI
- dodać w profilu osobne akcje `Rate this app` i `Send feedback`
- zweryfikować debug placeholder przez `ReviewPresenter`

Jeśli aplikacja ma centralne miejsce obsługi krytycznych błędów, można tam oznaczyć, że review nie powinno pojawiać się zaraz po takim błędzie.

## Źródła

- Apple Developer Documentation: Requesting App Store reviews - https://developer.apple.com/documentation/storekit/requesting-app-store-reviews
- Apple Developer Documentation: StoreKit review request - https://developer.apple.com/documentation/storekit/skstorereviewcontroller/requestreview%28%29
- Android Developers: Google Play In-App Reviews API - https://developer.android.com/guide/playcore/in-app-review
- pub.dev: in_app_review - https://pub.dev/packages/in_app_review

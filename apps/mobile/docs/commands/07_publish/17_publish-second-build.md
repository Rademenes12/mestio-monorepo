# ZADANIE: 17_publish_second_build

## CEL
Uruchomienie kolejnego buildu w Codemagic:
- jeśli pierwszy Android publishing przeszedł na zielono — uruchamiamy **tylko iOS**,
- jeśli w kroku 16 trzeba było ręcznie wgrać pierwszy `.aab` — uruchamiamy **Android + iOS**, żeby potwierdzić automatyczny Google Play publishing i wysłać iOS na TestFlight.

## KROKI DO WYKONANIA:

1. Powiedz mi, żebym teraz w Codemagic i ustawił platformy według wyniku z kroku 16:
   - Jeśli **Android publishing był zielony** → zaznacz **tylko iOS** (odznacz Android).
   - Jeśli **trzeba było ręcznie wgrać pierwszy `.aab`** → zaznacz **Android** i **iOS**.
   - Kliknij **Save changes**.

2. Powiedz mi, żebym uruchomił build:
   - Kliknij **Start new build** (prawy górny róg).
   - W oknie dialogowym:
     - **Select Branch**: domyślny (na 99% `main`).
     - **Select Workflow**: Default Workflow.
     - **Zostaw odznaczony** Enable SSH/VNC access.
   - Kliknij **Start new build**.

3. Poinformuj mnie o tym, co się teraz wydarzy:
   - Build iOS potrwa około **15–20 minut**; Android + iOS może potrwać około **20 minut**.
   - **iOS** pójdzie pierwszy raz na **TestFlight** (build pojawi się w App Store Connect → TestFlight po kilku minutach od zakończenia builda, po przetworzeniu przez Apple).
   - Jeśli uruchamiamy też Androida, Google Play publishing powinien teraz przejść na zielono.

4. Powiedz mi, że gdy wybrany build będzie zielony i publishing się powiedzie, mam napisać `next`, bo będziemy przechodzić do `18_publish-screenshots.md`. Jeśli build albo publishing się wywali — zaleć, abym napisał o tym do Ciebie (do agenta ai), wkleił logi błędu z Codemagic, żebyś pomógł zdiagnozować problem i go rozwiązać, zanim pójdziemy dalej.

**Nic nie commituj w tym kroku** — to instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/18_publish-screenshots.md`.

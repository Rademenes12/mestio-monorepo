# ZADANIE: 15_publish_first_build

## CEL
Uruchomienie **pierwszego buildu Android** w Codemagic z dashboardu. iOS zbudujemy osobno później — najpierw sprawdzamy, czy Google Play publishing przejdzie automatem.

## KROKI DO WYKONANIA:

1. Powiedz mi, żebym w Codemagic ustawił platformy na **tylko Android**:
   - Otworzył aplikację utworzoną w kroku `08_publish-codemagic.md`.
   - W sekcji **Build for platforms** zaznaczył **tylko Android** (odznacz iOS, jeśli jest zaznaczone).
   - Kliknął **Save changes**.

2. Powiedz mi, żebym uruchomił build:
   - W widoku aplikacji kliknij **Start your first build** (niebieski przycisk).
   - W oknie dialogowym:
     - **Select Branch**: domyślny (na 99% `main`).
     - **Select Workflow**: Default Workflow.
     - **Zostaw odznaczony** Enable SSH/VNC access.
   - Kliknij **Start new build**.

3. Poinformuj mnie o tym, co się teraz wydarzy:
   - Build Android potrwa około **10–15 minut**.
   - Poczekaj na wynik całego buildu, razem z sekcją **Publishing**.
   - Jeśli **Google Play publishing przejdzie na zielono**, ręczny upload `.aab` nie będzie potrzebny.
   - Jeśli **Google Play publishing będzie czerwony**, w kolejnym kroku sprawdzimy, czy trzeba wgrać pierwszy `.aab` ręcznie.

4. Powiedz mi, że gdy build się skończy, mam napisać `next` i podać wynik:
   - `Android publishing zielony`
   - albo `Android publishing czerwony`

**Nic nie commituj w tym kroku** — to instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/16_publish-googleplay-first-aab.md`.

# ZADANIE: 16_publish_googleplay_first_aab

## CEL
Decyzja po pierwszym Android buildzie:
- jeśli Google Play publishing przeszedł na zielono — nic nie wgrywamy ręcznie,
- jeśli Google Play publishing padł przez pierwszy upload/draft app — ręcznie wgrywamy pierwszy `.aab` do Google Play Console.

## KONTEKST
Codemagic nadal dokumentuje scenariusz, w którym pierwszy `.aab` trzeba wgrać ręcznie, ale w praktyce Google Play publishing może już przejść automatem. Dlatego ten krok jest warunkowy.

## KROKI DO WYKONANIA:

1. Zapytaj mnie o wynik kroku 15:
   - Czy **Google Play publishing** w Codemagic jest zielony?
   - Czy **Google Play publishing** w Codemagic jest czerwony?

2. **Wybierz jedną ścieżkę:**

   **Ścieżka A — Google Play publishing jest zielony**
   - Powiedz mi, że ręczny upload `.aab` nie jest potrzebny.
   - Powiedz mi, żebym napisał `next`, bo w kroku 17 uruchomimy już tylko iOS build.
   - Zakończ ten krok. Nie wykonuj ścieżki B.

   **Ścieżka B — Google Play publishing jest czerwony**
   - Przejdź do ręcznego uploadu poniżej.
   - Powiedz mi, żebym pobrał artefakt:
     - W [Codemagic](https://codemagic.io/) otwórz ostatni build tej apki.
     - W sekcji **Artifacts** pobierz plik **`app-release.aab`**.
   - Powiedz mi, żebym wgrał `app-release.aab` do Google Play Console:
     - Otwórz [Google Play Console](https://play.google.com/console/) i wejdź w utworzoną aplikację.
     - Z lewego menu: **Test and release** → **Testing** → **Closed testing**.
     - Na liście **Active tracks** powinna być gotowa ścieżka **`Closed testing - Alpha`** (utworzona wcześniej przez Codemagic przy Google Play publishingu). Kliknij przy niej **Manage track**.
     - Kliknij **Create new release** (prawy górny róg albo link na środku).
     - W sekcji **App bundles** przeciągnij plik `app-release.aab` w obszar **Drop app bundles here to upload** (albo **Upload**).
     - Po przetworzeniu (kilka minut) **Release name** i **Release notes** uzupełnią się automatycznie — zostaw tak.
     - Kliknij **Next** w prawym dolnym rogu.
   - Powiedz mi, że:
     - Google Play pokaże listę błędów walidacyjnych (zwykle **5 errors** lub podobnie) — **to jest OK**. Jedynym celem tego kroku jest, żeby `.aab` został zaciągnięty przez Google Play jako pierwsza wersja aplikacji.
     - **Zostaw release jako draft** (nie klikaj **Publish** / **Send for review**). Zamknij tę stronę.
     - Od tego momentu service account z kroku 12 będzie mógł wrzucać kolejne buildy automatem na ścieżkę `alpha`.
   - Powiedz mi, że gdy sprawa Androida jest załatwiona, mam napisać `next`, bo będziemy przechodzić do `17_publish-second-build.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelach zewnętrznych.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/17_publish-second-build.md`.

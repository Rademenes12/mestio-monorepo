# ZADANIE: 11_publish_codemagic_android_signing

## CEL
Włączenie i skonfigurowanie **Android code signing** w Codemagic za pomocą keystore wygenerowanego w etapie `00_init`.

## WYMAGANIA WSTĘPNE
User musi mieć już:
- plik `android/key.properties` (tworzony w kroku `docs/commands/00_init/09_init-android-key-properties.md`),
- plik `upload-keystore.p12` wygenerowany w kroku `docs/commands/00_init/10_init-upload-keystore-create.md` i umieszczony w ścieżce z kroku `11_init-upload-keystore-path.md`.

Jeśli któregoś z tych elementów nie ma, zatrzymaj się i poinformuj mnie, że najpierw muszę wrócić do etapu `00_init` i dokończyć tamte kroki.

## KROKI DO WYKONANIA:

1. Odczytaj z `android/key.properties` **tylko dwa pola**:
   - `storeFile` (ścieżka do pliku `.p12`),
   - `keyAlias` (powinno być `upload`).

   **NIE czytaj, nie wyświetlaj i nie cytuj** `storePassword` ani `keyPassword` — hasła nigdy nie mogą pojawić się w tym chacie.

2. Powiedz mi, żebym w Codemagic włączył Android signing:
   - Wejdź na [https://codemagic.io/apps](https://codemagic.io/apps), znajdź aplikację utworzoną w kroku `08_publish-codemagic.md` i kliknij przycisk **Finish build setup**.
   - Przejdź do **Distribution** → **Android code signing** → zaznacz **Enable Android code signing**.
   - W formularzu wypełnij:
     - **Upload keystore file**: wgraj plik z podanej ścieżki: **`<storeFile>`** *(wartość odczytana z pliku)*.
     - **Keystore password**: otwórz lokalnie plik `android/key.properties` i skopiuj stamtąd wartość `storePassword`. Wklej do tego pola.
     - **Key alias**: **`<keyAlias>`** *(wartość odczytana z pliku, powinno być `upload`)*.
     - **Key password**: otwórz lokalnie plik `android/key.properties` i skopiuj stamtąd wartość `keyPassword`. Wklej do tego pola.
   - Kliknij **Save changes**.

3. Powiedz mi, że gdy skończę konfigurację Android signing w Codemagic, mam napisać `next`, bo będziemy przechodzić do `12_publish-codemagic-google-play.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/12_publish-codemagic-google-play.md`.

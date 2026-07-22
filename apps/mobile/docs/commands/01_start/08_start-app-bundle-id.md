# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Ustawić App Bundle ID dla iOS i Android

# Task

Masz osiągnąć 3 rzeczy:

1. `iOS Bundle Identifier` ma mieć nową wartość.
2. `Android applicationId` i `namespace` mają mieć tę samą nową wartość.
3. Struktura folderów i package name na Androidzie mają zgadzać się z nowym identyfikatorem.

## Zasady

- Ustaw ten sam identyfikator logiczny na `iOS` i `Android`.
- Nie zostawiaj `com.example...`.
- Na Androidzie nie zmieniaj tylko `applicationId`. Zmień też `namespace`, `package` i ścieżkę pliku `MainActivity`.

## Krok 1. Pobierz nowy identyfikator

- Upewnij się, że w pliku `docs/IDEA.md` jest zdefiniowany unikalny identyfikator aplikacji, a nie jakiś generyczny typu `com.imienazwisko.appname`.
- Musi posiadać realne imię i nazwisko autora oraz nazwę aplikacji zapisaną w formacie: wszystko z małych liter [a-z], żadnych cyf, żadnych znaków specjalnych, brak polskich znaków.

## Krok 2. Zmień Android `namespace` i `applicationId`

- Otwórz:
  - [build.gradle.kts](/android/app/build.gradle.kts)

- Zmień:
  - `namespace`
  - `applicationId`

- Obie wartości ustaw na ten sam nowy identyfikator.

## Krok 3. Zmień Android package name w `MainActivity`

- Otwórz:
  - `android/app/src/main/kotlin/.../MainActivity.kt`

- Zmień linię:
  - `package ...`

- Ustaw ją na nowy identyfikator, np.:
  - `package com.imienazwisko.nazwaaplikacji`

## Krok 4. Przenieś `MainActivity.kt` do właściwego folderu

- Ścieżka pliku musi odpowiadać package name.
- Jeśli nowy identyfikator to:
  - `com.imienazwisko.nazwaaplikacji`

- To plik ma finalnie być tutaj:
  - `android/app/src/main/kotlin/com/imienazwisko/nazwaaplikacji/MainActivity.kt`

- Jeśli stary folder nadal istnieje, usuń go, jeśli jest pusty.

## Krok 5. Zmień `iOS Bundle Identifier`

- Otwórz:
  - [project.pbxproj](/ios/Runner.xcodeproj/project.pbxproj)

- Znajdź wszystkie:
  - `PRODUCT_BUNDLE_IDENTIFIER = ...;`

- Zmień identyfikator aplikacji `Runner` na nową wartość.
- Zmień też identyfikator testów `RunnerTests`, żeby był spójny, np.:
  - `com.imienazwisko.nazwaaplikacji.RunnerTests`

## Krok 6. Zweryfikuj, że starego identyfikatora już nie ma

- Wyszukaj w repo stare wartości, np.:
  - `com.example.twelveappstemplate`
  - poprzedni custom bundle id

- Nie zostawiaj starych wartości w:
  - `android/app/build.gradle.kts`
  - `android/app/src/main/kotlin/...`
  - `ios/Runner.xcodeproj/project.pbxproj`

## Krok 7. Uruchom walidację Fluttera

- Uruchom:
  - `flutter analyze`

- Jeśli coś nie przechodzi, napraw to.

## Krok 8. Sprawdź `git diff`

- Upewnij się, że zmieniły się tylko właściwe pliki:
  - `android/app/build.gradle.kts`
  - `android/app/src/main/kotlin/.../MainActivity.kt`
  - `ios/Runner.xcodeproj/project.pbxproj`

- Jeśli pojawiły się niepowiązane zmiany, nie commituj ich razem. Poinformuj mnie o nich i zaproponuj oddzielny commit.

## Krok 9. Zakończ pracę

- Zrób commit z jasnym opisem zmian, np.:
  - `build: update mobile app identifiers`

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `09_start-app-name.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/01_start/09_start-app-name.md`.

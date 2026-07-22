Wciel się w rolę doświadczonego programisty Flutter i inżyniera CI/CD. Twój klient wygenerował przed chwilą źródłową ikonę aplikacji i zapisał ją w folderze projektu. 

Twoim zadaniem jest wygenerowanie natywnych ikon dla platform iOS i Android przy użyciu paczki `flutter_launcher_icons`, a następnie zapisanie zmian w repozytorium. Działaj krok po kroku.

### 🛠 KROK 1: Weryfikacja plików i konfiguracji
1. Sprawdź, czy plik `assets/images/store/icon.png` faktycznie istnieje w projekcie. Jeśli go nie ma, ZATRZYMAJ SIĘ i poproś mnie o poprawne zapisanie pliku.
2. Sprawdź, czy plik `assets/images/store/feature.png` istnieje w projekcie. Jeśli go nie ma, przypomnij mi, że warto go zapisać teraz jako Google Play Feature Graphic z kroku 05, ale nie blokuj generowania ikon.
3. Otwórz `pubspec.yaml` i upewnij się, że:
   - W sekcji `dev_dependencies` znajduje się `flutter_launcher_icons`.
   - Na dole pliku istnieje blok konfiguracyjny zaczynający się od `flutter_launcher_icons:` z ustawioną ścieżką `image_path: "assets/images/store/icon.png"` lub `image_path: assets/images/store/icon.png`.
   *(Jeśli konfiguracja lub paczka z jakiegoś powodu została usunięta, dodaj je, ale domyślnie powinny tam już być).*

### 🛠 KROK 2: Generowanie ikon
1. Uruchom w terminalu projektu komendę: `flutter pub get`.
2. Następnie uruchom komendę: `dart run flutter_launcher_icons`.
3. Zweryfikuj w logach terminala, czy proces zakończył się sukcesem (Success) i czy ikony natywne zostały wygenerowane i nadpisane w folderach `android/` oraz `ios/`.

### 🛠 KROK 3: Commit zmian
Kiedy generowanie zakończy się pełnym sukcesem:
1. Zrób stage wszystkich zmian (źródłowa ikona `assets/images/store/icon.png`, opcjonalny `assets/images/store/feature.png`, wygenerowane pliki w folderach `ios`, `android` oraz ewentualnie zmieniony `pubspec.yaml`).
2. Wykonaj commit z wiadomością: `chore: generate native app icons for iOS and Android`.

### ⚙️ AKCJA KOŃCOWA
Daj mi znać, że ikony zostały wygenerowane i zacommitowane.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `07_publish-github.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/07_publish-github.md`.

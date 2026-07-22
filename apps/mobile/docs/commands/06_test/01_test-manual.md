# ZADANIE: 01_test_manual

## CEL
Testuję gotową aplikację manualnie według najważniejszych scenariuszy przed publikacją.

## SCENARIUSZE TESTOWE

1. **Scenariusz 1: Rejestracja, Logowanie i LockScreen (Auth)**
   - Welcome Screen: Wybierz "Kontynuuj jako gość" -> Powinien otworzyć się LockScreen.
   - Welcome Screen: Wybierz "Zaloguj się na istniejące konto" -> Zaloguj się.
   - LockScreen: Wypełnij dane profilu (imię i nazwisko, telefon, rola, adres) i przejdź dalej. Spróbuj też zarejestrować się jako rola zarządzająca i podaj kod zaproszenia.
   - Profil -> Zabezpiecz konto: Ulepsz konto gościa do stałego konta email/hasło (brak podwójnego e-maila).
2. **Scenariusz 2: Mieszkaniec (Resident)**
   - Dodaj nowe zgłoszenie awarii (tytuł, opis, kategoria, opcjonalnie zdjęcie/PDF/GPS).
   - Zobacz listę swoich zgłoszeń i upewnij się, że ich status się aktualizuje.
3. **Scenariusz 3: Zarząd / Administrator (Management)**
   - Zobacz pulpit z wszystkimi zgłoszeniami na osiedlu.
   - Przypisz zgłoszenie do konkretnego serwisanta.
   - Zarządzaj osiedlem i kodami zaproszeń.
4. **Scenariusz 4: Serwisant (Technician)**
   - Otwórz portal serwisanta z listą przypisanych zadań.
   - Zmień status zgłoszenia (np. Nowe -> W toku -> Zamknięte).
5. **Scenariusz 5: Usuwanie konta (Account Deletion)**
   - Przejdź do Profilu -> Usuń konto.
   - Potwierdź chęć usunięcia (potwierdzenie hasłem lub checkboxem w przypadku gościa).
   - Upewnij się, że zostajesz przekierowany na Welcome Screen, a dane zostały usunięte z bazy.

## KROKI DO WYKONANIA:
1. Przedstaw mi scenariusze testowe z sekcji powyżej.
2. Poproś mnie, żebym przetestował scenariusze. To jest ostatni krok przed publikacją, więc jeśli nic nie poprawimy, ta wersja trafi jako pierwsza wersja do sklepów dla końcowych użytkowników aplikacji.
3. Poproś mnie też o test na fizycznym urządzeniu w trybie `Release`. Możesz polecić mi konkretną komendę zgodną z `.vscode/launch.json`: `flutter run --release --dart-define-from-file=config/api-keys.json`. Możesz też powiedzieć, że w VSCode w zakładce `Run and Debug` mogę wybierać `Debug mode` albo `Release mode`, ale `Release mode` może uruchamiać tylko na prawdziwym urządzeniu.
4. Podkreśl, żebym skupił się na sprawdzeniu jakości i stabilności obecnych funkcji. Na tym etapie raczej nie wymyślam nowych funkcji — nowe rzeczy można dodać później w aktualizacjach. Jeśli coś nie działa, mam dać znać co.
5. Gdy zgłoszę problem, napraw go w kodzie. Jeśli da się to sensownie pokryć szybkim testem jednostkowym, dodaj taki test. Nie twórz jeszcze testów integracyjnych — decyzja o nich padnie w kolejnym kroku.
6. Po poprawce uruchom `flutter analyze`, uruchom odpowiednie szybkie testy, napraw ewentualne problemy i zacommituj.
7. Poinformuj mnie, że powinno już działać i poproś mnie o ponowną weryfikację.
8. Gdy potwierdzę, że wszystko działa — powiedz mi, że kolejny krok to `02_test-integration-decision.md` i zasugeruj mi napisanie `next`.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/06_test/02_test-integration-decision.md`.

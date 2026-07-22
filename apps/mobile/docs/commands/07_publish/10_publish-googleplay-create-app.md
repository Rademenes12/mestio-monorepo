# ZADANIE: 10_publish_googleplay_create_app

## CEL
Utworzenie aplikacji w **Google Play Console** (bez wypełniania pól sklepowych — te zostawiamy na krok 22).

## KROKI DO WYKONANIA:

1. Przygotuj dane:
   - Otwórz `docs/IDEA.md` i znajdź **app bundle ID** (format `com.imienazwisko.nazwaapki`) — to będzie wartość pola **Nazwa pakietu** (**Package name**).
   - Otwórz `docs/PUBLISH.md` i znajdź Android **Nazwa aplikacji** z sekcji `### Teksty Android (Google Play)`.
   - Ta Android **Nazwa aplikacji** z `docs/PUBLISH.md` będzie wartością pola **Nazwa aplikacji** (**App name**) w Google Play Console.

2. Sprawdź w `docs/IDEA.md`, czy aplikacja jest grą czy zwykłą aplikacją:
   - Domyślnie to **Aplikacja** (**App**).
   - Jeśli `docs/IDEA.md` wyraźnie opisuje apkę jako grę — użyj **Gra** (**Game**).

3. Powiedz mi, że zanim utworzę aplikację, moje konto Google Play Console musi być w pełni zweryfikowane. Jeśli przycisk **Utwórz aplikację** (**Create app**) jest niedostępny, mam sprawdzić wymagane zadania w lewym menu, szczególnie **Weryfikacja dewelopera aplikacji na Androida**, oraz ewentualnie **Ustawienia → Konto dewelopera → Profil płatności** (**Settings → Developer account → Payments profile**).

4. Powiedz mi, żebym utworzył aplikację:
   - Zaloguj się na [Google Play Console](https://play.google.com/console/).
   - Na głównej stronie (lista aplikacji) kliknij **Utwórz aplikację** (**Create app**) w prawym górnym rogu.
   - W sekcji **Szczegóły aplikacji** (**App details**) wypełnij pola:
     - **Nazwa aplikacji** (**App name**): *(wartość Android **Nazwa aplikacji** z `docs/PUBLISH.md`)*
     - **Nazwa pakietu** (**Package name**): *(app bundle ID z `docs/IDEA.md`)*
     - **Język domyślny** (**Default language**): **angielski (Stany Zjednoczone) – en-US** (**English (United States)**)
     - **Aplikacja czy gra** (**App or game**): *(wartość ustalona w kroku 2)*
     - **Bezpłatna czy płatna** (**Free or paid**): **Bezpłatne** (**Free**)
   - W sekcji **Deklaracje** zaakceptuj:
     - **Zasady programu dla deweloperów** (**Developer Program Policies**)
     - **Przepisy eksportowe USA** (**US export laws**)
   - Kliknij **Utwórz aplikację** (**Create app**).
   - Po utworzeniu wylądujesz w dashboardzie apki.

5. Powiedz mi, że gdy skończę tworzenie aplikacji w Google Play Console, mam napisać `next`, bo będziemy przechodzić do `11_publish-codemagic-android-signing.md`.

**Nic nie commituj w tym kroku** — to czysta instrukcja w panelu zewnętrznym.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/11_publish-codemagic-android-signing.md`.

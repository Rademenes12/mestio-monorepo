# ZADANIE: 13_publish_codemagic_ios_signing

## CEL
Konfiguracja **iOS Code Signing** w Codemagic w trybie Automatic. Obejmuje dwie fazy:
- Faza A — dodanie **App Store Connect API Key** w Codemagic Settings (**globalne**, dla wszystkich apek),
- Faza B — włączenie **iOS code signing** w ustawieniach konkretnej apki (per-app).

Ten sam klucz z fazy A zostanie użyty również w kroku 14 (App Store Connect publishing).

## WAŻNE — RAZ vs KAŻDORAZOWO
Faza **A** jest **jednorazowa dla całego konta Codemagic**. Faza **B** musi być powtórzona dla każdej apki osobno.

Na początku zapytaj mnie:
> "Czy wcześniej dodałeś już App Store Connect API Key do integracji w Codemagic (Teams/Settings)?"

**Wybierz jedną ścieżkę:**
- **Tak, klucz już jest w Codemagic** — pomiń fazę A. Przejdź od razu do fazy B.
- **Nie, klucza jeszcze nie ma** — przeprowadź przez obie fazy.

---

## FAZA A — App Store Connect API Key w Codemagic Settings (jednorazowa)

1. Powiedz mi, że najpierw wygenerujemy klucz w App Store Connect:
   - Zaloguj się na [App Store Connect](https://appstoreconnect.apple.com/).
   - Przejdź do **Users and Access** → zakładka **Integrations** → sekcja **App Store Connect API** → **Team Keys**.
   - Jeśli pojawi się przycisk **Request Access** (pierwsze użycie na koncie), kliknij go i potwierdź wniosek o dostęp.
   - Kliknij **+** (plus), żeby wygenerować nowy klucz:
     - **Name**: `Codemagic Key`
     - **Access**: **App Manager**
   - Kliknij **Generate**.

2. Powiedz mi, że z tego panelu muszę skopiować i pobrać trzy rzeczy:
   - **Issuer ID** (widoczny u góry sekcji Keys) → skopiuj.
   - **Key ID** (ID świeżo utworzonego klucza) → skopiuj.
   - Plik **`.p8`** — kliknij **Download** przy kluczu. **Uwaga:** Apple pozwala pobrać ten plik **tylko raz**. Zapisz go w bezpiecznym lokalnym folderze (np. razem z keystore).

3. Powiedz mi, żebym dodał klucz do Codemagic:
   - W [Codemagic](https://codemagic.io/) otwórz **Teams/Settings** → **Integrations** → **Developer Portal** → kliknij **Connect**.
   - Wypełnij:
     - **Integration name**: np. `Codemagic Production Key` (dowolna).
     - **Issuer ID**: wklej skopiowaną wartość.
     - **Key ID**: wklej skopiowaną wartość.
     - **API key**: wgraj plik `.p8`.
   - Kliknij **Save**. Po chwili powinna pojawić się zielona kropka (status: connected).

---

## FAZA B — iOS Code Signing w ustawieniach apki (per-app)

Pola pojawiają się po kolei w miarę wypełniania formularza — prowadź mnie krok po kroku, w tej dokładnie kolejności:

1. Powiedz mi, żebym w Codemagic otworzył aplikację utworzoną w kroku `08_publish-codemagic.md` i przeszedł do **Distribution** → **iOS code signing**.

2. **Select code signing method** → zaznacz **Automatic** (nie ma osobnego "Enable iOS code signing" — wybór `Automatic` odblokowuje resztę formularza).

3. **App Store Connect API key (using keys from user settings)** → z dropdowna wybierz klucz dodany w fazie A (np. `Personal App Store Connect API key (Key: ...)` albo `Codemagic Production Key`).

4. **Provisioning profile type** → zaznacz **App store** (nie Development, nie Ad hoc).

5. **Bundle identifier** → domyślnie pokazuje **XC Wildcard** — **zmień to**. Z dropdowna wybierz bundle ID apki zarejestrowany w kroku `09_publish-appstoreconnect-create-app.md` (np. `com.imienazwisko.nazwaapki`).

6. Kliknij **Save changes**.

7. Powiedz mi, że gdy skończę konfigurację iOS signing, mam napisać `next`, bo będziemy przechodzić do `14_publish-codemagic-app-store-connect.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelach zewnętrznych.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/14_publish-codemagic-app-store-connect.md`.

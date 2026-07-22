# ZADANIE: 12_publish_codemagic_google_play

## CEL
Włączenie publishingu na Google Play z Codemagic — via service account. Obejmuje **cztery fazy**:
- Faza A — **Google Cloud Console** (projekt + API + service account + klucz JSON),
- Faza B — **Google Play Console: zaproszenie service accountu** (nadanie dostępu do konta developerskiego),
- Faza C — **Google Play Console: dodanie tej apki do service accountu** (nadanie uprawnień do konkretnej aplikacji),
- Faza D — **Codemagic** (wgranie JSON-a + wybór tracka).

## WAŻNE — RAZ vs KAŻDORAZOWO
- Fazy **A** i **B** są **jednorazowe dla całego konta** (wszystkie 12 aplikacji z wyzwania korzystają z tego samego projektu Google Cloud, tego samego service accountu i tego samego pliku `.json`).
- Fazy **C** i **D** muszą być powtórzone **dla każdej apki osobno** — nawet jeśli service account jest już zaproszony, musisz mu osobno przyznać dostęp do nowej apki, inaczej Codemagic dostanie 403 przy publishingu.

Na początku zapytaj mnie:
> "Czy dla wcześniejszej aplikacji konfigurowałeś już Google Cloud + service account + zaproszenie do Google Play (fazy A i B)? Jeśli to Twoja druga lub kolejna aplikacja z tego szablonu, najprawdopodobniej masz już plik `codemagic-my-flutter-apps-coś-tam.json` — w takim razie możemy pominąć fazy A i B i zaczniemy od fazy C."

**Wybierz jedną ścieżkę:**
- **Mam plik `.json`** — pomiń fazy A i B. Przejdź od razu do fazy C. Upewnij się tylko, że mam jeszcze pobrany plik `.json` service accountu oraz email service accountu (format: `codemagic@<project>.iam.gserviceaccount.com` lub podobny).
- **Nie mam pliku `.json`** — przeprowadź przez wszystkie cztery fazy po kolei.

---

## FAZA A — Google Cloud Console (jednorazowa)

1. Powiedz mi, żebym:
   - Wszedł na [Google Cloud Console](https://console.cloud.google.com/).
   - Jeśli **nie mam jeszcze projektu Google Cloud dla 12 aplikacji**, utworzył nowy — selector projektu u góry → **New Project** → **Project name**: sugeruj `My Flutter Apps` (lub podobną wspólną nazwę). Zapamiętaj ten projekt — używasz go do wszystkich kolejnych apek.
   - Upewnił się, że ten projekt jest wybrany w selectorze u góry.

2. Powiedz mi, żebym włączył API:
   - W wyszukiwarce u góry wpisz **Google Play Android Developer API** i wybierz z wyników.
   - Kliknij **Enable**.

3. Powiedz mi, żebym utworzył service account:
   - Lewe menu → **APIs & Services** → **Credentials**.
   - **Create credentials** → **Service account**.
   - **Service account name**: `codemagic`.
   - Kliknij **Create and continue**.
   - **Grant this service account access to project** → **Role**: wybierz **Service Account User**.
   - Kliknij **Continue** i **Done**.

4. Powiedz mi, żebym pobrał klucz JSON:
   - Na liście **Service accounts** kliknij w świeżo utworzone konto `codemagic`.
   - Zakładka **Keys** → **Add key** → **Create new key** → **Key type**: **JSON** → **Create**.
   - Plik `.json` pobierze się automatycznie. Zapisz go w bezpiecznym lokalnym folderze (np. tam gdzie keystore). Będzie potrzebny przy każdej kolejnej apce.

5. Powiedz mi, żebym skopiował **email service accountu** (widoczny na liście Service accounts, format: `codemagic@<project>.iam.gserviceaccount.com`). Będzie potrzebny w fazie B i C.

---

## FAZA B — Google Play Console: zaproszenie service accountu (jednorazowa)

1. Powiedz mi, żebym:
   - Wszedł na [Google Play Console](https://play.google.com/console/).
   - Z lewego menu wybrał **Users and permissions** (poziom konta, nie aplikacji).
   - Kliknął **Invite new users**.

2. Powiedz mi, żebym wypełnił zaproszenie:
   - **Email address**: email service accountu z fazy A (`codemagic@<project>.iam.gserviceaccount.com`).
   - **App permissions**: na razie zostaw puste — dostęp do konkretnej apki nadamy w fazie C.
   - Kliknij **Invite user** → potwierdź **Send invitation**.

---

## FAZA C — Google Play Console: dodanie tej apki do service accountu (per-app)

1. Powiedz mi, żebym:
   - Wszedł na [Google Play Console](https://play.google.com/console/).
   - Z lewego menu wybrał **Users and permissions** (poziom konta, nie aplikacji).
   - Na liście użytkowników kliknął w service account (`codemagic@<project>.iam.gserviceaccount.com` lub `codemagic-deploy@...`).

2. Powiedz mi, żebym dodał tę apkę do uprawnień service accountu:
   - Zakładka **App permissions** → kliknij **Add app** (prawy górny róg sekcji).
   - Z listy zaznacz apkę utworzoną w kroku `10_publish-googleplay-create-app.md`.
   - Kliknij **Apply**.

3. Powiedz mi, żebym nadał service accountowi uprawnienia do releasów tej apki:
   - Przy właśnie dodanej apce kliknij **Manage permissions**.
   - W sekcji **Releases** zaznacz:
     - **Release to production, exclude devices, and use Play App Signing**,
     - **Release apps to testing tracks**,
     - **Manage testing tracks and edit tester lists**.
   - Kliknij **Apply** → **Save changes** → potwierdź **Yes**.

---

## FAZA D — Codemagic (per-app)

1. Powiedz mi, żebym w Codemagic:
   - Otworzył aplikację utworzoną w kroku `08_publish-codemagic.md`.
   - Przeszedł do **Distribution** → **Google Play** → zaznaczył **Enable Google Play**.
   - W polu **JSON key file** wgrał plik `.json` pobrany w fazie A (albo ten sam co dla poprzednich apek, jeśli pominęliśmy fazy A i B).
   - **Track**: wybierz **`alpha`**.
   - Zaznacz **Submit release as draft**.
   - Kliknij **Save changes**.

2. Powiedz mi, że gdy skończę konfigurację Google Play w Codemagic, mam napisać `next`, bo będziemy przechodzić do `13_publish-codemagic-ios-signing.md`.

**Nic nie commituj w tym kroku** — to instrukcja w panelach zewnętrznych.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/13_publish-codemagic-ios-signing.md`.

# Intro

Twoim zadaniem jako agenta AI jest przeprowadzić mnie przez prerekwizyty Google dla RevenueCat.

CEL: Przygotować Google payments, APIs, service account i uprawnienia Play Console.

# Task

1. Poproś mnie o potwierdzenie, że w **Play Console → Settings → Developer account → Payments profile** mam merchant account.

2. Poproś mnie, żebym upewnił się, że w GCP project podłączonym do Play Console (**Play Console → Setup → API access**) są włączone:
   - Google Play Android Developer API
   - Google Play Developer Reporting API
   - Cloud Pub/Sub API

3. Zapytaj, czy mam już Service Account JSON dla RevenueCat. Jeśli nie:
   - **Google Cloud Console → IAM & Admin → Service Accounts → Create service account**
   - nazwa np. `revenuecat`
   - role: **Pub/Sub Admin**, **Monitoring Viewer**
   - **Keys → Add key → Create new key → JSON**

4. Poproś mnie, żebym sprawdził, czy `client_email` z JSON jest już dodany w **Play Console → Użytkownicy i uprawnienia (Users and permissions)**. Podpowiedz, że to konto service account zwykle wygląda jak `revenuecat@my-flutter-apps-123456.iam.gserviceaccount.com`. Jeśli jest, niech tylko zweryfikuje **Uprawnienia do konta (Account permissions)**. Jeśli go nie ma, niech użyje **Zaproś nowych użytkowników (Invite new users)** i doda:
   - Wyświetlanie informacji o aplikacji i pobieranie raportów zbiorczych (View app information and download bulk reports)
   - Wyświetlanie danych finansowych, zamówień i odpowiedzi z ankiety na temat anulowania (View financial data, orders, and cancellation survey responses)
   - Zarządzanie zamówieniami i subskrypcjami (Manage orders and subscriptions)

5. Poproś mnie o potwierdzenie: merchant account, APIs enabled, JSON pobrany, service account dodany do Play Console.
6. Po potwierdzeniu powiedz mi, że kolejny krok to `03_revenuecat-project.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/03_revenuecat-project.md`.

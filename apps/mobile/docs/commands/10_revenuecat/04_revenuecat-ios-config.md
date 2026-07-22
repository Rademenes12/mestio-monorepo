# Intro

Twoim zadaniem jako agenta AI jest dodać konfigurację App Store w RevenueCat.

CEL: RC ma zapisaną App Store configuration dla aktualnego Bundle ID.

# Task

1. Poinformuj mnie, że mam wejść w **Apps & providers → Configurations**, kliknąć kafelek **New app configuration** i wybrać **App Store**. Podkreśl, że nie chodzi o **New web configuration**.

2. Odczytaj Bundle ID z `ios/Runner.xcodeproj/project.pbxproj` i podaj mi go do pola **App Bundle ID**.

3. Przy **In-app purchase key configuration** wybierz jedną ścieżkę:
   - Jeśli jest pasujący klucz, poproś mnie, żebym kliknął **Select existing key**.
   - Jeśli nie ma pasującego klucza, poprowadź mnie przez **Add new key** i App Store Connect: **Users and Access → Integrations → In-App Purchase → +** (`.p8` + Key ID + Issuer ID).

4. Przy **App Store Connect API** poproś mnie, żebym najpierw kliknął **Select existing key**.

5. Wyjaśnij, że Key ID i Issuer ID powinny uzupełnić się automatycznie, ale Vendor Number trzeba wpisać ręcznie.

6. Poproś mnie, żebym wziął Vendor Number z **App Store Connect → Payments and Financial Reports** (`https://appstoreconnect.apple.com/itc/payments_and_financial_reports#/`), z lewego górnego rogu.

7. Przy **App Store Connect API key** wybierz jedną ścieżkę:
   - Jeśli jest pasujący ASC API key, użyj go i przejdź dalej.
   - Jeśli nie ma pasującego ASC API key, poprowadź mnie przez **Add new key** i App Store Connect: **Users and Access → Integrations → App Store Connect API → +**, rola **App Manager** (`.p8` + Key ID + Issuer ID + Vendor Number).

8. Poproś mnie, żebym kliknął **Save changes**.

9. Poproś mnie o potwierdzenie: App Store configuration zapisana.
10. Po potwierdzeniu powiedz mi, że kolejny krok to `05_revenuecat-android-config.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/05_revenuecat-android-config.md`.

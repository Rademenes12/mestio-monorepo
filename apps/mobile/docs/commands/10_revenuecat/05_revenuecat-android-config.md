# Intro

Twoim zadaniem jako agenta AI jest dodać konfigurację Google Play Store w RevenueCat.

CEL: RC ma zapisaną Google Play Store configuration dla aktualnego package name.

# Task

1. Poinformuj mnie, że mam wejść w **Apps & providers → Configurations**, kliknąć kafelek **New app configuration** i wybrać **Google Play Store**. Podkreśl, że nie chodzi o **New web configuration**.

2. Odczytaj package name z `android/app/build.gradle.kts` i podaj mi go do pola **Google Play package name**.

3. Poproś mnie, żebym wgrał JSON w **Service Account Credentials JSON**.

4. Poproś mnie, żebym kliknął **Save changes**.

5. Poproś mnie, żebym kliknął **View details** i sprawdził, czy **Client Email** zgadza się z `client_email` z JSON-a. Jeśli nie, poproś mnie, żebym wgrał właściwy JSON i ponownie kliknął **Save changes**.

6. Uprzedź mnie, że po wgraniu JSON-a RevenueCat może pokazać `Credentials need attention` → `Could not validate subscriptions API permissions`. Jeśli API są włączone, `client_email` z JSON-a jest dodany w Play Console i permissions są ustawione, ten warning nie blokuje zapisania konfiguracji. Google credentials mogą mieć status pending/attention do 36h.

7. Powiedz żebym ustawił `Offerings compatibility mode` na `Only Android SDK v6+`.

8. Poproś mnie o potwierdzenie: Google Play Store configuration zapisana, **View details** pokazuje poprawny Client Email.
9. Po potwierdzeniu powiedz mi, że kolejny krok to `06_apple-products.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/06_apple-products.md`.

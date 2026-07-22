# ⚠️ KROK INSTRUKCYJNY
- NIE przenoś pliku sam.
- NIE edytuj `android/key.properties` sam.
- Powiedz mi co mam zrobić. Ja zrobię.
- **STOP** i czekaj na mój dosłowny `next`.

# CEL
Pokazać mi gdzie przenieść `upload-keystore.p12` i jak wpisać ścieżkę w `android/key.properties`.

# Task

## 1. Przeniesienie pliku
Każ mi przenieść `upload-keystore.p12` do folderu z kluczami z aplikacją. Propozycje:

- **macOS / Linux:** `/Users/<uzytkownik>/12appschallenge/keys/<app_name>/upload-keystore.p12`
- **Windows:** `C:\12appschallenge\keys\<app_name>\upload-keystore.p12`

`<app_name>` = realna nazwa apki.

## 2. `storeFile` w `android/key.properties`
`key.properties` to plik **Java Properties** — pojedynczy `\` jest escape'em (`\u`, `\n` się zepsują).

**Windows — forward slashes (zalecane):**
```
storeFile=C:/12appschallenge/keys/<app_name>/upload-keystore.p12
```

Alternatywnie podwójne backslashe:
```
storeFile=C:\\12appschallenge\\keys\\<app_name>\\upload-keystore.p12
```

> `key.properties` to format **Java Properties** — `\` to znak escape (`\n`, `\t`, `\u...` mają specjalne znaczenie). Na Windows użyj forward slashes albo escape'uj `\\`.

**Nigdy pojedynczy `\`.**

**macOS / Linux:**
```
storeFile=/Users/<uzytkownik>/12appschallenge/keys/<app_name>/upload-keystore.p12
```

Jeśli Gradle się wywali — pomóż mi zdiagnozować, **NIE edytuj pliku sam**.

## FINISH
Czekaj na mój dosłowny `next`. Powiedz mi, że kolejny krok to `12_init-supabase-shared-users-setup.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/12_init-supabase-shared-users-setup.md`.

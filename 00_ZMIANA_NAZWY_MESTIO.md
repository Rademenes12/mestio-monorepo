# Zmiana nazwy: FixFlow → Mestio

## Co się zmieniło
- Nazwa produktu/firmy: **FixFlow → Mestio**
- Domena wykupiona i aktywna: **mestio.pl**
- Wszystkie nowe dokumenty, prototypy i kod powinny odnosić się do nazwy Mestio.
  Starsze pliki z nazwą FixFlow (w tym `.dc.html` i dokumentacja w katalogach
  `0_Wspolne_Backend`, `1_Aplikacja_Mobilna`, `2_CRM_Klienta`, `3_CRM_Moj`,
  `4_Strona_WWW`) zostały częściowo już zaktualizowane (patrz pliki `MESTIO_*.md`
  w każdym katalogu) — traktować jako źródło aktualnego stanu, a pliki `FixFlow_*`
  jako historyczne/w trakcie migracji.

## Do zrobienia po stronie kodu (dla AI budującego aplikację)
- Zmiana nazwy pakietu/aplikacji: `com.pawelpasik.fixflow` → `com.pawelpasik.mestio`
  (już wykonane wg raportu z ostatniej sesji budowy — do potwierdzenia).
- Wszystkie URL-e w kodzie (API, linki w mailach, stopki, itd.): `fixflow.app` /
  `fixflow.pl` → **mestio.pl**.
- Nazwa w AndroidManifest, Info.plist, ARB (tłumaczenia), tytuły stron w Next.js
  (CRM Klienta, CRM Mój, Strona WWW) — zamienić widoczną nazwę na Mestio.
- Logo/ikona aplikacji — jeśli jeszcze nie zaktualizowane pod nową nazwę, do zrobienia.

## Ważne: konfiguracja domeny na Vercel
Dane domeny (mestio.pl) zostały już wpisane bezpośrednio w panelu Vercel — **nie
przez to narzędzie/rozmowę**. Poproś swoje AI budujące aplikację (Antigravity), żeby
**samo sprawdziło aktualny stan konfiguracji domeny w Vercel** (DNS, przypisanie
domeny do właściwego projektu: Strona WWW / CRM Klienta / CRM Mój — każdy może być
osobnym projektem na Vercel z osobną subdomeną, np. `mestio.pl`, `panel.mestio.pl`,
`app.mestio.pl` — do ustalenia która subdomena należy do którego systemu), zamiast
zakładać że trzeba to konfigurować od nowa.

## Poczta
Jeśli skrzynka pocztowa (np. przez Hostinger) została założona na domenie mestio.pl,
zaktualizować też adresy nadawcze w kodzie (maile transakcyjne, stopki, formularz
kontaktowy na stronie WWW) z starych adresów `@fixflow...` na `@mestio.pl`.

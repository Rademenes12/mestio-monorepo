# Etap `05_build`

## Stan workflow

Gdy zaczynasz ten etap, przeczytaj `STATE.md` i zaktualizuj go tak, aby wskazywał:
- `Aktualny etap`: `build`
- status etapu `build`: `🟡 in-progress`

Aplikacja ma już wybrany ekran Home, kierunek wizualny oraz plan implementacji MVP.

W tym etapie będziemy implementować aplikację krok po kroku.

Po etapie `04_plan`, ten plik powinien być zaktualizowany jako manifest wykonawczy builda: opisuje kolejność baby stepów, wspólne kontrakty, zależności i zasady weryfikacji. Pojedynczy baby step powinien dać się wykonać w świeżej rozmowie, zakładając tylko aktualny stan repo, `docs/IMPL_PLAN.md`, ten manifest i treść danego kroku.

# Tryb pracy

Jeżeli masz dostęp do subagentów, nie modyfikuj jeszcze plików.

Najpierw sprawdź wszystkie pliki `.md` w `docs/commands/05_build/` i oceń, czy baby stepy można bezpiecznie wykonać równolegle. Następnie poinformuj mnie, że masz dostęp do subagentów, krótko opisz możliwe tryby pracy i zapytaj, który wybieram:

1. Tryb równoległy/autonomiczny - dzielisz baby stepy między subagentów, koordynujesz ich pracę, integrujesz wyniki, rozwiązujesz konflikty, uruchamiasz wymaganą weryfikację i raportujesz końcowy wynik.
2. Tryb sekwencyjny - wykonujesz tylko pierwszy baby step, a po jego zakończeniu czekasz na moje `next` przed przejściem dalej.

W trybie równoległym uruchamiaj subagentów tylko dla zakresów, które da się jasno rozdzielić. Pliki i obszary wspólne, takie jak `pubspec.yaml`, DI, routing, ARB/l10n, migracje Supabase, globalne modele, konfiguracja aplikacji oraz pliki generowane traktuj jako punkty integracyjne koordynowane przez głównego agenta.

Jeżeli nie masz dostępu do subagentów, pomiń ten wybór trybu i przejdź od razu do standardowego startu.

# Start standardowy

Znajdź pierwszy plik `.md` w `docs/commands/05_build/` oznaczony jako krok `01` i wykonaj tylko ten krok.

Nie przechodź sam do kolejnych kroków bez mojego polecenia.

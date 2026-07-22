# Intro

Propozycja limitów i modelu Pro została przeze mnie zaakceptowana. Teraz twoim zadaniem jest utworzenie nowego pliku `docs/LIMITS.md`, który będzie kompletnym source of truth dla feature'a limitów i Pro.

Ten dokument ma zebrać w jednym miejscu:
- ustalenia produktowe z poprzednich kroków
- copy i messaging
- szczegółowy plan techniczny implementacji

---

# Task

Utwórz nowy plik `docs/LIMITS.md` i zapisz w nim kompletny dokument feature'a limitów zgodny z `AGENTS.md`.

# Zasady

- `docs/LIMITS.md` nie ma zawierać tylko technikaliów. Ma też utrwalić to, co zostało wcześniej ustalone na poziomie produktu i copy
- Trzymaj się zasad z `AGENTS.md`, zwłaszcza UI → Cubit → Repository → Data Source
- Pamiętaj o testach: każdy nowy Cubit musi mieć testy (`bloc_test` + `mocktail`)
- Wszystkie stringi widoczne dla końcowego użytkownika aplikacji muszą być w l10n (PL/EN)
- Copy sprzedażowy jest już gotowy w `docs/PAYWALL.md` — nie musisz go powielać w LIMITS.md
- Zaplanuj implementację Dark Mode na podstawie wytycznych z `docs/DESIGN.md` — jako feature dostępny tylko dla Pro
- Uwzględnij zasadę biznesową: guest z Pro ma być wyraźnie zachęcany do zabezpieczenia konta, bo inaczej może stracić zakup po usunięciu aplikacji
- Dev Tools toggle "Fake Pro" do testów **już istnieje** w `lib/app/developer/ui/developer_screen.dart` (Switch w `kDebugMode`, wywołuje `AccountActionsCubit.setDeveloperProOverride`). Działa tylko gdy RevenueCat nie jest aktywny. W `LIMITS.md` wskaż, że manualny verify bez RevenueCat wykorzystuje ten istniejący toggle, a verify z RevenueCat używa mock purchase — **nie** planuj nowego toggle'a
- Opisz techniczny kontrakt flow zakupu Pro:
  - `Cubit` emituje jednorazowy state efekt typu `openPaywall`
  - `UI` obsługuje go w `BlocListener`
  - `BlocListener` wywołuje `PaywallPresenter.presentIfNeeded(...)`
  - `PaywallPresenter` decyduje: gdy `RevenueCatConfig.isEnabled == true`, wyświetla prawdziwy RevenueCat paywall; gdy RevenueCat nie jest aktywny, wyświetla placeholder
  - `RevenueCatUI.presentPaywallIfNeeded(...)` nie może być wywoływane nigdzie poza `PaywallPresenter`.
- Uwzględnij CTA zakupu Pro w profilu:
  - pokazuj `Buy Pro` tylko gdy `RevenueCatConfig.isEnabled == true` i user nie ma Pro
  - guest może kupić Pro, ale `Register` pozostaje głównym CTA, `Login` secondary, a `Buy Pro` tertiary
  - dla registered non-Pro `Buy Pro` może być głównym CTA, a akcje profilu pozostają secondary
- Zapisz jako twardą zasadę UX:
  - nigdy nie otwieraj flow zakupu Pro bezpośrednio po kliknięciu zablokowanego elementu
  - zawsze najpierw pokaż spersonalizowany krok pośredni dopasowany do konkretnego kontekstu
  - ten krok pośredni ma tłumaczyć wartość dokładnie tej funkcji, ekranu lub benefitu, który user próbował odblokować
  - dopiero z tego kroku pośredniego główny CTA może prowadzić dalej do flow zakupu Pro
- Uwzględnij przykłady takiego spersonalizowanego kroku pośredniego:
  - kliknięcie w `Dark mode` toggle -> najpierw alert/dialog wyjaśniający wartość dark mode jako funkcji Pro
  - kliknięcie w funkcję Pro-only -> najpierw dialog wyjaśniający wartość tej konkretnej funkcji
  - wejście w ekran Pro-only -> najpierw dedykowany ekran przejściowy dla tego konkretnego ekranu
  - limit hit dla guest -> najpierw komunikat i CTA do rejestracji, nie do zakupu
- Opisz szczegółowo implementację UX blokad:
  - gdzie użyć dialogu
  - gdzie użyć ekranu przejściowego
  - jak prowadzić guest do rejestracji
  - jak prowadzić registered do flow zakupu Pro

# Oczekiwana struktura `docs/LIMITS.md`

Dokument powinien mieć wyraźnie rozdzielone sekcje:
- ustalenia produktowe: co limitujemy, jakie są progi, co jest Pro-only
- ustalenia copy i messaging: odwołanie do `docs/PAYWALL.md`, wykorzystanie placeholdera i komunikatów blokad
- plan implementacyjny: pliki, klasy, warstwy, testy, kolejność wdrożenia

Sekcja implementacyjna ma być wyraźnie oznaczona, bo to właśnie ona będzie później rozbijana na baby stepy.

---

# Finish

Po zapisaniu `docs/LIMITS.md`:

1. Commit: `docs(limits): add LIMITS.md`.
2. Przedstaw mi krótkie podsumowanie planu — najważniejsze punkty, nie cały dokument.
3. Powiedz mi, że kolejny krok to `05_limits-build-policy.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do wykonania polecenia zawartego w `docs/commands/09_limits/05_limits-build-policy.md` — nie podgląduj tego pliku wcześniej!

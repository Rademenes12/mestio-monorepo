Zapoznaj się z `docs/IDEA.md`, aby zrozumieć pomysł na aplikację.

Póki co w tej aplikacji mam zaimplementowany tylko Welcome Screen, który otwiera się przy pierwszym uruchomieniu aplikacji.

Z Welcome Screen `lib/features/auth/presentation/ui/welcome_screen.dart` mogę:
- Kontynuować jako gość `anonymous` Supabase Auth.
- Albo się zalogować. 

Nie ma opcji rejestracji (i nie będzie) - do aplikacji wchodzę zawsze jako użytkownik z własnym id.

Dalej jestem przekierowywany na Home Screen, którego ekran już powinien być gotowy w samej warstwie wizualnej UI `lib/features/home/ui/home_screen.dart`.

Z ekranu Home Screen mogę przejść do Profile, gdzie mogę się zalogować lub zarejestrować (tak naprawdę to zmigrować istniejące konto `guest` na `registered` - nigdy w tej aplikacji nie tworzymy nowego konta od zera). Mogę tam też się wylogować, ustawić swoje imię, usunąć konto itp.

I to na razie tyle ile mamy w tej aplikacji. Jedynie wstępny welcome flow. Wstępny Supabase Auth.

Rozeznaj się, zobacz jak to wszystko działa. Analyze & Explore. Ale niczego nie implementuj. Zapoznaj się tylko z projektem i to wszystko. Zrozum jak to wszystko jest powiązane, ale nie zmieniaj kodu.

## FINISH
Poinformuj mnie o tym, czy rozumiesz istniejącą bazę kodu i zasugeruj mi napisanie `next`. Kolejny krok: `02_plan-plan.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/04_plan/02_plan-plan.md`.

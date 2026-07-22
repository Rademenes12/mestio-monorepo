# Task

Krok informacyjny. **Niczego nie modyfikuj, niczego nie uruchamiaj.**

Powiedz mi dokładnie to (możesz sparafrazować, ale zachowaj zakres):

> W następnym kroku tymczasowo obniżę limity głównej encji do minimum (`guestLimit = 1`, `registeredLimit = 2`), żebyś mógł szybko przetestować manualnie:
>
> - osiągnięcie limitu jako guest → dialog z CTA do rejestracji,
> - Profile jako guest → `Register` jest głównym CTA, a `Buy Pro` jest widoczne tylko przy aktywnym RevenueCat,
> - osiągnięcie limitu jako registered → dialog z CTA do paywalla → prawdziwy RevenueCat paywall, jeśli RevenueCat jest aktywny; inaczej placeholder,
> - gdy RevenueCat nie jest aktywny: włączenie "Fake Pro" w Profile → Developer → limit zniesiony, Pro-only feature i ekran dostępne, dark mode toggle zmienia motyw,
> - gdy RevenueCat jest aktywny: mock purchase przez paywall daje Pro i znosi limit,
> - wyłączenie "Fake Pro" → wszystko wraca do stanu gated.
>
> Gdy jesteś gotowy, napisz `next` — wtedy obniżę limity i poproszę Cię o manualny test.

## Koniec

Powiedz mi, że kolejny krok to `12_limits-verify-manual.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/09_limits/12_limits-verify-manual.md` — nie podgląduj wcześniej!

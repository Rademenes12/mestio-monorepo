# Intro

Twoim zadaniem jako agenta AI jest przeprowadzić scenariusze RevenueCat w debug.

CEL: Guest, upgrade, switch, restore i resume działają zgodnie z auth flow.

# Task

1. Upewnij mnie, że apka działa w debug z Test Store (`test_` key).

2. Poproś mnie o wykonanie scenariuszy po kolei i zgłoszenie wyniku po każdym:
   - Guest → Buy Pro: nowy guest, Profile pokazuje `Register` jako główne CTA i `Buy Pro` jako akcję niższego poziomu tylko przy aktywnym RevenueCat; tap w `Buy Pro`, paywall, mock purchase, Pro=true bez restartu.
   - Guest+Pro → Register/upgrade: Pro zostaje, bo `user.id` zostaje ten sam.
   - Guest+Pro → Login/switch: Pro nie przenosi się na inne konto.
   - Sign out → nowy guest: Pro=false.
   - Foreground resume: kup Pro, zminimalizuj, wróć, Pro nadal true.
   - Restore z paywalla: wróć na konto Pro, użyj restore, Pro=true.

3. Jeśli scenariusz nie przejdzie, pomóż mi go zdiagnozować przed przejściem dalej.

4. Poproś mnie o potwierdzenie, że wszystkie scenariusze przeszły.
5. Po potwierdzeniu powiedz mi, że kolejny krok to `14_codemagic-keys.md` i zasugeruj mi napisanie `next`.

## FINISH

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/10_revenuecat/14_codemagic-keys.md`.

# Task

Przywróć limity i zamknij etap `09_limits`.

## Przywróć limity

W `LimitPolicy` (albo gdzie były oryginalnie stałe) ustaw:

```
static const int guestLimit = __ORIGINAL_GUEST_LIMIT__;
static const int registeredLimit = __ORIGINAL_REGISTERED_LIMIT__;
```

Placeholdery wypełnił krok 12. **Jeśli widzisz tu dosłownie `__ORIGINAL_GUEST_LIMIT__`** — krok 12 nie dopełnił obowiązku; znajdź oryginalne wartości przez `git log -p -- [plik z `LimitPolicy`]` (szukaj commita `chore(limits): lower limits for manual verify` — wartości przed tym commitem są tymi właściwymi) i zgłoś mi, że placeholdery się nie przekazały.

`flutter analyze` czysto. Commit: `chore(limits): restore original limits`.

## Koniec etapu

- To kończy etap `09_limits`.
- Zaktualizuj `STATE.md`: ustaw etap `limits` jako `✅ done`, ustaw `Ostatni zakończony etap` na `limits`, ustaw `Aktualny etap` na `revenuecat` i zostaw status etapu `revenuecat` jako `⬜ not-started`.
- Kolejny etap to `10_revenuecat`.
- Zasugeruj mi otworzenie nowej konwersacji / nowej sesji / nowego chata i wklejenie polecenia:
  `Wykonaj: docs/commands/10_revenuecat.md`
- Jeśli chcę kontynuować w tej samej rozmowie, niech napiszę `next`.

Gdy napiszę `next`, dopiero wtedy zapoznaj się z plikiem `docs/commands/10_revenuecat.md` — nie wcześniej!

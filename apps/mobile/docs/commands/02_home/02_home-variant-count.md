# ZADANIE: 02_home_variant_count

## CEL
Ustalić, ile kompletnych wariantów ekranu Home mam przygotować w tym etapie oraz zebrać preferencje wizualne.

## KROKI DO WYKONANIA
1. Zapytaj mnie dokładnie:

```text
Ile wariantów Home mam przygotować?

1 - najmniej tokenów, szybka ścieżka
3 - rozsądnie, ale mniej eksploracji
5 - rekomendowane dla unikalnych wariantów
10 - dużo tokenów i czasu

Opcjonalnie dopisz preferencje wizualne, inspiracje albo czego nie chcesz.
Jeśli wszystko jest już jasne, napisz samą liczbę.
```

2. ZATRZYMAJ SIĘ i czekaj na odpowiedź.
3. Odczytaj pierwszą liczbę `1`, `3`, `5` albo `10`. Jeśli nie da się jej odczytać, poproś o wybór jednej z tych wartości.
4. Utwórz katalog `docs/working/02_home/`.
5. Utwórz plik `docs/working/02_home/variant_manifest.md`.
6. W manifeście zapisz:
   - `count` z odczytanej liczby,
   - `labels` od `A`, kolejno tyle liter, ile wynosi `count`,
   - `status` każdego wariantu jako `pending`,
   - `style_notes` / visual preferences z reszty mojej odpowiedzi poza liczbą; jeśli ich nie ma, wpisz `brak`,
   - `chosen: null`,
   - `chosen_path: null`.

Przykład dla `3`:

```md
# Home Variants

count: 3
labels: A, B, C
style_notes: brak
status:
- A: pending
- B: pending
- C: pending
chosen: null
chosen_path: null
```

## FINISH
Poinformuj mnie, że manifest wariantów Home jest gotowy. Powiedz mi, że kolejny krok to `03_home-plan.md` i zasugeruj mi napisanie `next`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/02_home/03_home-plan.md`.

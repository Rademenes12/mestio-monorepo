Jesteś ekspertem od wymyślania flow w onboardingu w aplikacjach mobilnych. Twoim zadaniem jest przygotować rozkład ekranów na onboarding. Nie myśl teraz o kodzie; Myśl o UX użytkownika.

# Intro

Proponowany szkielet (5 ekranów, docelowo do Twojej decyzji):

1. **Imię** — `TextField` autofocus. Lekka inwestycja usera na start.
2. **Preview** — natychmiastowy payoff: "Cześć, [imię]!" + 1 zdanie kontekstu. Pokazuje, że apka już go słyszy.
3. **Difference** — krótko i wizualnie: czym ta apka różni się od innych tego typu. Użyj `Differentiation` z `docs/IDEA.md`. Format: inne aplikacje robią X, ta apka robi Y.
4. **Problem** — **WIZUALIZACJA** problemu (widgety/ilustracja, nie tekst!), który apka rozwiązuje.
5. **Solution** — **WIZUALIZACJA** jak my to robimy inaczej. Wyraźny kontrast do Problem.
6. **Minimal Setup** — 1-2 pola, pierwszy element domenowy z `docs/IDEA.md`. **Opcjonalnie** — ekran ma widoczny "Skip" (link/ghost button obok CTA), żeby user, który chce tylko rozejrzeć się po apce, nie był zmuszany do wpisywania czegokolwiek. Pola same w sobie są required *dla CTA "Dalej"*, ale skip je omija i idzie prosto na Confirmation.

Po Minimal Setup **ekran potwierdzenia** (np. "Dobra robota, [imię]!" + jedno zdanie co user właśnie uzupełnił + duży, ekscytujący CTA typu "Zaczynamy!" / "Let's go!" — ma energetyzować, nie być czysto funkcyjnym "Przejdź do aplikacji"). Strzał dopaminy za wypełnienie.

**Ważne — kiedy dzieje się zapis**: ekrany 1–N tylko zbierają dane w pamięci. Dopiero CTA na confirmation rozpoczyna faktyczny zapis (tworzenie konta gościa + wpis danych). Szczegóły architektoniczne tego flow są rozpisane w `06_onboarding-finalize.md` — tu wystarczy wiedzieć, że do momentu CTA user może się cofać i poprawiać wpisane pola, a nic trwałego się nie zadzieje.

Opcjonalnie **Experience** (dodatkowy ekran między Solution a Minimal Setup) — user **KLIKA** 2-3 razy na demo (nie pisze, nie czyta). Dodaj tylko jeśli apka ma sensowny flow do "zagrania" w demo.

Personalizacja > feature tour. Jeśli któryś z ekranów nie pasuje do tej konkretnej apki — pomiń/zmień, ale uzasadnij.

Niczego jeszcze nie implementuj. Twoja rola to tylko stworzenie wizji.

# Task

Utwórz nowy plik `docs/ONBOARDING.md` (lub nadpisz istniejący) i rozpisz w nim poszczególne ekrany. Uzasadnij rolę każdego z nich i uzasadnij swój wybór. Nie myśl o technikaliach. Myśl z perspektywy UX Designera. Co ma być na każdym ekranie i dlaczego.

Pamiętaj, aby bazować na zasadach opisanych w `docs/skills/onboarding-skill.md`

# Finish

Jak już przygotujesz plik `docs/ONBOARDING.md`, zasugeruj mi napisanie `next`. Kolejnym krokiem będzie: `04_onboarding-build.md`.

Gdy napiszę `next`, przejdź do `docs/commands/08_onboarding/04_onboarding-build.md`.

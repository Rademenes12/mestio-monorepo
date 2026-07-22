# ZADANIE: 07_publish_github

## CEL
Upewnić się, że lokalne repozytorium projektu jest połączone z remote na GitHubie (jako **private**). Niezpushowane lokalne commity są OK — w tym kroku sprawdzamy tylko, czy remote jest skonfigurowany.

## KROKI DO WYKONANIA:

### 🔍 KROK 1: Diagnoza stanu repo
Wykonaj w terminalu projektu:
1. `git remote -v` — czy jest skonfigurowany jakikolwiek remote (np. `origin`).

Na tej podstawie określ sytuację:
- **A) Remote jest:** `git remote -v` zwraca co najmniej jeden wpis.
- **B) Brak remote:** `git remote -v` nie zwraca nic — projekt istnieje tylko lokalnie.

### 🛠 KROK 2: Reakcja zależna od sytuacji

**Sytuacja A — remote jest:**
Poinformuj mnie krótko, że repo jest już połączone z remote na GitHubie. Przejdź do sekcji FINISH.

**Sytuacja B — brak remote:**
Najpierw ustal sugerowaną nazwę repozytorium:
1. Otwórz `docs/IDEA.md` i znajdź app bundle ID (w formacie np. `com.imienazwisko.nazwaapki`).
2. Weź fragment po **ostatniej kropce** (czyli `nazwaapki`) — to będzie sugerowana nazwa repo na GitHubie.
3. Jeśli z jakiegoś powodu nie uda się znaleźć bundle ID w `docs/IDEA.md`, pomiń sugestię nazwy i pozwól użytkownikowi wpisać dowolną.

Następnie poinformuj mnie, że projekt jest jeszcze tylko lokalnie i trzeba go opublikować na GitHubie z poziomu VS Code. Wypisz dokładnie te instrukcje (podaj sugerowaną nazwę w punkcie 4):
1. Otwórz VS Code w tym projekcie.
2. Przejdź do zakładki **Source Control** (ikona gałęzi po lewej stronie).
3. Kliknij przycisk **Publish Branch**.
4. W polu nazwy repozytorium wpisz: **`<sugerowana-nazwa>`** (na podstawie bundle ID z `docs/IDEA.md`).
5. Z listy wybierz **Publish to GitHub private repository**.
6. Poczekaj, aż VS Code skończy push.

Na końcu powiedz mi, że gdy skończę publikację w VS Code, mam napisać `next`, bo będziemy przechodzić do `08_publish-codemagic.md`.

**Nic nie commituj w tym kroku** — ten krok tylko weryfikuje i instruuje.

## FINISH
Nie przechodź dalej dopóki nie napiszę `next`.

Gdy napiszę `next`:
- Jeśli byliśmy w sytuacji B, najpierw wykonaj jeszcze raz `git remote -v`, żeby zweryfikować, że remote jest ustawiony. Jeśli nadal brak remote, poinformuj mnie i poproś o dokończenie publikacji w VS Code — nie idź dalej.
- Gdy remote jest skonfigurowany, przejdź do `docs/commands/07_publish/08_publish-codemagic.md`.

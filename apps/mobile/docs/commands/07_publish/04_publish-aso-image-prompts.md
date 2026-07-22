Wciel się w rolę Prompt Engineera i dyrektora artystycznego. Twój cel to stworzenie dwóch niezależnych promptów do generatora obrazów (np. Midjourney, DALL-E, Nano Banana), aby wygenerować grafiki do sklepów z aplikacjami.

Kluczowa zasada: **nie podejmuj za generator decyzji kreatywnych.** Nie narzucaj konkretnego symbolu, motywu ani kompozycji. Twoim zadaniem jest dać generatorowi bogaty **kontekst** (czym jest aplikacja, jaką obietnicę niesie, jaka jest paleta kolorów, jaki jest styl UI ze screenshota) oraz **twarde ograniczenia techniczne**. Decyzje artystyczne (jaki symbol, jaka scena, jaka kompozycja) zostaw generatorowi.

### 🗂 ETAP 1: KONTEKST WIZUALNY
Zanim zaczniesz pisać, zbierz materiał kontekstowy:
1. Przeczytaj `docs/IDEA.md` — co to za aplikacja, jaka obietnica, do kogo mówi, `Search Intents`.
2. Przeczytaj `docs/DESIGN.md` — zamysł artystyczny i język wizualny.
3. Sprawdź w kodzie pliki z kolorami (`ThemeData`, palety), aby wypisać 2-3 dominujące kolory bazowe i akcenty w kodzie HEX.
4. Przeczytaj i zastosuj skill `docs/skills/assets-ai-prompting-skill.md`.

### ⚠️ KRYTYCZNA ZASADA FORMATU
- Prompty zapisz jako **ścisłe obiekty JSON** zgodne ze skillem `docs/skills/assets-ai-prompting-skill.md`.
- Dla każdego assetu najpierw wpisz krótki `Design Context` (nie `Design Rationale` — nie tłumacz decyzji, bo ich nie podejmujesz), a zaraz po nim surowy blok `json`.
- Wszystkie wartości w JSON po angielsku.

### 📝 ETAP 2: GENEROWANIE PROMPTÓW (Na sam dół PUBLISH.md)
Otwórz `docs/PUBLISH.md` i dodaj na samym dole sekcję `## 🎨 5. AI Image Generation Prompts` w układzie:

```markdown
## 🎨 5. AI Image Generation Prompts

**⚠️ WAŻNE:** Zanim wkleisz poniższe prompty do generatora AI (np. Nano Banana, GPT-Image, Midjourney), **MUSISZ ZAŁĄCZYĆ SCREENSHOT** ze swojej aplikacji! Oba prompty bezpośrednio się do niego odwołują jako do głównego źródła stylu i kolorystyki.

**Prompt 1: App Icon (Ikona Aplikacji)**
Design Context: [1-2 zdania o aplikacji, jej obietnicy i nastroju wizualnym]
<json>
{ ... }
</json>

**Prompt 2: Google Play Feature Graphic**
Design Context: [1-2 zdania o aplikacji, jej obietnicy i nastroju wizualnym]
<json>
{ ... }
</json>
```

**Jak budować zawartość JSON (dotyczy obu promptów):**

Każdy JSON powinien zawierać przede wszystkim **kontekst**, który pomoże generatorowi samodzielnie zdecydować co narysować:
- czym aplikacja jest i jaką obietnicę daje użytkownikowi (kilka zdań, nie slogany marketingowe),
- dla kogo jest aplikacja i jaki ma nastrój (np. spokojna, energetyczna, profesjonalna — opisz to językiem wizualnym, nie narzucaj sceny),
- paleta kolorów z kodu (HEX-y, z krótką notką który jest bazowy, a który akcent),
- wyraźne wskazanie, że **załączony screenshot jest głównym źródłem stylu, kolorystyki i języka wizualnego** — generator ma się do niego dopasować,
- wolność kreatywna: jawnie pozwól generatorowi samodzielnie wybrać symbol, metaforę i kompozycję spójną z kontekstem.

Do tego dołóż **tylko twarde ograniczenia techniczne** właściwe dla danego assetu (patrz niżej). Nie dodawaj rozbudowanych list `avoid_elements` z estetycznymi wymaganiami typu "no generic AI look" — zamiast tego opisz pozytywnie, do czego generator ma się dopasować (screenshot, paleta, nastrój).

**Prompt 1: App Icon — twarde ograniczenia techniczne:**
- asset typu `app icon`
- proporcje 1:1
- bez zaokrąglonych rogów, bez marginesów, bez ramek
- bez tekstu, liter i cyfr na ikonie
- reszta (symbol, motyw, kompozycja, poziom abstrakcji) — decyzja generatora na bazie kontekstu i screenshota

**Prompt 2: Google Play Feature Graphic — twarde ograniczenia techniczne:**
- asset typu `marketing / feature graphic`
- format 1024x500px
- bezpieczne marginesy przy krawędziach
- bez elementów UI sklepu (przycisków "Download", ramek telefonu itp.)
- musi zawierać dokładnie jeden overlay tekstowy: `"[Wpisz tutaj nazwę aplikacji oraz Long tail keyword, np. 'ZenHabit: Daily Routine Tracker']"` i nic więcej
- tło, kompozycja, motyw wizualny — decyzja generatora, spójna ze screenshotem i paletą

Jeśli generator akceptuje tylko prompt tekstowy, i tak przygotuj go jako JSON zgodny ze skillem — nie zamieniaj go z własnej inicjatywy na paragraf.

### ⚙️ AKCJA KOŃCOWA:
1. Dopisz tę sekcję na koniec `docs/PUBLISH.md`.
2. **ZACOMMITUJ plik** z wiadomością: `chore: append AI image generation prompts to PUBLISH.md`.
3. Poinformuj mnie, że prompty JSON czekają na dole `PUBLISH.md`.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `05_publish-save-icon.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/05_publish-save-icon.md`.

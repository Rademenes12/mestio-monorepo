# ZADANIE: 19_publish_screenshots_ai_prompts

## CEL
Przygotować 5 uniwersalnych promptów do generatora obrazów AI, które przerobią surowe screenshoty z kroku `18_publish-screenshots.md` na marketingowe screenshoty sklepowe.

W tym kroku wygeneruję tylko 5 obrazów bazowych w AI generatorze. Techniczny crop/resize do iOS i Android będzie w kroku 20.

## WAŻNE ZASADY SKLEPÓW
- Apple: screenshoty i metadata muszą dokładnie odzwierciedlać realne doświadczenie aplikacji. Screenshot może mieć tekst i overlaye, ale nie może być samą planszą tytułową, loginem albo splash screenem. Nie używaj cen, rankingów, niezweryfikowanych claimów ani nazw/ikon innych platform. Źródło: https://developer.apple.com/app-store/review/guidelines/
- Google Play: screenshoty muszą pokazywać faktyczne doświadczenie aplikacji. Tagline tylko jeśli pomaga zrozumieć aplikację i nie powinien zajmować więcej niż około 20% obrazu. Nie używaj claimów typu `Best`, `#1`, `Top`, `New`, promocji, cen, rankingów, opinii userów ani badge'y sklepowych. Źródło: https://support.google.com/googleplay/android-developer/answer/9866151
- Telefon w grafice ma być **neutralny i bezmarkowy**: bez Dynamic Island, bez logo Apple, bez logo Android, bez nazw `iPhone`, `Pixel`, `App Store`, `Google Play`.
- Prompt ma wymuszać safe-zone, bo w kroku 20 będziemy przycinać obraz: krytyczne elementy w centralnych 70% szerokości, headline w górze z marginesem, nic ważnego przy bocznych krawędziach ani na samym dole.

## KROKI DO WYKONANIA

1. Otwórz `docs/PUBLISH.md` i znajdź sekcję `### Zrzuty ekranu (Screenshots)`.

2. Wyciągnij 5 pozycji. Każda pozycja ma format:
   `<opis UI> | <marketingowy tytuł na grafice>`.

3. Przeczytaj `docs/DESIGN.md` jako kontekst stylu.

4. Przeczytaj i zastosuj `docs/skills/assets-ai-prompting-skill.md`, ale dostosuj go do screenshotów sklepowych:
   - prompt ma być JSON,
   - wartości w JSON po angielsku,
   - generator dostaje kreatywną wolność w stylistyce tła i kompozycji, ale nie w treści tytułu, safe-zone, neutralności urządzenia i zgodności z realnym UI.

5. Wypisz mapowanie pod pracę w AI generatorze:

   ```text
   Screen 1 — <opis UI z PUBLISH.md>
   Title: <marketingowy tytuł z PUBLISH.md>

   Screen 2 — <opis UI z PUBLISH.md>
   Title: <marketingowy tytuł z PUBLISH.md>

   Screen 3 — <opis UI z PUBLISH.md>
   Title: <marketingowy tytuł z PUBLISH.md>

   Screen 4 — <opis UI z PUBLISH.md>
   Title: <marketingowy tytuł z PUBLISH.md>

   Screen 5 — <opis UI z PUBLISH.md>
   Title: <marketingowy tytuł z PUBLISH.md>
   ```

6. Powiedz mi, żebym otworzył **jedną rozmowę** w generatorze obrazów AI (np. GPT-Image / Nano Banana / Midjourney / inny model obsługujący obraz wejściowy) i pracował w niej po kolei:
   - najpierw mam wkleić `Prompt 1` i załączyć surowy screenshot 1,
   - wybrać najlepszy wynik jako główny obraz referencyjny stylu dla całej serii,
   - później w tej samej rozmowie wklejał `Prompt 2` + surowy screenshot 2, itd.

7. Wygeneruj 5 promptów. Każdy prompt wklej jako osobny blok `json`.

   **Prompt 1** ma ustanowić styl całego zestawu:

   ```json
   {
     "asset_type": "universal mobile app store screenshot",
     "input_image": "Attach the raw app screenshot for Screen 1. Treat it as the exact source of the in-app UI.",
     "screen_role": "Style-establishing first screenshot in a five-image store listing set.",
     "app_context": "<short factual context from PUBLISH.md / IDEA.md>",
     "ui_screen_description": "<opis UI z PUBLISH.md>",
     "headline_text": "<dokładny marketingowy tytuł z PUBLISH.md>",
     "headline_rules": "Render exactly one marketing headline: the headline_text value. Do not add, translate, paraphrase, correct, split into different words, or invent any other overlay text. Existing text inside the app UI screenshot may remain unchanged.",
     "composition": "Create a polished marketing store screenshot in portrait 9:16. Use a neutral, brandless smartphone mockup or clean device frame that is not identifiable as iPhone, Pixel, Android, or any specific platform. The attached app screenshot must stay recognizable and faithful to the real UI.",
     "safe_zone": "Keep all critical content inside the central 70% of the image width. Keep the headline in the upper area with comfortable top padding. Do not place important text, app UI, icons, or decorative elements near the left or right edges. Do not place important information at the very bottom. The next processing step may crop equal width from both sides and may crop extra height from the bottom while preserving the top.",
     "style_direction": "<short visual direction from DESIGN.md or current UI: colors, mood, typography, spacing>",
     "device_rules": "Use a generic modern smartphone silhouette only. No Apple logo, no Android logo, no Dynamic Island, no platform navigation chrome, no App Store or Google Play badges, no brand-specific hardware labels.",
     "store_policy_rules": "The result must accurately represent the current app experience. Do not include prices, discounts, rankings, awards, testimonials, download buttons, store badges, fake ratings, or unverifiable claims. Do not include people using the device.",
     "output_requirements": "Single flat image, portrait 9:16, high resolution, no transparency, no watermark. The headline should occupy no more than about 20% of the total image height."
   }
   ```

   **Prompt 2-5** mają kontynuować styl pierwszego wygenerowanego obrazu:

   ```json
   {
     "asset_type": "universal mobile app store screenshot",
     "input_image": "Attach the raw app screenshot for Screen N. Treat it as the exact source of the in-app UI.",
     "style_reference": "Continue the exact same visual system established by the first generated store screenshot in this same conversation. Treat that first generated image as the main style anchor. Also match the most recent generated store screenshot as a continuity reference. If the generator allows reference images, attach the first generated image and the most recent generated image in addition to the raw app screenshot for this screen.",
     "screen_role": "Continuation screenshot N in the same five-image store listing set.",
     "app_context": "<short factual context from PUBLISH.md / IDEA.md>",
     "ui_screen_description": "<opis UI z PUBLISH.md>",
     "headline_text": "<dokładny marketingowy tytuł z PUBLISH.md>",
     "headline_rules": "Render exactly one marketing headline: the headline_text value. Do not add, translate, paraphrase, correct, split into different words, or invent any other overlay text. Existing text inside the app UI screenshot may remain unchanged.",
     "composition": "Match the generated images from this same conversation as closely as possible: same background system, same typography style, same device treatment, same lighting, same spacing logic, same polish level. Only change the app screenshot content and the headline.",
     "safe_zone": "Keep all critical content inside the central 70% of the image width. Keep the headline in the upper area with comfortable top padding. Do not place important text, app UI, icons, or decorative elements near the left or right edges. Do not place important information at the very bottom. The next processing step may crop equal width from both sides and may crop extra height from the bottom while preserving the top.",
     "device_rules": "Use the same generic, brandless smartphone treatment as the generated images from this same conversation. No Apple logo, no Android logo, no Dynamic Island, no platform navigation chrome, no App Store or Google Play badges, no brand-specific hardware labels.",
     "store_policy_rules": "The result must accurately represent the current app experience. Do not include prices, discounts, rankings, awards, testimonials, download buttons, store badges, fake ratings, or unverifiable claims. Do not include people using the device.",
     "output_requirements": "Single flat image, portrait 9:16, high resolution, no transparency, no watermark. The headline should occupy no more than about 20% of the total image height."
   }
   ```

   W realnych promptach nie zostawiaj placeholderów. Podmień `Screen N`, `app_context`, `ui_screen_description`, `headline_text` i `style_direction` na konkretne wartości.

8. Po promptach powiedz mi:
   - Wygeneruj 5 obrazów, po jednym dla każdego promptu.
   - Jeśli generator przekręci tytuł, doda drugi tekst, doda logo platformy, zrobi iPhone/Pixel-specific mockup albo wytnie ważny element przy krawędzi, wygeneruj ponownie.
   - Zapisz wybrane 5 obrazów w projekcie jako:

     ```text
     assets/images/store/screenshots/raw/01.jpg
     assets/images/store/screenshots/raw/02.jpg
     assets/images/store/screenshots/raw/03.jpg
     assets/images/store/screenshots/raw/04.jpg
     assets/images/store/screenshots/raw/05.jpg
     ```

     Dopuszczalne są też `.png` lub `.jpeg`, ale nazwy muszą zaczynać się od `01`-`05`, żeby krok 20 zachował kolejność.

9. Zatrzymaj się i czekaj, aż potwierdzę, że pliki są zapisane w `assets/images/store/screenshots/raw/`.

**Nic nie commituj w tym kroku** — to instrukcja pracy z zewnętrznym AI generatorem.

## FINISH
Gdy potwierdzę, że mam 5 wygenerowanych obrazów w `assets/images/store/screenshots/raw/`, zasugeruj napisanie `next`. Kolejny krok: `20_publish-screenshots-resize.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/07_publish/20_publish-screenshots-resize.md`.

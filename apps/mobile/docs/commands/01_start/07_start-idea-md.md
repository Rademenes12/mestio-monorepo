# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Utwórz plik docs/IDEA.md

# Task

1. Upewnij się czy masz wszystkie dane, które musisz dostarczyć do `docs/IDEA.md`, aby ten pomysł w nim opisać.
    - Jeżeli tak - wypełnij ten plik od razu
    - Jeżeli brakuje Ci informacji - prowadź dalej dialog ze mną, aby doprecyzować ostatnie kwestie.

Mając imię i nazwisko autora oraz __APP_DISPLAY_NAME__ z poprzednich kroków utwórz __APP_BUNDLE_ID__ w formacie: com.imienazwisko.appname (wszystko z małych liter [a-z], żadnych cyf, żadnych znaków specjalnych, brak polskich znaków).

Ustal table prefix (__SUPABASE_TABLE_PREFIX__) dla Supabase (ustaw jako ostatni segment `APP_BUNDLE_ID` z dopisanym `_` - przykład: `com.adamsmaka.mytodoapp` -> `mytodoapp_`).

Template w którym pracujemy uwzglednia już ekran Welcome Screen, ekrany logowania, rejestracji, profilu oraz ustawień więc nie musisz tego dodatkowo opisywać.

Plik `docs/IDEA.md` ma być na tyle obszerny, byśmy mogli tym jedynym plikiem, w pełni przedstawić założenia tego projektu.

Jeżeli czujesz potrzebę dopisać tam więcej niż zakładają predefiniowane sekcje to śmiało.

W sekcji `## Raw User Input About The App` wklej moje dosłowne wypowiedzi z rozmowy o pomyśle na aplikację.
Ta sekcja ma zawierać surowy zapis 1:1 tego, co naprawdę napisałem.
Nie streszczaj tej części, nie parafrazuj jej i nie poprawiaj mojego języka.
Zachowaj kolejność chronologiczną.
Umieszczaj tam tylko moje wypowiedzi związane z pomysłem, kierunkiem aplikacji, grupą docelową, problemem, MVP, nazwą lub innymi decyzjami produktowymi.

2. Po utworzeniu pliku, zaleć mi, żebym go przeczytał i zaakceptował. Jeżeli mam jakieś uwagi, popraw je.

3. Gdy zaakceptuję plik `docs/IDEA.md` - zacommituj go do repository.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `08_start-app-bundle-id.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/01_start/08_start-app-bundle-id.md`.

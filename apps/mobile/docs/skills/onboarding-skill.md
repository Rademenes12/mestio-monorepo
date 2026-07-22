---
name: app-onboarding
description: Wspolna interpretacja najlepszych ksiazek o onboardingu mobilnym
user-invocable: true
---

## Główna zasada

Domyślny onboarding w tym projekcie ma:

- możliwie szybko doprowadzić do pierwszej wartości,
- wymagać minimalnego wysiłku poznawczego,
- sprawiać wrażenie personalizacji, a nie feature touru,
- zostawiać część edukacji na później, we właściwym kontekście,
- być krótki i wiarygodny.

## Wspólna interpretacja książek

### 1. First value wygrywa

Najpierw użytkownik ma poczuć sens aplikacji. Nie tłumacz wszystkiego od razu. Jeśli coś można odroczyć do momentu, gdy użytkownik zobaczy wartość, odrocz to.

W praktyce:

- nie buduj onboardingów wokół listy funkcji,
- nie wymagaj ciężkiego formularza na starcie,
- jeśli możesz, prowadź do pierwszego sensownego stanu lub prostego efektu.

### 2. Niski wysiłek poznawczy jest obowiązkowy

Onboarding mobilny ma działać w trybie szybkich, prostych decyzji. Użytkownik ma tapować bez zastanawiania się, co autor miał na myśli.

W praktyce:

- jeden ekran powinien mieć jeden dominujący cel,
- pytania mają być lekkie i intuicyjne,
- CTA ma być oczywiste,
- liczba opcji ma być mała,
- jeśli coś wymaga dłuższego myślenia, zwykle dzieje się za wcześnie.

### 3. Personalizacja tak, ale tylko realna

Pytania onboardingowe mają sens tylko wtedy, gdy rzeczywiście zmieniają doświadczenie użytkownika. Nie pytaj tylko po to, żeby "zwiększyć zaangażowanie".

W praktyce:

- pytaj o rzeczy, które wpływają na copy, startowy stan, pierwszy content albo następny krok,
- lekka inwestycja użytkownika jest dobra tylko wtedy, gdy daje sensowną korzyść później,
- nie udawaj personalizacji, jeśli aplikacja nic z tej odpowiedzi nie zrobi.

### 4. Edukację rozkładaj w czasie

Nie próbuj upchnąć całego produktu w pierwszych minutach. Część rzeczy powinna być tłumaczona dopiero wtedy, gdy użytkownik naprawdę ich potrzebuje.

W praktyce:

- onboarding początkowy ma przygotować start, nie zastąpić całej edukacji produktu,
- bardziej zaawansowane wskazówki dawaj później, kontekstowo,
- jeśli coś można wyjaśnić na pierwszym użyciu funkcji, zwykle nie trzeba tego wciskać do flow startowego.

### 5. Postęp ma pomagać, nie manipulować

Pasek postępu i rozbijanie flow na małe kroki pomagają domknąć proces. To jest użyteczne, dopóki nie zamienia się w tani teatr.

W praktyce:

- jeśli flow ma kilka kroków, pokazuj postęp,
- jeden ekran, jedna decyzja, to zwykle dobry kierunek,
- możesz użyć lekkiego poczucia postępu, ale bez agresywnego "growth theater",
- nie wydłużaj flow tylko po to, żeby pasek wyglądał efektownie.

### 6. Zaufanie przed permission promptem

Permission priming jest sensowny, ale tylko wtedy, gdy permission jest naprawdę potrzebne i ma pojawić się zaraz.

W praktyce:

- nie pokazuj permission screenu "na zapas",
- najpierw wyjaśnij korzyść dla użytkownika,
- dopiero potem wywołaj natywny prompt,
- jeśli permission nie jest potrzebne do pierwszej wartości, lepiej odroczyć je do właściwego momentu w aplikacji.

### 7. Retencja jest ważna, ale nie może psuć startu

Lekka inwestycja użytkownika może pomóc w D1 i D7, ale onboarding nie może wyglądać jak pułapka pod przyszłe notyfikacje.

W praktyce:

- preferuj małe inwestycje, które poprawiają doświadczenie już teraz,
- nie zbieraj danych tylko po to, by później mieć pretekst do pushy,
- najpierw użyteczność, potem retention mechanics.

### 8. Benchmarki są inspiracją, nie źródłem prawdy

Patrz na wzorce z rynku, ale nie kopiuj ich bezmyślnie. Duże aplikacje optymalizują flow pod własny model biznesowy, nie pod ten template.

W praktyce:

- używaj benchmarków do inspiracji w układzie, rytmie i detalu,
- nie kopiuj długości flow ani innych wzorców tylko dlatego, że działają u kogoś innego,
- najpierw dopasowanie do produktu, potem inspiracje z rynku.

## Priorytety przy konfliktach

Jeśli zasady z różnych źródeł ciągną w różne strony, stosuj tę kolejność:

1. Reguły z `AGENTS.md` i bieżącego polecenia.
2. Pierwsza wartość i sens produktu.
3. Niski wysiłek poznawczy.
4. Krótki, prosty flow.
5. Realna personalizacja.
6. Edukacja kontekstowa po wejściu do aplikacji.
7. Retencja i lekkie inwestycje użytkownika.
8. Permission priming.
9. Benchmarki i inspiracje z rynku.

## Twarde reguły tego repo

- Respektuj `AGENTS.md` oraz bieżące polecenie
- Onboarding dotyczy tylko użytkownika-gościa. Użytkownik zalogowany nie powinien go przechodzić.
- Do ostatniego ekranu onboardingu nie zmieniaj auth/session state aplikacji.
- Akcja `Continue as guest` ma finalnie uruchamiać onboarding, a samo tworzenie konta gościa ma nastąpić dopiero na ostatnim ekranie flow.
- Jeśli onboarding zbiera imię lub pierwszy obiekt domenowy, zapisz go dopiero na końcu flow, nie w połowie.
- Przy implementacji nie hardcoduj stringów widocznych dla użytkownika. Używaj lokalizacji.
- Przy implementacji trzymaj się Clean Architecture, `Cubit`, `Repository`, `Data Source` i zasad z `AGENTS.md`.

## Reguły projektowe dla tego template'u

### 1. Personalizacja ponad feature tour

Użytkownik ma mieć poczucie:

- "ta aplikacja rozumie, po co tu przyszedłem",
- "ustawiam ją pod siebie",
- "zaraz zobaczę coś użytecznego dla mnie".

Nie buduj onboardingu jako slajdów o funkcjach.

Dobrze jest pokazać `Differentiation` jako prosty kontrast: inne aplikacje robią X, ta aplikacja robi Y. Krótko, wizualnie, bez wymieniania konkurencji z nazwy.

### 2. Każdy ekran musi mieć powód istnienia

Domyślnie preferuj krótki flow. Najczęściej wystarczy `3-6` ekranów.

Każdy ekran powinien robić co najmniej jedną z tych rzeczy:

- ustawiać kontekst i obietnicę wartości,
- zbierać dane potrzebne do personalizacji,
- pomagać uniknąć pustego stanu po wejściu do aplikacji,
- przygotowywać sensowny finał flow.

Jeśli ekran nic realnie nie wnosi, usuń go.

### 3. Pytaj tylko o to, co zmienia doświadczenie

Dobre pytania onboardingowe:

- wpływają na kolejne ekrany,
- wpływają na końcowy stan po onboardingu,
- pomagają lepiej dobrać pierwszy content lub pierwszy krok.

Złe pytania onboardingowe:

- są tylko "dla marketingu",
- nie mają wpływu na nic,
- wydłużają flow bez poprawy pierwszej wartości.

### 4. Domyślnie odkładaj rzeczy na później

Odrocz, jeśli nie jest niezbędne od razu:

- rejestrację,
- bardziej zaawansowane objaśnienia,
- permissions,
- skomplikowane konfiguracje,
- dłuższe formularze.

### 5. Unikaj growth theater

Domyślnie nie dokładaj:

- permission priming screenów bez realnej potrzeby,
- viral/share momentów,
- processing screenów tylko dla efektu,
- skomplikowanych quizów,
- sztucznie rozciągniętych flow.

Dodawaj je wyłącznie wtedy, gdy wynikają z realnych potrzeb tej aplikacji i aktualnego zadania użytkownika.

## Szybki test jakości ekranu

Przed dodaniem ekranu sprawdź:

- czy ten ekran skraca drogę do pierwszej wartości albo sensownie zmniejsza ryzyko porzucenia,
- czy odpowiedź użytkownika realnie coś zmienia,
- czy tę rzecz można byłoby wyjaśnić później, kontekstowo,
- czy użytkownik od razu rozumie, co ma zrobić,
- czy po tym kroku aplikacja staje się dla niego bardziej użyteczna.

Jeśli większość odpowiedzi brzmi "nie", ekran prawdopodobnie nie powinien istnieć.

## Zasady copy

- Pisz krótko i po ludzku.
- Unikaj marketingowego nadmuchania.
- Użytkownik ma rozumieć od razu, po co jest dany krok.
- Mów językiem korzyści, ale konkretnie.
- Jeśli aplikacja jest jeszcze template'em, nie udawaj gotowych obietnic produktu, których repo jeszcze nie wspiera.

## Oczekiwany styl pracy

- Najpierw zrozum istniejącą aplikację.
- Potem zaproponuj najprostszy sensowny onboarding.
- Dopiero później buduj.
- Nie próbuj robić "najbardziej konwertującego onboardingu na świecie".
- Zrób onboarding, który pasuje do tej aplikacji, tego template'u i tego repo.

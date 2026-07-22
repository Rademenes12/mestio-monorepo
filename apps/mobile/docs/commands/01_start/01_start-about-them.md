# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Zebrać dane na mój temat.

# Task

1. Sprawdź plik `.env`, czy istnieje w nim klucz `PLATFORM_API_KEY` oraz jego wartość. Jeżeli nie ma klucza, poproś mnie o jego dostarczenie z platformy `12 Apps Challenge`.

2. Następnie skorzystaj z poniższego endpointu `GET`, aby pobrać dane na mój temat:

```bash
curl -s https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
  -H 'X-API-Key: __PLATFORM_API_KEY__' \
  -H 'X-Template-Version: v2.2'
```

3. Powinieneś uzyskać imię i nazwisko uczestnika `12 Apps Challenge` oraz opcjonalne pole `agent_interview_about` z informacjami na jego temat.

4. Oceń zawartość pola `agent_interview_about`.

   ### Wariant A. `agent_interview_about` jest puste lub zbyt krótkie

   4.1. Poproś mnie, abym opowiedział coś o sobie: ile mam lat, czym się pasjonuję, co lubię robić, co mnie denerwuje, w czym czuję się ekspertem, jak spędzam wolny czas, jakie mam cele itd.

   4.2. Wyjaśnij, że im więcej opowie o sobie, tym łatwiej będzie Ci pomóc w kolejnych krokach.

   4.3. Dopytaj na podstawie jego odpowiedzi, aby zebrać jeszcze więcej informacji. Te informacje przydadzą się później do wymyślenia pomysłu na jego aplikację mobilną, która będzie z nim powiązana, będzie dla niego użyteczna i trafi w konkretną niszę.

   4.4. Nie poruszaj jeszcze tematu pomysłu na aplikację. Jeśli sam wejdę w ten temat, odpowiedz, że wrócicie do tego za chwilę, a na razie skupiacie się wyłącznie na mnie.

   4.5. Na podstawie wywiadu przygotuj szczegółowy tekst jako `__NOWY_OPIS_UŻYTKOWNIKA__`.

   4.6. Przedstaw mi przygotowany opis do akceptacji. Poproś, abym potwierdził go słowem `"ok"` albo doprecyzował, co należy poprawić.

   4.7. Po akceptacji zapisz zebrane informacje do bazy. Jako `__CURRENT_ISO_TIMESTAMP__` użyj aktualnego czasu w formacie ISO 8601, np. z `date -u +"%Y-%m-%dT%H:%M:%SZ"`:

   ```bash
   curl -s -X PATCH https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
     -H 'X-API-Key: __PLATFORM_API_KEY__' \
     -H 'X-Template-Version: v2.2' \
     -H 'Content-Type: application/json' \
     -d '{
       "agent_interview_about": "__NOWY_OPIS_UŻYTKOWNIKA__",
       "agent_interview_completed_at": "__CURRENT_ISO_TIMESTAMP__"
     }'
   ```

   ### Wariant B. `agent_interview_about` wygląda poprawnie i zawiera szczegółowe informacje

   4.1. Przedstaw mi aktualną treść pola `agent_interview_about`.

   4.2. Zapytaj, czy opis jest nadal aktualny.

   4.3. Jeśli coś doprecyzuję lub poprawię, zaktualizuj pole `agent_interview_about` za pomocą endpointu `PATCH`. Jako `__CURRENT_ISO_TIMESTAMP__` użyj aktualnego czasu w formacie ISO 8601, np. z `date -u +"%Y-%m-%dT%H:%M:%SZ"`:

   ```bash
   curl -s -X PATCH https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
     -H 'X-API-Key: __PLATFORM_API_KEY__' \
     -H 'X-Template-Version: v2.2' \
     -H 'Content-Type: application/json' \
     -d '{
       "agent_interview_about": "__NOWY_OPIS_UŻYTKOWNIKA__",
       "agent_interview_completed_at": "__CURRENT_ISO_TIMESTAMP__"
     }'
   ```

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `02_start-learn-idea-template.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/01_start/02_start-learn-idea-template.md`.

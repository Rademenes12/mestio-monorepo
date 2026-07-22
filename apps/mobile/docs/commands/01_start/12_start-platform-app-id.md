# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Dodać aplikację do platformy `12 Apps Challenge`

# Task

W pliku `.env` powinien być X-API-Key do Platformy. 
Przeczytaj aktualną treść `docs/IDEA.md`, a następnie dodaj następujące dane o aplikacji do mojego konta:

curl -s -X POST https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user/apps \
  -H "X-API-Key: __PLATFORM_API_KEY__" \
  -H "X-Template-Version: v2.2" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "__APP_DISPLAY_NAME__",
    "description": "__APP_DESCRIPTION__",
    "bundle_id": "__APP_BUNDLE_ID__",
    "table_prefix": "__SUPABASE_TABLE_PREFIX__",
    "template_version": "v2.2",
    "idea_md": "__IDEA_MD_CONTENT__"
  }'

Jeżeli request zakończy się sukcesem i endpoint zwróci response w stylu `{ "id": "..." }`, zapisz ten identyfikator do `.env` jako `APP_PLATFORM_ID=...`.

Po zapisaniu `APP_PLATFORM_ID` zsynchronizuj stage `start` jako `in_progress` przez `PATCH /functions/v1/apps-api/user/apps/:appId/stage`, używając `PLATFORM_API_KEY`, `APP_PLATFORM_ID`, `X-Template-Version: v2.2` i `template_version: "v2.2"`.

To jednorazowy wyjątek: na faktycznym starcie etapu `start` nie ma jeszcze app id, więc normalny sync z `STATE.md` może być wtedy pominięty.

```bash
curl -s -X PATCH "https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user/apps/${APP_PLATFORM_ID}/stage" \
  -H "X-API-Key: ${PLATFORM_API_KEY}" \
  -H "X-Template-Version: v2.2" \
  -H "Content-Type: application/json" \
  -d '{"stage":"start","status":"in_progress","template_version":"v2.2"}'
```

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `13_start-checklist.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/01_start/13_start-checklist.md`.

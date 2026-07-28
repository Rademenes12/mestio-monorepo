# Telegram Bot — instrukcja konfiguracji

## Krok 1: Stwórz bota u @BotFather

1. Otwórz Telegram, znajdź **@BotFather**
2. Wyślij `/newbot`
3. Podaj nazwę: `Mestio CRM` (lub dowolną)
4. Podaj username: `mestio_crm_bot` (musi kończyć się na `bot`)
5. Dostaniesz **token** — skopiuj go

## Krok 2: Znajdź swój Chat ID

1. Otwórz czat ze swoim nowym botem
2. Wyślij `/start`
3. Otwórz w przeglądarce:
   `https://api.telegram.org/bot<TWOJ_TOKEN>/getUpdates`
4. Z JSON-a wyciągnij `message.chat.id` (liczba, np. `123456789`)

## Krok 3: Ustaw secrets w Supabase

```bash
# W terminalu na VPS:
cd /opt/data/mestio-monorepo/apps/mobile

npx supabase secrets set TELEGRAM_BOT_TOKEN="<token_z_botfather>"
npx supabase secrets set TELEGRAM_CHAT_ID="<twoj_chat_id>"
```

## Krok 4: Ustaw Chat ID w Vault (dla DB triggera)

Wejdź w **Supabase Dashboard → SQL Editor** i wykonaj:

```sql
-- Nadpisz placeholder swoim chat_id
SELECT vault.update_secret(
  (SELECT id FROM vault.secrets WHERE name = 'telegram_chat_id'),
  '<TWOJ_CHAT_ID>'
);
```

## Test

Dodaj nowego leada przez formularz na mestio.pl/zamow — powinieneś dostać powiadomienie w Telegramie.

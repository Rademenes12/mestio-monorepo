# Autenti Integration — Mestio CRM

## Docs URL
https://developers.autenti.com (requires JavaScript — Stoplight API portal)

Support: https://autenti.com/pl/kontakt | support@autenti.com
Pricing: https://autenti.com/pl/cennik/api

## API Base URLs

| Mode     | URL                                 |
|----------|--------------------------------------|
| Sandbox  | `https://api.sandbox.autenti.com/api/v1` |
| Live     | `https://api.autenti.com/api/v1`     |

## Authentication

```
Authorization: Bearer {AUTENTI_API_KEY}
```

Klucz API generowany w panelu Autenti (Ustawienia → API). Trzymany w Supabase Edge Function secrets.

## Endpoints

### POST /api/v1/documents — utwórz dokument do podpisu

**Request body:**
```json
{
  "title": "Umowa Mestio — Standard",
  "description": "Optional description",
  "recipients": [
    {
      "email": "klient@firma.pl",
      "name": "Jan Kowalski",
      "role": "SIGNER",
      "signingOrder": 1
    }
  ],
  "files": [
    {
      "name": "umowa.pdf",
      "content": "<base64-encoded PDF>",
      "content_type": "application/pdf"
    }
  ],
  "callback_url": "https://{project}.supabase.co/functions/v1/autenti-webhook",
  "sign_type": "standard",
  "language": "pl"
}
```

**Response 201:**
```json
{
  "id": "doc-uuid-here",
  "status": "WAITING",
  "recipients": [
    {
      "id": "rec-uuid",
      "email": "klient@firma.pl",
      "name": "Jan Kowalski",
      "status": "WAITING"
    }
  ],
  "links": [
    {
      "href": "https://app.autenti.com/documents/doc-uuid-here",
      "rel": "self",
      "method": "GET"
    }
  ],
  "created_at": "2025-01-01T12:00:00Z"
}
```

### GET /api/v1/documents/{id} — status dokumentu

**Response 200:**
```json
{
  "id": "doc-uuid",
  "status": "COMPLETED",
  "recipients": [
    { "email": "klient@firma.pl", "status": "SIGNED" }
  ]
}
```

### GET /api/v1/documents/{id}/file — pobierz podpisany PDF

Zwraca `application/pdf`. 404 jeśli dokument jeszcze niepodpisany.

## Webhook

POST na `callback_url` przy każdej zmianie statusu.

**Payload:**
```json
{
  "document_id": "doc-uuid",
  "status": "COMPLETED",
  "event": "document_completed",
  "recipients": [
    { "email": "klient@firma.pl", "name": "Jan Kowalski", "status": "SIGNED" }
  ]
}
```

**Statusy:** `PENDING` → `COMPLETED` | `DECLINED` | `EXPIRED` | `CANCELLED`

## Recenzja — mapowanie statusów Autenti → Mestio

| Autenti Status | `client_documents.status` | `client_documents.autenti_status` |
|---|---|---|
| `PENDING` | `sent` | `pending` |
| `COMPLETED` | `signed` | `completed` |
| `DECLINED` | `draft` | `declined` |
| `EXPIRED` | `draft` | `expired` |
| `CANCELLED` | `draft` | `cancelled` |

## Signature Types

| Type | Description |
|---|---|
| `standard` | Zwykły e-podpis Autenti (wystarcza dla większości umów B2B) |
| `qualified` | Podpis kwalifikowany (QES, równoważny odręcznemu) |

## Konfiguracja w Supabase

Ustaw sekrety w Edge Functions (Supabase CLI):

```bash
supabase secrets set AUTENTI_API_KEY=autenti_live_...
supabase secrets set AUTENTI_MODE=sandbox   # lub "live"
supabase secrets set CRM_API_KEY=<generated-uuid>
```

Dodatkowo w `.env.local` dla Next.js:

```
SUPABASE_AUTENTI_SEND_URL=https://{project}.supabase.co/functions/v1/send-to-autenti
CRM_API_KEY=<same-as-above>
```

## Bezpieczeństwo

- Klucz API Autenti **nigdy** nie jest przechowywany w bazie danych czytelnej z przeglądarki
- Sekrety Edge Functions są dostępne tylko po stronie serwera
- Webhook autoryzowany przez sprawdzenie `document_id` pasującego do rekordu w bazie
- Cron API key (`CRM_API_KEY`) chroni wewnętrzne wywołania między Next.js a Edge Functions

## Flow testowy (sandbox)

1. Ustaw `AUTENTI_MODE=sandbox` w Supabase Edge Function secrets
2. Wygeneruj klucz sandboxowy w panelu Autenti (https://app.autenti.com → Ustawienia → API)
3. Umieść go jako `AUTENTI_API_KEY`
4. Wygeneruj umowę w CRM Owner → "Wyślij do podpisu"
5. Sprawdź w panelu Autenti Sandbox czy dokument się pojawił
6. Podpisz testowo → webhook zaktualizuje status w CRM

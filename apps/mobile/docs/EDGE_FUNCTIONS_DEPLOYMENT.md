# FixFlow Edge Functions Deployment

## Wymagania

1. Supabase CLI zainstalowane globalnie:
   ```bash
   npm install -g supabase
   ```

2. Zalogowanie do Supabase:
   ```bash
   supabase login
   ```

3. Plik `.env` z `SUPABASE_PROJECT_ID`

## Deployment

### Opcja 1: Skrypt automatyczny

```bash
chmod +x deploy-edge-functions.sh
./deploy-edge-functions.sh
```

### Opcja 2: Ręczny deployment

```bash
# Deploy fixflow-cleanup
supabase functions deploy fixflow-cleanup --project-ref $SUPABASE_PROJECT_ID

# Deploy delete-account
supabase functions deploy delete-account --project-ref $SUPABASE_PROJECT_ID

# Deploy send-notification (wymaga Firebase credentials)
supabase functions deploy send-notification --project-ref $SUPABASE_PROJECT_ID
```

## Sekrety (Secrets)

Edge function `send-notification` wymaga Firebase credentials:

```bash
supabase secrets set FIREBASE_PROJECT_ID=your_project_id
supabase secrets set FIREBASE_CLIENT_EMAIL=your_client_email@your_project.iam.gserviceaccount.com
supabase secrets set FIREBASE_PRIVATE_KEY='-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n'
```

**Uwaga:** `FIREBASE_PRIVATE_KEY` musi być w formacie z `\n` zamiast rzeczywistych nowych linii.

## Weryfikacja

Po deploymentzie sprawdź w Supabase Dashboard → Edge Functions czy funkcje są aktywne.

Przetestuj usuwanie konta w aplikacji - powinno działać bez błędów.

## Rozwiązywanie problemów

### Błąd "Nie udało się usunąć konta"

1. Sprawdź czy edge functions są wdrożone:
   ```bash
   supabase functions list --project-ref $SUPABASE_PROJECT_ID
   ```

2. Sprawdź logi edge function:
   ```bash
   supabase functions logs fixflow-cleanup --project-ref $SUPABASE_PROJECT_ID
   supabase functions logs delete-account --project-ref $SUPABASE_PROJECT_ID
   ```

3. Upewnij się że `SUPABASE_SERVICE_ROLE_KEY` jest ustawiony w secrets:
   ```bash
   supabase secrets list --project-ref $SUPABASE_PROJECT_ID
   ```

### Błąd Firebase credentials

Jeśli `send-notification` nie działa, sprawdź:
```bash
supabase secrets list --project-ref $SUPABASE_PROJECT_ID | grep FIREBASE
```

Upewnij się że wszystkie trzy zmienne są ustawione.

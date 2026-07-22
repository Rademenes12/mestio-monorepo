# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Upewnienie się, że skonfigurowałem wymagane ustawienia w dashboardzie Supabase.

# Task

1. Poproś mnie, abym wszedł do dashboardu Supabase dla tego projektu: **Authentication → Sign In / Providers**.
2. Poproś go o sprawdzenie i ustawienie trzech przełączników:
   - **Allow manual linking** → ON
   - **Allow anonymous sign-ins** → ON
   - **Confirm email** → OFF
3. Następnie poproś mnie, abym wszedł do: **Authentication → Email → Templates → Reset Password**.
4. Poleć mi podmienić treść template na:

```html
<h2>Reset Password</h2>

<p>Your password reset code:</p>
<h1>{{ .Token }}</h1>
<p>Enter this code in the app to reset your password.</p>
```

5. Powiedz krótko, że dzięki temu Supabase będzie wysyłał kod resetu hasła zamiast linka.
6. Poczekaj, aż potwierdzę, że ustawienia są poprawne.

## FINISH
Poinformuj mnie o rezultatach i zasugeruj mi napisanie `next`. Kolejny krok: `07_init-api-keys-create.md`.

Nie przechodź dalej dopóki nie napiszę `next`.
Gdy napiszę `next`, przejdź do `docs/commands/00_init/07_init-api-keys-create.md`.

# ⏰ Apple JWT Token - Przypomnienie o wygaśnięciu

## ⚠️ KRYTYCZNE: Token wygasa 28.12.2026

Apple OAuth JWT token użyty w Supabase ma **ograniczoną ważność**.

---

## 📅 Ważne daty:

| Data | Akcja |
|------|-------|
| **28.12.2026** | ❌ Token WYGASA - użytkownicy nie będą mogli zalogować się przez Apple |
| **~20.12.2026** | ⚠️ Zalecane: Wygeneruj nowy token (tydzień przed wygaśnięciem) |

---

## 🔄 Jak odświeżyć token:

### Krok 1: Wygeneruj nowy JWT

```bash
cd C:\12appsChallange\apps5
node generate-apple-jwt.js
```

### Krok 2: Zaktualizuj w Supabase

1. Wejdź: https://supabase.com/dashboard/project/rtyywhbisjaxlpjcugdk/auth/providers
2. Znajdź **Apple** provider
3. W polu **"Secret Key (for OAuth)"** wklej **NOWY token**
4. Kliknij **Save**

**WAŻNE:** Nie musisz zmieniać:
- Client IDs (pozostaje: `com.pawelpasik.fixflow.auth`)
- Callback URL
- Klucza w Apple Developer Console

---

## 📋 Checklist przed wygaśnięciem:

- [ ] Uruchom `node generate-apple-jwt.js`
- [ ] Skopiuj wygenerowany JWT
- [ ] Wklej do Supabase (Secret Key)
- [ ] Zapisz (Save)
- [ ] Przetestuj logowanie Apple w aplikacji
- [ ] Zanotuj nową datę wygaśnięcia (+6 miesięcy)

---

## 🚨 Co się stanie jeśli zapomnisz:

- ❌ Użytkownicy nie będą mogli zalogować się przez Apple
- ❌ Istniejące sesje Apple mogą przestać działać
- ✅ Email/password login nadal będzie działać
- ✅ Nie stracisz danych użytkowników

---

## 📆 Dodaj przypomnienie w kalendarzu:

**Tytuł:** "Odśwież Apple JWT token w Supabase"  
**Data:** 20 grudnia 2026  
**Powtarzaj:** Co 6 miesięcy

---

**NASTĘPNE ODŚWIEŻENIE:** 20.12.2026 (zaplanuj przypomnienie!)

/**
 * Telegram Notifier — wysyła powiadomienia do właściciela Mestio.
 *
 * Wywoływana przez:
 *   - DB trigger na INSERT do crm_leads (nowy lead)
 *   - DB trigger na INSERT do crm_interactions (ważna zmiana)
 *   - Ręcznie z kodu (future: feedback, nowy użytkownik)
 *
 * Wymaga secrets:
 *   TELEGRAM_BOT_TOKEN  — token z @BotFather
 *   TELEGRAM_CHAT_ID    — ID czatu właściciela (można ustawić ręcznie)
 *
 * Gdy TELEGRAM_BOT_TOKEN jest pusty, funkcja loguje warning i zwraca
 * 200 z komunikatem "not configured" — nie psuje pipeline'a.
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const BOT_TOKEN = Deno.env.get("TELEGRAM_BOT_TOKEN") ?? "";
const CHAT_ID = Deno.env.get("TELEGRAM_CHAT_ID") ?? "";

const TELEGRAM_API = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;

interface NotificationPayload {
  type: "new_lead" | "stage_change" | "new_signup" | "feedback";
  title: string;
  message: string;
  /** Optional link (URL) to open in the CRM */
  link?: string;
}

function formatMessage(p: NotificationPayload): string {
  const emoji = {
    new_lead: "🆕",
    stage_change: "🔄",
    new_signup: "📱",
    feedback: "💬",
  }[p.type] ?? "🔔";

  let text = `${emoji} *${p.title}*\n\n${p.message}`;
  if (p.link) {
    text += `\n\n[Otwórz w CRM](${p.link})`;
  }
  return text;
}

serve(async (req) => {
  // --- CORS dla wywołań z innego origin ---
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: { "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Methods": "POST" },
    });
  }

  // --- Walidacja metody ---
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "POST only" }), { status: 405 });
  }

  // --- Sprawdź czy bot jest skonfigurowany ---
  if (!BOT_TOKEN) {
    console.warn("⚠️ [TelegramNotifier] TELEGRAM_BOT_TOKEN is empty — skipping");
    return new Response(JSON.stringify({ ok: true, skipped: true, reason: "not configured" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!CHAT_ID) {
    console.warn("⚠️ [TelegramNotifier] TELEGRAM_CHAT_ID is empty — skipping");
    return new Response(JSON.stringify({ ok: true, skipped: true, reason: "chat_id not set" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const payload: NotificationPayload = await req.json();
    const text = formatMessage(payload);

    const resp = await fetch(TELEGRAM_API, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        chat_id: CHAT_ID,
        text,
        parse_mode: "Markdown",
        disable_web_page_preview: true,
      }),
    });

    if (!resp.ok) {
      const errText = await resp.text();
      console.error("❌ [TelegramNotifier] Telegram API error:", errText);
      return new Response(JSON.stringify({ ok: false, error: errText }), { status: 502 });
    }

    const result = await resp.json();
    console.log("✅ [TelegramNotifier] sent:", result?.result?.message_id);
    return new Response(JSON.stringify({ ok: true, message_id: result?.result?.message_id }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error("❌ [TelegramNotifier] internal error:", e);
    return new Response(JSON.stringify({ ok: false, error: String(e) }), { status: 500 });
  }
});

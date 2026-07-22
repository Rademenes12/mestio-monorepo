import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const { prompt } = await request.json();
    if (!prompt || typeof prompt !== "string") {
      return NextResponse.json({ error: "Brak promptu" }, { status: 400 });
    }

    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Nieautoryzowany" }, { status: 401 });
    }

    const { data: settings } = await supabase
      .from("crm_settings")
      .select("value")
      .eq("key", "ai_provider")
      .maybeSingle();

    const cfg = (settings?.value as Record<string, string | null>) ?? {};
    const preferred = cfg.provider || "openai";
    const openaiKey = cfg.apiKey;
    const opencodeKey = cfg.opencodeKey;
    const openrouterKey = cfg.openrouterKey;

    console.log("[ai-assist] Config:", { preferred, hasOpenai: !!openaiKey, hasOpencode: !!opencodeKey, hasOpenrouter: !!openrouterKey });

    if (!openaiKey && !opencodeKey && !openrouterKey) {
      return NextResponse.json(
        { error: "Brak skonfigurowanego klucza API. Dodaj go w Ustawienia → AI." },
        { status: 400 }
      );
    }

    let result: string | null = null;
    const errors: string[] = [];

    // Try providers in order: preferred first, then fallbacks
    const providers: { name: string; key: string | null | undefined; baseUrl: string; model: string; isAnthropic: boolean }[] = [
      { name: "OpenCode", key: opencodeKey, baseUrl: "https://opencode.ai/zen", model: "claude-sonnet-5", isAnthropic: true },
      { name: "OpenAI", key: openaiKey, baseUrl: "https://api.openai.com/v1", model: "gpt-4o-mini", isAnthropic: false },
      { name: "OpenRouter", key: openrouterKey, baseUrl: "https://openrouter.ai/api/v1", model: "anthropic/claude-3.5-sonnet", isAnthropic: false },
    ];

    // Reorder: preferred first
    if (preferred === "anthropic" && openaiKey) {
      // Anthropic uses the same apiKey field
      providers.unshift({ name: "Anthropic", key: openaiKey, baseUrl: "https://api.anthropic.com/v1", model: "claude-3-sonnet-20250514", isAnthropic: true });
    }

    for (const p of providers) {
      if (!p.key) {
        errors.push(`${p.name}: brak klucza`);
        continue;
      }

      try {
        console.log(`[ai-assist] Trying ${p.name}...`);

        if (p.isAnthropic) {
          const res = await fetch(`${p.baseUrl}/messages`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "x-api-key": p.key,
              "anthropic-version": "2023-06-01",
            },
            body: JSON.stringify({
              model: p.model,
              max_tokens: 2048,
              messages: [{ role: "user", content: prompt }],
            }),
          });

          if (!res.ok) {
            const errData = await res.json().catch(() => ({}));
            const msg = (errData as { error?: { message?: string } })?.error?.message ?? `HTTP ${res.status}`;
            errors.push(`${p.name}: ${msg}`);
            console.error(`[ai-assist] ${p.name} error:`, msg);
            continue;
          }

          const data = await res.json() as { content: { text: string }[] };
          result = data.content?.[0]?.text ?? "Brak odpowiedzi";
        } else {
          const res = await fetch(`${p.baseUrl}/chat/completions`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${p.key}`,
            },
            body: JSON.stringify({
              model: p.model,
              max_tokens: 2048,
              messages: [{ role: "user", content: prompt }],
            }),
          });

          if (!res.ok) {
            const errData = await res.json().catch(() => ({}));
            const msg = (errData as { error?: { message?: string } })?.error?.message ?? `HTTP ${res.status}`;
            errors.push(`${p.name}: ${msg}`);
            console.error(`[ai-assist] ${p.name} error:`, msg);
            continue;
          }

          const data = await res.json() as { choices: { message: { content: string } }[] };
          result = data.choices?.[0]?.message?.content ?? "Brak odpowiedzi";
        }

        console.log(`[ai-assist] ${p.name} success`);
        break;
      } catch (e) {
        const msg = e instanceof Error ? e.message : "nieznany błąd";
        errors.push(`${p.name}: ${msg}`);
        console.error(`[ai-assist] ${p.name} exception:`, msg);
        continue;
      }
    }

    if (!result) {
      return NextResponse.json({ error: errors.join(" | ") || "Wszystkie providery zwróciły błąd" }, { status: 400 });
    }

    return NextResponse.json({ result });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Nieznany błąd";
    console.error("[ai-assist] Unhandled error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

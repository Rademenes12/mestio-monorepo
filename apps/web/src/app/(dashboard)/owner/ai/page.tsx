"use client";

import { useState } from "react";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

const AI_TOOLS = [
  {
    title: "Generuj e-mail",
    desc: "Opisz kontekst, AI napisze gotowy draft do edycji i wysłania.",
    icon: "M4 6h16v12H4zM4 6l8 7 8-7",
    color: "#3E7BD6",
    prompt: "Napisz e-mail do klienta. Kontekst: ",
  },
  {
    title: "Newsletter writer",
    desc: "Podaj temat i odbiorców — AI wygeneruje kompletny e-mail HTML ze zdjęciami przygotowany do wysyłki newslettera.",
    icon: "M20 4H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zM22 6l-10 7L2 6",
    color: "#8B5CF6",
    prompt: "Jesteś ekspertem od newsletterów dla branży nieruchomości i zarządzania osiedlami (Mestio). Wygeneruj kompletny e-mail HTML do wysyłki newslettera. Musi zawierać:\n- Temat wiadomości (Subject)\n- Treść HTML z nagłówkami, akapitami, listami (użyj <h2>, <p>, <ul>/<li>, <strong>)\n- 2-3 miejsca na grafiki oznaczone jako [IMAGE: krótki opis co ma być na zdjęciu]\n- Przycisk CTA (Call To Action) jako <a> ostylowany inline\n- Stopkę z linkiem do wypisania\n- Całość w jednym bloku <div style=\"max-width:600px;...\"> gotowym do wklejenia w mailu\n\nTemat newslettera: ",
  },
  {
    title: "Podsumowanie klienta",
    desc: "AI przeczyta historię interakcji i przygotuje zwięzłe podsumowanie.",
    icon: "M9 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM4 20a5 5 0 0 1 10 0",
    color: "#173A6A",
    prompt: "Podsumuj klienta na podstawie historii interakcji. Nazwa firmy: ",
  },
  {
    title: "Blog writer",
    desc: "Podaj temat i słowa kluczowe — AI wygeneruje szkic artykułu SEO.",
    icon: "M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z",
    color: "#2E9E6B",
    prompt: "Napisz szkic artykułu SEO na bloga Mestio. Temat: ",
  },
  {
    title: "Analiza churnu",
    desc: "AI analizuje, kiedy i dlaczego klienci odchodzą, i proponuje działania.",
    icon: "M12 8v4l3 2M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18z",
    color: "#F2A900",
    prompt: "Przeanalizuj churn moich klientów i zaproponuj działania zapobiegawcze.",
  },
];

export default function AiPage() {
  const [prompt, setPrompt] = useState("");
  const [response, setResponse] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [activeTool, setActiveTool] = useState<string | null>(null);

  const pickTool = (tool: (typeof AI_TOOLS)[number]) => {
    setActiveTool(tool.title);
    setPrompt(tool.prompt);
    setResponse(null);
    setError(null);
  };

  const handleAskAi = async () => {
    if (!prompt.trim()) return;
    setLoading(true);
    setError(null);

    try {
      const res = await fetch("/api/ai-assist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt: prompt.trim() }),
      });
      const data = await res.json();
      if (data.error) {
        setError(data.error);
      } else {
        setResponse(data.result ?? data.message);
      }
    } catch {
      setError(
        "Nie można połączyć się z asystentem AI. Edge Function 'ai-assist' nie jest jeszcze skonfigurowana. Skonfiguruj klucz API OpenAI/Anthropic w Ustawieniach."
      );
    }
    setLoading(false);
  };

  return (
    <div className="max-w-4xl mx-auto space-y-[14px]">
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-[14px]">
        {AI_TOOLS.map((t) => {
          const active = activeTool === t.title;
          return (
            <button
              key={t.title}
              onClick={() => pickTool(t)}
              className="bg-white rounded-[12px] border border-[#E9EEF5] p-[22px] text-left transition-all hover:shadow-[var(--shadow-card-hover)]"
              style={{ border: `2px solid ${active ? t.color : "transparent"}` }}
            >
              <div
                className="w-11 h-11 rounded-[13px] flex items-center justify-center"
                style={{ background: tint(t.color, 0.12), color: t.color }}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
                  <path d={t.icon} />
                </svg>
              </div>
              <div className="font-[family-name:var(--font-heading)] font-semibold text-base text-ink mt-[14px]">
                {t.title}
              </div>
              <div className="text-[13px] text-[#5A6B80] leading-normal mt-[6px]">{t.desc}</div>
            </button>
          );
        })}
      </div>

      <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5 space-y-3">
        <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase">
          {activeTool ? `Narzędzie: ${activeTool}` : "Twój prompt"}
        </div>
        <textarea
          value={prompt}
          onChange={(e) => setPrompt(e.target.value)}
          rows={4}
          placeholder="Wybierz narzędzie powyżej albo napisz własne polecenie…"
          className="w-full px-[16px] py-[13px] bg-[#F4F7FB] rounded-[11px] text-[13.5px] text-ink placeholder-[#9AA7B8] outline-none focus:ring-2 focus:ring-azure/30 transition-all resize-none"
        />
        <button
          onClick={handleAskAi}
          disabled={loading || !prompt.trim()}
          className="px-7 py-[12px] bg-gradient-to-br from-azure to-blueprint text-white text-[13.5px] font-semibold rounded-[11px] flex items-center gap-[8px] hover:brightness-105 active:scale-[0.98] transition-all disabled:opacity-50"
        >
          {loading && (
            <svg className="animate-spin" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round">
              <path d="M12 2a10 10 0 0 1 10 10" />
            </svg>
          )}
          {loading ? "AI pracuje..." : "Uruchom"}
        </button>

        {error && (
          <div className="bg-danger/5 text-danger text-[13.5px] px-[16px] py-[12px] rounded-[11px] border border-danger/20 leading-relaxed">
            {error}
          </div>
        )}

        {response && (
          <div className="p-[16px] bg-[#F6F8FB] rounded-[14px]">
            <p className="font-[family-name:var(--font-mono)] text-[10px] text-[#8A98AB] uppercase mb-2">Odpowiedź AI</p>
            <div className="text-[13.5px] text-ink leading-relaxed whitespace-pre-wrap">{response}</div>
          </div>
        )}
      </div>
    </div>
  );
}

"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { useEffect, useState, Suspense } from "react";

interface CodeData {
  code: string;
  usesLeft: number | null;
  validUntil: string;
}

function SukcesContent() {
  const searchParams = useSearchParams();
  const sessionId = searchParams.get("session_id");
  const [codeData, setCodeData] = useState<CodeData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let cancelled = false;

    // The Stripe webhook provisions the estate asynchronously — right after
    // checkout the code may not exist yet. Poll for up to ~30s before
    // showing an error (race condition fix).
    const MAX_ATTEMPTS = 15;
    const RETRY_DELAY_MS = 2000;

    async function loadCode() {
      if (!sessionId) {
        if (!cancelled) {
          setError("Brak identyfikatora sesji.");
          setLoading(false);
        }
        return;
      }

      for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
        if (cancelled) return;

        try {
          const res = await fetch(
            `/api/invitation-code?session_id=${sessionId}`
          );
          if (res.ok) {
            const data: CodeData = await res.json();
            if (!cancelled) {
              setCodeData(data);
              setLoading(false);
            }
            return;
          }

          // Not ready yet — webhook still provisioning. Retry unless
          // this was the last attempt.
          if (attempt === MAX_ATTEMPTS) {
            const json = await res.json().catch(() => null);
            throw new Error(json?.error || "Błąd pobierania kodu");
          }
        } catch (err) {
          if (attempt === MAX_ATTEMPTS) {
            if (!cancelled) {
              setError(
                err instanceof Error
                  ? `${err.message}. Kod znajdziesz też w panelu: panel.mestio.pl`
                  : "Błąd"
              );
              setLoading(false);
            }
            return;
          }
        }

        await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
      }
    }

    loadCode();

    return () => {
      cancelled = true;
    };
  }, [sessionId]);

  return (
    <div className="max-w-[720px] mx-auto px-6 py-[60px] pb-20 text-center">
      <div className="w-[72px] h-[72px] rounded-full bg-[rgba(46,158,107,.13)] flex items-center justify-center mx-auto">
        <svg
          width="38"
          height="38"
          viewBox="0 0 24 24"
          fill="none"
          stroke="#2E9E6B"
          strokeWidth="2.4"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <path d="M5 12l5 5 9-11" />
        </svg>
      </div>

      <h1 className="font-heading font-bold text-[30px] tracking-[-0.5px] mt-5 text-ink">
        Płatność zakończona sukcesem
      </h1>
      <p className="text-base text-[#4A5A6E] mt-[10px] leading-relaxed">
        Twoje osiedle jest już aktywne. Poniżej znajdziesz kod zaproszenia dla
        mieszkańców — skopiuj go i wyślij dalej.
      </p>

      {loading ? (
        <div className="mt-6 text-[#8A98AB]">
          Aktywujemy Twoje osiedle... To może potrwać do 30 sekund.
        </div>
      ) : error ? (
        <div className="mt-6 text-red-500">{error}</div>
      ) : codeData ? (
        <div className="bg-white rounded-[12px] shadow-[0_10px_30px_rgba(14,26,43,.08)] p-6 mt-[26px]">
          <div className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
            Kod zaproszenia dla mieszkańców
          </div>
          <div className="flex items-center justify-center gap-3 mt-3">
            <span className="font-mono font-semibold text-[30px] tracking-[2px] text-blueprint">
              {codeData.code}
            </span>
            <button
              onClick={() => {
                navigator.clipboard.writeText(codeData.code);
              }}
              className="flex items-center gap-[6px] px-[14px] py-[9px] rounded-[11px] bg-[#EAF0F7] text-blueprint text-[13px] font-semibold cursor-pointer hover:bg-[#DCE4F0] transition-colors"
            >
              <svg
                width="15"
                height="15"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#173A6A"
                strokeWidth="1.9"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M9 9h10v10H9zM5 15V5h10" />
              </svg>
              Kopiuj
            </button>
          </div>
          <p className="font-mono text-[11.5px] text-[#9AA7B8] mt-3">
            Ważny do {new Date(codeData.validUntil).toLocaleDateString("pl-PL")}
            {codeData.usesLeft !== null
              ? ` · pozostało użyć: ${codeData.usesLeft}`
              : " · bez limitu użyć"}
          </p>
        </div>
      ) : null}

      <div className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB] mt-7 mb-3">
        Pobierz aplikację dla mieszkańców
      </div>
      <div className="flex gap-3 justify-center flex-wrap">
        <button className="flex items-center gap-[9px] bg-ink text-white px-5 py-[13px] rounded-[13px] cursor-pointer hover:bg-ink/90 transition-colors">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="#fff">
            <path d="M16.4 12.6c0-2 1.6-2.9 1.7-3-1-1.4-2.4-1.6-2.9-1.6-1.2-.1-2.4.7-3 .7-.6 0-1.6-.7-2.6-.7-1.3 0-2.6.8-3.3 2-1.4 2.4-.4 6 1 8 .7 1 1.4 2 2.4 2 1 0 1.3-.6 2.5-.6s1.5.6 2.5.6 1.7-1 2.3-2c.7-1.1 1-2.2 1-2.3-.1 0-2-.8-2-3.1zM14.5 6.3c.5-.7.9-1.6.8-2.5-.8 0-1.7.5-2.3 1.2-.5.6-.9 1.5-.8 2.4.9.1 1.8-.4 2.3-1.1z" />
          </svg>
          <div className="text-left">
            <div className="text-[9px] opacity-80">Pobierz z</div>
            <div className="font-heading font-semibold text-sm">App Store</div>
          </div>
        </button>

        <button className="flex items-center gap-[9px] bg-ink text-white px-5 py-[13px] rounded-[13px] cursor-pointer hover:bg-ink/90 transition-colors">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
            <path d="M4 3l11 9-11 9z" fill="#3E7BD6" />
            <path d="M4 3l8 6-8 6z" fill="#2E9E6B" />
            <path d="M15 12l4-2.3v4.6z" fill="#F2A900" />
          </svg>
          <div className="text-left">
            <div className="text-[9px] opacity-80">Pobierz z</div>
            <div className="font-heading font-semibold text-sm">
              Google Play
            </div>
          </div>
        </button>
      </div>

      <Link
        href="/"
        className="inline-block mt-[30px] text-sm font-semibold text-azure hover:underline"
      >
        &larr; Wróć na stronę główną
      </Link>
    </div>
  );
}

export default function SukcesPage() {
  return (
    <Suspense fallback={<div className="py-20 text-center text-[#8A98AB]">Ładowanie...</div>}>
      <SukcesContent />
    </Suspense>
  );
}

"use client";

import { useState, useEffect } from "react";

interface CookieConsentProps {
  onConsent?: (isAll: boolean) => void;
}

export default function CookieConsent({ onConsent }: CookieConsentProps) {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    const stored = localStorage.getItem("cookie-consent");
    if (stored === null) {
      setVisible(true);
    }
  }, []);

  const accept = (isAll: boolean) => {
    localStorage.setItem("cookie-consent", isAll ? "all" : "necessary");
    setVisible(false);
    onConsent?.(isAll);
  };

  if (!visible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 bg-ink border-t border-white/10 p-4">
      <div className="max-w-[1160px] mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <p className="text-[13px] text-[#C7D2E0] leading-relaxed max-w-[640px]">
          Ta strona używa plików cookie do zapewnienia prawidłowego działania,
          analizy ruchu i personalizacji treści. Więcej informacji znajdziesz w{" "}
          <a href="/polityka" className="text-azure underline">
            polityce prywatności
          </a>
          .
        </p>
        <div className="flex items-center gap-2 shrink-0">
          <button
            type="button"
            onClick={() => accept(false)}
            className="text-[13px] font-semibold text-[#C7D2E0] border border-white/20 px-[14px] py-[9px] rounded-[10px] cursor-pointer hover:bg-white/10 transition-colors whitespace-nowrap"
          >
            Tylko niezbędne
          </button>
          <button
            type="button"
            onClick={() => accept(true)}
            className="text-[13px] font-semibold text-white bg-azure px-[14px] py-[9px] rounded-[10px] cursor-pointer hover:brightness-110 transition-all whitespace-nowrap"
          >
            Akceptuję wszystkie
          </button>
        </div>
      </div>
    </div>
  );
}

"use client";

import { useState } from "react";

export function CopyCodeButton({ code }: { code: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code);
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {
      // clipboard API unavailable — silently ignore
    }
  };

  return (
    <button
      type="button"
      onClick={handleCopy}
      className="text-[10px] px-2 py-1 rounded-lg bg-azure/10 text-azure font-medium hover:bg-azure/20 transition-colors shrink-0"
    >
      {copied ? "Skopiowano" : "Kopiuj"}
    </button>
  );
}

"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function RodoToggle({
  estateId,
  currentValue,
  isAdmin,
}: {
  estateId: string;
  currentValue: boolean;
  isAdmin: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleToggle = async () => {
    if (!isAdmin) return;
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("fixflow_estates")
      .update({ hide_resident_contacts: !currentValue })
      .eq("id", estateId);
    setLoading(false);
    if (updateError) {
      setError(`Nie udało się zmienić ustawienia: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h2 className="font-heading font-semibold text-ink mb-2">
        Ochrona danych (RODO)
      </h2>
      <p className="text-sm text-ink/40 mb-4">
        Gdy włączone, rola zarządu (board) nie widzi telefonów i e-maili
        mieszkańców. Administrator zawsze widzi pełne dane.
      </p>
      <div className="flex items-center gap-3">
        <button
          onClick={handleToggle}
          disabled={loading || !isAdmin}
          className={`relative w-12 h-6 rounded-full transition-all ${
            currentValue ? "bg-amber" : "bg-ink/15"
          } ${!isAdmin ? "opacity-50 cursor-not-allowed" : ""}`}
        >
          <span
            className={`absolute top-0.5 left-0.5 w-5 h-5 rounded-full bg-white transition-all shadow-sm ${
              currentValue ? "translate-x-6" : ""
            }`}
          />
        </button>
        <span
          className={`text-sm font-medium ${currentValue ? "text-amber" : "text-ink/40"}`}
        >
          {currentValue ? "Włączone" : "Wyłączone"}
        </span>
        {!isAdmin && (
          <span className="text-xs text-ink/30">
            (tylko administrator może zmieniać)
          </span>
        )}
      </div>
      {error && <p className="text-[12.5px] text-danger mt-2">{error}</p>}
    </div>
  );
}

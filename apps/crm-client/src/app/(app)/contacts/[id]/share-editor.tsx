"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function ShareEditor({
  residentId,
  estateId,
  initialShareUnits,
  initialTotalShares,
}: {
  residentId: string;
  estateId: string;
  initialShareUnits: number | null;
  initialTotalShares: number | null;
}) {
  const router = useRouter();
  const [shareUnits, setShareUnits] = useState<string>(
    initialShareUnits != null ? String(initialShareUnits) : ""
  );
  const [totalShares, setTotalShares] = useState<string>(
    initialTotalShares != null ? String(initialTotalShares) : "1000"
  );
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSave = async () => {
    setError(null);
    setSaved(false);

    const units = Number(shareUnits);
    const total = Number(totalShares);

    if (shareUnits === "" || !Number.isFinite(units) || units < 0) {
      setError("Udział lokalu musi być liczbą nie mniejszą niż 0.");
      return;
    }
    if (totalShares === "" || !Number.isFinite(total) || total < 1) {
      setError("Suma udziałów osiedla musi być liczbą nie mniejszą niż 1.");
      return;
    }

    setSaving(true);
    const supabase = createClient();

    const { error: profileError } = await supabase
      .from("fixflow_resident_profiles")
      .update({ share_units: Math.round(units) })
      .eq("id", residentId);

    if (profileError) {
      setError(`Nie udało się zapisać udziału lokalu: ${profileError.message}`);
      setSaving(false);
      return;
    }

    const { error: estateError } = await supabase
      .from("fixflow_estates")
      .update({ total_shares: Math.round(total) })
      .eq("id", estateId);

    if (estateError) {
      setError(
        `Nie udało się zapisać sumy udziałów osiedla: ${estateError.message}`
      );
      setSaving(false);
      return;
    }

    setSaving(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 3000);
    router.refresh();
  };

  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="font-heading font-semibold text-ink mb-1">
        Udział w nieruchomości wspólnej
      </h3>
      <p className="text-xs text-ink/40 mb-4">
        Wpisz obie wartości ręcznie — ile ma ten lokal / ile wynosi suma
        udziałów całego osiedla.
      </p>

      <div className="flex items-center gap-3 flex-wrap">
        <div>
          <span className="block text-[11px] uppercase tracking-wide text-ink/45 font-mono font-medium mb-1">
            Udział lokalu
          </span>
          <input
            type="number"
            min={0}
            value={shareUnits}
            onChange={(e) => setShareUnits(e.target.value)}
            disabled={saving}
            className="w-28 px-3 py-2 rounded-lg border border-ink/10 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
            placeholder="np. 54"
          />
        </div>

        <span className="text-xl text-ink/30 font-heading mt-4">/</span>

        <div>
          <span className="block text-[11px] uppercase tracking-wide text-ink/45 font-mono font-medium mb-1">
            Suma udziałów
          </span>
          <div className="flex items-center gap-2">
            <input
              type="number"
              min={1}
              value={totalShares}
              onChange={(e) => setTotalShares(e.target.value)}
              disabled={saving}
              className="w-28 px-3 py-2 rounded-lg border border-ink/10 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
              placeholder="np. 1000"
            />
            <span className="text-xs text-ink/40">łącznie w osiedlu</span>
          </div>
        </div>

        <div className="mt-4 flex items-center gap-3">
          <button
            type="button"
            onClick={handleSave}
            disabled={saving}
            className="px-4 py-2 rounded-lg bg-[#173A6A] text-white text-sm font-medium hover:bg-[#173A6A]/90 transition-colors disabled:opacity-50"
          >
            {saving ? "Zapisywanie…" : "Zapisz"}
          </button>
          {saved && (
            <span className="text-xs text-[#2E9E6B] font-medium">Zapisano</span>
          )}
        </div>
      </div>

      {error && <p className="text-[12.5px] text-danger mt-3">{error}</p>}
    </div>
  );
}

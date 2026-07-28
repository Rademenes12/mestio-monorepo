"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export function ContractForm({
  estateId,
  contractUntil,
}: {
  estateId: string;
  contractUntil: string | null;
}) {
  const router = useRouter();
  const [value, setValue] = useState(contractUntil ?? "");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSave = async () => {
    setError(null);
    setSaving(true);
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("fixflow_estates")
      .update({ contract_until: value || null })
      .eq("id", estateId);
    setSaving(false);
    if (updateError) {
      setError(`Nie udało się zapisać: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  let daysLeft: number | null = null;
  let daysLabel = "—";
  let color = "text-ink/40";
  if (contractUntil) {
    const target = new Date(contractUntil + "T00:00:00");
    daysLeft = Math.ceil((target.getTime() - Date.now()) / (1000 * 60 * 60 * 24));
    daysLabel = daysLeft > 0 ? `${daysLeft} dni` : daysLeft === 0 ? "dziś" : "po terminie";
    color = daysLeft > 30 ? "text-[#2E9E6B]" : daysLeft > 7 ? "text-[#F2A900]" : "text-[#C0392B]";
  }

  const contractHuman = contractUntil
    ? new Date(contractUntil + "T00:00:00").toLocaleDateString("pl-PL", {
        day: "numeric",
        month: "long",
        year: "numeric",
      })
    : "Nie ustawiono";

  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h2 className="font-heading font-semibold text-ink mb-4">Umowa</h2>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[12.5px] text-ink/50">Aktywna do</p>
          <p className="font-heading font-bold text-[18px] text-ink mt-0.5">
            {contractHuman}
          </p>
        </div>
        <div className="text-right">
          <p className="text-[12.5px] text-ink/50">Pozostało</p>
          <p className={`font-heading font-bold text-[18px] mt-0.5 ${color}`}>
            {daysLabel}
          </p>
        </div>
      </div>

      <p className="text-[10px] font-mono uppercase tracking-wide text-ink/40 mt-4 mb-1.5">
        Zmień datę końca umowy
      </p>
      <div className="flex gap-2">
        <input
          type="date"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          disabled={saving}
          className="flex-1 px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleSave}
          disabled={saving}
          className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 disabled:opacity-50 transition-colors"
        >
          {saving ? "Zapisywanie…" : "Zapisz"}
        </button>
      </div>
      {error && <p className="text-[12.5px] text-danger mt-2">{error}</p>}
    </div>
  );
}

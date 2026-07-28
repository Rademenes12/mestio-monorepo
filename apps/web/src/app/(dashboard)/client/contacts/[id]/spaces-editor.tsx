"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export type ResidentSpace = {
  id: string;
  space_type: string;
  label: string;
};

const SPACE_TYPES = [
  "Komórka lokatorska",
  "Piwnica",
  "Miejsce postojowe",
  "Garaż",
  "Inne",
];

export default function SpacesEditor({
  estateId,
  residentId,
  spaces,
}: {
  estateId: string;
  residentId: string;
  spaces: ResidentSpace[];
}) {
  const router = useRouter();
  const [spaceType, setSpaceType] = useState(SPACE_TYPES[0]);
  const [label, setLabel] = useState("");
  const [adding, setAdding] = useState(false);
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleAdd = async () => {
    setError(null);
    if (!label.trim()) {
      setError("Podaj oznaczenie pomieszczenia.");
      return;
    }

    setAdding(true);
    const supabase = createClient();
    const { error: insertError } = await supabase
      .from("fixflow_resident_spaces")
      .insert({
        estate_id: estateId,
        resident_id: residentId,
        space_type: spaceType,
        label: label.trim(),
      });

    setAdding(false);
    if (insertError) {
      setError(`Nie udało się dodać: ${insertError.message}`);
      return;
    }

    setLabel("");
    router.refresh();
  };

  const handleDelete = async (id: string) => {
    setError(null);
    setDeletingId(id);
    const supabase = createClient();
    const { error: deleteError } = await supabase
      .from("fixflow_resident_spaces")
      .delete()
      .eq("id", id);

    setDeletingId(null);
    if (deleteError) {
      setError(`Nie udało się usunąć: ${deleteError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <div className="flex items-baseline justify-between mb-1">
        <h3 className="font-heading font-semibold text-ink">
          Pomieszczenia i miejsca
        </h3>
        <span className="text-[11px] uppercase tracking-wide text-ink/45 font-mono font-medium">
          komórki · piwnice · postojowe
        </span>
      </div>
      <p className="text-xs text-ink/40 mb-4">
        Mieszkaniec uzupełnia je w profilu w aplikacji; pojawiają się tutaj.
        Możesz też dodać ręcznie.
      </p>

      {spaces.length === 0 ? (
        <p className="text-sm text-ink/30 mb-4">
          Brak przypisanych pomieszczeń.
        </p>
      ) : (
        <div className="flex flex-wrap gap-2 mb-4">
          {spaces.map((s) => (
            <div
              key={s.id}
              className="flex items-center gap-2.5 pl-2.5 pr-2 py-2 rounded-xl bg-paper"
            >
              <div className="w-8 h-8 rounded-lg bg-azure/10 flex items-center justify-center shrink-0">
                <svg
                  className="w-4 h-4 text-azure"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth={2}
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M3 21h18M5 21V7l7-4 7 4v14M9 21v-6h6v6"
                  />
                </svg>
              </div>
              <div className="min-w-0">
                <p className="text-sm font-semibold text-ink leading-tight">
                  {s.label}
                </p>
                <p className="text-[11px] uppercase tracking-wide text-ink/45 font-mono font-medium">
                  {s.space_type}
                </p>
              </div>
              <button
                type="button"
                onClick={() => handleDelete(s.id)}
                disabled={deletingId === s.id}
                title="Usuń"
                className="ml-1 w-8 h-8 rounded-full flex items-center justify-center text-danger/70 hover:bg-danger/10 hover:text-danger transition-colors disabled:opacity-40"
              >
                <svg
                  className="w-3.5 h-3.5"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth={2}
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
          ))}
        </div>
      )}

      <div className="flex items-center gap-2 flex-wrap">
        <select
          value={spaceType}
          onChange={(e) => setSpaceType(e.target.value)}
          disabled={adding}
          className="px-3 py-2 rounded-lg border border-ink/10 text-sm text-ink bg-white focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
        >
          {SPACE_TYPES.map((t) => (
            <option key={t} value={t}>
              {t}
            </option>
          ))}
        </select>
        <input
          type="text"
          value={label}
          onChange={(e) => setLabel(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") handleAdd();
          }}
          disabled={adding}
          placeholder="Oznaczenie, np. K-14 / P-42 / poziom -1"
          className="flex-1 min-w-[200px] px-3 py-2 rounded-lg border border-ink/10 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleAdd}
          disabled={adding}
          className="px-4 py-2 bg-[#173A6A] text-white rounded-lg text-sm font-medium hover:bg-[#173A6A]/90 transition-colors disabled:opacity-50"
        >
          {adding ? "Dodawanie…" : "Dodaj"}
        </button>
      </div>

      {error && <p className="text-[12.5px] text-danger mt-3">{error}</p>}
    </div>
  );
}

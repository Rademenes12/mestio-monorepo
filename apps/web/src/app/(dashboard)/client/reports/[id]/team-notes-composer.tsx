"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function TeamNotesComposer({
  reportId,
  existingNotes,
  authorLabel,
}: {
  reportId: string;
  existingNotes: string | null;
  authorLabel: string;
}) {
  const router = useRouter();
  const [draft, setDraft] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleAdd = async () => {
    setError(null);
    if (!draft.trim()) return;
    setSaving(true);
    const supabase = createClient();

    const stamp = new Date().toLocaleString("pl-PL", {
      day: "numeric",
      month: "short",
      hour: "2-digit",
      minute: "2-digit",
    });
    const entry = `[${stamp} · ${authorLabel}] ${draft.trim()}`;
    const nextNotes = existingNotes ? `${existingNotes}\n\n${entry}` : entry;

    const { error: upsertError } = await supabase
      .from("fixflow_report_internal_notes")
      .upsert(
        { report_id: reportId, board_notes: nextNotes },
        { onConflict: "report_id" }
      );

    setSaving(false);
    if (upsertError) {
      setError(`Nie udało się dodać notatki: ${upsertError.message}`);
      return;
    }
    setDraft("");
    router.refresh();
  };

  return (
    <div className="mt-3">
      <div className="flex gap-2">
        <input
          type="text"
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") handleAdd();
          }}
          disabled={saving}
          placeholder="Dodaj notatkę zespołu…"
          className="flex-1 px-3.5 py-2.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleAdd}
          disabled={saving}
          className="px-4 py-2.5 rounded-xl bg-[#173A6A] text-white text-sm font-medium hover:bg-[#173A6A]/90 transition-colors disabled:opacity-50 shrink-0 min-h-[42px]"
        >
          {saving ? "Dodawanie…" : "Dodaj"}
        </button>
      </div>
      {error && <p className="text-[12.5px] text-danger mt-2">{error}</p>}
    </div>
  );
}

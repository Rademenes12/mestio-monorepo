"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export type ContactNote = {
  id: string;
  body: string;
  created_at: string;
};

export default function ContactNotes({
  estateId,
  residentId,
  notes,
}: {
  estateId: string;
  residentId: string;
  notes: ContactNote[];
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
    const { error: insertError } = await supabase
      .from("fixflow_contact_notes")
      .insert({
        estate_id: estateId,
        resident_id: residentId,
        body: draft.trim(),
      });

    setSaving(false);
    if (insertError) {
      setError(`Nie udało się dodać notatki: ${insertError.message}`);
      return;
    }
    setDraft("");
    router.refresh();
  };

  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <div className="flex items-center gap-2 mb-3">
        <h3 className="font-heading font-semibold text-ink text-sm">
          Notatki
        </h3>
        <span className="text-[11px] font-medium uppercase tracking-wide px-2.5 py-0.5 rounded-full bg-paper text-ink/45">
          wewnętrzne
        </span>
      </div>

      <div className="flex gap-2 mb-4">
        <input
          type="text"
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") handleAdd();
          }}
          disabled={saving}
          placeholder="Dodaj notatkę…"
          className="flex-1 px-3 py-2 rounded-lg border border-ink/10 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleAdd}
          disabled={saving}
          className="px-4 py-2 bg-[#173A6A] text-white rounded-lg text-sm font-medium hover:bg-[#173A6A]/90 transition-colors disabled:opacity-50 shrink-0"
        >
          {saving ? "Dodawanie…" : "Dodaj"}
        </button>
      </div>

      {error && <p className="text-[12.5px] text-danger mb-3">{error}</p>}

      {notes.length === 0 ? (
        <p className="text-sm text-ink/30">Brak notatek.</p>
      ) : (
        <div className="flex flex-col gap-2">
          {notes.map((n) => (
            <div key={n.id} className="bg-paper border border-ink/5 rounded-xl px-3 py-2.5">
              <p className="text-[13px] leading-relaxed text-ink/80">{n.body}</p>
              <p className="text-[11px] font-mono text-ink/40 mt-1.5">
                {new Date(n.created_at).toLocaleString("pl-PL", {
                  day: "numeric",
                  month: "short",
                  hour: "2-digit",
                  minute: "2-digit",
                })}
              </p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

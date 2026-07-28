"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export type ContactTask = {
  id: string;
  title: string;
  status: string;
};

export default function ContactTasks({
  estateId,
  residentId,
  tasks,
}: {
  estateId: string;
  residentId: string;
  tasks: ContactTask[];
}) {
  const router = useRouter();
  const [draft, setDraft] = useState("");
  const [saving, setSaving] = useState(false);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleAdd = async () => {
    setError(null);
    if (!draft.trim()) return;

    setSaving(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_tasks").insert({
      estate_id: estateId,
      related_resident_id: residentId,
      title: draft.trim(),
      status: "Otwarte",
      kind: "resident",
    });

    setSaving(false);
    if (insertError) {
      setError(`Nie udało się dodać zadania: ${insertError.message}`);
      return;
    }
    setDraft("");
    router.refresh();
  };

  const handleToggle = async (task: ContactTask) => {
    setError(null);
    setTogglingId(task.id);
    const supabase = createClient();
    const nextStatus = task.status === "Zrobione" ? "Otwarte" : "Zrobione";
    const { error: updateError } = await supabase
      .from("fixflow_tasks")
      .update({ status: nextStatus })
      .eq("id", task.id);

    setTogglingId(null);
    if (updateError) {
      setError(`Nie udało się zmienić statusu: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="font-heading font-semibold text-ink text-sm mb-3">
        Zadania
      </h3>

      <div className="flex gap-2 mb-4">
        <input
          type="text"
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") handleAdd();
          }}
          disabled={saving}
          placeholder="Nowe zadanie…"
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

      {tasks.length === 0 ? (
        <p className="text-sm text-ink/30">Brak zadań.</p>
      ) : (
        <div className="flex flex-col gap-1.5">
          {tasks.map((t) => {
            const done = t.status === "Zrobione";
            return (
              <div
                key={t.id}
                className="flex items-center gap-3 bg-paper border border-ink/5 rounded-xl px-3 py-2.5 min-h-[48px]"
              >
                <button
                  type="button"
                  onClick={() => handleToggle(t)}
                  disabled={togglingId === t.id}
                  className={`w-7 h-7 rounded-full flex items-center justify-center shrink-0 border-2 transition-colors disabled:opacity-50 ${
                    done
                      ? "bg-[#2E9E6B] border-[#2E9E6B]"
                      : "bg-white border-ink/20 hover:border-azure/50"
                  }`}
                  aria-label={done ? "Oznacz jako niezrobione" : "Oznacz jako zrobione"}
                >
                  {done && (
                    <svg
                      className="w-3.5 h-3.5 text-white"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth={3}
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        d="M5 12l5 5 9-11"
                      />
                    </svg>
                  )}
                </button>
                <span
                  className={`text-[13.5px] ${
                    done ? "text-ink/40 line-through" : "text-ink/80"
                  }`}
                >
                  {t.title}
                </span>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export type InternalTaskComment = {
  id: string;
  body: string;
  author_name: string | null;
  created_at: string;
};

export type InternalTask = {
  id: string;
  title: string;
  description: string | null;
  recurrence_interval: number | null;
  recurrence_unit: string | null;
  assigned_group: string | null;
  created_at: string;
  comments: InternalTaskComment[];
};

const UNIT_LABEL: Record<string, string> = {
  Tydzien: "tygodni",
  Miesiac: "miesięcy",
  Rok: "lat",
};

export default function InternalTaskCard({
  estateId,
  task,
  authorName,
}: {
  estateId: string;
  task: InternalTask;
  authorName: string;
}) {
  const router = useRouter();
  const [draft, setDraft] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleAddComment = async () => {
    setError(null);
    if (!draft.trim()) return;

    setSaving(true);
    const supabase = createClient();
    const { error: insertError } = await supabase
      .from("fixflow_task_comments")
      .insert({
        estate_id: estateId,
        task_id: task.id,
        body: draft.trim(),
        author_name: authorName,
      });

    setSaving(false);
    if (insertError) {
      setError(`Nie udało się dodać komentarza: ${insertError.message}`);
      return;
    }
    setDraft("");
    router.refresh();
  };

  const cycleLabel = task.recurrence_interval
    ? `co ${task.recurrence_interval} ${UNIT_LABEL[task.recurrence_unit ?? ""] ?? task.recurrence_unit}`
    : "cykliczne";

  const assignedLabel =
    task.assigned_group === "serwis" ? "Serwis" : "Zarząd";

  return (
    <div className="bg-white rounded-[16px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
      <div className="flex items-center justify-between gap-3">
        <span className="font-heading font-semibold text-[14.5px] text-ink">
          {task.title}
        </span>
        <span className="text-[11.5px] font-mono font-medium bg-[#EFF2F6] text-[#5A6B80] px-2.5 py-0.5 rounded-full shrink-0">
          {cycleLabel}
        </span>
      </div>
      {task.description && (
        <p className="text-[12.5px] text-ink/60 leading-relaxed mt-1.5">
          {task.description}
        </p>
      )}
      <p className="text-[11.5px] font-mono text-ink/40 mt-2">
        Do: {assignedLabel} · dodano{" "}
        {new Date(task.created_at).toLocaleString("pl-PL", {
          day: "numeric",
          month: "short",
          hour: "2-digit",
          minute: "2-digit",
        })}
      </p>

      <div className="h-px bg-[#EEF2F6] my-3" />

      <div className="flex flex-col gap-2">
        {task.comments.length === 0 ? (
          <p className="text-[12.5px] text-ink/35">Brak dyskusji.</p>
        ) : (
          task.comments.map((c) => (
            <div key={c.id} className="bg-paper rounded-lg px-2.5 py-2">
              <p className="text-[12.5px] text-ink/70">{c.body}</p>
              <p className="text-[11.5px] font-mono text-ink/40 mt-1">
                {c.author_name ?? "Zarząd"} ·{" "}
                {new Date(c.created_at).toLocaleString("pl-PL", {
                  day: "numeric",
                  month: "short",
                  hour: "2-digit",
                  minute: "2-digit",
                })}
              </p>
            </div>
          ))
        )}
      </div>

      {error && <p className="text-[12.5px] text-danger mt-2">{error}</p>}

      <div className="flex gap-2 mt-2.5">
        <input
          type="text"
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") handleAddComment();
          }}
          disabled={saving}
          placeholder="Dodaj komentarz do dyskusji…"
          className="flex-1 px-3 py-2 rounded-lg bg-paper text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleAddComment}
          disabled={saving}
          className="px-3.5 py-2 rounded-lg bg-[#173A6A] text-white text-[12.5px] font-medium hover:bg-[#173A6A]/90 transition-colors disabled:opacity-50 shrink-0"
        >
          {saving ? "…" : "Dodaj"}
        </button>
      </div>
    </div>
  );
}

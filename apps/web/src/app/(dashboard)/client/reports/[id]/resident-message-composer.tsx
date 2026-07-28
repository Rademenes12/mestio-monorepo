"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function ResidentMessageComposer({
  reportId,
  authorId,
}: {
  reportId: string;
  authorId: string;
}) {
  const router = useRouter();
  const [draft, setDraft] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSend = async () => {
    setError(null);
    if (!draft.trim()) return;
    setSaving(true);
    const supabase = createClient();
    const { error: insertError } = await supabase
      .from("fixflow_report_comments")
      .insert({
        report_id: reportId,
        author_id: authorId,
        content: draft.trim(),
        is_internal: false,
      });
    setSaving(false);
    if (insertError) {
      setError(`Nie udało się wysłać wiadomości: ${insertError.message}`);
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
            if (e.key === "Enter") handleSend();
          }}
          disabled={saving}
          placeholder="Napisz do mieszkańca…"
          className="flex-1 px-3.5 py-2.5 rounded-xl border border-ink/10 bg-white text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/40 disabled:opacity-50"
        />
        <button
          type="button"
          onClick={handleSend}
          disabled={saving}
          className="w-11 rounded-xl bg-azure flex items-center justify-center shrink-0 hover:bg-azure/90 transition-colors disabled:opacity-50"
          aria-label="Wyślij"
        >
          <svg
            className="w-[18px] h-[18px] text-white"
            fill="none"
            stroke="currentColor"
            strokeWidth={2}
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M22 2 11 13M22 2l-7 20-4-9-9-4 20-7z"
            />
          </svg>
        </button>
      </div>
      {error && <p className="text-[12.5px] text-danger mt-2">{error}</p>}
    </div>
  );
}

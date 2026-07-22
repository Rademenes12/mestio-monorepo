"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function TaskCheck({
  taskId,
  done,
}: {
  taskId: string;
  done: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleToggle = async () => {
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("fixflow_tasks")
      .update({ status: done ? "Otwarte" : "Zrobione" })
      .eq("id", taskId);
    setLoading(false);
    if (updateError) {
      setError(`Nie udało się zmienić statusu: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <>
      <button
        type="button"
        onClick={handleToggle}
        disabled={loading}
        className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 border-2 transition-colors disabled:opacity-50 ${
          done ? "bg-[#2E9E6B] border-[#2E9E6B]" : "bg-white border-ink/20 hover:border-azure/50"
        }`}
        aria-label={done ? "Oznacz jako niezrobione" : "Oznacz jako zrobione"}
      >
        {done && (
          <svg
            className="w-4 h-4 text-white"
            fill="none"
            stroke="currentColor"
            strokeWidth={3}
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M5 12l5 5 9-11" />
          </svg>
        )}
      </button>
      {error && <p className="text-[11.5px] text-danger mt-1">{error}</p>}
    </>
  );
}

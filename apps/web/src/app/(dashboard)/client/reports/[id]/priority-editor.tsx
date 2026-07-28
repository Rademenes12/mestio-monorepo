"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { PRIORITY_CONFIG } from "@/lib/types";
import type { ReportPriority } from "@/lib/types";

const SLA_HOURS: Record<ReportPriority, number> = {
  low: 168,
  normal: 72,
  high: 24,
  critical: 4,
};

const PRIORITIES: ReportPriority[] = ["low", "normal", "high", "critical"];

export default function PriorityEditor({
  reportId,
  currentPriority,
}: {
  reportId: string;
  currentPriority: ReportPriority;
}) {
  const router = useRouter();
  const [priority, setPriority] = useState(currentPriority);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSet = async (p: ReportPriority) => {
    if (p === priority) return;
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("fixflow_reports")
      .update({ priority: p })
      .eq("id", reportId);
    setLoading(false);
    if (updateError) {
      setError(`Nie udało się zmienić priorytetu: ${updateError.message}`);
      return;
    }
    setPriority(p);
    router.refresh();
  };

  return (
    <div>
      <h3 className="text-[13px] font-semibold text-ink/60 mb-3">
        Priorytet · SLA {SLA_HOURS[priority]}h
      </h3>
      <div className="flex flex-wrap gap-2">
        {PRIORITIES.map((p) => {
          const config = PRIORITY_CONFIG[p];
          const on = p === priority;
          return (
            <button
              key={p}
              type="button"
              onClick={() => handleSet(p)}
              disabled={loading}
              className="px-3.5 py-2 rounded-full text-[12.5px] font-semibold transition-colors border disabled:opacity-50 min-h-[38px]"
              style={{
                backgroundColor: on ? config.color : "#fff",
                color: on ? "#fff" : "#5A6B80",
                borderColor: on ? config.color : "#E4EBF3",
              }}
            >
              {config.label}
            </button>
          );
        })}
      </div>
      {error && <p className="text-[11.5px] text-danger mt-2">{error}</p>}
    </div>
  );
}

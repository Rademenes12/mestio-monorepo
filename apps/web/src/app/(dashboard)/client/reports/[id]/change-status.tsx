"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";
import type { ReportStatus } from "@/lib/types";
import { STATUS_CONFIG } from "@/lib/types";

export function ChangeStatusButton({
  reportId,
  newStatus,
}: {
  reportId: string;
  newStatus: ReportStatus;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const config = STATUS_CONFIG[newStatus];

  const handleChange = async () => {
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase
      .from("fixflow_reports")
      .update({
        status: newStatus,
        status_enum: config.enum,
      })
      .eq("id", reportId);

    setLoading(false);
    if (updateError) {
      setError(`Nie udało się zmienić statusu: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <div>
      <button
        onClick={handleChange}
        disabled={loading}
        className="w-full text-left px-3.5 py-2.5 rounded-xl text-[13.5px] font-medium hover:opacity-90 disabled:opacity-50 transition-all flex items-center gap-2.5 min-h-[42px]"
        style={{
          backgroundColor: config.color + "12",
          color: config.color,
        }}
      >
        <span
          className="w-2.5 h-2.5 rounded-full shrink-0"
          style={{ backgroundColor: config.color }}
        />
        {loading ? "Zmienianie…" : newStatus}
      </button>
      {error && <p className="text-[11.5px] text-danger mt-1">{error}</p>}
    </div>
  );
}

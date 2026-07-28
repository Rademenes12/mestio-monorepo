"use client";

import { useRouter } from "next/navigation";
import { CrmLead } from "@/lib/types";

export default function MatrixCard({
  lead,
  urgency,
}: {
  lead: CrmLead;
  urgency: string;
}) {
  const router = useRouter();

  const daysSinceUpdate = Math.floor(
    (Date.now() - new Date(lead.updated_at).getTime()) / (1000 * 60 * 60 * 24)
  );

  return (
    <button
      onClick={() => router.push(`/customers/${lead.id}`)}
      className="w-full text-left rounded-[8px] p-2 bg-[#F6F8FB] hover:bg-[#EFF3F9] active:scale-[0.98] transition-all cursor-pointer"
    >
      <div className="flex items-center justify-between">
        <span className="text-[12px] font-semibold text-ink truncate max-w-[120px]">
          {lead.company_name}
        </span>
        {lead.mrr > 0 && (
          <span className="text-[10px] font-mono text-blueprint shrink-0">
            {lead.mrr.toLocaleString("pl-PL")} zł
          </span>
        )}
      </div>
      <div className="flex items-center justify-between mt-1">
        <span className="text-[10px] text-[#8A98AB]">
          {lead.contact_name ?? "—"}
        </span>
        {daysSinceUpdate > 0 && (
          <span
            className={`text-[9px] px-1.5 py-0.5 rounded-full font-medium ${
              daysSinceUpdate > 14
                ? "bg-red-50 text-red-600"
                : daysSinceUpdate > 7
                  ? "bg-amber-50 text-amber-600"
                  : "bg-blue-50 text-blue-600"
            }`}
          >
            {daysSinceUpdate}d
          </span>
        )}
      </div>
    </button>
  );
}

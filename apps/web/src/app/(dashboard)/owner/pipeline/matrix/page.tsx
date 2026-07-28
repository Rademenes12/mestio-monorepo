import { createClient } from "@/lib/supabase/server";
import { CrmLead, LeadStage, STAGE_LABELS, STAGE_HEX } from "@/lib/types";
import MatrixCard from "./MatrixCard";

function tint(hex: string, alpha: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${alpha})`;
}

type UrgencyLevel = "high" | "medium" | "low";

const URGENCY_CONFIG: Record<UrgencyLevel, { label: string; color: string; bg: string; icon: string }> = {
  high: {
    label: "⚡ Pilne",
    color: "#C0392B",
    bg: "#FFF0F0",
    icon: "M12 8v4l3 2M12 3a9 9 0 100 18 9 9 0 000-18z",
  },
  medium: {
    label: "📋 Średnie",
    color: "#F2A900",
    bg: "#FFF8ED",
    icon: "M12 6v6l4 2M21 12a9 9 0 11-18 0 9 9 0 0118 0z",
  },
  low: {
    label: "📌 Niski priorytet",
    color: "#6B7A90",
    bg: "#F4F7FB",
    icon: "M5 12h14M13 6l6 6-6 6",
  },
};

function getUrgency(lead: CrmLead): UrgencyLevel {
  if (lead.stage === "risk" || lead.stage === "churned") return "high";
  if (lead.stage === "lost") return "low";

  const daysSinceUpdate =
    (Date.now() - new Date(lead.updated_at).getTime()) / (1000 * 60 * 60 * 24);

  if (daysSinceUpdate > 14 && lead.stage !== "active") return "high";
  if (daysSinceUpdate > 7) return "medium";
  if (lead.mrr > 5000 && lead.stage === "lead") return "high";
  if (lead.mrr > 2000 && lead.stage === "lead") return "medium";

  return "low";
}

// Główne etapy sprzedażowe do macierzy
const MATRIX_STAGES: LeadStage[] = ["lead", "contact", "demo", "offer", "contract", "won"];

export default async function MatrixPage() {
  const supabase = await createClient();

  const { data: leadsData } = await supabase
    .from("crm_leads")
    .select("*")
    .order("created_at", { ascending: false });

  const leads = (leadsData as CrmLead[]) ?? [];

  // Grupuj po etapie i priorytecie
  const grid: Record<LeadStage, Record<UrgencyLevel, CrmLead[]>> = {} as any;

  for (const stage of MATRIX_STAGES) {
    grid[stage] = { high: [], medium: [], low: [] };
  }

  for (const lead of leads) {
    if (MATRIX_STAGES.includes(lead.stage)) {
      const urgency = getUrgency(lead);
      grid[lead.stage][urgency].push(lead);
    }
  }

  const urgencyLevels: UrgencyLevel[] = ["high", "medium", "low"];

  return (
    <div className="h-full space-y-6">
      <div>
        <h2 className="text-lg font-bold text-ink mb-1">Macierz Pipeline (Stage × Urgency)</h2>
        <p className="text-[13px] text-ink/50">
          Szybki rzut oka: które leady są najpilniejsze w danym etapie
        </p>
      </div>

      {/* Legenda */}
      <div className="flex gap-4 text-[12px]">
        {urgencyLevels.map((u) => (
          <div key={u} className="flex items-center gap-1.5">
            <div className="w-3 h-3 rounded-full" style={{ background: URGENCY_CONFIG[u].color }} />
            <span className="text-ink/60">{URGENCY_CONFIG[u].label}</span>
          </div>
        ))}
      </div>

      <div className="overflow-x-auto">
        <table className="w-full border-separate border-spacing-2">
          <thead>
            <tr>
              <th className="text-left text-[11px] font-semibold text-[#8A98AB] uppercase tracking-wide py-1 px-2 w-[80px]">
                Priorytet
              </th>
              {MATRIX_STAGES.map((stage) => (
                <th
                  key={stage}
                  className="text-center text-[12px] font-semibold py-1 px-2"
                >
                  <div className="flex items-center justify-center gap-1.5">
                    <span
                      className="w-2 h-2 rounded-full"
                      style={{ background: STAGE_HEX[stage] }}
                    />
                    <span className="text-ink">{STAGE_LABELS[stage]}</span>
                  </div>
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {urgencyLevels.map((urgency) => (
              <tr key={urgency}>
                <td className="py-1 px-2">
                  <div
                    className="rounded-[8px] px-2.5 py-2 text-center"
                    style={{
                      background: URGENCY_CONFIG[urgency].bg,
                      color: URGENCY_CONFIG[urgency].color,
                    }}
                  >
                    <p className="text-[12px] font-semibold">{URGENCY_CONFIG[urgency].label}</p>
                  </div>
                </td>
                {MATRIX_STAGES.map((stage) => {
                  const cellLeads = grid[stage][urgency];
                  const isEmpty = cellLeads.length === 0;
                  const isHotspot = cellLeads.length >= 3 && (urgency === "high" || urgency === "medium");

                  return (
                    <td key={stage} className="py-1 px-2">
                      <div
                        className={`rounded-[10px] p-2 min-h-[80px] transition-all ${
                          isEmpty
                            ? "bg-[#F6F8FB]/50 border border-dashed border-[#CBD5E1]"
                            : isHotspot
                            ? "bg-white border-2 shadow-sm"
                            : "bg-white border border-[#E9EFF6]"
                        }`}
                        style={isHotspot ? { borderColor: URGENCY_CONFIG[urgency].color + "40" } : {}}
                      >
                        {isEmpty ? (
                          <div className="flex items-center justify-center h-full">
                            <span className="text-[11px] text-[#CBD5E1]">—</span>
                          </div>
                        ) : (
                          <div className="space-y-1">
                            {cellLeads.slice(0, 4).map((lead) => (
                              <MatrixCard key={lead.id} lead={lead} urgency={urgency} />
                            ))}
                            {cellLeads.length > 4 && (
                              <p className="text-[10px] text-[#8A98AB] text-center">
                                +{cellLeads.length - 4} więcej
                              </p>
                            )}
                          </div>
                        )}
                      </div>
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Podsumowanie */}
      <div className="grid grid-cols-4 gap-4 text-center">
        {MATRIX_STAGES.map((stage) => {
          const total = grid[stage].high.length + grid[stage].medium.length + grid[stage].low.length;
          const high = grid[stage].high.length;
          return (
            <div key={stage} className="bg-white rounded-[10px] p-3 border border-[#E9EFF6]">
              <p className="text-[11px] text-[#8A98AB]">{STAGE_LABELS[stage]}</p>
              <p className="text-lg font-bold text-ink">{total}</p>
              {high > 0 && (
                <p className="text-[10px] text-[#C0392B] mt-0.5">⚡ {high} pilnych</p>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

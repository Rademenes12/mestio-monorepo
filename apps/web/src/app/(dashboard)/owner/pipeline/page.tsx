"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import {
  CrmLead,
  LeadStage,
  STAGE_LABELS,
  STAGE_HEX,
  SALES_STAGES,
  STAGE_ORDER,
} from "@/lib/types";

const SOURCE_COLORS: Record<string, string> = {
  website: "#3E7BD6",
  referral: "#2E9E6B",
  cold: "#6B7A90",
  other: "#C98800",
};

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

async function fetchLeads(
  supabase: ReturnType<typeof createClient>
): Promise<CrmLead[]> {
  const { data, error } = await supabase
    .from("crm_leads")
    .select("*")
    .order("created_at", { ascending: false });
  if (!error && data) return data as CrmLead[];
  return [];
}

export default function PipelinePage() {
  const [leads, setLeads] = useState<CrmLead[]>([]);
  const [loading, setLoading] = useState(true);
  const [draggedId, setDraggedId] = useState<string | null>(null);
  const [dragOverStage, setDragOverStage] = useState<LeadStage | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();
  const router = useRouter();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 3800);
  };

  useEffect(() => {
    let cancelled = false;
    fetchLeads(supabase).then((data) => {
      if (!cancelled) {
        setLeads(data);
        setLoading(false);
      }
    });
    return () => {
      cancelled = true;
    };
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const changeStage = async (lead: CrmLead, newStage: LeadStage, note?: string) => {
    setLeads((prev) =>
      prev.map((l) => (l.id === lead.id ? { ...l, stage: newStage } : l))
    );
    const { error } = await supabase
      .from("crm_leads")
      .update({ stage: newStage, updated_at: new Date().toISOString() })
      .eq("id", lead.id);
    if (!error) {
      await supabase.from("crm_interactions").insert({
        lead_id: lead.id,
        type: "stage_change",
        summary:
          note ??
          `Zmiana etapu: ${STAGE_LABELS[lead.stage]} → ${STAGE_LABELS[newStage]}`,
      });
    } else {
      fetchLeads(supabase).then(setLeads);
    }
  };

  const advance = async (lead: CrmLead) => {
    // Win-back: churned/lost wraca do Lead
    if (lead.stage === "churned" || lead.stage === "lost") {
      await changeStage(lead, "lead", `Win-back: ${STAGE_LABELS[lead.stage]} → Lead`);
      notify(`↺ ${lead.company_name} — win-back, wrócił do etapu Lead`);
      return;
    }
    const idx = STAGE_ORDER.indexOf(lead.stage);
    const nextStage = STAGE_ORDER[idx + 1];
    if (!nextStage) return;
    await changeStage(lead, nextStage);
    if (nextStage === "won") {
      notify(`🎉 Wygrana: ${lead.company_name}!`);
    } else {
      notify(`${lead.company_name} → ${STAGE_LABELS[nextStage]}`);
    }
  };

  const handleDrop = async (newStage: LeadStage) => {
    setDragOverStage(null);
    if (!draggedId) return;
    const lead = leads.find((l) => l.id === draggedId);
    setDraggedId(null);
    if (!lead || lead.stage === newStage) return;
    await changeStage(lead, newStage);
  };

  const leadsByStage = (stage: LeadStage) => leads.filter((l) => l.stage === stage);

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto py-20 text-center text-ink/40">
        Ładowanie...
      </div>
    );
  }

  return (
    <div className="h-full">
      {/* Pipeline toolbar */}
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <a
            href="/pipeline"
            className="px-3 py-1.5 rounded-[8px] text-[12px] font-semibold bg-[#EFF3F9] text-azure"
          >
            Kanban
          </a>
          <a
            href="/pipeline/matrix"
            className="px-3 py-1.5 rounded-[8px] text-[12px] font-medium text-ink/50 hover:text-ink hover:bg-[#F4F7FB] transition-colors"
          >
            Macierz
          </a>
        </div>
        <a
          href="/pipeline/matrix"
          className="text-[12px] text-azure hover:text-blueprint font-medium flex items-center gap-1"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <path d="M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z"/>
          </svg>
          Widok macierzowy
        </a>
      </div>

      <div className="flex gap-3 overflow-x-auto pb-2 items-start">
        {SALES_STAGES.map((stage) => {
          const stageLeads = leadsByStage(stage);
          const isDragOver = dragOverStage === stage;
          const color = STAGE_HEX[stage];

          return (
            <div
              key={stage}
              className="flex-shrink-0 w-[240px]"
              onDragOver={(e) => {
                e.preventDefault();
                setDragOverStage(stage);
              }}
              onDragLeave={() => setDragOverStage(null)}
              onDrop={(e) => {
                e.preventDefault();
                handleDrop(stage);
              }}
            >
              <div
                className={`bg-[#EFF3F9] rounded-[14px] p-[10px] flex flex-col ${
                  isDragOver ? "ring-2 ring-azure/40" : ""
                } transition-all`}
              >
                <div className="flex items-center justify-between px-[6px] pt-1 pb-3">
                  <div className="flex items-center gap-[7px]">
                    <span
                      className="w-2.5 h-2.5 rounded-full"
                      style={{ background: color }}
                    />
                    <span className="font-[family-name:var(--font-heading)] font-semibold text-[13.5px] text-ink">
                      {STAGE_LABELS[stage]}
                    </span>
                  </div>
                  <span className="font-[family-name:var(--font-mono)] text-[11px] font-semibold text-[#8A98AB] bg-white px-[8px] py-[2px] rounded-full">
                    {stageLeads.length}
                  </span>
                </div>

                {/* Suma MRR dla kolumny */}
                {stageLeads.length > 0 && (
                  <div className="px-[6px] pb-2">
                    <span className="text-[10px] font-mono text-ink/30">
                      {stageLeads.reduce((s, l) => s + (l.mrr || 0), 0).toLocaleString("pl-PL")} zł
                    </span>
                  </div>
                )}

                <div className="flex flex-col gap-2.5">
                  {stageLeads.length === 0 ? (
                    <p className="text-[12.5px] text-ink/30 text-center py-4">Brak leadów</p>
                  ) : (
                    stageLeads.map((lead) => {
                      const sc = SOURCE_COLORS[lead.source] ?? "#6B7A90";
                      const isWon = stage === "won";
                      const isWinBack = stage === "churned" || stage === "lost";
                      const isLastStage = STAGE_ORDER.indexOf(stage) === STAGE_ORDER.length - 1;
                      return (
                        <div
                          key={lead.id}
                          draggable
                          onDragStart={() => setDraggedId(lead.id)}
                          className={`bg-white rounded-xl p-3.5 shadow-[0_1px_4px_rgba(14,26,43,.06)] cursor-grab active:cursor-grabbing transition-opacity ${
                            draggedId === lead.id ? "opacity-40" : ""
                          }`}
                        >
                          <button
                            onClick={() => router.push(`/customers/${lead.id}`)}
                            className="text-left w-full"
                          >
                            <div className="flex items-center justify-between">
                              <div className="font-[family-name:var(--font-heading)] font-semibold text-[14.5px] leading-[1.3] text-ink">
                                {lead.company_name}
                              </div>
                              {(() => {
                                const days = Math.floor((Date.now() - new Date(lead.updated_at).getTime()) / (1000 * 60 * 60 * 24));
                                if (days > 14) return (
                                  <span className="text-[9px] px-1.5 py-0.5 rounded-full bg-red-50 text-red-600 font-semibold shrink-0">
                                    {days}d
                                  </span>
                                );
                                if (days > 7) return (
                                  <span className="text-[9px] px-1.5 py-0.5 rounded-full bg-amber-50 text-amber-600 font-semibold shrink-0">
                                    {days}d
                                  </span>
                                );
                                return null;
                              })()}
                            </div>
                            <div className="font-[family-name:var(--font-mono)] text-[11px] text-[#7C8AA0] mt-[5px]">
                              {lead.contact_name ?? "—"}
                            </div>
                          </button>
                          <div className="flex items-center justify-between mt-[10px]">
                            <span className="font-[family-name:var(--font-mono)] text-[12px] font-semibold text-blueprint">
                              {lead.mrr > 0
                                ? `${lead.mrr.toLocaleString("pl-PL")} zł`
                                : "—"}
                            </span>
                            <span
                              className="font-[family-name:var(--font-mono)] text-[10.5px] px-[8px] py-[3px] rounded-full"
                              style={{ background: tint(sc, 0.12), color: sc }}
                            >
                              {lead.source}
                            </span>
                          </div>
                          {!isLastStage && (
                            <button
                              onClick={() => advance(lead)}
                              className="mt-[10px] w-full flex items-center justify-center gap-[7px] py-[9px] rounded-lg bg-[#F4F7FB] text-blueprint text-[13px] font-semibold hover:bg-[#EAEFF5] active:scale-[0.98] transition-all"
                            >
                              {isWinBack
                                ? "↺ Win-back → Lead"
                                : isWon
                                  ? "Zakończ → klient aktywny"
                                  : "Przesuń dalej"}
                              {!isWinBack && (
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round">
                                  <path d="M5 12h13M13 6l6 6-6 6" />
                                </svg>
                              )}
                            </button>
                          )}
                        </div>
                      );
                    })
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {toast && (
        <div className="fixed left-1/2 bottom-8 -translate-x-1/2 bg-ink text-white text-[14px] font-semibold px-6 py-4 rounded-2xl shadow-[0_14px_40px_rgba(14,26,43,.45)] z-50 flex items-center gap-2.5 animate-[fadeInUp_.2s_ease-out]">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2E9E6B" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
            <path d="M5 12l5 5 9-11" />
          </svg>
          {toast}
        </div>
      )}
    </div>
  );
}

"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { CrmLead, STAGE_LABELS } from "@/lib/types";

const STAGE_COLORS: Record<string, string> = {
  lead: "#3E7BD6",
  contact: "#173A6A",
  demo: "#F2A900",
  offer: "#C98800",
  contract: "#8B5CF6",
};

const PLAN_COLORS: Record<string, string> = {
  start: "#6B7A90",
  standard: "#3E7BD6",
  pro: "#F2A900",
  enterprise: "#173A6A",
};

const FUNNEL_STAGES = ["lead", "contact", "demo", "offer", "contract"] as const;

export default function ReportsPage() {
  const [allLeads, setAllLeads] = useState<CrmLead[]>([]);
  const [loading, setLoading] = useState(true);
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const [planFilter, setPlanFilter] = useState("all");
  const [sourceFilter, setSourceFilter] = useState("all");
  const [stageFilter, setStageFilter] = useState("all");
  const [drill, setDrill] = useState<{ title: string; leads: CrmLead[] } | null>(null);
  const supabase = createClient();

  useEffect(() => {
    let cancelled = false;
    supabase
      .from("crm_leads")
      .select("*")
      .then(({ data }) => {
        if (!cancelled) {
          setAllLeads((data as CrmLead[]) ?? []);
          setLoading(false);
        }
      });
    return () => {
      cancelled = true;
    };
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) {
    return <div className="text-center text-[#9AA7B8] py-20 text-sm">Ładowanie...</div>;
  }

  // Filtry (wzorzec HubSpot custom reports): wszystkie metryki liczą się z przefiltrowanych danych
  const leads = allLeads.filter((l) => {
    if (dateFrom && l.created_at.slice(0, 10) < dateFrom) return false;
    if (dateTo && l.created_at.slice(0, 10) > dateTo) return false;
    if (planFilter !== "all" && (l.plan ?? "").toLowerCase() !== planFilter) return false;
    if (sourceFilter !== "all" && l.source !== sourceFilter) return false;
    if (stageFilter !== "all" && l.stage !== stageFilter) return false;
    return true;
  });
  const filtersActive =
    !!dateFrom || !!dateTo || planFilter !== "all" || sourceFilter !== "all" || stageFilter !== "all";

  const activeClients = leads.filter((l) => l.stage === "active" || l.stage === "risk");
  const mrrTotal = activeClients.reduce((a, c) => a + (c.mrr || 0), 0);
  const arr = Math.round(mrrTotal * 12);
  const wonCount = leads.filter((l) =>
    ["won", "onboarding", "active", "risk", "churned"].includes(l.stage)
  ).length;
  const lostCount = leads.filter((l) => l.stage === "lost").length;
  const winRate = wonCount + lostCount > 0 ? Math.round((wonCount / (wonCount + lostCount)) * 100) : 0;
  const churnedCount = leads.filter((l) => l.stage === "churned").length;
  const churnRate =
    activeClients.length + churnedCount > 0
      ? Math.round((churnedCount / (activeClients.length + churnedCount)) * 100)
      : 0;

  const kpis = [
    { label: "MRR (aktywni)", value: `${mrrTotal.toLocaleString("pl-PL")} zł`, sub: "suma miesięcznych abonamentów", color: "#173A6A" },
    { label: "ARR (roczny)", value: `${arr.toLocaleString("pl-PL")} zł`, sub: "prognoza 12 mies.", color: "#2E9E6B" },
    { label: "Win rate", value: `${winRate}%`, sub: `${wonCount} wygrane / ${lostCount} utracone`, color: "#3E7BD6" },
    { label: "Churn", value: `${churnRate}%`, sub: `${churnedCount} zakończonych umów`, color: churnRate > 15 ? "#C0392B" : "#F2A900" },
  ];

  const stageCount = (k: string) => leads.filter((l) => l.stage === k).length;
  const leadTotal = Math.max(1, stageCount("lead"));
  const funnel = FUNNEL_STAGES.map((k) => {
    const cnt = stageCount(k);
    const pct = Math.round((cnt / leadTotal) * 100);
    return { label: STAGE_LABELS[k], count: cnt, pct, color: STAGE_COLORS[k] };
  });

  const planCounts: Record<string, number> = {};
  leads.forEach((c) => {
    const p = c.plan || "—";
    planCounts[p] = (planCounts[p] || 0) + 1;
  });
  const byPlan = Object.keys(planCounts).map((p) => ({
    label: p,
    count: planCounts[p],
    color: PLAN_COLORS[p.toLowerCase()] || "#6B7A90",
  }));

  const srcCounts: Record<string, number> = {};
  leads.forEach((c) => {
    const s = c.source || "—";
    srcCounts[s] = (srcCounts[s] || 0) + 1;
  });
  const bySource = Object.keys(srcCounts).map((s) => ({ label: s, count: srcCounts[s] }));

  const now = new Date();
  const expiring = activeClients
    .filter((c) => c.contract_end)
    .sort((a, b) => (a.contract_end || "").localeCompare(b.contract_end || ""));

  const exportCsv = () => {
    const rows = [
      ["Firma", "Etap", "Plan", "MRR", "Źródło", "Umowa do"],
      ...leads.map((l) => [
        l.company_name,
        STAGE_LABELS[l.stage] ?? l.stage,
        l.plan ?? "",
        String(l.mrr ?? 0),
        l.source ?? "",
        l.contract_end ?? "",
      ]),
    ];
    const csv = rows.map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(",")).join("\n");
    const blob = new Blob(["\uFEFF" + csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `raport-mestio-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const filterSel = "text-[12.5px] bg-white rounded-[10px] px-3 py-[9px] text-ink outline-none border border-[#E4EBF3] focus:ring-2 focus:ring-azure/30 focus:border-azure/40 transition-all";

  return (
    <div className="max-w-6xl mx-auto space-y-[14px]">
      {/* Pasek filtrów (wzorzec HubSpot) */}
      <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 flex flex-wrap items-end gap-3">
        <div>
          <div className="font-[family-name:var(--font-mono)] text-[9px] text-[#8A98AB] uppercase mb-1">Utworzono od</div>
          <input type="date" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} className={filterSel} />
        </div>
        <div>
          <div className="font-[family-name:var(--font-mono)] text-[9px] text-[#8A98AB] uppercase mb-1">Do</div>
          <input type="date" value={dateTo} onChange={(e) => setDateTo(e.target.value)} className={filterSel} />
        </div>
        <div>
          <div className="font-[family-name:var(--font-mono)] text-[9px] text-[#8A98AB] uppercase mb-1">Etap</div>
          <select value={stageFilter} onChange={(e) => setStageFilter(e.target.value)} className={filterSel}>
            <option value="all">Wszystkie</option>
            {Object.entries(STAGE_LABELS).map(([k, v]) => (
              <option key={k} value={k}>{v}</option>
            ))}
          </select>
        </div>
        <div>
          <div className="font-[family-name:var(--font-mono)] text-[9px] text-[#8A98AB] uppercase mb-1">Plan</div>
          <select value={planFilter} onChange={(e) => setPlanFilter(e.target.value)} className={filterSel}>
            <option value="all">Wszystkie</option>
            <option value="start">Start</option>
            <option value="standard">Standard</option>
            <option value="pro">Pro</option>
            <option value="enterprise">Enterprise</option>
          </select>
        </div>
        <div>
          <div className="font-[family-name:var(--font-mono)] text-[9px] text-[#8A98AB] uppercase mb-1">Źródło</div>
          <select value={sourceFilter} onChange={(e) => setSourceFilter(e.target.value)} className={filterSel}>
            <option value="all">Wszystkie</option>
            <option value="website">website</option>
            <option value="referral">referral</option>
            <option value="cold">cold</option>
            <option value="other">other</option>
          </select>
        </div>
        {filtersActive && (
          <button
            onClick={() => { setDateFrom(""); setDateTo(""); setPlanFilter("all"); setSourceFilter("all"); setStageFilter("all"); }}
            className="px-[13px] py-[9px] rounded-[10px] bg-[#F4F7FB] text-[#5A6B80] text-[12.5px] font-semibold hover:bg-[#EAEFF5] transition-colors"
          >
            ✕ Wyczyść filtry
          </button>
        )}
        <div className="ml-auto font-[family-name:var(--font-mono)] text-[10.5px] text-[#9AA7B8]">
          {leads.length} z {allLeads.length} rekordów
        </div>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-[14px]">
        {kpis.map((k) => (
          <div key={k.label} className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-[18px]">
            <div className="font-[family-name:var(--font-mono)] text-[10px] text-[#8A98AB] uppercase tracking-[.4px]">
              {k.label}
            </div>
            <div className="font-[family-name:var(--font-heading)] font-bold text-[26px] mt-[6px]" style={{ color: k.color }}>
              {k.value}
            </div>
            <div className="text-[11.5px] text-[#7C8AA0] mt-[3px]">{k.sub}</div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-[1.3fr_1fr] gap-[14px]">
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-5">
          <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">
            Lejek sprzedażowy — konwersja między etapami
          </div>
          <div className="flex flex-col gap-[10px] mt-4">
            {funnel.map((f, fi) => (
              <button
                key={f.label}
                onClick={() =>
                  setDrill({ title: `Etap: ${f.label}`, leads: leads.filter((l) => l.stage === FUNNEL_STAGES[fi]) })
                }
                className="text-left w-full hover:bg-[#F8FAFC] rounded-lg p-1 -m-1 transition-colors"
                title="Kliknij, aby zobaczyć listę firm"
              >
                <div className="flex justify-between text-xs text-[#5A6B80] mb-[5px]">
                  <span className="font-semibold text-ink">{f.label}</span>
                  <span>{f.count} · {f.pct}%</span>
                </div>
                <div className="h-[10px] bg-[#F0F3F8] rounded-[6px] overflow-hidden">
                  <div className="h-full rounded-[6px]" style={{ width: `${f.pct}%`, background: f.color }} />
                </div>
              </button>
            ))}
          </div>
          <div className="font-[family-name:var(--font-mono)] text-[9.5px] text-[#9AA7B8] mt-3">
            kliknij etap, aby zobaczyć firmy
          </div>
        </div>

        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-5">
          <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">
            Klienci wg planu
          </div>
          <div className="flex flex-col gap-[9px] mt-[14px]">
            {byPlan.map((p) => (
              <button
                key={p.label}
                onClick={() =>
                  setDrill({ title: `Plan: ${p.label}`, leads: leads.filter((l) => (l.plan ?? "—") === p.label) })
                }
                className="flex items-center gap-[10px] w-full hover:bg-[#F8FAFC] rounded-lg p-1 -m-1 transition-colors"
              >
                <span className="w-[9px] h-[9px] rounded-full shrink-0" style={{ background: p.color }} />
                <span className="flex-1 text-[12.5px] font-medium text-left">{p.label}</span>
                <span className="font-[family-name:var(--font-mono)] text-xs font-semibold text-blueprint">{p.count}</span>
              </button>
            ))}
          </div>
          <div className="mt-4 pt-[14px] border-t border-[#F0F3F8]">
            <div className="font-[family-name:var(--font-mono)] text-[10px] text-[#8A98AB] uppercase">Źródła leadów</div>
            <div className="flex flex-col gap-[7px] mt-2">
              {bySource.map((s) => (
                <div key={s.label} className="flex justify-between text-xs">
                  <span className="text-[#5A6B80]">{s.label}</span>
                  <span className="font-semibold">{s.count}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-5">
        <div className="flex items-center justify-between">
          <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">
            Umowy kończące się wkrótce (ryzyko odnowienia)
          </div>
          <span className="font-[family-name:var(--font-mono)] text-[10px] text-[#9AA7B8]">sortowane wg pilności</span>
        </div>
        <div className="flex flex-col mt-[10px]">
          {expiring.length === 0 ? (
            <div className="py-[14px] px-1 text-[#9AA7B8] text-[12.5px]">Brak umów kończących się w najbliższym czasie.</div>
          ) : (
            expiring.map((c) => {
              const urgent = c.stage === "risk";
              const days = c.contract_end
                ? Math.ceil((new Date(c.contract_end).getTime() - now.getTime()) / 86400000)
                : null;
              return (
                <div key={c.id} className="flex items-center gap-3 py-[10px] px-1 border-b border-[#F1F5FA] last:border-0">
                  <span className="w-2 h-2 rounded-full shrink-0" style={{ background: urgent ? "#C0392B" : "#F2A900" }} />
                  <span className="flex-1 text-[13px] font-medium">{c.company_name}</span>
                  <span className="font-[family-name:var(--font-mono)] text-xs text-blueprint font-semibold">
                    {c.mrr > 0 ? `${c.mrr.toLocaleString("pl-PL")} zł` : "—"}
                  </span>
                  <span
                    className="font-[family-name:var(--font-mono)] text-[10.5px] font-semibold px-[9px] py-[3px] rounded-full"
                    style={{
                      background: urgent ? "rgba(192,57,43,.12)" : "rgba(242,169,0,.13)",
                      color: urgent ? "#C0392B" : "#9a6b00",
                    }}
                  >
                    {days !== null ? `${days} dni` : "—"}
                  </span>
                </div>
              );
            })
          )}
        </div>
      </div>

      <button
        onClick={exportCsv}
        className="inline-flex items-center gap-2 mt-1 px-[18px] py-[11px] rounded-[11px] bg-blueprint text-white text-[13px] font-semibold hover:bg-blueprint/90 transition-colors"
      >
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 3v12m0 0l-4-4m4 4l4-4M4 21h16" />
        </svg>
        Eksportuj raport (CSV{filtersActive ? " — z aktywnymi filtrami" : ""})
      </button>

      {/* Drill-down: lista firm za liczbą */}
      {drill && (
        <div className="fixed inset-0 bg-ink/50 flex items-center justify-center z-50 p-6" onClick={() => setDrill(null)}>
          <div
            className="bg-white rounded-[20px] shadow-[0_24px_70px_rgba(14,26,43,.4)] w-[480px] max-w-full max-h-[80vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-4 px-5 border-b border-[#EEF2F8] flex items-center justify-between sticky top-0 bg-white">
              <div className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink">
                {drill.title} <span className="text-[#9AA7B8] font-normal">({drill.leads.length})</span>
              </div>
              <button onClick={() => setDrill(null)} className="w-7 h-7 rounded-full bg-[#F4F7FB] flex items-center justify-center text-sm text-[#5A6B80]">✕</button>
            </div>
            <div className="p-2">
              {drill.leads.length === 0 ? (
                <div className="p-6 text-center text-[#9AA7B8] text-[12.5px]">Brak firm w tym segmencie.</div>
              ) : (
                drill.leads.map((l) => (
                  <a
                    key={l.id}
                    href={`/customers/${l.id}`}
                    className="flex items-center gap-3 py-[10px] px-3 rounded-[10px] hover:bg-[#F8FAFC] transition-colors"
                  >
                    <span className="flex-1 text-[13px] font-medium text-ink">{l.company_name}</span>
                    <span className="font-[family-name:var(--font-mono)] text-[10.5px] text-[#8A98AB]">
                      {STAGE_LABELS[l.stage]}
                    </span>
                    <span className="font-[family-name:var(--font-mono)] text-xs font-semibold text-blueprint">
                      {l.mrr > 0 ? `${l.mrr.toLocaleString("pl-PL")} zł` : "—"}
                    </span>
                  </a>
                ))
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

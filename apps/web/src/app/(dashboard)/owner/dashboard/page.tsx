"use client";

/**
 * CRM-Owner Dashboard — Daylight-inspired, full version
 * Inline styles to avoid broken monorepo package imports on Vercel.
 */
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { runAutomations } from "@/lib/automations";
import type { CrmLead, CrmTask } from "@/lib/types";

// ── Design tokens (inlined to avoid @mestio/design-tokens import) ──
const C = {
  page: "#F9FAFB",
  card: "#FFFFFF",
  cardBorder: "#EBEFF4",
  cardShadow: "0 1px 2px rgba(14,26,43,.03)",
  text: "#0E1A2B",
  textSec: "#4A5A6E",
  textMuted: "#7C8AA0",
  accent: "#3E7BD6",
  accentHover: "#2A5FA8",
  accentMuted: "rgba(62,123,214,.08)",
  success: "#22C55E",
  warning: "#F2A900",
  error: "#EF4444",
  navy: "#173A6A",
};

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

// ── Inline SVG icons ──
const Icn = {
  users: "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
  trending: "M22 7l-8.5 8.5-5-5L2 17M16 7h6v6",
  dollar: "M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6",
  file: "M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2zM14 2v6h6",
  alert: "M12 9v4M12 17h.01M10.29 3.86l-7 12a2 2 0 0 0 1.74 3h13.94a2 2 0 0 0 1.74-3l-7-12a2 2 0 0 0-3.43 0z",
  zap: "M13 2L3 14h8l-1 8 10-12h-8z",
  clock: "M12 6v6l4 2M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0z",
  check: "M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0zM16 10l-4 4-2-2",
  plus: "M12 5v14M5 12h14",
  barChart: "M18 20V10M12 20V4M6 20v-6",
  right: "M5 12h14M12 5l7 7-7 7",
};

function Svg({ d, size = 18, color = "currentColor" }: { d: string; size?: number; color?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d={d} />
    </svg>
  );
}

export default async function DashboardPage() {
  const supabase = await createClient();

  // Automations — non-blocking
  await runAutomations(supabase).catch(() => 0);

  // ── Data queries with fallback ──
  let leads: CrmLead[] = [];
  let openTasks: (CrmTask & { crm_leads: { company_name: string } | null })[] = [];
  let overdueInvoices: { status: string; amount: number }[] = [];

  try {
    const [leadsRes, tasksRes, invoicesRes] = await Promise.all([
      supabase.from("crm_leads").select("*"),
      supabase.from("crm_tasks").select("*").eq("done", false).order("due_date", { ascending: true }).limit(8),
      supabase.from("crm_invoices").select("status, amount").eq("status", "overdue"),
    ]);
    leads = (leadsRes.data as CrmLead[]) ?? [];
    openTasks = (tasksRes.data as (CrmTask & { crm_leads: { company_name: string } | null })[]) ?? [];
    overdueInvoices = (invoicesRes.data as { status: string; amount: number }[]) ?? [];
  } catch { /* empty fallback */ }

  const activeLeads = leads.filter((l) => l.stage === "active");
  const trialLeads = leads.filter((l) => ["onboarding", "won"].includes(l.stage));
  const mrr = activeLeads.reduce((sum, l) => sum + (l.mrr || 0), 0);
  const leadsPending = leads.filter((l) => l.stage === "lead");
  const leadsInProgress = leads.filter((l) => ["contact", "demo", "offer"].includes(l.stage));
  const leadsWon = leads.filter((l) => l.stage === "won");
  const overdueTotal = overdueInvoices.reduce((s, i) => s + i.amount, 0);
  const overdueCount = overdueInvoices.length;

  const pipelineStages = [
    { stage: "lead", label: "Lead", count: leads.filter((l) => l.stage === "lead").length, color: "#3E7BD6" },
    { stage: "contact", label: "Kontakt", count: leads.filter((l) => l.stage === "contact").length, color: "#2B6CB0" },
    { stage: "demo", label: "Demo", count: leads.filter((l) => l.stage === "demo").length, color: "#F2A900" },
    { stage: "offer", label: "Oferta", count: leads.filter((l) => l.stage === "offer").length, color: "#C98800" },
    { stage: "won", label: "Wygrana", count: leads.filter((l) => l.stage === "won").length, color: "#22C55E" },
  ];
  const pipelineTotal = pipelineStages.reduce((s, p) => s + p.count, 0);

  // Action queue
  const actions: { title: string; subtitle: string; tag: string; color: string; link: string; cta: string }[] = [];
  if (leadsPending.length) actions.push({ title: `${leadsPending.length} lead czeka na kontakt`, subtitle: leadsPending.slice(0, 3).map(l => l.company_name).join(", "), tag: "Lead", color: C.accent, cta: "Zadzwoń dziś", link: "/owner/pipeline" });
  if (leadsInProgress.length) actions.push({ title: `${leadsInProgress.length} rozmów w toku`, subtitle: leadsInProgress.slice(0, 3).map(l => l.company_name).join(", "), tag: "W toku", color: C.warning, cta: "Kontynuuj", link: "/owner/pipeline" });
  if (trialLeads.length) actions.push({ title: `${trialLeads.length} próba kończy się wkrótce`, subtitle: trialLeads.slice(0, 3).map(l => l.company_name).join(", "), tag: "Próba", color: C.warning, cta: "Przedłuż", link: "/owner/customers" });

  const hasData = leads.length > 0 || openTasks.length > 0;

  return (
    <div className="p-6 space-y-6 animate-fade-in">
      {/* Header */}
      <div>
        <h1 className="font-heading font-bold text-xl" style={{ color: C.text }}>Pulpit</h1>
        <p className="text-sm mt-0.5" style={{ color: C.textMuted }}>
          {hasData ? `${activeLeads.length} aktywnych klientów, MRR ${mrr.toLocaleString("pl-PL")} zł` : "Witaj w panelu zarządzania Mestio."}
        </p>
      </div>

      {/* Quick shortcuts */}
      <div className="flex flex-wrap gap-2">
        {[
          { label: "Nowy klient", href: "/owner/customers/new", icon: Icn.plus, accent: C.accent },
          { label: "Nowa faktura", href: "/owner/invoices", icon: Icn.file, accent: "#8B5CF6" },
          { label: "Pipeline", href: "/owner/pipeline", icon: Icn.trending, accent: C.warning },
          { label: "Zadania", href: "/owner/tasks", icon: Icn.check, accent: C.success },
        ].map((s) => (
          <Link key={s.label} href={s.href}
            className="flex items-center gap-2 px-3.5 py-2 rounded-xl text-sm font-medium transition-all active:scale-[.97]"
            style={{ background: tint(s.accent, 0.08), color: C.text, border: `1px solid ${tint(s.accent, 0.15)}` }}>
            <Svg d={s.icon} size={16} color={s.accent} />
            {s.label}
          </Link>
        ))}
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-4 gap-4">
        {[
          { label: "Aktywni klienci", value: activeLeads.length, color: C.accent, icon: Icn.users, sub: `MRR ${mrr.toLocaleString("pl-PL")} zł`, href: "/owner/customers" },
          { label: "Leady w pipeline", value: leadsPending.length + leadsInProgress.length, color: C.accent, icon: Icn.trending, sub: null, href: "/owner/pipeline",
            extra: <div className="flex items-center gap-2 text-xs mt-1" style={{ color: C.textMuted }}>
              <span className="flex items-center gap-1"><span className="w-1.5 h-1.5 rounded-full" style={{ background: C.accent }} />{leadsPending.length} lead</span>
              <span className="flex items-center gap-1"><span className="w-1.5 h-1.5 rounded-full" style={{ background: C.warning }} />{leadsInProgress.length} w toku</span>
            </div>
          },
          { label: "Zaległe faktury", value: overdueCount, color: C.error, icon: Icn.dollar, sub: overdueCount > 0 ? `${overdueTotal.toLocaleString("pl-PL")} zł` : null, href: "/owner/invoices" },
          { label: "Otwarte zadania", value: openTasks.length, color: C.warning, icon: Icn.file, sub: null, href: "/owner/tasks",
            extra: <div className="text-xs" style={{ color: C.textMuted }}>{openTasks.filter(t => t.due_date && new Date(t.due_date) < new Date()).length} po terminie</div>
          },
        ].map((kpi) => (
          <Link key={kpi.label} href={kpi.href}
            className="relative overflow-hidden rounded-[12px] border p-5 transition-all duration-200 card-hover-interactive"
            style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow, ["--card-accent" as string]: kpi.color }}>
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-medium uppercase tracking-wider" style={{ color: C.textSec }}>{kpi.label}</span>
              <Svg d={kpi.icon} size={16} color={kpi.color} />
            </div>
            <div className="flex items-baseline gap-2">
              <span className="text-2xl font-bold tracking-tight" style={{ color: C.text }}>{kpi.value}</span>
              {kpi.sub && <span className="text-xs font-medium truncate" style={{ color: C.textMuted }}>{kpi.sub}</span>}
            </div>
            {kpi.extra && <div className="mt-3 pt-3" style={{ borderTop: `1px solid ${C.cardBorder}` }}>{kpi.extra}</div>}
          </Link>
        ))}
      </div>

      {/* Middle row: Pipeline + Actions */}
      <div className="grid grid-cols-3 gap-4">
        {/* Pipeline */}
        <div className="col-span-2 rounded-[12px] border p-5" style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow }}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-base font-semibold" style={{ color: C.text }}>Pipeline</h3>
            <Link href="/owner/pipeline" className="text-xs font-medium" style={{ color: C.accent }}>Otwórz →</Link>
          </div>
          {pipelineTotal === 0 ? (
            <div className="flex flex-col items-center justify-center py-8 text-sm" style={{ color: C.textMuted }}>
              <Svg d={Icn.trending} size={32} color={C.textMuted} />
              <p className="mt-2">Brak leadów w pipeline</p>
            </div>
          ) : (
            <>
              <div className="flex h-8 rounded-lg overflow-hidden mb-4">
                {pipelineStages.map(s => { const pct = Math.round((s.count / pipelineTotal) * 100); return pct === 0 ? null : <div key={s.stage} className="flex items-center justify-center text-[11px] font-semibold text-white" style={{ width: `${pct}%`, background: s.color }}>{pct > 10 ? s.count : null}</div> })}
              </div>
              <div className="flex gap-2">
                {pipelineStages.map(s => (
                  <Link key={s.stage} href="/owner/pipeline" className="flex-1 rounded-xl p-3 text-center transition-opacity hover:opacity-85" style={{ background: tint(s.color, 0.08) }}>
                    <div className="w-2 h-2 rounded-full mx-auto mb-1.5" style={{ background: s.color }} />
                    <p className="text-xs font-semibold" style={{ color: s.color }}>{s.label}</p>
                    <p className="text-lg font-bold mt-0.5" style={{ color: C.text }}>{s.count}</p>
                  </Link>
                ))}
              </div>
            </>
          )}
        </div>

        {/* Actions */}
        <div className="rounded-[12px] border overflow-hidden" style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow }}>
          <div className="absolute top-0 left-0 right-0 h-0.5" style={{ background: C.warning }} />
          <div className="p-5">
            <h3 className="text-base font-semibold mb-4" style={{ color: C.text }}>Do działania</h3>
            {actions.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-6 text-sm" style={{ color: C.textMuted }}>
                <Svg d={Icn.check} size={32} color={C.textMuted} />
                <p className="mt-2">Wszystko pod kontrolą</p>
              </div>
            ) : (
              <div className="space-y-2">
                {actions.map((a, i) => (
                  <Link key={i} href={a.link} className="flex items-start gap-3 p-3 rounded-xl transition-colors" style={{ background: tint(a.color, 0.04) }}>
                    <div className="w-9 h-9 rounded-lg flex items-center justify-center shrink-0" style={{ background: tint(a.color, 0.12) }}>
                      <Svg d={Icn.alert} size={16} color={a.color} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium" style={{ color: C.text }}>{a.title}</p>
                      <p className="text-xs mt-0.5 truncate" style={{ color: C.textMuted }}>{a.subtitle || "—"}</p>
                      <div className="flex items-center gap-2 mt-1.5">
                        <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold" style={{ background: tint(a.color, 0.12), color: a.color }}>{a.tag}</span>
                        <span className="text-xs font-medium" style={{ color: a.color }}>{a.cta} →</span>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Bottom: Tasks + Summary */}
      <div className="grid grid-cols-2 gap-4">
        {/* Tasks */}
        <div className="rounded-[12px] border p-5" style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow }}>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-base font-semibold" style={{ color: C.text }}>Zadania</h3>
            <Link href="/owner/tasks" className="text-xs font-medium" style={{ color: C.accent }}>Wszystkie →</Link>
          </div>
          {openTasks.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-6 text-sm" style={{ color: C.textMuted }}>
              <Svg d={Icn.check} size={32} color={C.textMuted} />
              <p className="mt-2">Brak otwartych zadań</p>
            </div>
          ) : (
            <div className="space-y-1">
              {openTasks.slice(0, 6).map(task => {
                const overdue = task.due_date && new Date(task.due_date) < new Date();
                const prioColor = task.priority === "high" ? C.error : task.priority === "medium" ? C.warning : C.textMuted;
                return (
                  <Link key={task.id} href="/owner/tasks" className="flex items-center gap-3 py-2.5 px-3 rounded-xl" style={{ borderBottom: `1px solid ${C.cardBorder}` }}>
                    <div className="w-2 h-2 rounded-full shrink-0" style={{ background: prioColor }} />
                    <span className="text-sm flex-1 truncate" style={{ color: C.text }}>{task.title}</span>
                    {overdue && <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold shrink-0" style={{ background: tint(C.error, 0.12), color: C.error }}>PO TERMINIE</span>}
                  </Link>
                );
              })}
            </div>
          )}
        </div>

        {/* Pipeline summary */}
        <div className="rounded-[12px] border p-5" style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow }}>
          <h3 className="text-base font-semibold mb-3" style={{ color: C.text }}>Pipeline — podsumowanie</h3>
          <div className="space-y-1">
            {[
              { label: "Nowe leady", count: leadsPending.length, color: C.accent, href: "/owner/pipeline" },
              { label: "W toku", count: leadsInProgress.length, color: C.warning, href: "/owner/pipeline" },
              { label: "Wygrane", count: leadsWon.length, color: C.success, href: "/owner/pipeline" },
              { label: "Aktywni klienci", count: activeLeads.length, color: C.accent, href: "/owner/customers" },
              { label: "Zaległe faktury", count: overdueCount, color: C.error, href: "/owner/invoices" },
            ].map(item => (
              <Link key={item.label} href={item.href} className="flex items-center justify-between py-2.5 px-3 rounded-xl" style={{ borderBottom: `1px solid ${C.cardBorder}` }}>
                <div className="flex items-center gap-2.5">
                  <div className="w-2 h-2 rounded-full" style={{ background: item.color }} />
                  <span className="text-sm" style={{ color: C.text }}>{item.label}</span>
                </div>
                <span className="text-sm font-bold" style={{ color: C.text }}>{item.count}</span>
              </Link>
            ))}
          </div>
        </div>
      </div>

      {/* Empty state when no data */}
      {!hasData && (
        <div className="rounded-[12px] border p-12 text-center" style={{ background: C.card, borderColor: C.cardBorder, boxShadow: C.cardShadow }}>
          <div className="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-4" style={{ background: C.accentMuted }}>
            <Svg d={Icn.zap} size={24} color={C.accent} />
          </div>
          <h3 className="font-heading font-semibold text-lg mb-2" style={{ color: C.text }}>Dashboard gotowy</h3>
          <p className="text-sm mb-6 max-w-md mx-auto" style={{ color: C.textMuted }}>
            Baza CRM jest pusta. Dodaj pierwszych klientów, aby zobaczyć pipeline, zadania i KPI w akcji.
          </p>
          <Link href="/owner/customers/new"
            className="inline-flex items-center gap-2 px-5 py-2.5 rounded-[12px] text-sm font-semibold text-white transition-all hover:translate-y-[-1px]"
            style={{ background: `linear-gradient(135deg, ${C.accent}, ${C.accentHover})`, boxShadow: "0 2px 8px rgba(62,123,214,.25)" }}>
            Dodaj pierwszego klienta
            <Svg d={Icn.right} size={14} color="#fff" />
          </Link>
        </div>
      )}
    </div>
  );
}

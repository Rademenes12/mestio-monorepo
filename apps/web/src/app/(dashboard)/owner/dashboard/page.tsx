"use client";

/**
 * CRM-Owner Dashboard (Stratify Light Premium inspired)
 * "Pulpit" — KPI cards with trends, pipeline visual, action queue, team tasks.
 */
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import type { CrmLead, CrmTask } from "@/lib/types";
import Link from "next/link";
import { colors } from "@mestio/design-tokens";
import {
  Users,
  TrendingUp,
  FileText,
  AlertTriangle,
  Zap,
  UserPlus,
  DollarSign,
  BarChart3,
  CheckCircle,
  Clock,
} from "lucide-react";
import {
  SkrotyBar,
  WidgetCard,
  StratifyKpiCard,
} from "@mestio/ui";
import type { Shortcut } from "@mestio/ui";

function PipelineVisual({
  stages,
  total,
}: {
  stages: { stage: string; label: string; count: number; color: string }[];
  total: number;
}) {
  return (
    <div className="space-y-3">
      <div className="flex h-3 w-full rounded-full overflow-hidden bg-gray-100 p-0.5">
        {stages.map((st) => {
          const pct = total > 0 ? (st.count / total) * 100 : 0;
          if (pct === 0) return null;
          return (
            <div
              key={st.stage}
              style={{ width: `${pct}%`, background: st.color }}
              className="h-full first:rounded-l-full last:rounded-r-full transition-all"
              title={`${st.label}: ${st.count}`}
            />
          );
        })}
      </div>
      <div className="grid grid-cols-5 gap-2 pt-1">
        {stages.map((st) => (
          <div key={st.stage} className="text-center">
            <div className="flex items-center justify-center gap-1.5 mb-1">
              <span className="w-2 h-2 rounded-full shrink-0" style={{ background: st.color }} />
              <span className="text-xs text-gray-500 font-medium truncate">{st.label}</span>
            </div>
            <p className="text-sm font-bold text-gray-900">{st.count}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default function DashboardPage() {
  const [leads, setLeads] = useState<CrmLead[]>([]);
  const [openTasks, setOpenTasks] = useState<(CrmTask & { crm_leads: { company_name: string } | null })[]>([]);
  const [overdueInvoices, setOverdueInvoices] = useState<{ status: string; amount: number }[]>([]);

  useEffect(() => {
    async function fetchData() {
      try {
        const supabase = createClient();
        const [leadsRes, tasksRes, invoicesRes] = await Promise.allSettled([
          supabase.from("crm_leads").select("*"),
          supabase
            .from("crm_tasks")
            .select("*, crm_leads(company_name)")
            .eq("done", false)
            .order("due_date", { ascending: true })
            .limit(8),
          supabase.from("crm_invoices").select("status, amount").eq("status", "overdue"),
        ]);

        if (leadsRes.status === "fulfilled" && leadsRes.value.data) {
          setLeads(leadsRes.value.data as CrmLead[]);
        }
        if (tasksRes.status === "fulfilled" && tasksRes.value.data) {
          setOpenTasks(tasksRes.value.data as (CrmTask & { crm_leads: { company_name: string } | null })[]);
        }
        if (invoicesRes.status === "fulfilled" && invoicesRes.value.data) {
          setOverdueInvoices(invoicesRes.value.data as { status: string; amount: number }[]);
        }
      } catch (err) {
        console.error("[DashboardPage] DB load error:", err);
      }
    }
    fetchData();
  }, []);

  const activeLeads = (leads || []).filter((l) => l?.stage === "active");
  const trialLeads = (leads || []).filter((l) => ["onboarding", "won"].includes(l?.stage || ""));
  const mrr = activeLeads.reduce((sum, l) => sum + (l?.mrr || 0), 0);

  const leadsPending = (leads || []).filter((l) => l?.stage === "lead");
  const leadsInProgress = (leads || []).filter((l) => ["contact", "demo", "offer"].includes(l?.stage || ""));

  // ── Pipeline stages ──
  const pipelineStages = [
    { stage: "lead", label: "Lead", count: (leads || []).filter((l) => l?.stage === "lead").length, color: "#3E7BD6" },
    { stage: "contact", label: "Kontakt", count: (leads || []).filter((l) => l?.stage === "contact").length, color: "#2B6CB0" },
    { stage: "demo", label: "Demo", count: (leads || []).filter((l) => l?.stage === "demo").length, color: "#F2A900" },
    { stage: "offer", label: "Oferta", count: (leads || []).filter((l) => l?.stage === "offer").length, color: "#C98800" },
    { stage: "won", label: "Wygrana", count: (leads || []).filter((l) => l?.stage === "won").length, color: "#2E9E6B" },
  ];

  const pipelineTotal = pipelineStages.reduce((s, p) => s + (p?.count || 0), 0);

  // ── Action queue ──
  const actionQueue: {
    title: string; subtitle: string; tag: string; color: string;
    icon: typeof Zap; link: string; cta: string;
  }[] = [];

  if (leadsPending.length) {
    actionQueue.push({
      title: `${leadsPending.length} ${leadsPending.length === 1 ? "lead czeka" : "leady czekają"} na kontakt`,
      subtitle: leadsPending.slice(0, 3).map((l) => l?.company_name || "Klient").join(", "),
      tag: "Lead", color: colors.info,
      icon: Zap, cta: "Zadzwoń dziś", link: "/pipeline",
    });
  }
  if (leadsInProgress.length) {
    actionQueue.push({
      title: `${leadsInProgress.length} rozmów w toku`,
      subtitle: leadsInProgress.slice(0, 3).map((l) => l?.company_name || "Klient").join(", "),
      tag: "W toku", color: colors.warning,
      icon: Clock, cta: "Kontynuuj", link: "/pipeline",
    });
  }
  if (trialLeads.length) {
    actionQueue.push({
      title: `${trialLeads.length} ${trialLeads.length === 1 ? "próba kończy się" : "próby kończą się"} wkrótce`,
      subtitle: trialLeads.slice(0, 3).map((l) => l?.company_name || "Klient").join(", "),
      tag: "Próba", color: colors.warning,
      icon: AlertTriangle, cta: "Przedłuż", link: "/customers",
    });
  }

  const overdueTotal = (overdueInvoices || []).reduce((s, i) => s + (i?.amount || 0), 0);
  const overdueCount = (overdueInvoices || []).length;

  // ── Shortcuts ──
  const shortcuts: Shortcut[] = [
    { label: "Nowy klient", icon: UserPlus, href: "/customers/new", accentColor: colors.accent, shortcut: "Ctrl+N" },
    { label: "Nowa faktura", icon: FileText, href: "/invoices", accentColor: "#8B5CF6", shortcut: "Ctrl+I" },
    { label: "Nowe zadanie", icon: CheckCircle, href: "/tasks", accentColor: colors.warning, shortcut: "Ctrl+T" },
    { label: "Raport", icon: BarChart3, href: "/reports", accentColor: "#173A6A" },
  ];

  return (
    <div className="space-y-6 animate-fade-in">
      {/* ── Header ── */}
      <div>
        <h1 className="font-heading font-bold text-xl text-ink">Pulpit</h1>
        <p className="text-sm text-ink/50 mt-0.5">
          Witaj w panelu zarządzania — {activeLeads.length} aktywnych klientów, MRR {(mrr || 0).toLocaleString("pl-PL")} zł
        </p>
      </div>

      {/* ── Twoje skróty ── */}
      <SkrotyBar shortcuts={shortcuts} />

      {/* ── KPI Cards row (Stratify Light Design) ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Link href="/customers" className="block">
          <StratifyKpiCard
            title="Aktywni Klienci"
            value={activeLeads.length}
            change="+14%"
            changeType="positive"
            timeframe={`MRR ${(mrr || 0).toLocaleString("pl-PL")} zł`}
            icon={Users}
            iconBgColor="bg-blue-50"
            iconColor="text-[#3E7BD6]"
          />
        </Link>
        <Link href="/pipeline" className="block">
          <StratifyKpiCard
            title="Leady w Pipeline"
            value={leadsPending.length + leadsInProgress.length}
            change={`${leadsPending.length} nowych`}
            changeType="positive"
            timeframe={`${leadsInProgress.length} w toku negocjacji`}
            icon={TrendingUp}
            iconBgColor="bg-purple-50"
            iconColor="text-[#8864F0]"
          />
        </Link>
        <Link href="/invoices" className="block">
          <StratifyKpiCard
            title="Zaległe Faktury"
            value={overdueCount}
            change={overdueCount > 0 ? `${(overdueTotal || 0).toLocaleString("pl-PL")} zł` : "0 zł"}
            changeType={overdueCount > 0 ? "negative" : "neutral"}
            timeframe={overdueCount > 0 ? "Wymaga ponaglenia" : "Brak opóźnień"}
            icon={DollarSign}
            iconBgColor={overdueCount > 0 ? "bg-rose-50" : "bg-emerald-50"}
            iconColor={overdueCount > 0 ? "text-rose-600" : "text-emerald-600"}
          />
        </Link>
        <Link href="/tasks" className="block">
          <StratifyKpiCard
            title="Otwarte Zadania"
            value={openTasks.length}
            change={`${openTasks.filter((t) => t?.due_date && new Date(t.due_date) < new Date()).length} po terminie`}
            changeType={openTasks.filter((t) => t?.due_date && new Date(t.due_date) < new Date()).length > 0 ? "negative" : "positive"}
            timeframe="Do zrealizowania"
            icon={FileText}
            iconBgColor="bg-amber-50"
            iconColor="text-amber-600"
          />
        </Link>
      </div>

      {/* ── Middle row: Pipeline + Action queue ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Pipeline visual */}
        <WidgetCard
          title="Pipeline"
          action={
            <Link href="/pipeline" className="text-xs font-medium" style={{ color: colors.accent }}>
              Otwórz →
            </Link>
          }
          className="lg:col-span-2"
        >
          <PipelineVisual stages={pipelineStages} total={pipelineTotal} />
        </WidgetCard>

        {/* Action queue */}
        <WidgetCard title="Do działania" accentColor={colors.warning}>
          {actionQueue.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-6 text-sm" style={{ color: colors.textMuted }}>
              <CheckCircle className="w-8 h-8 mb-2 opacity-40" />
              <p>Wszystko pod kontrolą</p>
            </div>
          ) : (
            <div className="space-y-2">
              {actionQueue.map((card, i) => {
                const Icon = card.icon;
                return (
                  <Link
                    key={i}
                    href={card.link}
                    className="flex items-start gap-3 p-3 rounded-xl transition-colors"
                    style={{ background: `${card.color}08` }}
                  >
                    <div
                      className="w-9 h-9 rounded-lg flex items-center justify-center shrink-0"
                      style={{ background: `${card.color}15` }}
                    >
                      <Icon className="w-4 h-4" style={{ color: card.color }} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium" style={{ color: colors.text }}>
                        {card.title}
                      </p>
                      <p className="text-xs mt-0.5 truncate" style={{ color: colors.textMuted }}>
                        {card.subtitle}
                      </p>
                      <div className="flex items-center gap-2 mt-1.5">
                        <span
                          className="text-[10px] px-2 py-0.5 rounded-full font-semibold"
                          style={{ background: `${card.color}18`, color: card.color }}
                        >
                          {card.tag}
                        </span>
                      </div>
                    </div>
                  </Link>
                );
              })}
            </div>
          )}
        </WidgetCard>
      </div>
    </div>
  );
}

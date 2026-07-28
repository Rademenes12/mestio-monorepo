/**
 * CRM-Client Dashboard (Erste Mobile inspired)
 * "Pulpit" — health score, quick glance, attention list, activity timeline.
 */
import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";
import { PRIORITY_CONFIG, type ReportPriority } from "@/lib/types";
import { colors } from "@mestio/design-tokens";
import {
  AlertCircle,
  MessageSquare,
  FileText,
  Plus,
  TrendingUp,
  TrendingDown,
  Clock,
  CheckCircle,
  AlertTriangle,
  Eye,
} from "lucide-react";
import {
  KpiCard,
  SkrotyBar,
  ActivityTimeline,
  StratifyKpiCard,
  StratifyActivityStream,
} from "@mestio/ui";
import type { Shortcut, TimelineEvent, ActivityEvent } from "@mestio/ui";

export default async function DashboardPage() {
  const ctx = await getActiveEstate();
  if (!ctx || !ctx.estateId) redirect("/login");
  const { supabase, estateId } = ctx;

  // ── Parallel data ──
  const [
    { count: totalReports },
    { count: newReports },
    { count: inProgressReports },
    { count: closedReports },
    { count: rejectedReports },
    { count: urgentReports },
    { count: overdueSla },
    { count: totalTasks },
    { count: doneTasks },
    attentionReportsRes,
    recentEventsRes,
  ] = await Promise.all([
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Nowe"),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "W realizacji"),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Zamkniete"),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Odrzucone"),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).in("priority", ["high", "critical"]).not("status", "in", '("Zamkniete","Odrzucone")'),
    supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).not("status", "in", '("Zamkniete","Odrzucone")').lt("sla_deadline", new Date().toISOString()),
    supabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).eq("estate_id", estateId),
    supabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Zrobione"),
    supabase
      .from("fixflow_reports")
      .select("id, display_id, title, priority, status")
      .eq("estate_id", estateId)
      .in("priority", ["high", "critical"])
      .in("status", ["Nowe", "W realizacji"])
      .order("created_at", { ascending: false })
      .limit(5),
    supabase
      .from("fixflow_report_events")
      .select("id, event_type, description, user_name, created_at, report_id, fixflow_reports!inner(estate_id)")
      .eq("fixflow_reports.estate_id", estateId)
      .order("created_at", { ascending: false })
      .limit(10),
  ]);

  // ── Computed metrics ──
  const activeCalc = (newReports ?? 0) + (inProgressReports ?? 0);
  const slaPct = activeCalc > 0 ? Math.round(((activeCalc - (overdueSla ?? 0)) / activeCalc) * 100) : 100;
  const taskPct = (totalTasks ?? 0) > 0 ? Math.round(((doneTasks ?? 0) / (totalTasks ?? 1)) * 100) : 100;
  const healthScore = Math.round((Math.max(0, Math.min(100, slaPct)) + taskPct) / 2);

  const healthMeta =
    healthScore >= 80
      ? { label: "Dobry stan", color: colors.success, icon: CheckCircle }
      : healthScore >= 50
        ? { label: "Wymaga uwagi", color: colors.warning, icon: AlertTriangle }
        : { label: "Krytyczny", color: colors.error, icon: AlertCircle };

  // ── Shortcuts ──
  const shortcuts: Shortcut[] = [
    { label: "Nowe zgłoszenie", icon: Plus, href: "/reports", accentColor: colors.accent },
    { label: "Wiadomości", icon: MessageSquare, href: "/announcements", accentColor: colors.info },
    { label: "Zadania", icon: FileText, href: "/tasks", accentColor: colors.warning },
  ];

  // ── Activity timeline ──
  const events: TimelineEvent[] = (recentEventsRes.data ?? []).map((e: any) => ({
    id: e.id,
    time: e.created_at,
    user: e.user_name ?? "System",
    action: e.event_type,
    description: e.description ?? "",
    href: `/reports/${e.report_id}`,
  }));

  // ── Priority colors for attention list ──
  const priorityColor = (p: string) =>
    p === "critical"
      ? colors.error
      : p === "high"
        ? colors.warning
        : colors.info;

  return (
    <div className="space-y-6 animate-fade-in">
      {/* ── Header ── */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-heading font-bold text-ink">Pulpit</h1>
          <p className="text-sm text-ink/50 mt-0.5">Przegląd sytuacji na osiedlu</p>
        </div>
        <Link
          href="/reports"
          className="flex items-center gap-1.5 text-xs font-medium px-3 py-1.5 rounded-lg transition-colors"
          style={{
            background: `${colors.accent}10`,
            color: colors.accent,
          }}
        >
          <Eye className="w-3.5 h-3.5" />
          Szybki podgląd
        </Link>
      </div>

      {/* ── Shortcuts bar (Erste-inspired "Twoje skróty") ── */}
      <SkrotyBar shortcuts={shortcuts} />

      {/* ── KPI Cards row (Stratify Light Premium) ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Link href="/reports?status=Nowe" className="block">
          <StratifyKpiCard
            title="Nowe Zgłoszenia"
            value={newReports ?? 0}
            change={(newReports ?? 0) > 0 ? `${newReports} oczekujących` : "Brak zgłoszeń"}
            changeType={(newReports ?? 0) > 5 ? "warning" : "positive"}
            timeframe="Zgłoszone przez mieszkańców"
            icon={AlertCircle}
            iconBgColor="bg-blue-50"
            iconColor="text-[#3E7BD6]"
          />
        </Link>
        <Link href="/reports?status=W+realizacji" className="block">
          <StratifyKpiCard
            title="W Realizacji"
            value={inProgressReports ?? 0}
            change={overdueSla && overdueSla > 0 ? `${overdueSla} po SLA` : "SLA w normie"}
            changeType={overdueSla && overdueSla > 0 ? "negative" : "positive"}
            timeframe="Zlecenia u wykonawców"
            icon={Clock}
            iconBgColor="bg-amber-50"
            iconColor="text-amber-600"
          />
        </Link>
        <Link href="/reports?priority=high,critical" className="block">
          <StratifyKpiCard
            title="Wymagają Uwagi"
            value={urgentReports ?? 0}
            change={(urgentReports ?? 0) > 0 ? "Priorytet pilny" : "Wszystko w normie"}
            changeType={(urgentReports ?? 0) > 0 ? "negative" : "positive"}
            timeframe="Zgłoszenia o wysokim priorytecie"
            icon={AlertTriangle}
            iconBgColor={(urgentReports ?? 0) > 0 ? "bg-rose-50" : "bg-emerald-50"}
            iconColor={(urgentReports ?? 0) > 0 ? "text-rose-600" : "text-emerald-600"}
          />
        </Link>
        <div className="bg-white border border-[#E9EEF5] rounded-[20px] p-5 shadow-[0_2px_14px_rgba(14,26,43,0.04)] hover:shadow-[0_6px_20px_rgba(14,26,43,0.08)] transition-all duration-200">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-semibold uppercase tracking-wider text-[#7C8AA0]">
              Zdrowie Osiedla
            </span>
            <div className="p-2.5 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <CheckCircle className="w-5 h-5" />
            </div>
          </div>

          <div className="flex items-baseline justify-between gap-2">
            <div className="text-2xl font-bold text-[#0E1A2B] tracking-tight">
              {healthScore} / 100
            </div>
            <div className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200/50">
              <span>{healthMeta.label}</span>
            </div>
          </div>

          <div className="mt-3">
            <div className="w-full bg-[#F0F3F8] h-2 rounded-full overflow-hidden">
              <div
                className="bg-[#10B981] h-full rounded-full transition-all duration-500"
                style={{ width: `${Math.min(100, Math.max(0, healthScore))}%` }}
              />
            </div>
          </div>

          <div className="mt-2.5 text-xs text-[#7C8AA0] flex items-center justify-between">
            <span>SLA: {slaPct}%</span>
            <span>Zadania: {taskPct}%</span>
          </div>
        </div>
      </div>

      {/* ── Middle row: Status chart + Attention list ── */}
      <div className="grid grid-cols-3 gap-4">
        {/* Status chart card */}
        <div className="col-span-2 rounded-2xl border p-5" style={{ background: colors.card, borderColor: colors.cardBorder }}>
          <h3 className="text-base font-semibold mb-4" style={{ color: colors.text }}>
            Sprawy według statusu
          </h3>
          <StatusBarChart
            nowe={newReports ?? 0}
            realizacji={inProgressReports ?? 0}
            zamkniete={closedReports ?? 0}
            odrzucone={rejectedReports ?? 0}
          />
        </div>

        {/* Attention list */}
        <div className="rounded-2xl border p-5" style={{ background: colors.card, borderColor: colors.cardBorder }}>
          <h3 className="text-base font-semibold mb-4" style={{ color: colors.text }}>
            Wymagają uwagi
            {(attentionReportsRes.data?.length ?? 0) > 0 && (
              <span
                className="ml-2 text-xs px-2 py-0.5 rounded-full font-medium"
                style={{ background: `${colors.error}15`, color: colors.error }}
              >
                {attentionReportsRes.data?.length ?? 0}
              </span>
            )}
          </h3>
          <AttentionList
            reports={(attentionReportsRes.data ?? []) as any[]}
            priorityColor={priorityColor}
          />
        </div>
      </div>

      {/* ── Activity Timeline (Erste-inspired) ── */}
      <div className="rounded-2xl border" style={{ background: colors.card, borderColor: colors.cardBorder }}>
        <div className="flex items-center justify-between px-5 pt-4 pb-2">
          <h3 className="text-base font-semibold" style={{ color: colors.text }}>
            Ostatnia aktywność
          </h3>
          {events.length > 0 && (
            <Link
              href="/reports"
              className="text-xs font-medium transition-colors"
              style={{ color: colors.accent }}
            >
              Zobacz wszystkie →
            </Link>
          )}
        </div>
        <div className="px-5 pb-5">
          <ActivityTimeline events={events} />
        </div>
      </div>
    </div>
  );
}

/* ── Inline chart ── */
function StatusBarChart({
  nowe, realizacji, zamkniete, odrzucone,
}: {
  nowe: number; realizacji: number; zamkniete: number; odrzucone: number;
}) {
  const cols = [
    { label: "Nowe", count: nowe, color: colors.info },
    { label: "W realizacji", count: realizacji, color: colors.warning },
    { label: "Zamknięte", count: zamkniete, color: colors.success },
    { label: "Odrzucone", count: odrzucone, color: colors.textMuted },
  ];
  const max = Math.max(1, ...cols.map((c) => c.count));
  const total = nowe + realizacji + zamkniete + odrzucone;

  if (total === 0) {
    return (
      <div className="flex items-center justify-center h-[160px] text-sm" style={{ color: colors.textMuted }}>
        Brak zgłoszeń
      </div>
    );
  }

  return (
    <div className="flex items-end gap-5 h-[160px] px-1">
      {cols.map((c) => {
        const height = Math.max(8, Math.round((c.count / max) * 130));
        return (
          <div key={c.label} className="flex-1 flex flex-col items-center justify-end gap-2">
            <span className="font-heading font-bold text-base" style={{ color: c.color }}>
              {c.count}
            </span>
            <div
              className="w-full max-w-[52px] rounded-t-lg transition-all duration-300"
              style={{ height, background: c.color, opacity: c.count > 0 ? 1 : 0.3 }}
            />
            <span className="text-xs font-medium text-center" style={{ color: colors.textSecondary }}>
              {c.label}
            </span>
          </div>
        );
      })}
    </div>
  );
}

/* ── Attention list ── */
function AttentionList({
  reports,
  priorityColor,
}: {
  reports: { id: string; display_id: string | null; title: string; priority: string }[];
  priorityColor: (p: string) => string;
}) {
  if (reports.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-8 text-sm" style={{ color: colors.textMuted }}>
        <CheckCircle className="w-8 h-8 mb-2 opacity-40" />
        <p>Wszystko pod kontrolą</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col">
      {reports.map((r) => {
        const config = PRIORITY_CONFIG[r.priority as ReportPriority] ?? { label: r.priority, color: colors.textMuted };
        return (
          <Link
            key={r.id}
            href={`/reports/${r.id}`}
            className="flex items-center gap-3 py-2.5 border-b last:border-0 hover:opacity-80 transition-opacity min-h-[44px]"
            style={{ borderColor: colors.cardBorder }}
          >
            <div
              className="w-2.5 h-2.5 rounded-full shrink-0"
              style={{ background: priorityColor(r.priority) }}
            />
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium truncate" style={{ color: colors.text }}>
                {r.title}
              </p>
              <p className="text-xs mt-0.5 font-mono" style={{ color: colors.textMuted }}>
                #{r.display_id ?? r.id.slice(0, 6)}
              </p>
            </div>
            <span
              className="text-[11px] font-semibold px-2.5 py-1 rounded-full shrink-0"
              style={{
                background: `${config.color}18`,
                color: config.color,
              }}
            >
              {config.label}
            </span>
          </Link>
        );
      })}
    </div>
  );
}

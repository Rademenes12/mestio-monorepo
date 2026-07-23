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
import { KpiCard, SkrotyBar, ActivityTimeline } from "@mestio/ui";
import type { Shortcut, TimelineEvent } from "@mestio/ui";

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

      {/* ── KPI Cards row (Erste-inspired "Szybki podgląd") ── */}
      <div className="grid grid-cols-4 gap-4">
        <KpiCard
          label="Nowe zgłoszenia"
          value={newReports ?? 0}
          accentColor={colors.info}
          trend={(newReports ?? 0) > 5 ? "up" : "flat"}
          trendLabel={(newReports ?? 0) > 5 ? "ponad 5" : undefined}
          href="/reports?status=Nowe"
        />
        <KpiCard
          label="W realizacji"
          value={inProgressReports ?? 0}
          accentColor={colors.warning}
          href="/reports?status=W+realizacji"
        >
          <div className="flex items-center gap-3 text-xs" style={{ color: colors.textMuted }}>
            <span className="flex items-center gap-1">
              <Clock className="w-3 h-3" />
              {overdueSla ?? 0} po SLA
            </span>
          </div>
        </KpiCard>
        <KpiCard
          label="Wymagają uwagi"
          value={urgentReports ?? 0}
          accentColor={colors.error}
          trend={(urgentReports ?? 0) > 0 ? "down" : undefined}
          trendLabel={(urgentReports ?? 0) > 0 ? "do działania" : undefined}
          href="/reports?priority=high,critical"
        />
        <div
          className="relative overflow-hidden rounded-2xl border p-5"
          style={{
            background: colors.card,
            borderColor: colors.cardBorder,
          }}
        >
          <div
            className="absolute top-0 left-0 right-0 h-0.5"
            style={{ background: `linear-gradient(90deg, ${healthMeta.color}, transparent)` }}
          />
          <div className="flex items-center justify-between mb-2">
            <span className="text-xs font-medium uppercase tracking-wider" style={{ color: colors.textSecondary }}>
              Zdrowie osiedla
            </span>
            <healthMeta.icon className="w-4 h-4" style={{ color: healthMeta.color }} />
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold tracking-tight" style={{ color: colors.text }}>
              {healthScore}
            </span>
            <span className="text-xs font-medium" style={{ color: healthMeta.color }}>
              {healthMeta.label}
            </span>
          </div>
          <div className="mt-3 pt-3 space-y-1.5" style={{ borderTop: `1px solid ${colors.cardBorder}` }}>
            <div className="flex justify-between text-xs" style={{ color: colors.textMuted }}>
              <span>SLA</span>
              <span className="font-mono font-medium" style={{ color: colors.text }}>{slaPct}%</span>
            </div>
            <div className="flex justify-between text-xs" style={{ color: colors.textMuted }}>
              <span>Zadania</span>
              <span className="font-mono font-medium" style={{ color: colors.text }}>{taskPct}%</span>
            </div>
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

"use client";

/**
 * CRM-Client Dashboard (Erste Mobile inspired)
 * "Pulpit" — health score, quick glance, attention list, activity timeline.
 */
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import Link from "next/link";
import { colors } from "@mestio/design-tokens";
import {
  AlertCircle,
  MessageSquare,
  FileText,
  Plus,
  Clock,
  CheckCircle,
  AlertTriangle,
  Eye,
} from "lucide-react";
import {
  SkrotyBar,
  WidgetCard,
  StratifyKpiCard,
  StratifyActivityStream,
} from "@mestio/ui";
import type { Shortcut, ActivityEvent } from "@mestio/ui";

export default function ClientDashboardPage() {
  const [loading, setLoading] = useState(true);
  const [newReports, setNewReports] = useState(0);
  const [inProgressReports, setInProgressReports] = useState(0);
  const [urgentReports, setUrgentReports] = useState(0);
  const [overdueSla, setOverdueSla] = useState(0);
  const [totalTasks, setTotalTasks] = useState(0);
  const [doneTasks, setDoneTasks] = useState(0);
  const [attentionReports, setAttentionReports] = useState<any[]>([]);
  const [recentEvents, setRecentEvents] = useState<any[]>([]);

  useEffect(() => {
    async function loadData() {
      try {
        const supabase = createClient();
        const { data: estateData } = await supabase.from("fixflow_estates").select("id").limit(1);
        const estateId = estateData?.[0]?.id || "demo-estate-1";

        const [
          newRes,
          progRes,
          urgRes,
          overRes,
          totTaskRes,
          doneTaskRes,
          attRes,
          evRes,
        ] = await Promise.allSettled([
          supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Nowe"),
          supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "W realizacji"),
          supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).in("priority", ["high", "critical"]),
          supabase.from("fixflow_reports").select("*", { count: "exact", head: true }).eq("estate_id", estateId).lt("sla_deadline", new Date().toISOString()),
          supabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).eq("estate_id", estateId),
          supabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).eq("estate_id", estateId).eq("status", "Zrobione"),
          supabase
            .from("fixflow_reports")
            .select("id, display_id, title, priority, status")
            .eq("estate_id", estateId)
            .limit(5),
          supabase
            .from("fixflow_report_events")
            .select("id, event_type, description, user_name, created_at, report_id")
            .limit(10),
        ]);

        if (newRes.status === "fulfilled") setNewReports(newRes.value.count ?? 0);
        if (progRes.status === "fulfilled") setInProgressReports(progRes.value.count ?? 0);
        if (urgRes.status === "fulfilled") setUrgentReports(urgRes.value.count ?? 0);
        if (overRes.status === "fulfilled") setOverdueSla(overRes.value.count ?? 0);
        if (totTaskRes.status === "fulfilled") setTotalTasks(totTaskRes.value.count ?? 0);
        if (doneTaskRes.status === "fulfilled") setDoneTasks(doneTaskRes.value.count ?? 0);
        if (attRes.status === "fulfilled" && attRes.value.data) setAttentionReports(attRes.value.data);
        if (evRes.status === "fulfilled" && evRes.value.data) setRecentEvents(evRes.value.data);
      } catch (err) {
        console.error("[ClientDashboard] Load error:", err);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  // ── Computed metrics ──
  const activeCalc = newReports + inProgressReports;
  const slaPct = activeCalc > 0 ? Math.round(((activeCalc - overdueSla) / activeCalc) * 100) : 100;
  const taskPct = totalTasks > 0 ? Math.round((doneTasks / totalTasks) * 100) : 100;
  const healthScore = Math.round((Math.max(0, Math.min(100, slaPct)) + taskPct) / 2);

  const healthMeta =
    healthScore >= 80
      ? { label: "Dobry stan", color: colors.success, icon: CheckCircle }
      : healthScore >= 50
        ? { label: "Wymaga uwagi", color: colors.warning, icon: AlertTriangle }
        : { label: "Krytyczny", color: colors.error, icon: AlertCircle };

  // ── Shortcuts ──
  const shortcuts: Shortcut[] = [
    { label: "Nowe zgłoszenie", icon: Plus, href: "/client/reports", accentColor: colors.accent },
    { label: "Wiadomości", icon: MessageSquare, href: "/client/announcements", accentColor: colors.info },
    { label: "Zadania", icon: FileText, href: "/client/tasks", accentColor: colors.warning },
  ];

  // ── Activity stream ──
  const streamEvents: ActivityEvent[] = (recentEvents || []).map((e: any) => ({
    id: e.id,
    type: "info",
    title: e.event_type || "Aktywność",
    description: e.description || "Zaktualizowano zgłoszenie",
    time: e.created_at || new Date().toISOString(),
    timestamp: e.created_at || new Date().toISOString(),
    user: e.user_name || "System",
  }));

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
          <h1 className="text-xl font-heading font-bold text-ink">Pulpit Zarządcy</h1>
          <p className="text-sm text-ink/50 mt-0.5">Przegląd sytuacji na osiedlu</p>
        </div>
        <Link
          href="/client/reports"
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

      {/* ── Shortcuts bar ── */}
      <SkrotyBar shortcuts={shortcuts} />

      {/* ── KPI Cards row (Stratify Light Premium) ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Link href="/client/reports?status=Nowe" className="block">
          <StratifyKpiCard
            title="Nowe Zgłoszenia"
            value={newReports}
            change={newReports > 0 ? `${newReports} oczekujących` : "Brak zgłoszeń"}
            changeType={newReports > 5 ? "warning" : "positive"}
            timeframe="Zgłoszone przez mieszkańców"
            icon={AlertCircle}
            iconBgColor="bg-blue-50"
            iconColor="text-[#3E7BD6]"
          />
        </Link>
        <Link href="/client/reports?status=W+realizacji" className="block">
          <StratifyKpiCard
            title="W Realizacji"
            value={inProgressReports}
            change={overdueSla > 0 ? `${overdueSla} po SLA` : "SLA w normie"}
            changeType={overdueSla > 0 ? "negative" : "positive"}
            timeframe="Zlecenia u wykonawców"
            icon={Clock}
            iconBgColor="bg-amber-50"
            iconColor="text-amber-600"
          />
        </Link>
        <Link href="/client/reports?priority=high,critical" className="block">
          <StratifyKpiCard
            title="Wymagają Uwagi"
            value={urgentReports}
            change={urgentReports > 0 ? "Priorytet pilny" : "Wszystko w normie"}
            changeType={urgentReports > 0 ? "negative" : "positive"}
            timeframe="Zgłoszenia o wysokim priorytecie"
            icon={AlertTriangle}
            iconBgColor={urgentReports > 0 ? "bg-rose-50" : "bg-emerald-50"}
            iconColor={urgentReports > 0 ? "text-rose-600" : "text-emerald-600"}
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
        </div>
      </div>

      {/* ── Middle row: Attention list + Activity Stream ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        <WidgetCard
          title="Wymagają Uwagi"
          accentColor={colors.warning}
          className="lg:col-span-2"
        >
          {attentionReports.length === 0 ? (
            <div className="py-8 text-center text-sm text-ink/40">
              Brak zgłoszeń wymagających natychmiastowej uwagi.
            </div>
          ) : (
            <div className="divide-y divide-glass-border">
              {attentionReports.map((r: any) => (
                <Link
                  key={r.id}
                  href={`/client/reports/${r.id}`}
                  className="flex items-center justify-between py-3 hover:bg-[#F8FAFC] -mx-4 px-4 transition-colors rounded-lg"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <span
                      className="w-2 h-2 rounded-full shrink-0"
                      style={{ background: priorityColor(r.priority) }}
                    />
                    <span className="mono text-xs text-ink/40 shrink-0">
                      {r.display_id || r.id.slice(0, 6)}
                    </span>
                    <span className="text-sm font-medium text-ink truncate">
                      {r.title}
                    </span>
                  </div>
                  <span className="text-xs font-medium text-ink/50 bg-[#F1F5F9] px-2 py-0.5 rounded-full shrink-0">
                    {r.status}
                  </span>
                </Link>
              ))}
            </div>
          )}
        </WidgetCard>

        <WidgetCard title="Strumień Aktywności">
          <StratifyActivityStream events={streamEvents.slice(0, 6)} />
        </WidgetCard>
      </div>
    </div>
  );
}

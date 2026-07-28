/**
 * CRM-Owner Dashboard (Erste Mobile inspired)
 * "Pulpit" — KPI cards with trends, pipeline visual, action queue, team tasks.
 */
import { createClient } from "@/lib/supabase/server";
import type { CrmLead, CrmTask } from "@/lib/types";
import { runAutomations } from "@/lib/automations";
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
  ArrowRight,
  CheckCircle,
  Clock,
} from "lucide-react";
import {
  KpiCard,
  SkrotyBar,
  WidgetCard,
  ActivityTimeline,
  StratifyKpiCard,
  StratifyActivityStream,
} from "@mestio/ui";
import type { Shortcut, TimelineEvent, ActivityEvent } from "@mestio/ui";

function tint(hex: string, alpha: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255}, ${(n >> 8) & 255}, ${n & 255}, ${alpha})`;
}

export default async function DashboardPage() {
  const supabase = await createClient();
  await supabase.auth.getUser();

  // Silnik automatyzacji
  await runAutomations(supabase).catch(() => 0);

  // ── Parallel queries ──
  const [leadsRes, tasksRes, invoicesRes] = await Promise.all([
    supabase.from("crm_leads").select("*"),
    supabase
      .from("crm_tasks")
      .select("*, crm_leads(company_name)")
      .eq("done", false)
      .order("due_date", { ascending: true })
      .limit(8),
    supabase.from("crm_invoices").select("status, amount").eq("status", "overdue"),
  ]);

  const leads = (leadsRes.data as CrmLead[]) ?? [];
  const openTasks = (tasksRes.data as (CrmTask & { crm_leads: { company_name: string } | null })[]) ?? [];
  const overdueInvoices = (invoicesRes.data as { status: string; amount: number }[]) ?? [];

  const activeLeads = leads.filter((l) => l.stage === "active");
  const trialLeads = leads.filter((l) => ["onboarding", "won"].includes(l.stage));
  const mrr = activeLeads.reduce((sum, l) => sum + (l.mrr || 0), 0);

  const leadsPending = leads.filter((l) => l.stage === "lead");
  const leadsInProgress = leads.filter((l) => ["contact", "demo", "offer"].includes(l.stage));
  const leadsWon = leads.filter((l) => l.stage === "won");

  // ── Pipeline stages ──
  const pipelineStages = [
    { stage: "lead", label: "Lead", count: leads.filter((l) => l.stage === "lead").length, color: "#3E7BD6" },
    { stage: "contact", label: "Kontakt", count: leads.filter((l) => l.stage === "contact").length, color: "#2B6CB0" },
    { stage: "demo", label: "Demo", count: leads.filter((l) => l.stage === "demo").length, color: "#F2A900" },
    { stage: "offer", label: "Oferta", count: leads.filter((l) => l.stage === "offer").length, color: "#C98800" },
    { stage: "won", label: "Wygrana", count: leads.filter((l) => l.stage === "won").length, color: "#2E9E6B" },
  ];

  const pipelineTotal = pipelineStages.reduce((s, p) => s + p.count, 0);

  // ── Action queue ──
  const actionQueue: {
    title: string; subtitle: string; tag: string; color: string;
    icon: typeof Zap; link: string; cta: string;
  }[] = [];

  if (leadsPending.length) {
    actionQueue.push({
      title: `${leadsPending.length} ${leadsPending.length === 1 ? "lead czeka" : "leady czekają"} na kontakt`,
      subtitle: leadsPending.slice(0, 3).map((l) => l.company_name).join(", "),
      tag: "Lead", color: colors.info,
      icon: Zap, cta: "Zadzwoń dziś", link: "/pipeline",
    });
  }
  if (leadsInProgress.length) {
    actionQueue.push({
      title: `${leadsInProgress.length} rozmów w toku`,
      subtitle: leadsInProgress.slice(0, 3).map((l) => l.company_name).join(", "),
      tag: "W toku", color: colors.warning,
      icon: Clock, cta: "Kontynuuj", link: "/pipeline",
    });
  }
  if (trialLeads.length) {
    actionQueue.push({
      title: `${trialLeads.length} ${trialLeads.length === 1 ? "próba kończy się" : "próby kończą się"} wkrótce`,
      subtitle: trialLeads.slice(0, 3).map((l) => l.company_name).join(", "),
      tag: "Próba", color: colors.warning,
      icon: AlertTriangle, cta: "Przedłuż", link: "/customers",
    });
  }

  const overdueTotal = overdueInvoices.reduce((s, i) => s + i.amount, 0);
  const overdueCount = overdueInvoices.length;

  // ── Shortcuts ──
  const shortcuts: Shortcut[] = [
    { label: "Nowy klient", icon: UserPlus, href: "/customers/new", accentColor: colors.accent, shortcut: "Ctrl+N" },
    { label: "Nowa faktura", icon: FileText, href: "/invoices", accentColor: "#8B5CF6", shortcut: "Ctrl+I" },
    { label: "Nowe zadanie", icon: CheckCircle, href: "/tasks", accentColor: colors.warning, shortcut: "Ctrl+T" },
    { label: "Raport", icon: BarChart3, href: "/reports", accentColor: "#173A6A" },
  ];

  // ── Tasks as timeline events ──
  const taskEvents: TimelineEvent[] = openTasks.slice(0, 6).map((t) => ({
    id: t.id,
    time: t.due_date ?? t.created_at,
    user: t.crm_leads?.company_name ?? "—",
    action: t.priority === "high" ? "Priorytet" : t.priority === "medium" ? "Średni" : "Niski",
    description: t.title,
    href: `/tasks`,
    type: t.priority === "high" ? "created" : "updated",
  }));

  return (
    <div className="space-y-6 animate-fade-in">
      {/* ── Header ── */}
      <div>
        <h1 className="font-heading font-bold text-xl text-ink">Pulpit</h1>
        <p className="text-sm text-ink/50 mt-0.5">
          Witaj w panelu zarządzania — {activeLeads.length} aktywnych klientów, MRR {mrr.toLocaleString("pl-PL")} zł
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
            timeframe={`MRR ${mrr.toLocaleString("pl-PL")} zł`}
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
            change={overdueCount > 0 ? `${overdueTotal.toLocaleString("pl-PL")} zł` : "0 zł"}
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
            change={`${openTasks.filter((t) => t.due_date && new Date(t.due_date) < new Date()).length} po terminie`}
            changeType={openTasks.filter((t) => t.due_date && new Date(t.due_date) < new Date()).length > 0 ? "negative" : "positive"}
            timeframe="Do zrealizowania"
            icon={FileText}
            iconBgColor="bg-amber-50"
            iconColor="text-amber-600"
          />
        </Link>
      </div>

      {/* ── Middle row: Pipeline + Action queue ── */}
      <div className="grid grid-cols-3 gap-4">
        {/* Pipeline visual */}
        <WidgetCard
          title="Pipeline"
          action={
            <Link href="/pipeline" className="text-xs font-medium" style={{ color: colors.accent }}>
              Otwórz →
            </Link>
          }
          className="col-span-2"
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
                        <span className="text-xs font-medium" style={{ color: card.color }}>
                          {card.cta} →
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

      {/* ── Bottom row: Tasks + Recent activity ── */}
      <div className="grid grid-cols-2 gap-4">
        {/* Tasks */}
        <WidgetCard
          title="Zadania"
          action={
            <Link href="/tasks" className="text-xs font-medium" style={{ color: colors.accent }}>
              Zespół →
            </Link>
          }
        >
          {openTasks.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-6 text-sm" style={{ color: colors.textMuted }}>
              <CheckCircle className="w-8 h-8 mb-2 opacity-40" />
              <p>Brak otwartych zadań</p>
            </div>
          ) : (
            <div className="space-y-1">
              {openTasks.slice(0, 6).map((task) => {
                const overdue = task.due_date && new Date(task.due_date) < new Date();
                return (
                  <Link
                    key={task.id}
                    href="/tasks"
                    className="flex items-center gap-3 py-2.5 px-3 rounded-xl transition-colors"
                    style={{ borderBottom: `1px solid ${colors.cardBorder}` }}
                  >
                    <div
                      className="w-2 h-2 rounded-full shrink-0"
                      style={{
                        background:
                          task.priority === "high"
                            ? colors.error
                            : task.priority === "medium"
                              ? colors.warning
                              : colors.textMuted,
                      }}
                    />
                    <span className="text-sm flex-1 truncate" style={{ color: colors.text }}>
                      {task.title}
                    </span>
                    <span className="text-xs shrink-0" style={{ color: colors.textMuted }}>
                      {task.crm_leads?.company_name ?? "—"}
                    </span>
                    {overdue && (
                      <span
                        className="text-[10px] px-2 py-0.5 rounded-full font-semibold shrink-0"
                        style={{ background: `${colors.error}15`, color: colors.error }}
                      >
                        PO TERMINIE
                      </span>
                    )}
                  </Link>
                );
              })}
            </div>
          )}
        </WidgetCard>

        {/* Pipeline summary */}
        <WidgetCard title="Pipeline — podsumowanie">
          <div className="space-y-1">
            {[
              { label: "Nowe leady", count: leadsPending.length, color: colors.info, href: "/pipeline" },
              { label: "W toku", count: leadsInProgress.length, color: colors.warning, href: "/pipeline" },
              { label: "Wygrane", count: leadsWon.length, color: colors.success, href: "/pipeline" },
              { label: "Aktywni klienci", count: activeLeads.length, color: colors.accent, href: "/customers" },
              { label: "Zaległe faktury", count: overdueCount, color: colors.error, href: "/invoices" },
            ].map((item) => (
              <Link
                key={item.label}
                href={item.href}
                className="flex items-center justify-between py-2.5 px-3 rounded-xl transition-colors"
                style={{ borderBottom: `1px solid ${colors.cardBorder}` }}
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-2 h-2 rounded-full" style={{ background: item.color }} />
                  <span className="text-sm" style={{ color: colors.text }}>
                    {item.label}
                  </span>
                </div>
                <span className="text-sm font-bold" style={{ color: colors.text }}>
                  {item.count}
                </span>
              </Link>
            ))}
          </div>
        </WidgetCard>
      </div>

      {/* ── Activity timeline ── */}
      {taskEvents.length > 0 && (
        <WidgetCard
          title="Ostatnie zadania"
          subtitle="Najnowsze aktywności"
          action={
            <Link href="/tasks" className="text-xs font-medium" style={{ color: colors.accent }}>
              Wszystkie zadania →
            </Link>
          }
        >
          <ActivityTimeline events={taskEvents} />
        </WidgetCard>
      )}
    </div>
  );
}

/* ── Pipeline visual component ── */
function PipelineVisual({
  stages,
  total,
}: {
  stages: { stage: string; label: string; count: number; color: string }[];
  total: number;
}) {
  if (total === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-8 text-sm" style={{ color: colors.textMuted }}>
        <Users className="w-8 h-8 mb-2 opacity-40" />
        <p>Brak leadów w pipeline</p>
      </div>
    );
  }

  return (
    <div className="pt-2">
      {/* Funnel bar */}
      <div className="flex h-8 rounded-lg overflow-hidden mb-4">
        {stages.map((s) => {
          const pct = Math.round((s.count / total) * 100);
          if (pct === 0) return null;
          return (
            <div
              key={s.stage}
              className="flex items-center justify-center text-[11px] font-semibold text-white transition-all"
              style={{
                width: `${pct}%`,
                background: s.color,
                opacity: 0.85,
              }}
              title={`${s.label}: ${s.count}`}
            >
              {pct > 10 ? s.count : null}
            </div>
          );
        })}
      </div>

      {/* Stage cards */}
      <div className="flex gap-2">
        {stages.map((s) => (
          <Link
            key={s.stage}
            href="/pipeline"
            className="flex-1 rounded-xl p-3 text-center transition-opacity hover:opacity-85"
            style={{ background: tint(s.color, 0.08) }}
          >
            <div className="w-2 h-2 rounded-full mx-auto mb-1.5" style={{ background: s.color }} />
            <p className="text-xs font-semibold" style={{ color: `${s.color}cc` }}>
              {s.label}
            </p>
            <p className="text-lg font-bold mt-0.5" style={{ color: colors.text }}>
              {s.count}
            </p>
          </Link>
        ))}
      </div>
    </div>
  );
}

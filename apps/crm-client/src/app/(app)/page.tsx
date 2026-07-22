import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";
import { PRIORITY_CONFIG } from "@/lib/types";
import type { ReportPriority } from "@/lib/types";

export default async function DashboardPage() {
  const ctx = await getActiveEstate();
  if (!ctx || !ctx.estateId) redirect("/login");
  const { supabase, estateId } = ctx;

  const { count: totalReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId);

  const { count: newReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .eq("status", "Nowe");

  const { count: inProgressReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .eq("status", "W realizacji");

  const { count: closedReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .eq("status", "Zamkniete");

  const { count: rejectedReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .eq("status", "Odrzucone");

  const { count: urgentReports } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .in("priority", ["high", "critical"])
    .not("status", "in", '("Zamkniete","Odrzucone")');

  const now = new Date().toISOString();
  const { count: overdueSla } = await supabase
    .from("fixflow_reports")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .not("status", "in", '("Zamkniete","Odrzucone")')
    .lt("sla_deadline", now);

  const { count: totalTasks } = await supabase
    .from("fixflow_tasks")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId);

  const { count: doneTasks } = await supabase
    .from("fixflow_tasks")
    .select("*", { count: "exact", head: true })
    .eq("estate_id", estateId)
    .eq("status", "Zrobione");

  const { data: attentionReports } = await supabase
    .from("fixflow_reports")
    .select("id, display_id, title, priority, status")
    .eq("estate_id", estateId)
    .in("priority", ["high", "critical"])
    .in("status", ["Nowe", "W realizacji"])
    .order("created_at", { ascending: false })
    .limit(5);

  // fixflow_report_events nie ma kolumny estate_id — filtrujemy przez
  // relację do fixflow_reports (report_id -> fixflow_reports.id)
  const { data: recentEvents } = await supabase
    .from("fixflow_report_events")
    .select(
      "id, event_type, description, user_name, created_at, report_id, fixflow_reports!inner(estate_id)"
    )
    .eq("fixflow_reports.estate_id", estateId)
    .order("created_at", { ascending: false })
    .limit(6);

  const activeCalc = (newReports ?? 0) + (inProgressReports ?? 0);
  const slaHealth =
    activeCalc > 0
      ? Math.round(((activeCalc - (overdueSla ?? 0)) / activeCalc) * 100)
      : 100;
  const slaHealthSafe = Math.max(0, Math.min(100, slaHealth));

  const taskHealth =
    (totalTasks ?? 0) > 0
      ? Math.round(((doneTasks ?? 0) / (totalTasks ?? 1)) * 100)
      : 100;

  const healthScore = Math.round((slaHealthSafe + taskHealth) / 2);

  const healthLabel =
    healthScore >= 80
      ? "Dobry stan"
      : healthScore >= 50
        ? "Wymaga uwagi"
        : "Krytyczny";
  const healthColor =
    healthScore >= 80
      ? "var(--color-success)"
      : healthScore >= 50
        ? "var(--color-amber)"
        : "var(--color-danger)";

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-heading font-bold text-ink">Pulpit</h1>
        <p className="text-sm text-ink/50 mt-1">
          Przegląd sytuacji na osiedlu
        </p>
      </div>

      <div className="grid grid-cols-5 gap-5">
        <KpiCard
          label="Wszystkie zgłoszenia"
          value={totalReports ?? 0}
          color="var(--color-azure)"
        />
        <KpiCard
          label="Nowe"
          value={newReports ?? 0}
          color="var(--color-status-new)"
        />
        <KpiCard
          label="W realizacji"
          value={inProgressReports ?? 0}
          color="var(--color-status-progress)"
        />
        <KpiCard
          label="Wymagają uwagi"
          value={urgentReports ?? 0}
          color="var(--color-danger)"
        />
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
          <p className="text-sm text-ink/50 mb-1">Zdrowie osiedla</p>
          <p className="text-3xl font-heading font-bold" style={{ color: healthColor }}>
            {healthScore}
          </p>
          <p className="text-xs font-semibold mt-1" style={{ color: healthColor }}>
            {healthLabel}
          </p>
          <div className="mt-3 pt-3 border-t border-ink/5 space-y-1.5 text-[11.5px] text-ink/50">
            <div className="flex justify-between">
              <span>SLA terminowość</span>
              <span className="font-mono font-medium">{slaHealthSafe}%</span>
            </div>
            <div className="flex justify-between">
              <span>Zadania zrobione</span>
              <span className="font-mono font-medium">{taskHealth}%</span>
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-5">
        <div className="col-span-2">
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <h2 className="font-heading font-semibold text-ink mb-5">
              Sprawy według statusu
            </h2>
            <StatusBarChart
              nowe={newReports ?? 0}
              realizacji={inProgressReports ?? 0}
              zamkniete={closedReports ?? 0}
              odrzucone={rejectedReports ?? 0}
            />
          </div>
        </div>
        <div>
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <h2 className="font-heading font-semibold text-ink mb-4">
              Wymagają uwagi
            </h2>
            <AttentionList
              reports={
                (attentionReports ?? []) as {
                  id: string;
                  display_id: string | null;
                  title: string;
                  priority: string;
                }[]
              }
            />
          </div>
        </div>
      </div>

      <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
        <h2 className="font-heading font-semibold text-ink mb-4">
          Ostatnia aktywność
        </h2>
        <ActivityList
          events={(recentEvents ?? []).map((e) => ({
            id: e.id as string,
            event_type: e.event_type as string,
            description: e.description as string | null,
            user_name: e.user_name as string | null,
            created_at: e.created_at as string,
            report_id: e.report_id as string,
          }))}
        />
      </div>
    </div>
  );
}

function KpiCard({
  label,
  value,
  color,
}: {
  label: string;
  value: number;
  color: string;
}) {
  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <p className="text-sm text-ink/50 mb-1">{label}</p>
      <p className="text-3xl font-heading font-bold" style={{ color }}>
        {value}
      </p>
    </div>
  );
}

function StatusBarChart({
  nowe,
  realizacji,
  zamkniete,
  odrzucone,
}: {
  nowe: number;
  realizacji: number;
  zamkniete: number;
  odrzucone: number;
}) {
  const cols = [
    { label: "Nowe", count: nowe, color: "#3E7BD6" },
    { label: "W realizacji", count: realizacji, color: "#F2A900" },
    { label: "Zamknięte", count: zamkniete, color: "#2E9E6B" },
    { label: "Odrzucone", count: odrzucone, color: "#6B7A90" },
  ];
  const max = Math.max(1, ...cols.map((c) => c.count));

  if (nowe + realizacji + zamkniete + odrzucone === 0) {
    return <p className="text-sm text-ink/40">Brak zgłoszeń do wyświetlenia</p>;
  }

  return (
    <div className="flex items-end gap-5 h-[180px] px-1.5">
      {cols.map((c) => {
        const height = Math.max(6, Math.round((c.count / max) * 130));
        return (
          <div
            key={c.label}
            className="flex-1 flex flex-col items-center justify-end gap-2"
          >
            <span
              className="font-heading font-bold text-base"
              style={{ color: c.color }}
            >
              {c.count}
            </span>
            <div
              className="w-full max-w-[52px] rounded-t-lg"
              style={{ height, backgroundColor: c.color }}
            />
            <span className="text-[12.5px] font-medium text-ink/60 text-center">
              {c.label}
            </span>
          </div>
        );
      })}
    </div>
  );
}

function AttentionList({
  reports,
}: {
  reports: {
    id: string;
    display_id: string | null;
    title: string;
    priority: string;
  }[];
}) {
  if (reports.length === 0) {
    return (
      <p className="text-sm text-ink/40">
        Brak spraw wymagających uwagi — wszystko pod kontrolą.
      </p>
    );
  }

  return (
    <div className="flex flex-col">
      {reports.map((r) => {
        const config = PRIORITY_CONFIG[r.priority as ReportPriority];
        return (
          <Link
            key={r.id}
            href={`/reports/${r.id}`}
            className="flex items-center gap-3 py-3 border-b border-ink/5 last:border-0 hover:bg-paper/60 -mx-1 px-1 rounded-lg transition-colors min-h-[44px]"
          >
            <span
              className="w-2.5 h-2.5 rounded-full shrink-0"
              style={{ backgroundColor: config.color }}
            />
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-ink truncate">{r.title}</p>
              <p className="text-[11.5px] font-mono text-ink/40 mt-0.5">
                {r.display_id ?? r.id.slice(0, 8)}
              </p>
            </div>
            <span
              className="text-[11px] font-semibold px-2.5 py-1 rounded-full shrink-0"
              style={{ backgroundColor: config.color + "20", color: config.color }}
            >
              {config.label}
            </span>
          </Link>
        );
      })}
    </div>
  );
}

function ActivityList({
  events,
}: {
  events: {
    id: string;
    event_type: string;
    description: string | null;
    user_name: string | null;
    created_at: string;
    report_id: string;
  }[];
}) {
  if (events.length === 0) {
    return <p className="text-sm text-ink/40">Brak ostatnich zdarzeń</p>;
  }

  return (
    <div className="flex flex-col">
      {events.map((e) => (
        <Link
          key={e.id}
          href={`/reports/${e.report_id}`}
          className="flex items-center gap-3 py-3 border-b border-ink/5 last:border-0 hover:bg-paper/60 -mx-1 px-1 rounded-lg transition-colors min-h-[44px]"
        >
          <span className="text-sm font-medium text-ink/70 shrink-0">
            {e.user_name ?? "System"}
          </span>
          <span className="text-[12.5px] text-ink/50 flex-1 min-w-0 truncate">
            {e.description ?? e.event_type}
          </span>
          <span className="text-[11.5px] font-mono text-ink/40 shrink-0">
            {new Date(e.created_at).toLocaleString("pl-PL", {
              day: "numeric",
              month: "short",
              hour: "2-digit",
              minute: "2-digit",
            })}
          </span>
        </Link>
      ))}
    </div>
  );
}

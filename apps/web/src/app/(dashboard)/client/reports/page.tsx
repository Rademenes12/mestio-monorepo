import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { STATUS_CONFIG, PRIORITY_CONFIG } from "@/lib/types";
import type { Report, ReportStatus, ReportPriority } from "@/lib/types";
import Link from "next/link";

const KANBAN_COLUMNS: ReportStatus[] = [
  "Nowe",
  "W realizacji",
  "Zamkniete",
  "Odrzucone",
];

export default async function ReportsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, estateId } = ctx;

  if (!estateId) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">
          Tablica spraw
        </h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Brak przypisanych osiedli</p>
        </div>
      </div>
    );
  }

  const { data: reports } = await supabase
    .from("fixflow_reports")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const grouped: Record<string, Report[]> = {};
  for (const report of (reports ?? []) as Report[]) {
    const status = report.status as ReportStatus;
    if (!grouped[status]) grouped[status] = [];
    grouped[status].push(report);
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-heading font-bold text-ink">
        Tablica spraw
      </h1>

      <div className="grid grid-cols-4 gap-5 items-start">
        {KANBAN_COLUMNS.map((status) => {
          const items = grouped[status] ?? [];
          const config = STATUS_CONFIG[status];

          return (
            <div key={status} className="space-y-3">
              <div className="flex items-center gap-2 px-1">
                <span
                  className="w-3 h-3 rounded-full shrink-0"
                  style={{ backgroundColor: config.color }}
                />
                <span className="text-[13.5px] font-semibold text-ink/70">
                  {status}
                </span>
                <span className="ml-auto text-[12.5px] text-ink/40 font-mono font-medium">
                  {items.length}
                </span>
              </div>

              <div className="space-y-3">
                {items.map((report) => (
                  <Link
                    key={report.id}
                    href={`/reports/${report.id}`}
                    className="block"
                  >
                    <ReportCard report={report} />
                  </Link>
                ))}
                {items.length === 0 && (
                  <div className="bg-white/50 rounded-[12px] border border-dashed border-ink/10 p-6 text-center">
                    <p className="text-[12.5px] text-ink/35">
                      Brak zgłoszeń w tej kolumnie
                    </p>
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function ReportCard({ report }: { report: Report }) {
  const priorityConfig = PRIORITY_CONFIG[report.priority as ReportPriority];

  return (
    <div className="bg-white rounded-[20px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-4 hover:shadow-[0_4px_16px_rgba(14,26,43,.1)] transition-shadow cursor-pointer">
      <div className="flex items-start justify-between gap-2 mb-2">
        <span className="text-[12.5px] font-mono text-ink/45">
          {report.display_id ?? report.id.slice(0, 8)}
        </span>
        {report.priority !== "normal" && (
          <span
            className="text-[11px] font-semibold px-2 py-0.5 rounded-full shrink-0"
            style={{
              backgroundColor: priorityConfig.color + "18",
              color: priorityConfig.color,
            }}
          >
            {priorityConfig.label}
          </span>
        )}
      </div>

      <h3 className="text-[14.5px] font-medium text-ink leading-snug line-clamp-2 mb-2">
        {report.title}
      </h3>

      <div className="flex items-center gap-2 text-[12.5px] text-ink/50">
        <span>{report.reporter_name ?? "Anonim"}</span>
        {report.reporter_building && (
          <>
            <span>·</span>
            <span>{report.reporter_building}</span>
          </>
        )}
      </div>

      {report.assigned_to_name && (
        <div className="mt-2.5 flex items-center gap-1.5">
          <div className="w-6 h-6 rounded-full bg-azure/10 flex items-center justify-center text-[11px] font-semibold text-azure">
            {report.assigned_to_name[0]}
          </div>
          <span className="text-[12.5px] text-ink/60">
            {report.assigned_to_name}
          </span>
        </div>
      )}
    </div>
  );
}

import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { STATUS_CONFIG, PRIORITY_CONFIG } from "@/lib/types";
import type { Report, ReportStatus, ReportPriority } from "@/lib/types";
import Link from "next/link";
import { AlertTriangle, Clock, ShieldAlert } from "lucide-react";

const KANBAN_COLUMNS: ReportStatus[] = [
  "Nowe",
  "W realizacji",
  "Zamkniete",
  "Odrzucone",
];

const SLA_HOURS: Record<ReportPriority, number> = {
  critical: 4,
  high: 24,
  normal: 72,
  low: 168,
};

const SAMPLE_DEMO_REPORTS: Report[] = [
  {
    id: "demo-rep-1",
    estate_id: "demo-estate-id",
    reporter_user_id: "demo-user-1",
    reporter_name: "Anna Nowak",
    reporter_building: "Budynek A / klatka 2",
    reporter_footbridge: null,
    reporter_floor: "2",
    reporter_apartment: "m. 14",
    title: "Awaria ogrzewania na klatce schodowej",
    description: "Grzejnik na 2. piętrze wycieka wodę. Prośba o szybką interwencję serwisu.",
    category: "Hydraulika",
    status: "W realizacji",
    status_enum: "in_progress",
    priority: "critical",
    sla_deadline: new Date(Date.now() + 2 * 3600 * 1000).toISOString(),
    assigned_to_user_id: "serwis-1",
    assigned_to_name: "Marek Serwisant",
    assigned_to_role: "technician",
    photo_path: null,
    display_id: "UST-8492",
    created_at: new Date(Date.now() - 5 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: "demo-rep-2",
    estate_id: "demo-estate-id",
    reporter_user_id: "demo-user-2",
    reporter_name: "Piotr Kowalski",
    reporter_building: "Budynek B / m. 14",
    reporter_footbridge: null,
    reporter_floor: "1",
    reporter_apartment: "m. 14",
    title: "INCYDENT: Uszkodzony domofon przy wejściu",
    description: "Brak możliwości otwarcia drzwi kodem. Ochrona została poinformowana.",
    category: "Incydent",
    status: "Nowe",
    status_enum: "new",
    priority: "high",
    sla_deadline: new Date(Date.now() + 20 * 3600 * 1000).toISOString(),
    assigned_to_user_id: null,
    assigned_to_name: null,
    assigned_to_role: null,
    photo_path: null,
    display_id: "INC-1029",
    created_at: new Date(Date.now() - 1 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: "demo-rep-3",
    estate_id: "demo-estate-id",
    reporter_user_id: "demo-user-3",
    reporter_name: "Ochrona Osiedla",
    reporter_building: "Brama Główna",
    reporter_footbridge: null,
    reporter_floor: "0",
    reporter_apartment: "brama",
    title: "Wymiana żarówki w windzie Budynek C",
    description: "Oświetlenie w dźwigu B miga. Karta zlecenia przekazana do konserwatora.",
    category: "Elektryka",
    status: "Zamkniete",
    status_enum: "closed",
    priority: "normal",
    sla_deadline: null,
    assigned_to_user_id: "elektryk-1",
    assigned_to_name: "Tomasz Elektryk",
    assigned_to_role: "technician",
    photo_path: null,
    display_id: "UST-7712",
    created_at: new Date(Date.now() - 48 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString(),
  },
];

function getSlaInfo(report: Report) {
  if (report.status === "Zamkniete" || report.status === "Odrzucone") {
    return { label: "SLA Spełnione", color: "#2E9E6B", expired: false, urgent: false };
  }

  const priority = (report.priority as ReportPriority) || "normal";
  const hoursAllowed = SLA_HOURS[priority] || 72;
  const createdAt = new Date(report.created_at).getTime();
  const deadline = createdAt + hoursAllowed * 60 * 60 * 1000;
  const now = Date.now();
  const hoursLeft = Math.round((deadline - now) / (1000 * 60 * 60));

  if (hoursLeft < 0) {
    return {
      label: `SLA przekroczone o ${Math.abs(hoursLeft)}h`,
      color: "#DC2626",
      expired: true,
      urgent: true,
    };
  }

  if (hoursLeft <= 2) {
    return {
      label: `Zostało ${hoursLeft}h do SLA`,
      color: "#D97706",
      expired: false,
      urgent: true,
    };
  }

  return {
    label: `SLA: ${hoursLeft}h limitu`,
    color: "#6B7A90",
    expired: false,
    urgent: false,
  };
}

export default async function ReportsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, estateId } = ctx;

  let reportList: Report[] = [];

  if (estateId) {
    const { data: reports } = await supabase
      .from("fixflow_reports")
      .select("*")
      .eq("estate_id", estateId)
      .order("created_at", { ascending: false });
    reportList = (reports ?? []) as Report[];
  }

  if (reportList.length === 0) {
    reportList = SAMPLE_DEMO_REPORTS;
  }

  const grouped: Record<string, Report[]> = {};
  for (const report of reportList) {
    const status = report.status as ReportStatus;
    if (!grouped[status]) grouped[status] = [];
    grouped[status].push(report);
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">
            Tablica spraw i nadzór SLA (CRM Klienta)
          </h1>
          <p className="text-sm text-ink/60 mt-1">
            Zgłoszenia usterek osiedla, przypisani serwisanci oraz czas reakcji (SLA)
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-5 items-start">
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
  const priorityConfig = PRIORITY_CONFIG[report.priority as ReportPriority] || PRIORITY_CONFIG.normal;
  const sla = getSlaInfo(report);
  const isEmergency = report.priority === "critical" || report.category?.toLowerCase() === "alarm" || report.category?.toLowerCase() === "incydent";

  return (
    <div className="bg-white rounded-[20px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-4 hover:shadow-[0_4px_16px_rgba(14,26,43,.1)] transition-shadow cursor-pointer border border-[#EAF0F7]">
      {/* Emergency Alarm Banner if Critical */}
      {isEmergency && report.status !== "Zamkniete" && (
        <div className="mb-2.5 px-2.5 py-1 rounded-lg bg-red-50 border border-red-200 flex items-center gap-1.5 text-red-700 text-[11.5px] font-semibold">
          <ShieldAlert className="w-3.5 h-3.5 text-red-600 animate-pulse shrink-0" />
          <span>INCYDENT / ALARM KRYTYCZNY</span>
        </div>
      )}

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

      <div className="flex items-center gap-2 text-[12.5px] text-ink/50 mb-3">
        <span>{report.reporter_name ?? "Anonim"}</span>
        {report.reporter_building && (
          <>
            <span>·</span>
            <span>{report.reporter_building}</span>
          </>
        )}
      </div>

      {/* SLA Badge */}
      <div className="flex items-center justify-between pt-2 border-t border-[#F0F4F8]">
        <div className="flex items-center gap-1 text-[11.5px] font-medium" style={{ color: sla.color }}>
          {sla.expired ? (
            <AlertTriangle className="w-3.5 h-3.5 shrink-0" />
          ) : (
            <Clock className="w-3.5 h-3.5 shrink-0" />
          )}
          <span>{sla.label}</span>
        </div>

        {report.assigned_to_name && (
          <div className="flex items-center gap-1">
            <div className="w-5 h-5 rounded-full bg-azure/10 flex items-center justify-center text-[10px] font-semibold text-azure">
              {report.assigned_to_name[0]}
            </div>
            <span className="text-[11.5px] text-ink/60 truncate max-w-[80px]">
              {report.assigned_to_name}
            </span>
          </div>
        )}
      </div>
    </div>
  );
}

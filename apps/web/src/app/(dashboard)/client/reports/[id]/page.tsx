import { createClient } from "@/lib/supabase/server";
import { getActiveEstate } from "@/lib/active-estate";
import { STATUS_CONFIG, PRIORITY_CONFIG } from "@/lib/types";
import type {
  Report,
  ReportStatus,
  ReportPriority,
  ReportEvent,
  ReportComment,
} from "@/lib/types";
import { redirect } from "next/navigation";
import Link from "next/link";
import { ChangeStatusButton } from "./change-status";
import { revalidatePath } from "next/cache";
import ResidentMessageComposer from "./resident-message-composer";
import TeamNotesComposer from "./team-notes-composer";
import PriorityEditor from "./priority-editor";

export default async function ReportDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const allowedEstateIds = [estateId];

  const { data: report } = await supabase
    .from("fixflow_reports")
    .select("*")
    .eq("id", id)
    .eq("estate_id", estateId)
    .single();

  if (!report) {
    return (
      <div className="space-y-6">
        <Link
          href="/reports"
          className="text-sm text-azure hover:underline"
        >
          ← Wróć do tablicy
        </Link>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Zgłoszenie nie zostało znalezione</p>
        </div>
      </div>
    );
  }

  const { data: notes } = await supabase
    .from("fixflow_report_internal_notes")
    .select("*")
    .eq("report_id", id)
    .maybeSingle();

  const { data: comments } = await supabase
    .from("fixflow_report_comments")
    .select("*")
    .eq("report_id", id)
    .order("created_at", { ascending: true });

  const { data: events } = await supabase
    .from("fixflow_report_events")
    .select("*")
    .eq("report_id", id)
    .order("created_at", { ascending: false });

  const { data: techMembers } = await supabase
    .from("fixflow_user_estates")
    .select("user_id")
    .in("estate_id", allowedEstateIds)
    .eq("role", "technician");

  const techIds = [...new Set((techMembers ?? []).map((m) => m.user_id))];

  const { data: technicians } = techIds.length > 0
    ? await supabase
        .from("fixflow_resident_profiles")
        .select("id, name")
        .in("id", techIds)
        .limit(50)
    : { data: [] };

  const r = report as Report;

  return (
    <div className="space-y-6">
      <Link href="/reports" className="text-sm text-azure hover:underline">
        ← Wróć do tablicy
      </Link>

      <div className="flex gap-6 items-start">
        <div className="flex-1 space-y-6">
          <ReportHeader report={r} />
          <StatusStepper currentStatus={r.status as ReportStatus} />
          {r.description && (
            <ReportDescription description={r.description} />
          )}
          <ReporterInfo report={r} />
          {r.photo_path && <PhotoSection path={r.photo_path} />}
          <ResidentMessagesSection
            comments={comments as ReportComment[]}
            reportId={r.id}
            authorId={user.id}
          />
        </div>

        <div className="w-80 shrink-0 space-y-4 sticky top-24">
          <SideActions
            report={r}
            notes={notes}
            technicians={technicians ?? []}
            events={events as ReportEvent[]}
            authorLabel={user.email ?? "Zarząd"}
          />
        </div>
      </div>
    </div>
  );
}

function ReportHeader({ report }: { report: Report }) {
  const config = STATUS_CONFIG[report.status as ReportStatus];
  const priorityConfig = PRIORITY_CONFIG[report.priority as ReportPriority];

  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <div className="flex items-center gap-2 mb-3 flex-wrap">
        <span className="text-[12.5px] font-mono text-ink/45">
          {report.display_id ?? report.id.slice(0, 8)}
        </span>
        <span
          className="text-[12px] font-semibold px-2.5 py-1 rounded-full"
          style={{
            backgroundColor: config.color + "18",
            color: config.color,
          }}
        >
          {report.status}
        </span>
        <span
          className="text-[12px] font-semibold px-2.5 py-1 rounded-full"
          style={{
            backgroundColor: priorityConfig.color + "18",
            color: priorityConfig.color,
          }}
        >
          {priorityConfig.label}
        </span>
        {report.category && (
          <span className="text-[12px] font-medium px-2.5 py-1 rounded-full bg-paper text-ink/55">
            {report.category}
          </span>
        )}
      </div>
      <h1 className="text-[22px] font-heading font-semibold text-ink leading-snug">
        {report.title}
      </h1>
      {report.sla_deadline && (
        <p className="text-[12.5px] text-ink/50 mt-2 font-mono">
          Termin SLA: {new Date(report.sla_deadline).toLocaleDateString("pl-PL")}
        </p>
      )}
    </div>
  );
}

function StatusStepper({ currentStatus }: { currentStatus: ReportStatus }) {
  const steps: ReportStatus[] = [
    "Nowe",
    "W realizacji",
    "Zamkniete",
  ];

  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="text-[13px] font-semibold text-ink/60 mb-5">Status zgłoszenia</h3>
      <div className="flex items-center">
        {steps.map((step, i) => {
          const config = STATUS_CONFIG[step];
          const stepIdx = steps.indexOf(currentStatus);
          const isActive = i <= stepIdx;
          const isOdrzucone = currentStatus === "Odrzucone";

          return (
            <div key={step} className="flex items-center flex-1 last:flex-none">
              <div className="flex flex-col items-center">
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${
                    isOdrzucone
                      ? "bg-status-rejected text-white"
                      : isActive
                        ? "text-white"
                        : "bg-paper text-ink/30"
                  }`}
                  style={
                    isActive && !isOdrzucone
                      ? { backgroundColor: config.color }
                      : undefined
                  }
                >
                  {isActive && !isOdrzucone ? (
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 16 16"
                      fill="none"
                    >
                      <path
                        d="M13.3 4.3L6 11.6L2.7 8.3"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                  ) : isOdrzucone ? (
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 16 16"
                      fill="none"
                    >
                      <path
                        d="M4 4L12 12M12 4L4 12"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                      />
                    </svg>
                  ) : (
                    <span className="text-[13px] font-semibold">{i + 1}</span>
                  )}
                </div>
                <span
                  className={`text-[12.5px] mt-2 font-semibold whitespace-nowrap ${
                    isOdrzucone
                      ? "text-status-rejected"
                      : isActive
                        ? "text-ink/70"
                        : "text-ink/35"
                  }`}
                >
                  {step}
                </span>
              </div>
              {i < steps.length - 1 && (
                <div className="flex-1 h-0.5 mx-3 mb-6">
                  <div
                    className={`h-full rounded transition-all ${
                      isOdrzucone
                        ? "bg-status-rejected/30"
                        : i < stepIdx
                          ? ""
                          : "bg-ink/10"
                    }`}
                    style={
                      i < stepIdx && !isOdrzucone
                        ? {
                            backgroundColor: STATUS_CONFIG[steps[i + 1]].color,
                          }
                        : undefined
                    }
                  />
                </div>
              )}
            </div>
          );
        })}
      </div>
      {currentStatus === "Odrzucone" && (
        <div className="mt-5 pt-4 border-t border-ink/5">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-status-rejected text-white flex items-center justify-center">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path
                  d="M4 4L12 12M12 4L4 12"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </div>
            <div>
              <p className="text-sm font-semibold text-status-rejected">
                Odrzucone
              </p>
              <p className="text-[12.5px] text-ink/45">
                Zgłoszenie zostało odrzucone przez zarząd
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function ReportDescription({ description }: { description: string }) {
  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="text-[13px] font-semibold text-ink/60 mb-3">Opis zgłoszenia</h3>
      <p className="text-sm text-ink/80 whitespace-pre-wrap leading-relaxed">
        {description}
      </p>
    </div>
  );
}

function ReporterInfo({ report }: { report: Report }) {
  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="text-[13px] font-semibold text-ink/60 mb-3">
        Dane zgłaszającego
      </h3>
      <div className="grid grid-cols-2 gap-3 text-sm">
        <InfoField label="Imię i nazwisko" value={report.reporter_name} />
        <InfoField label="Budynek" value={report.reporter_building} />
        <InfoField label="Klatka" value={report.reporter_footbridge} />
        <InfoField label="Piętro" value={report.reporter_floor} />
        <InfoField label="Mieszkanie" value={report.reporter_apartment} />
      </div>
    </div>
  );
}

function InfoField({
  label,
  value,
}: {
  label: string;
  value: string | null;
}) {
  return (
    <div>
      <span className="text-[12px] text-ink/45">{label}</span>
      <p className="text-[14px] text-ink/80 mt-0.5">{value ?? "—"}</p>
    </div>
  );
}

function PhotoSection({ path }: { path: string }) {
  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h3 className="text-[13px] font-semibold text-ink/60 mb-3">Zdjęcie</h3>
      <img
        src={path}
        alt="Zdjęcie zgłoszenia"
        className="w-full max-w-md rounded-xl"
      />
    </div>
  );
}

function ResidentMessagesSection({
  comments,
  reportId,
  authorId,
}: {
  comments: ReportComment[];
  reportId: string;
  authorId: string;
}) {
  const residentMsgs = comments.filter((c) => !c.is_internal);

  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <div className="flex items-center gap-2 mb-4 flex-wrap">
        <h3 className="text-[13px] font-semibold text-ink/70">
          Wiadomość do mieszkańca
        </h3>
        <span className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-azure/10 text-azure">
          Widoczne dla mieszkańca
        </span>
      </div>
      {residentMsgs.length === 0 ? (
        <p className="text-sm text-ink/40">
          Brak wiadomości do mieszkańca. Napisz przed zamknięciem sprawy.
        </p>
      ) : (
        <div className="space-y-4">
          {residentMsgs.map((c) => (
            <div key={c.id} className="flex gap-3">
              <div className="w-8 h-8 rounded-full bg-azure/10 flex items-center justify-center shrink-0">
                <span className="text-[11.5px] font-semibold text-azure">
                  {c.author_id.slice(0, 2).toUpperCase()}
                </span>
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <span className="text-[12.5px] font-medium text-ink/70">
                    {c.author_id.slice(0, 8)}
                  </span>
                  <span className="text-[11px] text-ink/40 font-mono">
                    {new Date(c.created_at).toLocaleString("pl-PL")}
                  </span>
                </div>
                <p className="text-sm text-ink/80">{c.content}</p>
              </div>
            </div>
          ))}
        </div>
      )}
      <ResidentMessageComposer reportId={reportId} authorId={authorId} />
    </div>
  );
}

function SideActions({
  report,
  notes,
  technicians,
  events,
  authorLabel,
}: {
  report: Report;
  notes: { board_notes: string | null; internal_tech_notes: string | null } | null;
  technicians: { id: string; name: string | null }[];
  events: ReportEvent[] | null;
  authorLabel: string;
}) {
  return (
    <>
      <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
        <h3 className="text-[13px] font-semibold text-ink/60 mb-4">
          Zmień status
        </h3>
        <div className="space-y-2">
          <ChangeStatusButton reportId={report.id} newStatus="Nowe" />
          <ChangeStatusButton reportId={report.id} newStatus="W realizacji" />
          <ChangeStatusButton reportId={report.id} newStatus="Zamkniete" />
          <ChangeStatusButton reportId={report.id} newStatus="Odrzucone" />
        </div>

        <div className="mt-4 pt-4 border-t border-ink/5">
          <PriorityEditor
            reportId={report.id}
            currentPriority={report.priority}
          />
        </div>
      </div>

      <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
        <h3 className="text-[13px] font-semibold text-ink/60 mb-3">
          Przypisany serwisant
        </h3>
        {report.assigned_to_name ? (
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-full bg-azure flex items-center justify-center text-white text-sm font-medium">
              {report.assigned_to_name[0]}
            </div>
            <div>
              <p className="text-sm font-medium text-ink">
                {report.assigned_to_name}
              </p>
              {report.assigned_to_role && (
                <p className="text-xs text-ink/40">
                  {report.assigned_to_role}
                </p>
              )}
            </div>
          </div>
        ) : (
          <p className="text-sm text-ink/30">Nieprzypisane</p>
        )}
        {technicians.length > 0 && (
          <div className="mt-3 pt-3 border-t border-ink/5">
            <p className="text-[12px] text-ink/45 mb-2">Dostępni serwisanci:</p>
            <div className="space-y-1">
              {technicians.slice(0, 5).map((t) => (
                <AssignTechnicianButton
                  key={t.id}
                  reportId={report.id}
                  userId={t.id}
                  name={t.name ?? t.id.slice(0, 8)}
                />
              ))}
            </div>
          </div>
        )}
      </div>

      <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
        <div className="flex items-center gap-2 mb-3 flex-wrap">
          <h3 className="text-[13px] font-semibold text-ink/70">Notatki zespołu</h3>
          <span className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-[#EFF2F6] text-[#6B7A90]">
            wewnętrzne
          </span>
        </div>
        {notes?.board_notes ? (
          <p className="text-sm text-ink/70 whitespace-pre-wrap">
            {notes.board_notes}
          </p>
        ) : (
          <p className="text-sm text-ink/40">Brak notatek zespołu.</p>
        )}
        {notes?.internal_tech_notes && (
          <>
            <h4 className="text-[12px] font-semibold text-ink/45 mt-3 mb-1">
              Notatki techniczne
            </h4>
            <p className="text-[12.5px] text-ink/60 whitespace-pre-wrap font-mono">
              {notes.internal_tech_notes}
            </p>
          </>
        )}
        <TeamNotesComposer
          reportId={report.id}
          existingNotes={notes?.board_notes ?? null}
          authorLabel={authorLabel}
        />
      </div>

      <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
        <h3 className="text-[13px] font-semibold text-ink/60 mb-3">
          Historia zdarzeń
        </h3>
        {events && events.length > 0 ? (
          <div className="space-y-3">
            {events.map((event) => (
              <div key={event.id} className="flex gap-2.5">
                <div className="mt-1.5 w-1.5 h-1.5 rounded-full bg-azure/30 shrink-0" />
                <div className="min-w-0">
                  <p className="text-[12.5px] text-ink/70">
                    {event.description ?? event.event_type}
                  </p>
                  <div className="flex items-center gap-1.5 mt-0.5">
                    {event.user_name && (
                      <span className="text-[11px] text-ink/45">
                        {event.user_name}
                      </span>
                    )}
                    <span className="text-[11px] text-ink/30 font-mono">
                      {new Date(event.created_at).toLocaleString("pl-PL")}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-sm text-ink/40">Brak zdarzeń</p>
        )}
      </div>
    </>
  );
}

function AssignTechnicianButton({
  reportId,
  userId,
  name,
}: {
  reportId: string;
  userId: string;
  name: string;
}) {
  return (
    <form
      action={async () => {
        "use server";
        const supabase = await createClient();
        const { error } = await supabase
          .from("fixflow_reports")
          .update({
            assigned_to_user_id: userId,
            assigned_to_name: name,
          })
          .eq("id", reportId);
        if (error) return;
        revalidatePath(`/reports/${reportId}`);
      }}
    >
      <button className="w-full text-left text-[13px] font-medium px-3 py-2.5 rounded-lg hover:bg-azure/5 text-ink/60 hover:text-azure transition-colors min-h-[40px]">
        {name}
      </button>
    </form>
  );
}

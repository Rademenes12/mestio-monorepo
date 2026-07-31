import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";

interface Report {
  id: string;
  title: string;
  description: string | null;
  category: string | null;
  status: string;
  display_id: string | null;
  created_at: string;
  updated_at: string;
  assigned_to: string | null;
}

export default async function ResidentReportsPage() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/reports");
  const { supabase, estateId, user } = ctx;

  if (!estateId) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">Moje zgłoszenia</h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz przypisanego osiedla.</p>
        </div>
      </div>
    );
  }

  const { data: reports } = await supabase
    .from("fixflow_reports")
    .select("id, title, description, category, status, display_id, created_at, updated_at, assigned_to")
    .eq("estate_id", estateId)
    .eq("reporter_user_id", user.id)
    .order("created_at", { ascending: false });

  const rlist = (reports ?? []) as Report[];
  const openCount = rlist.filter((r) => r.status === "Nowe" || r.status === "W realizacji").length;
  const closedCount = rlist.filter((r) => r.status === "Zamkniete" || r.status === "Odrzucone").length;

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">Moje zgłoszenia</h1>
          <p className="text-sm text-ink/50 mt-1">
            {rlist.length} zgłoszeń · {openCount} otwartych · {closedCount} zamkniętych
          </p>
        </div>
      </div>

      {rlist.length === 0 ? (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz jeszcze żadnych zgłoszeń.</p>
          <p className="text-ink/30 text-sm mt-2">
            Zgłoś sprawę przez aplikację mobilną — pojawi się tutaj.
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {rlist.map((r) => {
            const statusColor: Record<string, { hex: string }> = {
              Nowe: { hex: "#3E7BD6" },
              "W realizacji": { hex: "#F2A900" },
              Zamkniete: { hex: "#2E9E6B" },
              Odrzucone: { hex: "#6B7A90" },
            };
            const sc = statusColor[r.status] ?? { hex: "#6B7A90" };
            return (
              <div
                key={r.id}
                className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <span className="text-[10px] font-mono font-semibold text-ink/40">
                        {r.display_id ?? r.id.slice(0, 8)}
                      </span>
                      {r.category && (
                        <span className="text-[10px] text-ink/30">· {r.category}</span>
                      )}
                    </div>
                    <h3 className="text-[15px] font-medium text-ink leading-snug">{r.title}</h3>
                    {r.description && (
                      <p className="text-[12.5px] text-ink/60 mt-1 line-clamp-2">{r.description}</p>
                    )}
                  </div>
                  <span
                    className="text-[11px] font-semibold px-2.5 py-0.5 rounded-full shrink-0"
                    style={{ backgroundColor: sc.hex + "18", color: sc.hex }}
                  >
                    {r.status}
                  </span>
                </div>
                <div className="flex items-center gap-3 mt-3 text-[11px] text-ink/40">
                  <span>
                    Zgłoszono: {new Date(r.created_at).toLocaleDateString("pl-PL")}
                  </span>
                  {r.assigned_to && (
                    <span>Przyjął: {r.assigned_to}</span>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}

      <div className="bg-white/60 rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.04)] p-5 text-center">
        <p className="text-[12.5px] text-ink/40">
          Nowe zgłoszenie możesz dodać przez aplikację mobilną Mestio.
        </p>
      </div>
    </div>
  );
}

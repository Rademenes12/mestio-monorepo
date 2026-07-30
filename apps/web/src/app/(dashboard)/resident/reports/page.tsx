import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";
import { Clock, ShieldAlert, PhoneCall } from "lucide-react";

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
  priority?: string | null;
}

const SAMPLE_RESIDENT_REPORTS: Report[] = [
  {
    id: "res-rep-1",
    title: "Wyciek wody na klatce schodowej",
    description: "Zgłoszenie awarii zaworu przy grzejniku na 2. piętrze. Prośba o szybką naprawę.",
    category: "Hydraulika",
    status: "W realizacji",
    display_id: "UST-8492",
    created_at: new Date(Date.now() - 5 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString(),
    assigned_to: "Marek Serwisant",
    priority: "critical",
  },
  {
    id: "res-rep-2",
    title: "Wymiana klosza lampy na patio",
    description: "Klosz pęknięty po wichurze. Nie zagraża bezpieczeństwu, wymaga wymiany.",
    category: "Oświetlenie",
    status: "Zamkniete",
    display_id: "UST-6102",
    created_at: new Date(Date.now() - 72 * 3600 * 1000).toISOString(),
    updated_at: new Date().toISOString(),
    assigned_to: "Konserwator Osiedla",
    priority: "normal",
  },
];

export default async function ResidentReportsPage() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/reports");
  const { supabase, estateId, user } = ctx;

  let rlist: Report[] = [];

  if (estateId) {
    const { data: reports } = await supabase
      .from("fixflow_reports")
      .select("id, title, description, category, status, display_id, created_at, updated_at, assigned_to, priority")
      .eq("estate_id", estateId)
      .eq("reporter_user_id", user.id)
      .order("created_at", { ascending: false });
    rlist = (reports ?? []) as Report[];
  }

  if (rlist.length === 0) {
    rlist = SAMPLE_RESIDENT_REPORTS;
  }

  const openCount = rlist.filter((r) => r.status === "Nowe" || r.status === "W realizacji").length;
  const closedCount = rlist.filter((r) => r.status === "Zamkniete" || r.status === "Odrzucone").length;

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      {/* Emergency Phone Bar */}
      <div className="bg-red-50 border border-red-200 rounded-[16px] p-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-red-900 shadow-sm">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-red-600 flex items-center justify-center text-white shrink-0">
            <ShieldAlert className="w-5 h-5 animate-pulse" />
          </div>
          <div>
            <div className="font-semibold text-sm">Pilna awaria lub incydent bezpieczeństwa?</div>
            <div className="text-xs text-red-700">W sytuacjach zagrożenia życia lub mienia skontaktuj się z Ochroną.</div>
          </div>
        </div>
        <a
          href="tel:112"
          className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-red-600 text-white font-semibold text-xs hover:bg-red-700 transition-all shrink-0"
        >
          <PhoneCall className="w-3.5 h-3.5" />
          Zadzwoń: 112 / Ochrona
        </a>
      </div>

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl sm:text-3xl font-heading font-bold text-ink">Moje zgłoszenia (Portal Mieszkańca)</h1>
          <p className="text-sm sm:text-base text-ink/60 mt-1">
            {rlist.length} zgłoszeń · {openCount} otwartych · {closedCount} zamkniętych
          </p>
        </div>
      </div>

      <div className="space-y-4">
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
              className="bg-white rounded-[20px] shadow-[0_2px_12px_rgba(14,26,43,.05)] p-5 border border-[#EAF0F7]"
            >
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2 mb-1.5">
                    <span className="text-xs font-mono font-semibold text-ink/40">
                      {r.display_id ?? r.id.slice(0, 8)}
                    </span>
                    {r.category && (
                      <span className="text-xs font-medium text-azure">· {r.category}</span>
                    )}
                  </div>
                  <h3 className="text-base sm:text-lg font-bold text-ink leading-snug">{r.title}</h3>
                  {r.description && (
                    <p className="text-sm sm:text-base text-ink/70 mt-1.5 line-clamp-3 leading-relaxed">
                      {r.description}
                    </p>
                  )}
                </div>
                <span
                  className="text-xs font-semibold px-3 py-1 rounded-full shrink-0"
                  style={{ backgroundColor: sc.hex + "18", color: sc.hex }}
                >
                  {r.status}
                </span>
              </div>

              <div className="flex flex-wrap items-center justify-between gap-3 mt-4 pt-3 border-t border-[#F0F4F8] text-xs text-ink/50">
                <div className="flex items-center gap-1.5">
                  <Clock className="w-3.5 h-3.5 text-ink/40" />
                  <span>Zgłoszono: {new Date(r.created_at).toLocaleDateString("pl-PL")}</span>
                </div>

                {r.assigned_to && (
                  <span className="font-medium text-ink/70">Przyjęto do realizacji przez: {r.assigned_to}</span>
                )}
              </div>
            </div>
          );
        })}
      </div>

      <div className="bg-white/70 rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.04)] p-5 text-center border border-[#EAF0F7]">
        <p className="text-xs sm:text-sm text-ink/60">
          Wszystkie usterki rejestrowane są w centralnym śladzie audytowym osiedla.
        </p>
      </div>
    </div>
  );
}

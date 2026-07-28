import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";

interface Resolution {
  id: string;
  number: string | null;
  title: string;
  description: string | null;
  deadline: string | null;
  status: string;
  closed_at: string | null;
  created_at: string;
}

interface ResolutionVote {
  resolution_id: string;
  choice: "for" | "against" | "abstain";
  share_units: number;
}

const STATUS_CONFIG: Record<string, { label: string; color: string }> = {
  open: { label: "W trakcie", color: "#3E7BD6" },
  passed: { label: "Przyjęta", color: "#2E9E6B" },
  rejected: { label: "Odrzucona", color: "#6B7A90" },
};

export default async function ResidentResolutionsPage() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/resolutions");
  const { supabase, estateId } = ctx;

  if (!estateId) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">Głosowania</h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz przypisanego osiedla.</p>
        </div>
      </div>
    );
  }

  const { data: resolutions } = await supabase
    .from("fixflow_resolutions")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const rlist = (resolutions ?? []) as Resolution[];
  const resolutionIds = rlist.map((r) => r.id);

  const { data: votesRaw } =
    resolutionIds.length > 0
      ? await supabase
          .from("fixflow_resolution_votes")
          .select("resolution_id, choice, share_units")
          .in("resolution_id", resolutionIds)
      : { data: [] };

  const votes = (votesRaw ?? []) as ResolutionVote[];

  const { data: estate } = await supabase
    .from("fixflow_estates")
    .select("total_shares")
    .eq("id", estateId)
    .maybeSingle();

  const totalShares = estate?.total_shares ?? 1000;

  function computeShares(resolutionId: string) {
    const rv = votes.filter((v) => v.resolution_id === resolutionId);
    const forShares = rv.filter((v) => v.choice === "for").reduce((a, v) => a + (v.share_units ?? 0), 0);
    const againstShares = rv.filter((v) => v.choice === "against").reduce((a, v) => a + (v.share_units ?? 0), 0);
    const abstainShares = rv.filter((v) => v.choice === "abstain").reduce((a, v) => a + (v.share_units ?? 0), 0);
    const totalVoted = forShares + againstShares + abstainShares;
    return {
      pctFor: totalShares ? Math.round((forShares / totalShares) * 100) : 0,
      pctAgainst: totalShares ? Math.round((againstShares / totalShares) * 100) : 0,
      pctAbstain: totalShares ? Math.max(0, 100 - Math.round((forShares / totalShares) * 100) - Math.round((againstShares / totalShares) * 100)) : 0,
      turnoutPct: totalShares ? Math.round((totalVoted / totalShares) * 100) : 0,
      votersCount: rv.length,
    };
  }

  const activeCount = rlist.filter((r) => r.status === "open").length;
  const closedCount = rlist.filter((r) => r.status !== "open").length;

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">Głosowania</h1>
          <p className="text-sm text-ink/50 mt-1">
            {rlist.length} uchwał · {activeCount} aktywnych · {closedCount} zakończonych
          </p>
        </div>
      </div>

      {/* Summary cards */}
      <div className="flex gap-4">
        <div className="flex-1 bg-white rounded-[14px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-4">
          <p className="text-[10px] font-mono uppercase tracking-wide text-ink/40">W trakcie</p>
          <p className="font-heading font-bold text-[24px] text-[#3E7BD6] mt-1">{activeCount}</p>
        </div>
        <div className="flex-1 bg-white rounded-[14px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-4">
          <p className="text-[10px] font-mono uppercase tracking-wide text-ink/40">Zakończone</p>
          <p className="font-heading font-bold text-[24px] text-[#2E9E6B] mt-1">{closedCount}</p>
        </div>
      </div>

      {rlist.length === 0 ? (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Brak uchwał dla tego osiedla.</p>
          <p className="text-ink/30 text-sm mt-2">Gdy pojawią się nowe głosowania, zobaczysz je tutaj.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {rlist.map((r) => {
            const config = STATUS_CONFIG[r.status] ?? STATUS_CONFIG.open;
            const deadlineDate = r.deadline ? new Date(r.deadline) : null;
            const isOpen = r.status === "open";
            const isOverdue = isOpen && !!deadlineDate && deadlineDate < new Date();
            const daysLeft = deadlineDate
              ? Math.ceil((deadlineDate.getTime() - Date.now()) / (1000 * 60 * 60 * 24))
              : null;
            const shares = computeShares(r.id);

            return (
              <div
                key={r.id}
                className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5"
              >
                <div className="flex items-center justify-between gap-3">
                  <span className="text-[10px] font-mono font-semibold text-ink/40">
                    {r.number ?? `#${r.id.slice(0, 4)}`}
                  </span>
                  <span
                    className="text-[10.5px] font-semibold px-2.5 py-0.5 rounded-full"
                    style={{ backgroundColor: config.color + "20", color: isOverdue ? "#F2A900" : config.color }}
                  >
                    {isOverdue ? "Termin minął" : config.label}
                  </span>
                </div>

                <h3 className="font-heading font-semibold text-[16px] text-ink mt-2">{r.title}</h3>
                {r.description && (
                  <p className="text-[12.5px] text-ink/60 leading-relaxed mt-1">{r.description}</p>
                )}

                <div className="flex items-center justify-between mt-3">
                  <span className="text-[11px] font-mono text-ink/40">
                    {deadlineDate ? `Termin: ${deadlineDate.toLocaleDateString("pl-PL")} · ` : ""}
                    {isOpen && daysLeft !== null && !isOverdue
                      ? `${daysLeft} dni do końca`
                      : isOpen
                        ? "Brak terminu"
                        : "Głosowanie zakończone"}
                  </span>
                  <span className="text-[11px] font-mono text-ink/30">
                    {shares.votersCount} głosów · {shares.turnoutPct}% frekwencja
                  </span>
                </div>

                <div className="mt-3">
                  <div className="flex h-2.5 rounded-md overflow-hidden bg-[#EFF2F6]">
                    <div className="h-full bg-[#2E9E6B]" style={{ width: `${shares.pctFor}%` }} />
                    <div className="h-full bg-[#C0392B]" style={{ width: `${shares.pctAgainst}%` }} />
                  </div>
                  <div className="flex gap-3.5 mt-1.5">
                    <span className="text-[11px] font-mono font-semibold text-[#2E9E6B]">
                      Za: {shares.pctFor}%
                    </span>
                    <span className="text-[11px] font-mono font-semibold text-[#C0392B]">
                      Przeciw: {shares.pctAgainst}%
                    </span>
                    <span className="text-[11px] font-mono text-ink/30">
                      Wstrzymało się: {shares.pctAbstain}%
                    </span>
                  </div>
                </div>

                {r.closed_at && (
                  <p className="text-[10.5px] font-mono text-[#2E9E6B] mt-2">
                    Zamknięto: {new Date(r.closed_at).toLocaleDateString("pl-PL")}
                  </p>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { CreateResolutionModal } from "./create-modal";
import CloseResolutionButton from "./close-button";

interface Resolution {
  id: string;
  estate_id: string;
  number: string | null;
  title: string;
  description: string | null;
  deadline: string | null; // fixflow_resolutions dopuszcza brak terminu
  status: string;
  closed_at: string | null;
  created_at: string;
}

interface ResolutionVote {
  resolution_id: string;
  choice: "for" | "against" | "abstain";
  share_units: number;
}

// Status "passed"/"rejected" (nie "closed") - ujednolicone z fixflow_resolutions
// uzywanym rowniez przez aplikacje mobilna (naprawa konfliktu schematow 2026-07-14).
const STATUS_CONFIG: Record<string, { label: string; color: string }> = {
  open: { label: "W trakcie", color: "#3E7BD6" },
  passed: { label: "Przyjęta", color: "#2E9E6B" },
  rejected: { label: "Odrzucona", color: "#6B7A90" },
};

export default async function ResolutionsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  // fixflow_resolutions jest kanoniczna tabela (uzywana rowniez przez aplikacje
  // mobilna) - stara "resolutions" mialaby zlamany FK do fixflow_resolution_votes
  // (naprawa konfliktu schematow 2026-07-14, patrz migracja 0014 w repo CRM Owner).
  const { data: resolutions, error } = await supabase
    .from("fixflow_resolutions")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const isTableReady = !error;

  const { data: estate } = await supabase
    .from("fixflow_estates")
    .select("total_shares")
    .eq("id", estateId)
    .maybeSingle();

  const totalShares = estate?.total_shares ?? 1000;

  const rlist = (resolutions ?? []) as Resolution[];
  const resolutionIds = rlist.map((r) => r.id);

  const { data: votesRaw } =
    isTableReady && resolutionIds.length > 0
      ? await supabase
          .from("fixflow_resolution_votes")
          .select("resolution_id, choice, share_units")
          .in("resolution_id", resolutionIds)
      : { data: [] };

  const votes = (votesRaw ?? []) as ResolutionVote[];

  const suggestedNumber = `U-${rlist.length + 1}/${new Date().getFullYear()}`;

  if (!isTableReady) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-heading font-bold text-ink">Uchwały</h1>
          <CreateResolutionModal
            estateId={estateId}
            userId={user.id}
            suggestedNumber={suggestedNumber}
          />
        </div>
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
          <p className="text-ink/50 text-sm mb-2">
            Nie udało się wczytać uchwał
          </p>
          <p className="text-ink/30 text-xs">
            Spróbuj odświeżyć stronę. Jeśli problem się powtarza, skontaktuj się z pomocą techniczną.
          </p>
        </div>
      </div>
    );
  }

  function computeShares(resolutionId: string) {
    const rv = votes.filter((v) => v.resolution_id === resolutionId);
    const forShares = rv
      .filter((v) => v.choice === "for")
      .reduce((a, v) => a + (v.share_units ?? 0), 0);
    const againstShares = rv
      .filter((v) => v.choice === "against")
      .reduce((a, v) => a + (v.share_units ?? 0), 0);
    const abstainShares = rv
      .filter((v) => v.choice === "abstain")
      .reduce((a, v) => a + (v.share_units ?? 0), 0);
    const pctFor = totalShares ? Math.round((forShares / totalShares) * 100) : 0;
    const pctAgainst = totalShares
      ? Math.round((againstShares / totalShares) * 100)
      : 0;
    const pctAbstain = Math.max(0, 100 - pctFor - pctAgainst);
    const turnoutPct = totalShares
      ? Math.round(((forShares + againstShares + abstainShares) / totalShares) * 100)
      : 0;
    return {
      forShares,
      againstShares,
      abstainShares,
      pctFor,
      pctAgainst,
      pctAbstain,
      turnoutPct,
      votersCount: rv.length,
    };
  }

  const activeCount = rlist.filter((r) => r.status === "open").length;
  const closedCount = rlist.filter((r) => r.status !== "open").length;
  const avgTurnout = rlist.length
    ? Math.round(
        rlist.reduce((a, r) => a + computeShares(r.id).turnoutPct, 0) / rlist.length
      )
    : 0;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-heading font-bold text-ink">Uchwały</h1>
        <CreateResolutionModal
          estateId={estateId}
          userId={user.id}
          suggestedNumber={suggestedNumber}
        />
      </div>

      <div className="flex gap-5 items-start">
        <div className="flex-1 min-w-0 flex flex-col gap-4">
          {rlist.length === 0 ? (
            <div className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-8 text-center">
              <p className="text-ink/40 text-sm">
                Brak uchwał. Dodaj pierwszą przyciskiem „Nowa uchwała&quot;.
              </p>
            </div>
          ) : (
            rlist.map((r) => {
              const config = STATUS_CONFIG[r.status] ?? STATUS_CONFIG.open;
              const deadlineDate = r.deadline ? new Date(r.deadline) : null;
              const currentDate = new Date();
              const isOpen = r.status === "open";
              const isOverdue = isOpen && !!deadlineDate && deadlineDate < currentDate;
              const daysLeft = deadlineDate
                ? Math.ceil(
                    (deadlineDate.getTime() - currentDate.getTime()) /
                      (1000 * 60 * 60 * 24)
                  )
                : null;
              const shares = computeShares(r.id);

              const daysLeftLabel = !isOpen
                ? "Głosowanie zakończone"
                : !deadlineDate
                  ? "Brak terminu"
                  : isOverdue
                    ? "Czeka na zamknięcie"
                    : daysLeft === 0
                      ? "Ostatni dzień głosowania"
                      : `${daysLeft} dni do końca`;

              const statusLabel = isOpen
                ? isOverdue
                  ? "Termin minął"
                  : "W trakcie"
                : config.label;
              const statusColor = isOpen ? (isOverdue ? "#F2A900" : "#3E7BD6") : config.color;

              return (
                <div
                  key={r.id}
                  className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5"
                >
                  <div className="flex items-center justify-between gap-3">
                    <span className="text-[10px] font-mono font-semibold text-ink/40">
                      {r.number ?? `UCHWAŁA #${r.id.slice(0, 4)}`}
                    </span>
                    <span
                      className="text-[10.5px] font-semibold px-2.5 py-0.5 rounded-full"
                      style={{ backgroundColor: statusColor + "20", color: statusColor }}
                    >
                      {statusLabel}
                    </span>
                  </div>

                  <h3 className="font-heading font-semibold text-[16px] text-ink mt-2">
                    {r.title}
                  </h3>
                  {r.description && (
                    <p className="text-[12.5px] text-ink/60 leading-relaxed mt-1">
                      {r.description}
                    </p>
                  )}

                  <div className="flex items-center justify-between mt-3">
                    <span className="text-[11px] font-mono text-ink/40">
                      {deadlineDate
                        ? `Termin: ${deadlineDate.toLocaleDateString("pl-PL")} · `
                        : ""}
                      {daysLeftLabel}
                    </span>
                    <span className="text-[11px] font-mono text-ink/30">
                      Głosów: {shares.votersCount} · frekwencja {shares.turnoutPct}%
                    </span>
                  </div>

                  {r.closed_at && (
                    <p className="text-[10.5px] font-mono text-[#2E9E6B] mt-1">
                      Zamknięto: {new Date(r.closed_at).toLocaleDateString("pl-PL")}
                    </p>
                  )}

                  <div className="mt-3">
                    <div className="flex h-2.5 rounded-md overflow-hidden bg-[#EFF2F6]">
                      <div
                        className="h-full bg-[#2E9E6B]"
                        style={{ width: `${shares.pctFor}%` }}
                      />
                      <div
                        className="h-full bg-[#C0392B]"
                        style={{ width: `${shares.pctAgainst}%` }}
                      />
                    </div>
                    <div className="flex flex-wrap gap-x-3.5 gap-y-1 mt-1.5">
                      <span className="text-[11px] font-mono font-semibold text-[#2E9E6B] whitespace-nowrap">
                        Za: {shares.pctFor}% ({shares.forShares} udz.)
                      </span>
                      <span className="text-[11px] font-mono font-semibold text-[#C0392B] whitespace-nowrap">
                        Przeciw: {shares.pctAgainst}% ({shares.againstShares} udz.)
                      </span>
                      <span className="text-[11px] font-mono text-ink/30 whitespace-nowrap">
                        Wstrz.: {shares.pctAbstain}%
                      </span>
                    </div>
                  </div>

                  {isOpen && (
                    <div className="mt-3">
                      <CloseResolutionButton resolutionId={r.id} />
                    </div>
                  )}
                </div>
              );
            })
          )}
        </div>

        <div className="w-[270px] shrink-0 flex flex-col gap-3 sticky top-24">
          <div className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5">
            <p className="text-[10px] font-mono uppercase tracking-wide text-ink/40">
              Podsumowanie głosowań
            </p>
            <div className="flex justify-between items-baseline mt-3.5">
              <span className="text-[13px] text-ink/60">W trakcie</span>
              <span className="font-heading font-bold text-[18px] text-azure">
                {activeCount}
              </span>
            </div>
            <div className="flex justify-between items-baseline mt-2">
              <span className="text-[13px] text-ink/60">Zakończone</span>
              <span className="font-heading font-bold text-[18px] text-[#2E9E6B]">
                {closedCount}
              </span>
            </div>
            <div className="flex justify-between items-baseline mt-2">
              <span className="text-[13px] text-ink/60">Śr. frekwencja</span>
              <span className="font-heading font-bold text-[18px] text-ink">
                {avgTurnout}%
              </span>
            </div>
          </div>

          <div className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-4">
            <p className="text-[10px] font-mono uppercase tracking-wide text-ink/40 mb-2.5">
              Wyniki na skróty
            </p>
            {rlist.length === 0 ? (
              <p className="text-xs text-ink/30">Brak danych</p>
            ) : (
              <div className="flex flex-col gap-2.5">
                {rlist.map((r) => {
                  const shares = computeShares(r.id);
                  const open = r.status === "open";
                  return (
                    <div key={r.id}>
                      <div className="flex justify-between gap-2">
                        <span className="text-xs font-semibold text-ink truncate">
                          {r.title}
                        </span>
                        <span className="text-[10.5px] font-mono text-ink/30 shrink-0">
                          {open ? "trwa" : "zam."}
                        </span>
                      </div>
                      <div className="flex h-1.5 rounded overflow-hidden bg-[#EFF2F6] mt-1">
                        <div
                          className="h-full bg-[#2E9E6B]"
                          style={{ width: `${shares.pctFor}%` }}
                        />
                        <div
                          className="h-full bg-[#C0392B]"
                          style={{ width: `${shares.pctAgainst}%` }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

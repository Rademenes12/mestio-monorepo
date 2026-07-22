import Link from "next/link";

const MEDALS = ["🥇", "🥈", "🥉"];

interface RankingEntry {
  estate_name: string;
  resolved_count: number;
  avg_hours: number;
}

const FALLBACK_ENTRIES: RankingEntry[] = [
  { estate_name: "Osiedle Słoneczne", resolved_count: 12, avg_hours: 48.5 },
  { estate_name: "Apartamenty Park", resolved_count: 5, avg_hours: 96.2 },
];

async function fetchRanking(): Promise<RankingEntry[]> {
  try {
    const res = await fetch("https://admin.mestio.pl/api/ranking", {
      next: { revalidate: 3600 },
    });
    if (!res.ok) return FALLBACK_ENTRIES;
    const json = (await res.json()) as { ranking?: RankingEntry[] };
    return json.ranking ?? FALLBACK_ENTRIES;
  } catch {
    return FALLBACK_ENTRIES;
  }
}

export default async function RankingSection() {
  const ranking = await fetchRanking();
  const top5 = ranking.slice(0, 5);
  const isEmpty = top5.length === 0;

  return (
    <section className="max-w-[1160px] mx-auto px-6 py-10">
      <div className="text-center">
        <h2 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
          Który zarząd działa najszybciej?
        </h2>
        <p className="text-base text-[#4A5A6E] mt-[10px] max-w-[600px] mx-auto">
          Osiedla, które najsprawniej obsługują zgłoszenia mieszkańców, trafiają
          do naszego rankingu. Rywalizacja podnosi jakość obsługi — dołącz i
          pokaż, że Twój zarząd działa najszybciej.
        </p>
      </div>

      {isEmpty ? (
        <div className="mt-[34px] bg-white rounded-[20px] p-[40px_24px] text-center shadow-[0_2px_14px_rgba(14,26,43,.06)] border border-[#EAF0F7]">
          <p className="text-base text-[#4A5A6E] max-w-[480px] mx-auto">
            Ranking jest jeszcze pusty — Twoje osiedle może być pierwsze.
            Uruchom Mestio i wejdź na szczyt zestawienia.
          </p>
          <Link
            href="/zamow"
            className="inline-block mt-[18px] text-base font-semibold text-white px-[30px] py-[15px] rounded-[13px] bg-gradient-to-r from-azure to-blueprint hover:brightness-105 transition-all"
          >
            Dołącz i wejdź do rankingu &rarr;
          </Link>
        </div>
      ) : (
        <div className="mt-[34px] bg-white rounded-[20px] overflow-hidden shadow-[0_2px_14px_rgba(14,26,43,.06)] border border-[#EAF0F7]">
          <div className="hidden sm:grid grid-cols-[60px_1fr_140px_140px] gap-4 px-6 py-[14px] bg-[#F6F8FB] border-b border-[#EAF0F7] font-mono text-[11px] uppercase tracking-[0.5px] text-[#8A98AB]">
            <span className="text-center">#</span>
            <span>Osiedle</span>
            <span className="text-center">Uchwały</span>
            <span className="text-center">Śr. czas</span>
          </div>

          {top5.map((entry, i) => {
            const isLast = i === top5.length - 1;
            const hoursStr =
              entry.avg_hours < 24
                ? `${entry.avg_hours.toFixed(1)} h`
                : `${Math.round(entry.avg_hours / 24)} dni`;

            return (
              <div
                key={entry.estate_name}
                className={`grid grid-cols-1 sm:grid-cols-[60px_1fr_140px_140px] gap-3 sm:gap-4 px-6 py-[18px] items-center ${
                  isLast ? "" : "border-b border-[#EEF2F8]"
                }`}
              >
                <div className="flex sm:justify-center items-center gap-2">
                  {i < 3 ? (
                    <span className="text-[22px] leading-none">
                      {MEDALS[i]}
                    </span>
                  ) : (
                    <span className="w-7 h-7 rounded-full bg-[#EEF2F8] flex items-center justify-center font-mono text-[13px] font-semibold text-[#8A98AB]">
                      {i + 1}
                    </span>
                  )}
                  <span className="sm:hidden font-heading font-semibold text-base text-ink">
                    {entry.estate_name}
                  </span>
                </div>

                <span className="hidden sm:block font-heading font-semibold text-base text-ink">
                  {entry.estate_name}
                </span>

                <div className="sm:text-center">
                  <span className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] text-[#8A98AB] mr-2">
                    Uchwały:
                  </span>
                  <span className="font-mono text-[14px] font-semibold text-ink">
                    {entry.resolved_count}
                  </span>
                </div>

                <div className="sm:text-center">
                  <span className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] text-[#8A98AB] mr-2">
                    Śr. czas:
                  </span>
                  <span className="font-mono text-[14px] font-semibold text-[#173A6A]">
                    {hoursStr}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </section>
  );
}

import { colors } from "@mestio/design-tokens";
import { Sparkles, Trophy } from "lucide-react";
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
    <section id="ranking" className="max-w-7xl mx-auto px-6 py-[60px]">
      <div className="text-center">
        <div
          className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-4"
          style={{
            background: `${colors.warning}14`,
            color: colors.warning,
            border: `1px solid ${colors.warning}25`,
          }}
        >
          <Trophy className="w-3.5 h-3.5" />
          Ranking
        </div>
        <h2
          className="font-heading font-bold text-[30px] tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Który zarząd działa najszybciej?
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Osiedla, które najsprawniej obsługują zgłoszenia mieszkańców, trafiają
          do naszego rankingu. Rywalizacja podnosi jakość obsługi.
        </p>
      </div>

      {isEmpty ? (
        <div
          className="mt-[34px] glass-card p-[40px_24px] text-center"
          style={{ borderColor: colors.cardBorder }}
        >
          <p
            className="text-base max-w-[480px] mx-auto"
            style={{ color: colors.textSecondary }}
          >
            Ranking jest jeszcze pusty — Twoje osiedle może być pierwsze.
            Uruchom Mestio i wejdź na szczyt zestawienia.
          </p>
          <Link
            href="/zamow"
            className="inline-flex items-center gap-2 mt-[18px] text-base font-semibold px-[30px] py-[15px] rounded-[13px] transition-all duration-200 hover:brightness-110"
            style={{
              background: `linear-gradient(135deg, ${colors.accent}, ${colors.navyLight})`,
              color: colors.text,
              boxShadow: `0 4px 16px ${colors.accent}35`,
            }}
          >
            Dołącz i wejdź do rankingu &rarr;
          </Link>
        </div>
      ) : (
        <div
          className="mt-[34px] glass-card overflow-hidden"
          style={{
            borderColor: colors.cardBorder,
            background: colors.card,
          }}
        >
          {/* Table header */}
          <div
            className="hidden sm:grid grid-cols-[60px_1fr_140px_140px] gap-4 px-6 py-[14px] font-mono text-[11px] uppercase tracking-[0.5px]"
            style={{
              background: colors.bgSecondary,
              color: colors.textMuted,
              borderBottom: `1px solid ${colors.cardBorder}`,
            }}
          >
            <span className="text-center">#</span>
            <span>Osiedle</span>
            <span className="text-center">Rozwiązane</span>
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
                className={`grid grid-cols-1 sm:grid-cols-[60px_1fr_140px_140px] gap-3 sm:gap-4 px-6 py-[18px] items-center transition-colors hover:bg-white/[0.03] ${
                  isLast ? "" : "border-b"
                }`}
                style={{ borderColor: colors.cardBorder }}
              >
                <div className="flex sm:justify-center items-center gap-2">
                  {i < 3 ? (
                    <span className="text-[22px] leading-none">
                      {MEDALS[i]}
                    </span>
                  ) : (
                    <span
                      className="w-7 h-7 rounded-full flex items-center justify-center font-mono text-[13px] font-semibold"
                      style={{
                        background: colors.bgSecondary,
                        color: colors.textMuted,
                      }}
                    >
                      {i + 1}
                    </span>
                  )}
                  <span
                    className="sm:hidden font-heading font-semibold text-base"
                    style={{ color: colors.text }}
                  >
                    {entry.estate_name}
                  </span>
                </div>

                <span
                  className="hidden sm:block font-heading font-semibold text-base"
                  style={{ color: colors.text }}
                >
                  {entry.estate_name}
                </span>

                <div className="sm:text-center">
                  <span
                    className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] mr-2"
                    style={{ color: colors.textMuted }}
                  >
                    Rozwiązane:
                  </span>
                  <span
                    className="font-mono text-[14px] font-semibold"
                    style={{ color: colors.text }}
                  >
                    {entry.resolved_count}
                  </span>
                </div>

                <div className="sm:text-center">
                  <span
                    className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] mr-2"
                    style={{ color: colors.textMuted }}
                  >
                    Śr. czas:
                  </span>
                  <span
                    className="font-mono text-[14px] font-semibold"
                    style={{ color: colors.accent }}
                  >
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

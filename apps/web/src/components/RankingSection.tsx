import RankingSectionClient from "./RankingSectionClient";

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
  return <RankingSectionClient ranking={ranking} />;
}

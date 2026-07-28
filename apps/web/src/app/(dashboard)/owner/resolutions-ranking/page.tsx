"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Estate {
  id: string;
  name: string;
}

interface RankRow {
  estate: Estate;
  resolved: number;
  avgHours: number;
}

const MEDALS = ["🥇", "🥈", "🥉"];

export default function ResolutionsRankingPage() {
  const [rows, setRows] = useState<RankRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [unavailable, setUnavailable] = useState(false);
  const supabase = createClient();

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const { data: ranking, error } = await supabase.rpc("mestio_ranking_uchwal");
      if (cancelled) return;
      if (error) {
        setUnavailable(true);
        setRows([]);
      } else {
        const raw = ranking as { estate_name: string; resolved_count: number; avg_hours: number }[] | null;
        if (!raw || raw.length === 0) {
          setRows([]);
        } else {
          setRows(
            raw.map((r) => ({
              estate: { id: r.estate_name, name: r.estate_name },
              resolved: Number(r.resolved_count),
              avgHours: Math.round(Number(r.avg_hours)),
            }))
          );
        }
      }
      setLoading(false);
    })();
    return () => {
      cancelled = true;
    };
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) {
    return <div className="text-center text-[#9AA7B8] py-20 text-sm">Ładowanie...</div>;
  }

  const maxHours = Math.max(1, ...rows.map((r) => r.avgHours));

  return (
    <div className="max-w-4xl mx-auto">
      {/* Gradientowy nagłówek */}
      <div className="bg-gradient-to-br from-azure to-blueprint rounded-[12px] p-5 px-[22px] text-white mb-4">
        <div className="font-[family-name:var(--font-heading)] font-bold text-base">
          Grywalizacja: kto najszybciej uchwala uchwały
        </div>
        <div className="text-[12.5px] text-white/85 mt-[5px] leading-normal">
          Ranking liczony ze średniego czasu od otwarcia do zamknięcia głosowania. Widoczny też
          publicznie na stronie WWW jako element konkursu dla zarządów/administratorów.
        </div>
      </div>

      {unavailable ? (
        <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-[30px] text-center">
          <div className="w-12 h-12 rounded-full bg-azure/10 flex items-center justify-center mx-auto mb-3">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0V4z" />
            </svg>
          </div>
          <p className="text-ink font-medium text-sm">Brak danych o uchwałach</p>
          <p className="text-[12.5px] text-[#9AA7B8] mt-1 max-w-md mx-auto">
            Moduł głosowań (tabela{" "}
            <code className="font-[family-name:var(--font-mono)] text-[11px] bg-[#F4F7FB] px-1 py-0.5 rounded">
              fixflow_resolutions
            </code>
            ) nie ma jeszcze zamkniętych uchwał. Ranking wypełni się automatycznie, gdy
            zarządy osiedli zaczną tworzyć uchwały w CRM klienta, a mieszkańcy głosować w aplikacji.
          </p>
        </div>
      ) : rows.length === 0 ? (
        <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
          Brak zamkniętych uchwał. Ranking pojawi się po pierwszych zakończonych głosowaniach.
        </div>
      ) : (
        <div className="flex flex-col gap-[10px]">
          {rows.map((row, i) => {
            const barWidth = Math.max(8, 100 - Math.round((row.avgHours / maxHours) * 100)) + "%";
            return (
              <div
                key={row.estate.id}
                className="bg-white rounded-2xl border border-[#E9EEF5] p-4 px-[18px] flex items-center gap-[14px]"
              >
                <div className="w-[34px] font-[family-name:var(--font-heading)] font-bold text-lg text-center shrink-0">
                  {MEDALS[i] ?? ""}
                  {i + 1}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-[family-name:var(--font-heading)] font-semibold text-[14.5px] text-ink">
                    {row.estate.name}
                  </div>
                  <div className="font-[family-name:var(--font-mono)] text-[10.5px] text-[#8A98AB] mt-[2px]">
                    {row.resolved} uchwał zakończonych
                  </div>
                  <div className="h-[6px] rounded bg-[#EDF1F7] mt-2 overflow-hidden">
                    <div className="h-full rounded bg-success" style={{ width: barWidth }} />
                  </div>
                </div>
                <div className="text-right shrink-0">
                  <div className="font-[family-name:var(--font-heading)] font-bold text-base text-blueprint">
                    {row.avgHours}h
                  </div>
                  <div className="font-[family-name:var(--font-mono)] text-[9.5px] text-[#9AA7B8]">śr. czas</div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Estate {
  id: string;
  name: string;
  address: string;
  city: string | null;
  created_at: string;
}

const COVERS = [
  "from-azure to-blueprint",
  "from-amber to-[#C98800]",
  "from-success to-blueprint",
  "from-[#C0392B] to-ink",
  "from-blueprint to-azure",
  "from-[#6B7A90] to-ink",
];

async function fetchEstates(
  supabase: ReturnType<typeof createClient>
): Promise<Estate[]> {
  const { data } = await supabase
    .from("estates")
    .select("*")
    .order("created_at", { ascending: false });
  return (data as Estate[]) ?? [];
}

export default function EstatesPage() {
  const [estates, setEstates] = useState<Estate[]>([]);
  const [loading, setLoading] = useState(true);
  const supabase = createClient();

   
  useEffect(() => {
    let cancelled = false;
    fetchEstates(supabase).then((data) => {
      if (!cancelled) { setEstates(data); setLoading(false); }
    });
    return () => { cancelled = true; };
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) {
    return (
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[14px] animate-pulse">
        {[0, 1, 2, 3, 4, 5].map((i) => (
          <div key={i} className="h-[168px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />
        ))}
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto">
      {estates.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
          Brak osiedli w systemie. Osiedla pojawią się automatycznie po rejestracji klientów przez aplikację mobilną.
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[14px]">
          {estates.map((e, i) => (
            <div
              key={e.id}
              className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-5 transition-shadow hover:shadow-[var(--shadow-card-hover)]"
            >
              <div className="flex items-center gap-[11px]">
                <div
                  className={`w-10 h-10 rounded-[11px] bg-gradient-to-br ${COVERS[i % COVERS.length]} flex items-center justify-center shrink-0`}
                >
                  <span className="font-[family-name:var(--font-heading)] font-bold text-sm text-white">
                    {e.name.slice(0, 2).toUpperCase()}
                  </span>
                </div>
                <div className="min-w-0">
                  <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink truncate">
                    {e.name}
                  </div>
                  <div className="font-[family-name:var(--font-mono)] text-[11px] text-[#8A98AB] truncate">
                    {e.city ?? e.address ?? "—"}
                  </div>
                </div>
              </div>

              <div className="mt-[14px]">
                <div className="font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-[#8A98AB] uppercase">Adres</div>
                <div className="text-[13px] font-medium text-[#3A4759] mt-[3px] leading-snug">
                  {e.address ?? "—"}
                </div>
              </div>

              <div className="flex items-center justify-between mt-[16px] pt-[13px] border-t border-[#F4F7FB]">
                <span className="font-[family-name:var(--font-mono)] text-[10.5px] font-semibold px-[10px] py-[4px] rounded-full bg-success/10 text-success">
                  Aktywne
                </span>
                <a
                  href={`https://panel.mestio.pl/estates/${e.id}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-[4px] font-[family-name:var(--font-mono)] text-[12px] font-semibold text-azure hover:text-azure-dark transition-colors"
                >
                  Otwórz panel zarządu
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M5 12h13M13 6l6 6-6 6" />
                  </svg>
                </a>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

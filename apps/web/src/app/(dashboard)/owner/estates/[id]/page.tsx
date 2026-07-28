"use client";

import { useEffect, useState, use } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

interface Building {
  id: string;
  estate_id: string;
  name: string;
  address: string | null;
  created_at: string;
  units?: Unit[];
}

interface Unit {
  id: string;
  building_id: string;
  unit_number: string;
  floor: number | null;
  area_sqm: number | null;
  rooms: number | null;
  status: "vacant" | "occupied" | "maintenance" | "reserved";
}

export default function EstateDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [estateName, setEstateName] = useState("");
  const [buildings, setBuildings] = useState<Building[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAddBuilding, setShowAddBuilding] = useState(false);
  const [newBuildingName, setNewBuildingName] = useState("");
  const supabase = createClient();

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const [estateRes, buildingsRes] = await Promise.all([
        supabase.from("estates").select("name").eq("id", id).single(),
        supabase
          .from("estate_buildings")
          .select("*, estate_units(*)")
          .eq("estate_id", id)
          .order("name"),
      ]);
      if (cancelled) return;
      if (estateRes.data) setEstateName((estateRes.data as { name: string }).name);
      setBuildings((buildingsRes.data as (Building & { estate_units: Unit[] })[])?.map((b) => ({ ...b, units: b.estate_units })) ?? []);
      setLoading(false);
    }
    load();
    return () => { cancelled = true; };
  }, [id]); // eslint-disable-line react-hooks/exhaustive-deps

  async function addBuilding() {
    if (!newBuildingName.trim()) return;
    const { data } = await supabase
      .from("estate_buildings")
      .insert({ estate_id: id, name: newBuildingName.trim() })
      .select("*, estate_units(*)")
      .single();
    if (data) {
      const b = data as Building & { estate_units: Unit[] };
      setBuildings((prev) => [...prev, { ...b, units: b.estate_units }]);
      setNewBuildingName("");
      setShowAddBuilding(false);
    }
  }

  const totalUnits = buildings.reduce((s, b) => s + (b.units?.length ?? 0), 0);
  const occupiedUnits = buildings.reduce(
    (s, b) => s + (b.units?.filter((u) => u.status === "occupied").length ?? 0),
    0
  );

  if (loading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 w-48 bg-white/50 rounded-lg" />
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {[0, 1, 2].map((i) => (
            <div key={i} className="h-40 bg-white rounded-2xl shadow-[var(--shadow-card)]" />
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Link
            href="/estates"
            className="text-xs font-medium text-[#9AA7B8] hover:text-ink transition-colors"
          >
            ← Osiedla
          </Link>
          <h1 className="font-heading font-bold text-xl text-ink mt-1">{estateName}</h1>
          <p className="text-sm text-[#9AA7B8] mt-0.5">
            {buildings.length} budynków · {totalUnits} lokali · {occupiedUnits} zamieszkanych
          </p>
        </div>
        <button
          onClick={() => setShowAddBuilding(true)}
          className="flex items-center gap-2 bg-gradient-to-br from-azure to-blueprint text-white text-[13px] font-semibold px-4 py-2.5 rounded-xl hover:opacity-90 transition-opacity"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.6" strokeLinecap="round">
            <path d="M12 6v12M6 12h12" />
          </svg>
          Dodaj budynek
        </button>
      </div>

      {/* Add building form */}
      {showAddBuilding && (
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-5">
          <div className="flex items-center gap-3">
            <input
              value={newBuildingName}
              onChange={(e) => setNewBuildingName(e.target.value)}
              placeholder="Nazwa budynku (np. Budynek A)"
              className="flex-1 px-4 py-2.5 bg-[#F4F7FB] border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
              onKeyDown={(e) => e.key === "Enter" && addBuilding()}
              autoFocus
            />
            <button
              onClick={addBuilding}
              className="px-4 py-2.5 bg-success text-white text-[13px] font-semibold rounded-xl hover:opacity-90 transition-opacity"
            >
              Dodaj
            </button>
            <button
              onClick={() => { setShowAddBuilding(false); setNewBuildingName(""); }}
              className="px-4 py-2.5 text-[13px] text-[#9AA7B8] hover:text-ink transition-colors"
            >
              Anuluj
            </button>
          </div>
        </div>
      )}

      {/* Buildings grid */}
      {buildings.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
          <div className="w-12 h-12 rounded-xl bg-[#F4F7FB] flex items-center justify-center mx-auto mb-3">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#9AA7B8" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <path d="M3 21h18M3 10l9-7 9 7M5 10v11h4V14h6v7h4V10" />
            </svg>
          </div>
          <p>Brak budynków w osiedlu</p>
          <p className="text-xs mt-1">Dodaj pierwszy budynek, aby rozpocząć zarządzanie lokalami</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {buildings.map((building) => {
            const unitCount = building.units?.length ?? 0;
            const occCount = building.units?.filter((u) => u.status === "occupied").length ?? 0;
            return (
              <Link
                key={building.id}
                href={`/estates/${id}/buildings/${building.id}`}
                className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-5 hover:shadow-lg transition-shadow group"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h3 className="font-semibold text-[15px] text-ink group-hover:text-azure transition-colors">
                      {building.name}
                    </h3>
                    {building.address && (
                      <p className="text-xs text-[#9AA7B8] mt-0.5">{building.address}</p>
                    )}
                  </div>
                  <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-azure/10 to-blueprint/10 flex items-center justify-center shrink-0">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M3 21h18M3 10l9-7 9 7M5 10v11h4V14h6v7h4V10" />
                    </svg>
                  </div>
                </div>
                <div className="flex items-center gap-4 text-xs text-[#9AA7B8]">
                  <span>{unitCount} lokali</span>
                  <span>{occCount} zamieszkanych</span>
                  <span className="ml-auto text-azure font-medium group-hover:mr-1 transition-all">
                    Zarządzaj →
                  </span>
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}

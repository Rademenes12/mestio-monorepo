"use client";

import { useEffect, useState, use } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

interface Unit {
  id: string;
  building_id: string;
  unit_number: string;
  floor: number | null;
  area_sqm: number | null;
  rooms: number | null;
  status: "vacant" | "occupied" | "maintenance" | "reserved";
  created_at: string;
}

interface Tenant {
  id: string;
  unit_id: string;
  full_name: string;
  email: string | null;
  phone: string | null;
  is_owner: boolean;
  is_primary: boolean;
}

interface BuildingInfo {
  id: string;
  estate_id: string;
  name: string;
  address: string | null;
}

const STATUS_STYLES: Record<string, { label: string; bg: string; text: string }> = {
  vacant: { label: "Wolny", bg: "bg-success/15", text: "text-success" },
  occupied: { label: "Zamieszkany", bg: "bg-azure/10", text: "text-azure" },
  maintenance: { label: "Remont", bg: "bg-amber/20", text: "text-amber-light" },
  reserved: { label: "Zarezerwowany", bg: "bg-[#8B5CF6]/15", text: "text-[#8B5CF6]" },
};

export default function BuildingDetailPage({
  params,
}: {
  params: Promise<{ id: string; buildingId: string }>;
}) {
  const { id: estateId, buildingId } = use(params);
  const [building, setBuilding] = useState<BuildingInfo | null>(null);
  const [units, setUnits] = useState<Unit[]>([]);
  const [tenantsMap, setTenantsMap] = useState<Record<string, Tenant[]>>({});
  const [loading, setLoading] = useState(true);
  const [showAddUnit, setShowAddUnit] = useState(false);
  const [newUnit, setNewUnit] = useState({ unit_number: "", floor: "", area_sqm: "", rooms: "" });
  const supabase = createClient();

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const [buildingRes, unitsRes] = await Promise.all([
        supabase.from("estate_buildings").select("*").eq("id", buildingId).single(),
        supabase.from("estate_units").select("*").eq("building_id", buildingId).order("unit_number"),
      ]);
      if (cancelled) return;
      setBuilding(buildingRes.data as BuildingInfo);

      const unitsData = (unitsRes.data as Unit[]) ?? [];
      setUnits(unitsData);

      // Load tenants for all units
      if (unitsData.length > 0) {
        const { data: tenantsData } = await supabase
          .from("estate_tenants")
          .select("*")
          .in("unit_id", unitsData.map((u) => u.id));
        if (tenantsData) {
          const map: Record<string, Tenant[]> = {};
          for (const t of tenantsData as Tenant[]) {
            if (!map[t.unit_id]) map[t.unit_id] = [];
            map[t.unit_id].push(t);
          }
          setTenantsMap(map);
        }
      }

      setLoading(false);
    }
    load();
    return () => { cancelled = true; };
  }, [buildingId, estateId]); // eslint-disable-line react-hooks/exhaustive-deps

  async function addUnit() {
    if (!newUnit.unit_number.trim()) return;
    const payload: Record<string, unknown> = {
      building_id: buildingId,
      estate_id: estateId,
      unit_number: newUnit.unit_number.trim(),
      floor: newUnit.floor ? parseInt(newUnit.floor) : null,
      area_sqm: newUnit.area_sqm ? parseFloat(newUnit.area_sqm) : null,
      rooms: newUnit.rooms ? parseInt(newUnit.rooms) : null,
    };
    const { data } = await supabase.from("estate_units").insert(payload).select().single();
    if (data) {
      setUnits((prev) => [...prev, data as Unit]);
      setNewUnit({ unit_number: "", floor: "", area_sqm: "", rooms: "" });
      setShowAddUnit(false);
    }
  }

  // Group units by floor
  const unitsByFloor: Record<string, Unit[]> = {};
  for (const u of units) {
    const key = u.floor !== null ? `Piętro ${u.floor}` : "Parter";
    if (!unitsByFloor[key]) unitsByFloor[key] = [];
    unitsByFloor[key].push(u);
  }

  const unitCount = units.length;
  const vacantCount = units.filter((u) => u.status === "vacant").length;
  const occupiedCount = units.filter((u) => u.status === "occupied").length;

  if (loading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 w-48 bg-white/50 rounded-lg" />
        <div className="h-64 bg-white rounded-2xl border border-[#E9EEF5]" />
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <Link
            href={`/estates/${estateId}`}
            className="text-xs font-medium text-[#9AA7B8] hover:text-ink transition-colors"
          >
            ← {building?.name ?? "Budynek"}
          </Link>
          <h1 className="font-heading font-bold text-xl text-ink mt-1">{building?.name ?? "Budynek"}</h1>
          <p className="text-sm text-[#9AA7B8] mt-0.5">
            {unitCount} lokali · {vacantCount} wolnych · {occupiedCount} zamieszkanych
            {building?.address && ` · ${building.address}`}
          </p>
        </div>
        <button
          onClick={() => setShowAddUnit(true)}
          className="flex items-center gap-2 bg-gradient-to-br from-azure to-blueprint text-white text-[13px] font-semibold px-4 py-2.5 rounded-xl hover:opacity-90 transition-opacity"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.6" strokeLinecap="round">
            <path d="M12 6v12M6 12h12" />
          </svg>
          Dodaj lokal
        </button>
      </div>

      {/* Add unit form */}
      {showAddUnit && (
        <div className="bg-white rounded-2xl border border-[#E9EEF5] p-5">
          <div className="grid grid-cols-5 gap-3 mb-3">
            <input
              value={newUnit.unit_number}
              onChange={(e) => setNewUnit((p) => ({ ...p, unit_number: e.target.value }))}
              placeholder="Nr lokalu *"
              className="col-span-1 px-4 py-2.5 bg-[#F4F7FB] border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
              autoFocus
            />
            <input
              value={newUnit.floor}
              onChange={(e) => setNewUnit((p) => ({ ...p, floor: e.target.value }))}
              placeholder="Piętro"
              type="number"
              className="col-span-1 px-4 py-2.5 bg-[#F4F7FB] border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
            />
            <input
              value={newUnit.area_sqm}
              onChange={(e) => setNewUnit((p) => ({ ...p, area_sqm: e.target.value }))}
              placeholder="Pow. m²"
              type="number"
              step="0.1"
              className="col-span-1 px-4 py-2.5 bg-[#F4F7FB] border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
            />
            <input
              value={newUnit.rooms}
              onChange={(e) => setNewUnit((p) => ({ ...p, rooms: e.target.value }))}
              placeholder="Pokoje"
              type="number"
              className="col-span-1 px-4 py-2.5 bg-[#F4F7FB] border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
            />
            <button
              onClick={addUnit}
              className="col-span-1 px-4 py-2.5 bg-success text-white text-[13px] font-semibold rounded-xl hover:opacity-90 transition-opacity"
            >
              Dodaj
            </button>
          </div>
          <button
            onClick={() => { setShowAddUnit(false); setNewUnit({ unit_number: "", floor: "", area_sqm: "", rooms: "" }); }}
            className="text-xs text-[#9AA7B8] hover:text-ink transition-colors"
          >
            Anuluj
          </button>
        </div>
      )}

      {/* Units grid */}
      {units.length === 0 ? (
        <div className="bg-white rounded-2xl border border-[#E9EEF5] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
          <div className="w-12 h-12 rounded-xl bg-[#F4F7FB] flex items-center justify-center mx-auto mb-3">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#9AA7B8" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
              <line x1="3" y1="9" x2="21" y2="9" />
              <line x1="9" y1="3" x2="9" y2="21" />
            </svg>
          </div>
          <p>Brak lokali w tym budynku</p>
          <p className="text-xs mt-1">Dodaj pierwszy lokal, aby rozpocząć zarządzanie</p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-[#E9EEF5] divide-y divide-[#F4F7FB]">
          {/* Header */}
          <div className="grid grid-cols-12 px-5 py-3 text-[11px] font-semibold uppercase tracking-[.4px] text-[#9AA7B8]">
            <span className="col-span-2">Lokal</span>
            <span className="col-span-1">Piętro</span>
            <span className="col-span-2">Pow.</span>
            <span className="col-span-2">Pokoje</span>
            <span className="col-span-2">Status</span>
            <span className="col-span-3">Mieszkaniec</span>
          </div>
          {units.map((unit) => {
            const style = STATUS_STYLES[unit.status] ?? STATUS_STYLES.vacant;
            const tenants = tenantsMap[unit.id] ?? [];
            const primaryTenant = tenants.find((t) => t.is_primary) ?? tenants[0];
            return (
              <Link
                key={unit.id}
                href={`/estates/${estateId}/buildings/${buildingId}/units/${unit.id}`}
                className="grid grid-cols-12 px-5 py-3.5 items-center hover:bg-[#FAFBFC] transition-colors group"
              >
                <span className="col-span-2 text-[14px] font-semibold text-ink">
                  {unit.unit_number}
                </span>
                <span className="col-span-1 text-[13px] text-[#3A4759]">
                  {unit.floor !== null ? `${unit.floor}` : "—"}
                </span>
                <span className="col-span-2 text-[13px] text-[#3A4759]">
                  {unit.area_sqm ? `${unit.area_sqm} m²` : "—"}
                </span>
                <span className="col-span-2 text-[13px] text-[#3A4759]">
                  {unit.rooms ? `${unit.rooms} ${unit.rooms === 1 ? "pokój" : unit.rooms < 5 ? "pokoje" : "pokoi"}` : "—"}
                </span>
                <span className="col-span-2">
                  <span className={`text-[11px] font-semibold px-2.5 py-1 rounded-full ${style.bg} ${style.text}`}>
                    {style.label}
                  </span>
                </span>
                <span className="col-span-3 text-[13px] text-[#3A4759] truncate flex items-center gap-2">
                  {primaryTenant ? (
                    <>
                      {primaryTenant.full_name}
                      {primaryTenant.is_owner && (
                        <span className="text-[10px] px-1.5 py-0.5 rounded bg-[#F4F7FB] text-[#9AA7B8]">W</span>
                      )}
                    </>
                  ) : (
                    <span className="text-[#9AA7B8]">—</span>
                  )}
                  <svg
                    className="ml-auto w-4 h-4 text-[#D0D7E0] group-hover:text-azure transition-colors shrink-0"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <path d="M9 18l6-6-6-6" />
                  </svg>
                </span>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}

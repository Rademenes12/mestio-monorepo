"use client";

import { useEffect, useState, use } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

interface UnitData {
  id: string;
  building_id: string;
  estate_id: string;
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
  user_id: string | null;
  full_name: string;
  email: string | null;
  phone: string | null;
  is_owner: boolean;
  is_primary: boolean;
  move_in_date: string | null;
  move_out_date: string | null;
  notes: string | null;
}

interface BuildingInfo {
  name: string;
}

const STATUS_OPTIONS = [
  { value: "vacant" as const, label: "Wolny", color: "text-success" },
  { value: "occupied" as const, label: "Zamieszkany", color: "text-azure" },
  { value: "maintenance" as const, label: "Remont", color: "text-amber-light" },
  { value: "reserved" as const, label: "Zarezerwowany", color: "text-[#8B5CF6]" },
];

export default function UnitDetailPage({
  params,
}: {
  params: Promise<{ id: string; buildingId: string; unitId: string }>;
}) {
  const { id: estateId, buildingId, unitId } = use(params);
  const [unit, setUnit] = useState<UnitData | null>(null);
  const [building, setBuilding] = useState<BuildingInfo | null>(null);
  const [tenants, setTenants] = useState<Tenant[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAddTenant, setShowAddTenant] = useState(false);
  const [newTenant, setNewTenant] = useState({ full_name: "", email: "", phone: "", is_owner: false });
  const [statusUpdating, setStatusUpdating] = useState(false);
  const supabase = createClient();

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const [unitRes, buildingRes, tenantsRes] = await Promise.all([
        supabase.from("estate_units").select("*").eq("id", unitId).single(),
        supabase.from("estate_buildings").select("name").eq("id", buildingId).single(),
        supabase.from("estate_tenants").select("*").eq("unit_id", unitId).order("created_at"),
      ]);
      if (cancelled) return;
      setUnit(unitRes.data as UnitData);
      setBuilding(buildingRes.data as BuildingInfo);
      setTenants((tenantsRes.data as Tenant[]) ?? []);
      setLoading(false);
    }
    load();
    return () => { cancelled = true; };
  }, [unitId, buildingId]); // eslint-disable-line react-hooks/exhaustive-deps

  async function changeStatus(status: string) {
    setStatusUpdating(true);
    await supabase.from("estate_units").update({ status }).eq("id", unitId);
    setUnit((prev) => prev ? { ...prev, status: status as UnitData["status"] } : prev);
    setStatusUpdating(false);
  }

  async function addTenant() {
    if (!newTenant.full_name.trim()) return;
    const { data } = await supabase
      .from("estate_tenants")
      .insert({
        unit_id: unitId,
        full_name: newTenant.full_name.trim(),
        email: newTenant.email.trim() || null,
        phone: newTenant.phone.trim() || null,
        is_owner: newTenant.is_owner,
        is_primary: tenants.length === 0,
      })
      .select()
      .single();
    if (data) {
      setTenants((prev) => [...prev, data as Tenant]);
      setNewTenant({ full_name: "", email: "", phone: "", is_owner: false });
      setShowAddTenant(false);
    }
  }

  async function removeTenant(tenantId: string) {
    await supabase.from("estate_tenants").delete().eq("id", tenantId);
    setTenants((prev) => prev.filter((t) => t.id !== tenantId));
  }

  const currentStatus = STATUS_OPTIONS.find((s) => s.value === unit?.status) ?? STATUS_OPTIONS[0];

  if (loading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 w-48 bg-white/50 rounded-lg" />
        <div className="h-48 bg-white rounded-2xl shadow-[var(--shadow-card)]" />
      </div>
    );
  }

  if (!unit) {
    return (
      <div className="text-center text-[#9AA7B8] py-12">
        Nie znaleziono lokalu
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Breadcrumbs */}
      <div className="flex items-center gap-2 text-xs text-[#9AA7B8]">
        <Link href="/estates" className="hover:text-ink transition-colors">Osiedla</Link>
        <span>/</span>
        <Link href={`/estates/${estateId}`} className="hover:text-ink transition-colors">
          {(building?.name) ?? "..."}
        </Link>
        <span>/</span>
        <span className="text-ink font-medium">Lokal {unit.unit_number}</span>
      </div>

      {/* Unit info card */}
      <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-6 space-y-5">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="font-heading font-bold text-xl text-ink">
              Lokal {unit.unit_number}
            </h1>
            <p className="text-sm text-[#9AA7B8] mt-0.5">
              {building?.name}
              {unit.floor !== null && ` · Piętro ${unit.floor}`}
            </p>
          </div>
          <span className={`text-[13px] font-semibold px-3 py-1.5 rounded-full ${currentStatus.color} bg-current/10`}>
            {currentStatus.label}
          </span>
        </div>

        <div className="grid grid-cols-3 gap-6 py-4 border-t border-[#F4F7FB]">
          <div>
            <div className="text-[11px] font-semibold uppercase tracking-[.4px] text-[#9AA7B8] mb-1">Powierzchnia</div>
            <div className="text-[15px] font-semibold text-ink">{unit.area_sqm ? `${unit.area_sqm} m²` : "—"}</div>
          </div>
          <div>
            <div className="text-[11px] font-semibold uppercase tracking-[.4px] text-[#9AA7B8] mb-1">Pokoje</div>
            <div className="text-[15px] font-semibold text-ink">
              {unit.rooms ? `${unit.rooms} ${unit.rooms === 1 ? "pokój" : unit.rooms < 5 ? "pokoje" : "pokoi"}` : "—"}
            </div>
          </div>
          <div>
            <div className="text-[11px] font-semibold uppercase tracking-[.4px] text-[#9AA7B8] mb-1">Status</div>
            <select
              value={unit.status}
              onChange={(e) => changeStatus(e.target.value)}
              disabled={statusUpdating}
              className="text-[13px] font-semibold bg-[#F4F7FB] border-none rounded-lg px-3 py-1.5 text-ink outline-none cursor-pointer"
            >
              {STATUS_OPTIONS.map((opt) => (
                <option key={opt.value} value={opt.value}>{opt.label}</option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Residents */}
      <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-heading font-semibold text-[16px] text-ink">Mieszkańcy</h2>
          <button
            onClick={() => setShowAddTenant(true)}
            className="flex items-center gap-1.5 text-[12px] font-semibold text-azure hover:text-azure-dark transition-colors"
          >
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round">
              <path d="M12 6v12M6 12h12" />
            </svg>
            Dodaj mieszkańca
          </button>
        </div>

        {/* Add tenant form */}
        {showAddTenant && (
          <div className="bg-[#F4F7FB] rounded-xl p-4 mb-4 space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <input
                value={newTenant.full_name}
                onChange={(e) => setNewTenant((p) => ({ ...p, full_name: e.target.value }))}
                placeholder="Imię i nazwisko *"
                className="col-span-2 px-4 py-2.5 bg-white border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
                autoFocus
              />
              <input
                value={newTenant.email}
                onChange={(e) => setNewTenant((p) => ({ ...p, email: e.target.value }))}
                placeholder="Email"
                className="px-4 py-2.5 bg-white border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
              />
              <input
                value={newTenant.phone}
                onChange={(e) => setNewTenant((p) => ({ ...p, phone: e.target.value }))}
                placeholder="Telefon"
                className="px-4 py-2.5 bg-white border-none rounded-xl text-[13px] text-ink placeholder-[#9AA7B8] outline-none"
              />
            </div>
            <label className="flex items-center gap-2 text-[13px] text-ink cursor-pointer">
              <input
                type="checkbox"
                checked={newTenant.is_owner}
                onChange={(e) => setNewTenant((p) => ({ ...p, is_owner: e.target.checked }))}
                className="w-4 h-4 rounded border-[#D0D7E0] text-azure"
              />
              Właściciel
            </label>
            <div className="flex gap-2">
              <button
                onClick={addTenant}
                className="px-4 py-2 bg-success text-white text-[12px] font-semibold rounded-xl hover:opacity-90 transition-opacity"
              >
                Dodaj
              </button>
              <button
                onClick={() => { setShowAddTenant(false); setNewTenant({ full_name: "", email: "", phone: "", is_owner: false }); }}
                className="px-4 py-2 text-[12px] text-[#9AA7B8] hover:text-ink transition-colors"
              >
                Anuluj
              </button>
            </div>
          </div>
        )}

        {tenants.length === 0 ? (
          <div className="text-center py-8 text-[#9AA7B8] text-[13px]">
            <p>Brak mieszkańców przypisanych do tego lokalu</p>
          </div>
        ) : (
          <div className="divide-y divide-[#F4F7FB]">
            {tenants.map((tenant) => (
              <div key={tenant.id} className="flex items-center justify-between py-3">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-full bg-gradient-to-br from-azure/10 to-blueprint/10 flex items-center justify-center text-[12px] font-semibold text-azure shrink-0">
                    {tenant.full_name.charAt(0).toUpperCase()}
                  </div>
                  <div>
                    <div className="text-[14px] font-medium text-ink flex items-center gap-2">
                      {tenant.full_name}
                      {tenant.is_primary && (
                        <span className="text-[10px] px-1.5 py-0.5 rounded bg-azure/10 text-azure font-semibold">
                          GŁÓWNY
                        </span>
                      )}
                      {tenant.is_owner && (
                        <span className="text-[10px] px-1.5 py-0.5 rounded bg-success/10 text-success font-semibold">
                          WŁAŚCICIEL
                        </span>
                      )}
                    </div>
                    <div className="text-[12px] text-[#9AA7B8]">
                      {[tenant.email, tenant.phone].filter(Boolean).join(" · ") || "—"}
                    </div>
                  </div>
                </div>
                <button
                  onClick={() => removeTenant(tenant.id)}
                  className="text-[#9AA7B8] hover:text-danger transition-colors p-1"
                  title="Usuń mieszkańca"
                >
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2" />
                  </svg>
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

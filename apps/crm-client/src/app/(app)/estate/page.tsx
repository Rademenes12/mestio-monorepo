import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import {
  AddBuildingModal,
  AddStairwellModal,
  DeleteBuildingButton,
  DeleteStairwellButton,
} from "./manage-modals";
import { MaintenanceList, AddMaintenanceModal } from "./maintenance";
import { BuildingVisualization } from "./visualization";

export default async function EstatePage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const { data: estates } = await supabase
    .from("fixflow_estates")
    .select("id, name")
    .eq("id", estateId)
    .eq("status", "active");

  const { data: buildings } = await supabase
    .from("fixflow_buildings")
    .select("*")
    .eq("estate_id", estateId)
    .order("display_order");

  const buildingIds = (buildings ?? []).map((b) => b.id);
  const { data: stairwells } = buildingIds.length > 0
    ? await supabase
        .from("fixflow_stairwells")
        .select("*")
        .in("building_id", buildingIds)
        .order("display_order")
    : { data: [] };

  const { data: maintenanceTasks } = await supabase
    .from("fixflow_tasks")
    .select("id, title, recurrence_interval, recurrence_unit, recurrence_end_date")
    .eq("estate_id", estateId)
    .eq("kind", "maintenance")
    .order("created_at", { ascending: false });

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-heading font-bold text-ink">
          Osiedle
        </h1>
        <AddBuildingModal estateId={estateId} />
      </div>

      {estates && estates.length > 0 ? (
        <div className="space-y-6">
          {estates.map((estate) => {
            const estateBuildings =
              buildings?.filter((b) => b.estate_id === estate.id) ?? [];

            return (
              <div key={estate.id} className="space-y-4">
                <h2 className="text-lg font-heading font-semibold text-ink">
                  {estate.name}
                </h2>

                {estateBuildings.length === 0 ? (
                  <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
                    <p className="text-sm text-ink/30">
                      Brak budynków — dodaj pierwszy w SQL Editor lub przez
                      aplikację
                    </p>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {estateBuildings.map((building) => {
                      const buildingStairwells =
                        stairwells?.filter(
                          (s) => s.building_id === building.id
                        ) ?? [];

                      return (
                        <div
                          key={building.id}
                          className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] overflow-hidden"
                        >
                          <div className="px-6 py-4 bg-ink/3 flex items-center gap-3">
                            <span className="text-lg">
                              {building.building_type === "garage"
                                ? "🚗"
                                : "🏢"}
                            </span>
                            <div>
                              <h3 className="font-heading font-semibold text-ink">
                                {building.name}
                              </h3>
                              <p className="text-xs text-ink/40">
                                {building.building_type === "garage"
                                  ? "Garaż"
                                  : "Budynek mieszkalny"}
                                {building.address &&
                                  ` — ${building.address}`}
                              </p>
                            </div>
                            <DeleteBuildingButton buildingId={building.id} />
                          </div>

                          <div className="p-6 grid grid-cols-[1fr_168px] gap-4">
                            <div>
                              {buildingStairwells.length === 0 ? (
                                <p className="text-sm text-ink/30 pl-8">
                                  Brak klatek
                                </p>
                              ) : (
                                <div className="space-y-3">
                                  {buildingStairwells.map((sw) => {
                                    const floors: number[] = [];
                                    for (
                                      let f = sw.floor_min;
                                      f <= sw.floor_max;
                                      f++
                                    ) {
                                      floors.push(f);
                                    }

                                    return (
                                      <div key={sw.id} className="pl-4">
                                        <div className="flex items-center gap-2 mb-2">
                                          <span className="text-sm font-medium text-ink/70">
                                            {sw.name}
                                          </span>
                                          <span className="text-xs text-ink/30 font-mono">
                                            P{sw.floor_min}–P{sw.floor_max}
                                          </span>
                                          <DeleteStairwellButton
                                            stairwellId={sw.id}
                                          />
                                        </div>

                                        <div className="flex flex-wrap gap-1.5 pl-6">
                                          {floors.slice(0, 20).map((f) => (
                                            <span
                                              key={f}
                                              className={`px-2 py-1 rounded-lg text-[10px] font-mono ${
                                                f === 0
                                                  ? "bg-azure/10 text-azure"
                                                  : f < 0
                                                    ? "bg-amber/10 text-amber"
                                                    : "bg-paper text-ink/40"
                                              }`}
                                            >
                                              {f === 0
                                                ? "P0"
                                                : f < 0
                                                  ? `G${Math.abs(f)}`
                                                  : `P${f}`}
                                            </span>
                                          ))}
                                          {floors.length > 20 && (
                                            <span className="text-[10px] text-ink/20">
                                              +{floors.length - 20}
                                            </span>
                                          )}
                                        </div>
                                      </div>
                                    );
                                  })}
                                </div>
                              )}
                              <div className="mt-4 pt-4 border-t border-ink/5">
                                <AddStairwellModal buildingId={building.id} />
                              </div>
                            </div>
                            <BuildingVisualization
                              buildingType={building.building_type}
                              stairwells={buildingStairwells}
                            />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      ) : (
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50 text-sm">
            Brak osiedli — skontaktuj się z administratorem systemu
          </p>
        </div>
      )}

      <div className="flex items-center justify-between mt-8 mb-3">
        <h2 className="text-[10px] font-mono uppercase tracking-wide text-ink/40">
          Konserwacja prewencyjna — zadania cykliczne
        </h2>
        <AddMaintenanceModal estateId={estateId} />
      </div>
      <MaintenanceList tasks={maintenanceTasks ?? []} />

      <div className="mt-4 flex items-start gap-2.5 bg-azure/[.06] border border-azure/20 rounded-[13px] px-3.5 py-3">
        <svg
          className="w-4 h-4 text-azure shrink-0 mt-0.5"
          fill="none"
          stroke="currentColor"
          strokeWidth={1.9}
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="M12 16v-4M12 8h.01" />
          <circle cx="12" cy="12" r="9" />
        </svg>
        <p className="text-[12.5px] leading-relaxed text-ink/70">
          Strukturę budujesz tutaj. Mieszkaniec podczas rejestracji w
          aplikacji wybiera z niej blok, klatkę i piętro (także garaż do -4).
        </p>
      </div>
    </div>
  );
}

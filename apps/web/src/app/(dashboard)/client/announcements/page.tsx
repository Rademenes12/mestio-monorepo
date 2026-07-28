import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import type { DbAnnouncement } from "@/lib/types";
import { CreateAnnouncementModal } from "./create-modal";

export default async function AnnouncementsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const estateIds = [estateId];

  const { data: announcements } = await supabase
    .from("fixflow_announcements")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false })
    .limit(50);

  const { data: buildings } = await supabase
    .from("fixflow_buildings")
    .select("id, name, estate_id")
    .eq("estate_id", estateId);

  const bldIds = (buildings ?? []).map((b) => b.id);
  const { data: stairwells } = bldIds.length > 0
    ? await supabase
        .from("fixflow_stairwells")
        .select("id, name, building_id")
        .in("building_id", bldIds)
    : { data: [] };

  const alist = announcements ?? [];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">
            Komunikaty
          </h1>
          <p className="text-sm text-ink/50 mt-1">
            {alist.length} ogłoszeń
          </p>
        </div>
        <CreateAnnouncementModal
          buildings={buildings ?? []}
          stairwells={stairwells ?? []}
          estateIds={estateIds}
          userId={user.id}
          userName={user.email ?? "Zarząd"}
        />
      </div>

      {alist.length === 0 ? (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
          <p className="text-ink/50 text-sm">Brak ogłoszeń</p>
        </div>
      ) : (
        <div className="grid gap-4">
          {(alist as DbAnnouncement[]).map((a) => (
            <div
              key={a.id}
              className={`bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6 ${
                !a.is_active ? "opacity-60" : ""
              }`}
            >
              <div className="flex items-center gap-3 mb-3">
                <h3 className="font-heading font-semibold text-ink">
                  {a.title}
                </h3>
                {!a.is_active && (
                  <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-amber-50 text-amber-600">
                    Nieaktywne
                  </span>
                )}
                {a.scope_type && a.scope_type !== "estate" && (
                  <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-azure/10 text-azure">
                    {a.scope_type === "building" ? "Budynek" : "Klatka"}
                  </span>
                )}
              </div>
              <p className="text-sm text-ink/70 whitespace-pre-wrap line-clamp-3">
                {a.content}
              </p>
              <div className="flex items-center gap-3 mt-3 text-xs text-ink/30">
                <span>{a.author_name ?? "Zarząd"}</span>
                <span>·</span>
                <span className="font-mono">
                  {new Date(a.created_at).toLocaleDateString("pl-PL")}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

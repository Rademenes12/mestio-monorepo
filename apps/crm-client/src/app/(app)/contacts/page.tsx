import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";

export default async function ContactsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, role, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const isAdmin = role === "admin";

  const { data: rodoEstate } = await supabase
    .from("fixflow_estates")
    .select("hide_resident_contacts")
    .eq("id", estateId)
    .maybeSingle();

  const rodoActive = !isAdmin && rodoEstate?.hide_resident_contacts === true;

  const { data: estateMembers } = await supabase
    .from("fixflow_user_estates")
    .select("user_id")
    .eq("estate_id", estateId);

  const residentIds = [...new Set((estateMembers ?? []).map((m) => m.user_id))];

  const { data: residents } = residentIds.length > 0
    ? await supabase
        .from("fixflow_resident_profiles")
        .select("*")
        .in("id", residentIds)
        .order("name", { ascending: true })
        .limit(200)
    : { data: null };

  const rlist = residents ?? [];

  const maskText = rodoActive
    ? () => "ukryte (RODO)"
    : (v: string | null) => v || "Brak danych kontaktowych";

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">
            Kontakty
          </h1>
          <p className="text-sm text-ink/50 mt-1">
            {rlist.length} mieszkańców
          </p>
        </div>
      </div>

      <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] overflow-hidden">
        {rlist.length === 0 ? (
          <div className="p-12 text-center">
            <p className="text-ink/50 text-sm">Brak mieszkańców w bazie</p>
            <p className="text-ink/35 text-[12.5px] mt-1">
              Mieszkańcy pojawią się tutaj, gdy dołączą do osiedla przez kod zaproszenia.
            </p>
          </div>
        ) : (
          <div className="divide-y divide-ink/5">
            {rlist.map((r) => (
              <Link
                key={r.id}
                href={`/contacts/${r.id}`}
                className="flex items-center gap-4 px-6 py-4 hover:bg-paper/50 transition-colors min-h-[64px]"
              >
                <div className="w-11 h-11 rounded-full bg-azure/10 flex items-center justify-center shrink-0">
                  <span className="text-[15px] font-semibold text-azure">
                    {(r.name ?? "?")[0].toUpperCase()}
                  </span>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-ink">
                    {r.name ?? "Bez nazwy"}
                  </p>
                  <p
                    className={`text-[12.5px] truncate mt-0.5 ${
                      rodoActive ? "text-ink/35 italic" : "text-ink/45"
                    }`}
                  >
                    {maskText(r.email || r.phone || null)}
                  </p>
                </div>
                <div className="text-right text-[12.5px] text-ink/40">
                  {r.building && (
                    <span>
                      {r.building}
                      {r.apartment ? ` m.${r.apartment}` : ""}
                    </span>
                  )}
                </div>
                <span className="text-[11px] font-semibold px-2.5 py-1 rounded-full bg-paper text-ink/55">
                  {r.role}
                </span>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

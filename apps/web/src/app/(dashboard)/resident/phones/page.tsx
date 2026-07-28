import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";

interface PhoneContact {
  id: string;
  name: string;
  role: string;
  phone: string;
  email: string | null;
  category: string;
  is_active: boolean;
}

const CATEGORIES: Record<string, string> = {
  administration: "Administracja",
  emergency: "Alarmowe",
  maintenance: "Serwis",
};

export default async function ResidentPhonesPage() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/phones");
  const { supabase, estateId } = ctx;

  if (!estateId) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">Numery alarmowe</h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz przypisanego osiedla.</p>
        </div>
      </div>
    );
  }

  const { data: contacts } = await supabase
    .from("fixflow_emergency_contacts")
    .select("*")
    .eq("estate_id", estateId)
    .eq("is_active", true)
    .order("display_order");

  const clist = (contacts ?? []) as PhoneContact[];

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-heading font-bold text-ink">Numery alarmowe</h1>
        <p className="text-sm text-ink/50 mt-1">
          Ważne kontakty dla Twojego osiedla
        </p>
      </div>

      {clist.length === 0 ? (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Brak kontaktów dla tego osiedla.</p>
        </div>
      ) : (
        <div className="space-y-6">
          {Object.entries(CATEGORIES).map(([catKey, catLabel]) => {
            const catContacts = clist.filter((c) => c.category === catKey);
            if (catContacts.length === 0) return null;

            return (
              <div key={catKey}>
                <h2 className="text-sm font-medium text-ink/40 mb-3">{catLabel}</h2>
                <div className="space-y-2">
                  {catContacts.map((c) => (
                    <div
                      key={c.id}
                      className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-4 flex items-center gap-4"
                    >
                      <div
                        className="w-10 h-10 rounded-full flex items-center justify-center shrink-0"
                        style={{
                          backgroundColor: catKey === "emergency" ? "#C0392B15" : "#3E7BD615",
                        }}
                      >
                        <span
                          className="text-sm font-semibold"
                          style={{ color: catKey === "emergency" ? "#C0392B" : "#3E7BD6" }}
                        >
                          {c.name[0]}
                        </span>
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-[13.5px] font-medium text-ink">{c.name}</p>
                        <p className="text-[12px] text-ink/40">{c.role}</p>
                      </div>
                      <div className="text-right space-y-0.5 shrink-0">
                        {c.phone && (
                          <a
                            href={`tel:${c.phone}`}
                            className="block text-[13px] font-mono text-azure hover:underline font-medium"
                          >
                            {c.phone}
                          </a>
                        )}
                        {c.email && (
                          <a
                            href={`mailto:${c.email}`}
                            className="block text-[11px] text-ink/50 hover:text-azure"
                          >
                            {c.email}
                          </a>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

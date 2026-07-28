import { createClient } from "@/lib/supabase/server";
import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { AddPhoneModal } from "./create-modal";
import { revalidatePath } from "next/cache";

interface PhoneContact {
  id: string;
  name: string;
  role: string;
  phone: string;
  email: string | null;
  category: string;
  is_active: boolean;
}

export default async function PhonesPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const { data: contacts } = await supabase
    .from("fixflow_emergency_contacts")
    .select("*")
    .eq("estate_id", estateId)
    .order("display_order");

  const clist = contacts ?? [];

  const categories: Record<string, string> = {
    administration: "Administracja",
    emergency: "Alarmowe",
    maintenance: "Serwis",
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-heading font-bold text-ink">Telefony</h1>
        <AddPhoneModal estateId={estateId} />
      </div>

      {clist.length === 0 ? (
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50 text-sm">Brak kontaktów</p>
        </div>
      ) : (
        <div className="space-y-4">
          {Object.entries(categories).map(([catKey, catLabel]) => {
            const catContacts = (clist as PhoneContact[]).filter(
              (c) => c.category === catKey && c.is_active
            );
            if (catContacts.length === 0) return null;

            return (
              <div key={catKey}>
                <h2 className="text-sm font-medium text-ink/40 mb-3">
                  {catLabel}
                </h2>
                <div className="space-y-2">
                  {catContacts.map((c) => (
                    <div
                      key={c.id}
                      className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5 flex items-center gap-4"
                    >
                      <div className="w-10 h-10 rounded-full bg-azure/10 flex items-center justify-center shrink-0">
                        <span className="text-sm font-medium text-azure">
                          {(c.name ?? "?")[0]}
                        </span>
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-ink">
                          {c.name}
                        </p>
                        <p className="text-xs text-ink/40">{c.role}</p>
                      </div>
                      <div className="text-right text-sm space-y-0.5">
                        {c.phone && (
                          <a
                            href={`tel:${c.phone}`}
                            className="block text-azure hover:underline font-mono"
                          >
                            {c.phone}
                          </a>
                        )}
                        {c.email && (
                          <a
                            href={`mailto:${c.email}`}
                            className="block text-xs text-ink/50 hover:text-azure"
                          >
                            {c.email}
                          </a>
                        )}
                      </div>
                      <form
                        action={async () => {
                          "use server";
                          const supabase = await createClient();
                          const { error } = await supabase
                            .from("fixflow_emergency_contacts")
                            .delete()
                            .eq("id", c.id);
                          if (error) return;
                          revalidatePath("/phones");
                        }}
                      >
                        <button className="text-[10px] text-red-400 hover:text-red-600 transition-colors ml-4">
                          Usuń
                        </button>
                      </form>
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

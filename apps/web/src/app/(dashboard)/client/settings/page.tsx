import { createClient } from "@/lib/supabase/server";
import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { RodoToggle } from "./rodo-toggle";
import { InviteCodes } from "./invite-codes";
import { JoinRequests } from "./join-requests";
import { ContractForm } from "./contract-form";
import { ClientDocuments } from "./client-documents";
import { ClientInvoices } from "./client-invoices";

export default async function SettingsPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, role, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const isAdmin = role === "admin";
  const estateIds = [estateId];

  const { data: estates } = await supabase
    .from("fixflow_estates")
    .select("*")
    .eq("id", estateId)
    .eq("status", "active");

  const { data: inviteCodes } = await supabase
    .from("fixflow_invitation_codes")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const { data: joinRequests } = await supabase
    .from("fixflow_join_requests")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const { data: documents } = await supabase
    .from("fixflow_client_documents")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const { data: invoices } = await supabase
    .from("fixflow_client_invoices")
    .select("*")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false });

  const activeEstate = estates?.[0];

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-heading font-bold text-ink">
        Ustawienia
      </h1>

      {activeEstate && (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
          <h2 className="font-heading font-semibold text-ink mb-4">
            Dane osiedla
          </h2>
          <form
            action={async (formData: FormData) => {
              "use server";
              const supabase = await createClient();
              const { error } = await supabase
                .from("fixflow_estates")
                .update({
                  name: formData.get("name") as string,
                  address: formData.get("address") as string || null,
                  company_name: formData.get("company_name") as string || null,
                  admin_name: formData.get("admin_name") as string || null,
                  admin_email: formData.get("admin_email") as string || null,
                  admin_phone: formData.get("admin_phone") as string || null,
                })
                .eq("id", activeEstate.id);
              if (error) return;
              revalidatePath("/settings");
            }}
            className="space-y-4"
          >
            <div className="grid grid-cols-2 gap-4">
              <div>
                <span className="text-xs text-ink/40">Nazwa osiedla</span>
                <input
                  name="name"
                  defaultValue={activeEstate.name}
                  className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                />
              </div>
              <div>
                <span className="text-xs text-ink/40">Adres</span>
                <input
                  name="address"
                  defaultValue={activeEstate.address ?? ""}
                  className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                />
              </div>
              <div>
                <span className="text-xs text-ink/40">
                  Nazwa firmy (widoczna w aplikacji)
                </span>
                <input
                  name="company_name"
                  defaultValue={activeEstate.company_name ?? ""}
                  className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                />
              </div>
              <div>
                <span className="text-xs text-ink/40">Status</span>
                <p className="text-status-closed font-medium mt-1">
                  {activeEstate.status === "active" ? "Aktywne" : activeEstate.status}
                </p>
              </div>
            </div>

            <div className="pt-2 border-t border-ink/5">
              <p className="text-xs text-ink/40 mb-3 uppercase tracking-wide font-mono text-[10px]">
                Administrator
              </p>
              <div className="grid grid-cols-3 gap-4">
                <div>
                  <span className="text-xs text-ink/40">Imię i nazwisko</span>
                  <input
                    name="admin_name"
                    defaultValue={activeEstate.admin_name ?? ""}
                    className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  />
                </div>
                <div>
                  <span className="text-xs text-ink/40">E-mail</span>
                  <input
                    name="admin_email"
                    type="email"
                    defaultValue={activeEstate.admin_email ?? ""}
                    className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  />
                </div>
                <div>
                  <span className="text-xs text-ink/40">Telefon</span>
                  <input
                    name="admin_phone"
                    defaultValue={activeEstate.admin_phone ?? ""}
                    className="w-full mt-1 px-3 py-1.5 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  />
                </div>
              </div>
            </div>

            <div className="flex justify-end">
              <button className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors">
                Zapisz
              </button>
            </div>
          </form>
        </div>
      )}

      <ContractForm
        estateId={activeEstate?.id ?? ""}
        contractUntil={activeEstate?.contract_until ?? null}
      />

      <RodoToggle
        estateId={activeEstate?.id ?? ""}
        currentValue={activeEstate?.hide_resident_contacts ?? false}
        isAdmin={isAdmin}
      />

      <InviteCodes
        codes={inviteCodes ?? []}
        estateIds={estateIds}
        isAdmin={isAdmin}
      />

      <JoinRequests
        requests={joinRequests ?? []}
        estateIds={estateIds}
      />

      <ClientDocuments documents={documents ?? []} />

      <ClientInvoices invoices={invoices ?? []} />
    </div>
  );
}

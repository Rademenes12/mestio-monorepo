import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";
import type { Invoice } from "@/lib/types";

const STATUS_LABELS: Record<string, string> = {
  issued: "Wystawiona",
  paid: "Opłacona",
  cancelled: "Anulowana",
};

const STATUS_COLORS: Record<string, string> = {
  issued: "#F2A900",
  paid: "#2E9E6B",
  cancelled: "#6B7A90",
};

function formatGrosze(gross: number | null): string {
  if (gross === null) return "—";
  return `${(gross / 100).toFixed(2)} PLN`;
}

export default async function InvoicesPage() {
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user } = ctx;

  const { data: invoices } = await supabase
    .from("fixflow_invoices")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  const { data: pendingTransfer } = await supabase
    .from("fixflow_transfer_payments")
    .select("*")
    .eq("user_id", user.id)
    .eq("status", "pending")
    .maybeSingle();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-heading font-bold text-ink">Faktury VAT</h1>
        <p className="text-sm text-ink/50 mt-1">
          Faktury za subskrypcję Mestio
        </p>
      </div>

      {pendingTransfer && (
        <div className="bg-amber/10 border border-amber/30 rounded-[22px] p-5">
          <div className="flex items-start gap-3">
            <span className="text-xl mt-0.5">⏳</span>
            <div>
              <p className="text-sm font-semibold text-ink">
                Płatność przelewem jest weryfikowana
              </p>
              <p className="text-xs text-ink/50 mt-1">
                Twój przelew o kwocie {(pendingTransfer.amount / 100).toFixed(2)} PLN
                (tytuł: {pendingTransfer.transfer_title}) został odnotowany.
                Środki zostaną zweryfikowane w ciągu 48h.
              </p>
            </div>
          </div>
        </div>
      )}

      <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
        {!invoices || invoices.length === 0 ? (
          <p className="text-sm text-ink/30">Brak faktur.</p>
        ) : (
          <div className="flex flex-col gap-2">
            {(invoices as Invoice[]).map((f) => {
              const color = STATUS_COLORS[f.status] ?? "#6B7A90";
              const label = STATUS_LABELS[f.status] ?? f.status;
              return (
                <Link
                  key={f.id}
                  href={`/invoices/${f.id}`}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-xl bg-paper hover:bg-paper/80 transition-colors"
                >
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-mono font-semibold text-[#173A6A]">
                      {f.invoice_number}
                    </p>
                    <p className="text-[11px] text-ink/40 mt-0.5">
                      {f.plan_name ?? "—"}
                      {f.amount_gross !== null ? ` · ${formatGrosze(f.amount_gross)}` : ""}
                    </p>
                  </div>
                  <span
                    className="text-[9.5px] font-semibold px-2 py-0.5 rounded-full shrink-0"
                    style={{ backgroundColor: color + "20", color }}
                  >
                    {label}
                  </span>
                  <span className="text-[10.5px] font-mono text-ink/30 shrink-0">
                    {new Date(f.created_at).toLocaleDateString("pl-PL")}
                  </span>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

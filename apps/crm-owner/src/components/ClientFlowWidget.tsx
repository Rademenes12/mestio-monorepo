import { createClient } from "@/lib/supabase/server";

function formatPLN(val: number): string {
  return val.toLocaleString("pl-PL") + " zł";
}

export default async function ClientFlowWidget() {
  const supabase = await createClient();

  const { data: leads } = await supabase
    .from("crm_leads")
    .select("id, company_name, contact_name, mrr, stage")
    .eq("stage", "active")
    .order("created_at", { ascending: false })
    .limit(5);

  if (!leads?.length) {
    return (
      <div className="bg-white rounded-[14px] p-5 border border-[#E9EFF6] text-center text-ink/30 text-[13px]">
        Brak aktywnych klientów. Gdy zdobędziesz pierwszych, zobaczysz tu flow: Klient → Faktury → Płatności
      </div>
    );
  }

  const leadIds = leads.map((l) => l.id);

  const { data: invoices } = await supabase
    .from("crm_invoices")
    .select("id, lead_id, amount, status, number")
    .in("lead_id", leadIds)
    .order("created_at", { ascending: false });

  const flows = leads.map((lead) => {
    const leadInvoices = ((invoices as any[]) || []).filter((inv: any) => inv.lead_id === lead.id);
    const paidTotal = leadInvoices.filter((i: any) => i.status === "paid").reduce((s: number, i: any) => s + (i.amount || 0), 0);
    const pendingCount = leadInvoices.filter((i: any) => i.status !== "paid").length;

    return {
      client: (lead as any).company_name,
      contact: (lead as any).contact_name,
      mrr: (lead as any).mrr || 0,
      invoiceCount: leadInvoices.length,
      paidTotal,
      pendingCount,
    };
  });

  return (
    <div className="bg-white rounded-[14px] p-5 border border-[#E9EFF6]">
      <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink mb-4">
        Flow: Klient → Faktury → Płatności
      </h3>
      <div className="space-y-3">
        {flows.map((flow, i) => (
          <div
            key={i}
            className="flex items-center gap-4 py-2.5 px-3 rounded-[10px] hover:bg-[#F4F7FB] transition-colors"
          >
            <div className="flex-shrink-0 w-[120px]">
              <p className="text-[13px] font-semibold text-ink truncate">{flow.client}</p>
              <p className="text-[11px] text-[#8A98AB]">{flow.contact ?? "—"}</p>
            </div>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round">
              <path d="M5 12h14M13 6l6 6-6 6" />
            </svg>
            <div className="flex-shrink-0 text-center w-[80px]">
              <p className="text-[13px] font-bold text-ink">{flow.invoiceCount}</p>
              <p className="text-[10px] text-[#8A98AB]">faktur</p>
            </div>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" strokeWidth="2" strokeLinecap="round">
              <path d="M5 12h14M13 6l6 6-6 6" />
            </svg>
            <div className="flex-shrink-0 text-center w-[100px]">
              <p className="text-[13px] font-bold" style={{ color: flow.pendingCount > 0 ? "#C0392B" : "#2E9E6B" }}>
                {formatPLN(flow.paidTotal)}
              </p>
              <p className="text-[10px] text-[#8A98AB]">
                {flow.pendingCount > 0 ? `${flow.pendingCount} nieopłaconych` : "wszystko opłacone"}
              </p>
            </div>
            <div className="flex-1 ml-2">
              <div className="flex items-center gap-1.5">
                <div
                  className="h-1.5 rounded-full flex-1"
                  style={{
                    background: flow.invoiceCount === 0
                      ? "#E2E8F0"
                      : `linear-gradient(to right, #2E9E6B ${flow.pendingCount === 0 ? 100 : (flow.paidTotal / (flow.mrr * 6)) * 100}%, #E2E8F0 0%)`,
                  }}
                />
                <span className="text-[10px] text-[#8A98AB] font-medium">MRR: {formatPLN(flow.mrr)}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

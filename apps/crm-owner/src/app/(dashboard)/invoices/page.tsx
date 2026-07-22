"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { CrmInvoice, InvoiceLineItem } from "@/lib/types";
import { getSellerSettings, calcTotals, invoiceText, createInvoice, SellerSettings, DEFAULT_SELLER } from "@/lib/invoices";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${a})`;
}

const STATUS_META: Record<string, { label: string; color: string }> = {
  paid: { label: "Opłacona", color: "#2E9E6B" },
  overdue: { label: "Zaległa", color: "#C0392B" },
  issued: { label: "Wystawiona", color: "#F2A900" },
};

const KSEF_META: Record<string, { label: string; color: string }> = {
  confirmed: { label: "Potwierdzona", color: "#2E9E6B" },
  sent: { label: "Wysłana", color: "#F2A900" },
  pending: { label: "Oczekuje", color: "#6B7A90" },
  error: { label: "Błąd", color: "#C0392B" },
};

interface LeadLite {
  id: string;
  company_name: string;
  contact_email: string | null;
  nip: string | null;
  mrr: number;
  plan: string | null;
}

interface CrmInvoiceWithClient extends CrmInvoice {
  crm_leads?: { company_name: string; nip: string | null; contact_email: string | null } | null;
}

const money = (v: number) =>
  v.toLocaleString("pl-PL", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

const EMPTY_ITEM: InvoiceLineItem = { name: "", qty: 1, net: 0, vat: 23 };

interface FixflowInvoice {
  id: string;
  invoice_number: string;
  user_id: string;
  plan_name: string | null;
  amount_net: number;
  amount_vat: number;
  amount_gross: number;
  html_content: string | null;
  created_at: string;
}

const grossMoney = (v: number) =>
  (v / 100).toLocaleString("pl-PL", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

export default function InvoicesPage() {
  const [invoices, setInvoices] = useState<CrmInvoiceWithClient[]>([]);
  const [fixflowInvoices, setFixflowInvoices] = useState<FixflowInvoice[]>([]);
  const [leads, setLeads] = useState<LeadLite[]>([]);
  const [seller, setSeller] = useState<SellerSettings>(DEFAULT_SELLER);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState<"all" | "issued" | "paid" | "overdue">("all");
  const [mode, setMode] = useState<"crm" | "fixflow">("crm");
  const [wizardOpen, setWizardOpen] = useState(false);
  const [wizClient, setWizClient] = useState("");
  const [wizItems, setWizItems] = useState<InvoiceLineItem[]>([{ ...EMPTY_ITEM }]);
  const [wizDue, setWizDue] = useState("");
  const [wizPreview, setWizPreview] = useState(false);
  const [saving, setSaving] = useState(false);
  const [detail, setDetail] = useState<CrmInvoiceWithClient | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2600);
  };

  const fetchAll = async () => {
    setLoading(true);

    // Auto-status: wystawione po terminie -> zaległe. To jest też odświeżane
    // przez silnik automatyzacji na Pulpicie (lib/automations.ts), więc status
    // nie zależy wyłącznie od wizyty na tej stronie (audyt bezpieczeństwa 09.07).
    const today = new Date().toISOString().slice(0, 10);
    await supabase
      .from("crm_invoices")
      .update({ status: "overdue" })
      .eq("status", "issued")
      .lt("due_date", today);

    let query = supabase
      .from("crm_invoices")
      .select("*, crm_leads(company_name, nip, contact_email)")
      .order("issued_at", { ascending: false });
    if (statusFilter !== "all") query = query.eq("status", statusFilter);

    const [invRes, leadsRes, sellerData] = await Promise.all([
      query,
      supabase.from("crm_leads").select("id, company_name, contact_email, nip, mrr, plan").order("company_name"),
      getSellerSettings(supabase),
    ]);

    setInvoices((invRes.data as CrmInvoiceWithClient[]) ?? []);
    setLeads((leadsRes.data as LeadLite[]) ?? []);
    setSeller(sellerData);

    const { data: fxInvoices } = await supabase
      .from("fixflow_invoices")
      .select("*")
      .order("created_at", { ascending: false });
    setFixflowInvoices((fxInvoices as FixflowInvoice[]) ?? []);

    setLoading(false);
  };

  useEffect(() => {
    void fetchAll();
  }, [statusFilter]); // eslint-disable-line react-hooks/exhaustive-deps

  // ---- Kreator ----
  const openWizard = () => {
    setWizClient("");
    setWizItems([{ ...EMPTY_ITEM }]);
    const due = new Date();
    due.setDate(due.getDate() + 14);
    setWizDue(due.toISOString().slice(0, 10));
    setWizPreview(false);
    setWizardOpen(true);
  };

  const pickClient = (id: string) => {
    setWizClient(id);
    const lead = leads.find((l) => l.id === id);
    if (lead && lead.mrr > 0 && wizItems.length === 1 && !wizItems[0].name) {
      setWizItems([{ name: `Abonament Mestio — plan ${lead.plan ?? "Standard"}`, qty: 1, net: lead.mrr, vat: 23 }]);
    }
  };

  const setItem = (idx: number, patch: Partial<InvoiceLineItem>) =>
    setWizItems((arr) => arr.map((it, k) => (k === idx ? { ...it, ...patch } : it)));

  const wizTotals = calcTotals(wizItems.filter((i) => i.name.trim()));
  const wizLead = leads.find((l) => l.id === wizClient);
  const wizValid = !!wizClient && wizItems.some((i) => i.name.trim() && i.net > 0) && !!wizDue;

  const issueInvoice = async () => {
    if (!wizValid || !wizLead) return;
    setSaving(true);
    const items = wizItems.filter((i) => i.name.trim());
    const { number, error } = await createInvoice(supabase, {
      leadId: wizClient,
      items,
      dueDate: wizDue,
    });
    setSaving(false);
    if (error) {
      notify("Błąd: " + error);
      return;
    }
    setWizardOpen(false);
    notify(`Wystawiono fakturę ${number}`);
    fetchAll();
  };

  // ---- Akcje na fakturze ----
  const [actionBusy, setActionBusy] = useState(false);

  const markPaid = async (inv: CrmInvoiceWithClient) => {
    setActionBusy(true);
    const { error } = await supabase
      .from("crm_invoices")
      .update({ status: "paid", paid_at: new Date().toISOString().slice(0, 10) })
      .eq("id", inv.id);
    setActionBusy(false);
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    notify(`${inv.number} oznaczona jako opłacona`);
    setDetail(null);
    fetchAll();
  };

  const duplicate = async (inv: CrmInvoiceWithClient) => {
    setActionBusy(true);
    const due = new Date();
    due.setDate(due.getDate() + 14);
    const { number, error } = await createInvoice(supabase, {
      leadId: inv.lead_id,
      items: inv.line_items ?? [{ name: "Abonament Mestio", qty: 1, net: inv.amount / 1.23, vat: 23 }],
      dueDate: due.toISOString().slice(0, 10),
    });
    setActionBusy(false);
    if (error) {
      notify("Błąd: " + error);
      return;
    }
    notify(`Utworzono duplikat: ${number}`);
    setDetail(null);
    fetchAll();
  };

  const sendByEmail = async (inv: CrmInvoiceWithClient) => {
    const to = inv.crm_leads?.contact_email;
    if (!to) {
      notify("Klient nie ma adresu e-mail — uzupełnij w karcie klienta");
      return;
    }
    const body = invoiceText(inv, inv.crm_leads!, seller);
    const { error } = await supabase.from("crm_emails").insert({
      lead_id: inv.lead_id,
      to_email: to,
      subject: `Faktura ${inv.number} — Mestio`,
      body,
      status: "draft",
    });
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    notify(`Szkic e-maila z fakturą ${inv.number} czeka w Poczcie na akceptację`);
  };

  const printInvoice = (inv: CrmInvoiceWithClient) => {
    const w = window.open("", "_blank", "width=700,height=900");
    if (!w) {
      notify("Przeglądarka zablokowała okno — zezwól na wyskakujące okna dla tej strony");
      return;
    }
    w.document.write(
      `<pre style="font-family:'Courier New',monospace;font-size:13px;line-height:1.6;padding:40px;white-space:pre-wrap">${invoiceText(inv, inv.crm_leads ?? { company_name: "—", nip: null }, seller)}</pre>`
    );
    w.document.close();
    w.print();
  };

  const totalAmount = invoices.reduce((s, i) => s + (i.amount || 0), 0);
  const paidAmount = invoices.filter((i) => i.status === "paid").reduce((s, i) => s + (i.amount || 0), 0);
  const overdueAmount = invoices.filter((i) => i.status === "overdue").reduce((s, i) => s + (i.amount || 0), 0);

  const cols = ["Numer", "Klient", "Kwota", "Status", "Termin", "KSeF"];
  const lbl = "font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase";
  const inp = "w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all";

  return (
    <div className="max-w-7xl mx-auto space-y-4">
      <div className="grid grid-cols-3 gap-[10px]">
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-4">
          <div className="text-[11px] text-[#7C8AA0]">Suma</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-xl text-ink mt-1">{money(totalAmount)} PLN</div>
          <div className="text-[10px] text-[#9AA7B8] mt-[2px]">{invoices.length} faktur</div>
        </div>
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-4">
          <div className="text-[11px] text-[#7C8AA0]">Opłacone</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-xl text-success mt-1">{money(paidAmount)} PLN</div>
        </div>
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-4">
          <div className="text-[11px] text-[#7C8AA0]">Zaległe</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-xl text-danger mt-1">{money(overdueAmount)} PLN</div>
        </div>
      </div>

      <div className="flex gap-[8px] items-center justify-between flex-wrap">
        <div className="flex gap-[8px]">
          <button
            onClick={() => setMode("crm")}
            className={`px-[13px] py-[7px] rounded-full text-[12.5px] font-medium transition-colors ${
              mode === "crm"
                ? "bg-blueprint text-white"
                : "bg-white text-[#5A6B80] border border-[#E4EBF3]"
            }`}
          >
            Moje faktury
          </button>
          <button
            onClick={() => setMode("fixflow")}
            className={`px-[13px] py-[7px] rounded-full text-[12.5px] font-medium transition-colors ${
              mode === "fixflow"
                ? "bg-blueprint text-white"
                : "bg-white text-[#5A6B80] border border-[#E4EBF3]"
            }`}
          >
            Systemowe
          </button>
        </div>
        {mode === "crm" && (
          <div className="flex gap-[8px]">
            {(["all", "issued", "paid", "overdue"] as const).map((s) => (
              <button
                key={s}
                onClick={() => setStatusFilter(s)}
                className={`px-[13px] py-[7px] rounded-full text-[12.5px] font-medium transition-colors ${
                  statusFilter === s
                    ? "bg-blueprint text-white"
                    : "bg-white text-[#5A6B80] border border-[#E4EBF3]"
                }`}
              >
                {s === "all" ? "Wszystkie" : s === "issued" ? "Wystawione" : s === "paid" ? "Opłacone" : "Zaległe"}
              </button>
            ))}
            <button
              onClick={openWizard}
              className="px-[14px] py-[7px] rounded-full bg-azure text-white text-[12.5px] font-medium hover:bg-azure-dark transition-colors flex items-center gap-[5px]"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round"><path d="M12 5v14M5 12h14" /></svg>
              Utwórz fakturę
            </button>
          </div>
        )}
      </div>

      <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] overflow-hidden">
        {loading ? (
          <div className="p-12 text-center text-[#9AA7B8] text-sm">Ładowanie...</div>
        ) : mode === "fixflow" ? (
          fixflowInvoices.length === 0 ? (
            <div className="p-12 text-center text-[#9AA7B8] text-[13.5px]">Brak faktur systemowych.</div>
          ) : (
            <>
              <div className="grid grid-cols-[1.2fr_1fr_.8fr_.8fr_.8fr] bg-ink px-[18px]">
                {["Numer", "Plan", "Netto", "VAT", "Brutto"].map((c) => (
                  <div key={c} className="py-[11px] px-[6px] font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-white/60 uppercase">{c}</div>
                ))}
              </div>
              {fixflowInvoices.map((inv) => (
                <div key={inv.id} className="grid grid-cols-[1.2fr_1fr_.8fr_.8fr_.8fr] px-[18px] border-b border-[#F4F7FB] last:border-0 items-center hover:bg-[#F8FAFC] transition-colors">
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] font-semibold text-blueprint">{inv.invoice_number}</div>
                  <div className="py-3 px-[6px] text-[13px] text-[#3A4759]">{inv.plan_name ?? "—"}</div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs text-ink">{grossMoney(inv.amount_net)} PLN</div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs text-[#7C8AA0]">{grossMoney(inv.amount_vat)} PLN</div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs font-semibold text-ink">{grossMoney(inv.amount_gross)} PLN</div>
                </div>
              ))}
            </>
          )
        ) : invoices.length === 0 ? (
          <div className="p-12 text-center text-[#9AA7B8] text-[13.5px]">
            Brak faktur.{" "}
            <button onClick={openWizard} className="text-azure font-semibold hover:underline">
              Wystaw pierwszą fakturę →
            </button>
          </div>
        ) : (
          <>
            <div className="grid grid-cols-[1fr_1.5fr_1fr_.8fr_.8fr_.8fr] bg-ink px-[18px]">
              {cols.map((c) => (
                <div key={c} className="py-[11px] px-[6px] font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-white/60 uppercase">{c}</div>
              ))}
            </div>
            {invoices.map((inv) => {
              const sm = STATUS_META[inv.status] ?? STATUS_META.issued;
              const km = KSEF_META[inv.ksef_status] ?? KSEF_META.pending;
              return (
                <button
                  key={inv.id}
                  onClick={() => setDetail(inv)}
                  className="w-full text-left grid grid-cols-[1fr_1.5fr_1fr_.8fr_.8fr_.8fr] px-[18px] border-b border-[#F4F7FB] last:border-0 hover:bg-[#F8FAFC] transition-colors"
                >
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs font-semibold text-blueprint">{inv.number}</div>
                  <div className="py-3 px-[6px] text-[13px] text-[#3A4759]">{inv.crm_leads?.company_name ?? "—"}</div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs font-semibold text-ink">{money(inv.amount)} {inv.currency}</div>
                  <div className="py-3 px-[6px]">
                    <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full" style={{ background: tint(sm.color, 0.13), color: sm.color }}>{sm.label}</span>
                  </div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] text-[#7C8AA0]">
                    {inv.due_date ? new Date(inv.due_date).toLocaleDateString("pl-PL") : "—"}
                  </div>
                  <div className="py-3 px-[6px]">
                    <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full" style={{ background: tint(km.color, 0.13), color: km.color }}>{km.label}</span>
                  </div>
                </button>
              );
            })}
          </>
        )}
      </div>

      {/* ===== KREATOR FAKTURY ===== */}
      {wizardOpen && (
        <div className="fixed inset-0 bg-ink/50 flex items-center justify-center z-50 p-6" onClick={() => setWizardOpen(false)}>
          <div
            className="bg-[#F6F8FB] rounded-[20px] shadow-[0_24px_70px_rgba(14,26,43,.4)] w-[620px] max-w-full max-h-[90vh] overflow-y-auto p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between">
              <div className="font-[family-name:var(--font-heading)] font-bold text-lg text-ink">
                {wizPreview ? "Podgląd faktury" : "Nowa faktura"}
              </div>
              <button onClick={() => setWizardOpen(false)} className="w-7 h-7 rounded-full bg-[#EAF0F7] flex items-center justify-center text-sm text-[#5A6B80]">✕</button>
            </div>

            {!wizPreview ? (
              <>
                <div className={`${lbl} mt-4 mb-[6px]`}>Klient</div>
                <select value={wizClient} onChange={(e) => pickClient(e.target.value)} className={inp}>
                  <option value="">— wybierz klienta —</option>
                  {leads.map((l) => (
                    <option key={l.id} value={l.id}>{l.company_name}</option>
                  ))}
                </select>

                <div className={`${lbl} mt-4 mb-[6px]`}>Pozycje faktury</div>
                <div className="flex flex-col gap-2">
                  {wizItems.map((it, idx) => (
                    <div key={idx} className="bg-white rounded-xl p-3 grid grid-cols-[2fr_.6fr_.9fr_.6fr_auto] gap-2 items-center">
                      <input value={it.name} onChange={(e) => setItem(idx, { name: e.target.value })} placeholder="Nazwa usługi/produktu" className="text-[13px] bg-[#F4F7FB] rounded-lg px-[11px] py-[10px] outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
                      <input type="number" min={1} value={it.qty} onChange={(e) => setItem(idx, { qty: Number(e.target.value) || 1 })} title="Ilość" className="text-[13px] bg-[#F4F7FB] rounded-lg px-[11px] py-[10px] outline-none focus:ring-2 focus:ring-azure/30 transition-all text-center" />
                      <input type="number" min={0} step="0.01" value={it.net || ""} onChange={(e) => setItem(idx, { net: Number(e.target.value) || 0 })} placeholder="Netto zł" title="Cena jednostkowa netto" className="text-[13px] bg-[#F4F7FB] rounded-lg px-[11px] py-[10px] outline-none focus:ring-2 focus:ring-azure/30 transition-all text-right font-[family-name:var(--font-mono)]" />
                      <select value={it.vat} onChange={(e) => setItem(idx, { vat: Number(e.target.value) })} title="Stawka VAT" className="text-[13px] bg-[#F4F7FB] rounded-lg px-2 py-[10px] outline-none focus:ring-2 focus:ring-azure/30 transition-all">
                        <option value={23}>23%</option>
                        <option value={8}>8%</option>
                        <option value={5}>5%</option>
                        <option value={0}>0%</option>
                      </select>
                      <button
                        onClick={() => setWizItems((arr) => arr.filter((_, k) => k !== idx))}
                        disabled={wizItems.length === 1}
                        className="w-7 h-7 rounded-full bg-danger/10 text-danger flex items-center justify-center text-[13px] hover:bg-danger/20 disabled:opacity-30 transition-colors"
                      >✕</button>
                    </div>
                  ))}
                </div>
                <button onClick={() => setWizItems((arr) => [...arr, { ...EMPTY_ITEM }])} className="mt-2 text-[11.5px] font-semibold text-azure">
                  + Dodaj pozycję
                </button>

                <div className="grid grid-cols-2 gap-3 mt-4">
                  <div>
                    <div className={`${lbl} mb-[6px]`}>Termin płatności</div>
                    <input type="date" value={wizDue} onChange={(e) => setWizDue(e.target.value)} className={inp} />
                  </div>
                  <div className="bg-white rounded-xl p-3 px-4">
                    <div className="flex justify-between text-xs text-[#7C8AA0]"><span>Netto</span><span className="font-[family-name:var(--font-mono)]">{money(wizTotals.net)} zł</span></div>
                    <div className="flex justify-between text-xs text-[#7C8AA0] mt-1"><span>VAT</span><span className="font-[family-name:var(--font-mono)]">{money(wizTotals.vat)} zł</span></div>
                    <div className="flex justify-between text-[13px] font-bold text-ink mt-1 pt-1 border-t border-[#F1F5FA]"><span>Brutto</span><span className="font-[family-name:var(--font-mono)]">{money(wizTotals.gross)} zł</span></div>
                  </div>
                </div>

                <div className="flex gap-[10px] mt-5">
                  <button onClick={() => setWizardOpen(false)} className="flex-1 py-3 rounded-[11px] bg-[#EAF0F7] text-[#5A6B80] font-semibold text-[13.5px]">Anuluj</button>
                  <button
                    onClick={() => setWizPreview(true)}
                    disabled={!wizValid}
                    className="flex-[1.6] py-3 rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50"
                  >
                    Podgląd →
                  </button>
                </div>
              </>
            ) : (
              <>
                <div className="mt-4 bg-[#FAFBFD] rounded-xl p-1">
                  <pre className="whitespace-pre-wrap font-[family-name:var(--font-mono)] text-[12px] leading-[1.7] text-[#1f2937] bg-white rounded-[10px] p-[18px] shadow-[0_1px_4px_rgba(14,26,43,.06)] m-0">
                    {wizLead &&
                      invoiceText(
                        { number: "FV/…/… (nadany przy wystawieniu)", issued_at: new Date().toISOString(), due_date: wizDue, line_items: wizItems.filter((i) => i.name.trim()), amount: wizTotals.gross },
                        wizLead,
                        seller
                      )}
                  </pre>
                </div>
                {(seller.nip === "—" || seller.nip === "") && (
                  <div className="mt-3 py-[10px] px-[13px] rounded-[11px] bg-amber/10 border border-amber/35 text-xs text-[#8a6200]">
                    ⚠ Brak NIP sprzedawcy — uzupełnij w Ustawienia → Dane, żeby faktura była poprawna formalnie.
                  </div>
                )}
                <div className="flex gap-[10px] mt-5">
                  <button onClick={() => setWizPreview(false)} className="flex-1 py-3 rounded-[11px] bg-[#EAF0F7] text-[#5A6B80] font-semibold text-[13.5px]">← Wróć do edycji</button>
                  <button
                    onClick={issueInvoice}
                    disabled={saving}
                    className="flex-[1.6] py-3 rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50"
                  >
                    {saving ? "Wystawianie..." : "Wystaw fakturę"}
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}

      {/* ===== PODGLĄD FAKTURY ===== */}
      {detail && (
        <div className="fixed inset-0 bg-ink/50 flex items-center justify-center z-50 p-6" onClick={() => setDetail(null)}>
          <div
            className="bg-white rounded-[20px] shadow-[0_24px_70px_rgba(14,26,43,.4)] w-[560px] max-w-full max-h-[88vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-5 px-[22px] border-b border-[#EEF2F8] flex items-center justify-between">
              <div>
                <div className="font-[family-name:var(--font-heading)] font-bold text-[17px] text-ink">{detail.number}</div>
                <div className="text-xs text-[#7C8AA0] mt-[2px]">
                  {detail.crm_leads?.company_name ?? "—"} · {money(detail.amount)} {detail.currency}
                </div>
              </div>
              <button onClick={() => setDetail(null)} className="w-7 h-7 rounded-full bg-[#F4F7FB] flex items-center justify-center text-sm text-[#5A6B80]">✕</button>
            </div>

            <div className="p-5 px-[22px]">
              <div className="bg-[#FAFBFD] rounded-xl p-4 font-[family-name:var(--font-mono)] text-[11.5px] leading-[1.7] text-[#3A4759] shadow-[0_1px_4px_rgba(14,26,43,.06)] whitespace-pre-wrap">
                {invoiceText(detail, detail.crm_leads ?? { company_name: "—", nip: null }, seller)}
              </div>

              <div className={`${lbl} mt-[18px] mb-[9px]`}>Checklista</div>
              <div className="flex flex-col gap-2">
                {[
                  { label: "Faktura wygenerowana", done: true },
                  { label: "Wysłana do klienta", done: detail.ksef_status === "sent" || detail.status === "paid" },
                  { label: "Płatność potwierdzona", done: detail.status === "paid" },
                ].map((c) => (
                  <div key={c.label} className="flex items-center gap-[10px] bg-[#F6F8FB] rounded-[10px] py-[10px] px-3">
                    <div
                      className="w-5 h-5 rounded-md flex items-center justify-center shrink-0"
                      style={{ background: c.done ? "#2E9E6B" : "#fff", border: `2px solid ${c.done ? "#2E9E6B" : "#D4DEEA"}` }}
                    >
                      {c.done && (
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5 9-11" /></svg>
                      )}
                    </div>
                    <span className={`text-[12.5px] font-medium ${c.done ? "text-ink" : "text-[#5A6B80]"}`}>{c.label}</span>
                  </div>
                ))}
              </div>

              <div className="grid grid-cols-2 gap-[9px] mt-5">
                {detail.status !== "paid" && (
                  <button onClick={() => markPaid(detail)} disabled={actionBusy} className="col-span-2 py-[13px] rounded-[11px] bg-success text-white text-[13.5px] font-semibold flex items-center justify-center gap-2 hover:brightness-105 active:scale-[0.99] transition-all disabled:opacity-50">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.8" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5 9-11" /></svg>
                    Oznacz opłaconą
                  </button>
                )}
                <button onClick={() => sendByEmail(detail)} disabled={actionBusy} className="py-[12px] rounded-[11px] bg-blueprint text-white text-[12.5px] font-semibold hover:brightness-110 transition-all disabled:opacity-50">
                  Wyślij mailem
                </button>
                <button onClick={() => duplicate(detail)} disabled={actionBusy} className="py-[12px] rounded-[11px] bg-[#F4F7FB] text-blueprint text-[12.5px] font-semibold hover:bg-[#EAEFF5] transition-colors disabled:opacity-50">
                  Duplikat
                </button>
                <button
                  onClick={() => printInvoice(detail)}
                  disabled={actionBusy}
                  title="Jeśli przeglądarka zablokuje okno, odblokuj wyskakujące okna dla tej strony"
                  className="col-span-2 py-[12px] rounded-[11px] bg-[#F4F7FB] text-blueprint text-[12.5px] font-semibold hover:bg-[#EAEFF5] transition-colors disabled:opacity-50"
                >
                  Drukuj / PDF
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-[70]">
          {toast}
        </div>
      )}
    </div>
  );
}

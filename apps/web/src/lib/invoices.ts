import type { SupabaseClient } from "@supabase/supabase-js";
import { InvoiceLineItem } from "./types";

export interface SellerSettings {
  company: string;
  nip: string;
  email: string;
  phone: string;
  address: string;
  iban: string;
  termin: string;
  stopka: string;
}

export const DEFAULT_SELLER: SellerSettings = {
  company: "AIVOLUX",
  nip: "",
  email: "",
  phone: "",
  address: "",
  iban: "",
  termin: "14 dni",
  stopka: "Dziękujemy za korzystanie z Mestio.",
};

/**
 * Jedyne miejsce czytające dane sprzedawcy (audyt: wcześniej 3-4 niezależne
 * kopie, część modułów ignorowała Ustawienia i miała hardcoded "AIVOLUX").
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function getSellerSettings(supabase: SupabaseClient<any>): Promise<SellerSettings> {
  const { data } = await supabase
    .from("crm_settings")
    .select("value")
    .eq("key", "owner_settings")
    .maybeSingle();
  if (data?.value) {
    return { ...DEFAULT_SELLER, ...(data.value as Partial<SellerSettings>) };
  }
  return DEFAULT_SELLER;
}

export function calcTotals(items: InvoiceLineItem[]) {
  const net = items.reduce((s, i) => s + i.qty * i.net, 0);
  const vat = items.reduce((s, i) => s + i.qty * i.net * (i.vat / 100), 0);
  return { net, vat, gross: net + vat };
}

const money = (v: number) =>
  v.toLocaleString("pl-PL", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

export function invoiceText(
  inv: { number: string; issued_at: string; due_date: string | null; line_items: InvoiceLineItem[] | null; amount: number },
  client: { company_name: string; nip: string | null },
  seller: SellerSettings
): string {
  const items = inv.line_items?.length
    ? inv.line_items
    : [{ name: "Abonament Mestio", qty: 1, net: inv.amount / 1.23, vat: 23 }];
  const t = calcTotals(items);
  const lines = items
    .map(
      (i, k) =>
        `${k + 1}. ${i.name} — ${i.qty} × ${money(i.net)} zł netto (VAT ${i.vat}%) = ${money(i.qty * i.net * (1 + i.vat / 100))} zł brutto`
    )
    .join("\n");
  return `FAKTURA VAT ${inv.number}

Data wystawienia: ${new Date(inv.issued_at).toLocaleDateString("pl-PL")}
Termin płatności: ${inv.due_date ? new Date(inv.due_date).toLocaleDateString("pl-PL") : seller.termin}

SPRZEDAWCA:
${seller.company}
NIP: ${seller.nip || "—"}
${seller.address || "—"}
Konto: ${seller.iban || "—"}

NABYWCA:
${client.company_name}
NIP: ${client.nip ?? "—"}

POZYCJE:
${lines}

RAZEM netto: ${money(t.net)} zł
VAT: ${money(t.vat)} zł
RAZEM brutto: ${money(t.gross)} zł
${seller.stopka ? "\n" + seller.stopka : ""}`;
}

/**
 * Jedyne miejsce tworzące fakturę w bazie (audyt: wcześniej duplikowane w
 * customers/page.tsx z zawsze VAT 23%/1 pozycja i invoices/page.tsx z
 * elastycznymi pozycjami — teraz oba moduły wołają tę samą funkcję).
 * Numer generowany atomowo przez RPC crm_next_invoice_number() - eliminuje
 * race condition poprzedniego wzorca COUNT(*)+1.
 */
export async function createInvoice(
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  supabase: SupabaseClient<any>,
  params: { leadId: string; items: InvoiceLineItem[]; dueDate: string }
): Promise<{ id: string | null; number: string; error: string | null }> {
  const { data: number, error: rpcError } = await supabase.rpc("crm_next_invoice_number");
  if (rpcError || !number) {
    return { id: null, number: "", error: rpcError?.message ?? "Nie udało się wygenerować numeru faktury" };
  }

  const totals = calcTotals(params.items);
  const { data: inserted, error } = await supabase
    .from("crm_invoices")
    .insert({
      lead_id: params.leadId,
      number,
      amount: totals.gross,
      currency: "PLN",
      status: "issued",
      issued_at: new Date().toISOString().slice(0, 10),
      due_date: params.dueDate,
      line_items: params.items,
      ksef_status: "pending",
    })
    .select("id")
    .single();

  if (error || !inserted) return { id: null, number, error: error?.message ?? "Nie udało się utworzyć faktury" };

  await supabase.rpc("sync_crm_invoice_to_fixflow", { p_invoice_id: inserted.id });

  return { id: inserted.id, number, error: null };
}

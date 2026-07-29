import { supabaseAdmin } from "./supabase-admin";

export interface OrderLeadInput {
  companyName: string;
  contactName: string;
  email: string;
  phone: string;
  nip: string;
  plan: string;
  /** Kwota brutto w groszach (z pricing) */
  amountGrosze: number;
  /** Metoda płatności: card | blik | transfer */
  paymentMethod: "card" | "blik" | "transfer";
  /** Tytuł przelewu (tylko dla metody transfer) */
  transferTitle?: string;
  /** Nazwa osiedla */
  estateName?: string;
}

const PAYMENT_METHOD_LABELS: Record<string, string> = {
  card: "Karta (autopłatność)",
  blik: "BLIK / Przelewy24",
  transfer: "Przelew tradycyjny",
};

/**
 * Tworzy leada w tabeli `crm_leads` na podstawie danych z formularza zamówienia.
 * Wywoływany przez wszystkie endpointy płatności (create-transfer, create-checkout, create-payment).
 *
 * Lead trafia do pipeline CRM Owner ze statusem "lead" i źródłem "website".
 * MRR = kwota netto (brutto / 1.23) w PLN.
 */
export async function createLeadFromOrder(input: OrderLeadInput): Promise<string | null> {
  const adminClient = supabaseAdmin();

  // MRR = kwota netto w PLN (grosze brutto → PLN netto)
  const mrrPln = input.amountGrosze > 0
    ? Math.round((input.amountGrosze / 100 / 1.23) * 100) / 100
    : 0;

  const notes = [
    `Zamówienie ze strony WWW`,
    `Metoda płatności: ${PAYMENT_METHOD_LABELS[input.paymentMethod] ?? input.paymentMethod}`,
    input.transferTitle ? `Tytuł przelewu: ${input.transferTitle}` : null,
    input.estateName ? `Nazwa osiedla: ${input.estateName}` : null,
  ]
    .filter(Boolean)
    .join("\n");

  const { data, error } = await adminClient
    .from("crm_leads")
    .insert({
      company_name: input.companyName,
      contact_name: input.contactName || null,
      contact_email: input.email,
      contact_phone: input.phone || null,
      nip: input.nip || null,
      source: "website",
      stage: "lead",
      plan: input.plan || null,
      mrr: mrrPln,
      notes,
    })
    .select("id")
    .single();

  if (error) {
    console.error("[createLeadFromOrder] Błąd tworzenia leada:", error);
    return null;
  }

  // Pierwszy wpis w historii interakcji
  await adminClient.from("crm_interactions").insert({
    lead_id: data.id,
    type: "note",
    summary: `Lead utworzony automatycznie z formularza zamówienia (źródło: strona WWW, plan: ${input.plan}, metoda: ${PAYMENT_METHOD_LABELS[input.paymentMethod] ?? input.paymentMethod})`,
  });

  return data.id;
}

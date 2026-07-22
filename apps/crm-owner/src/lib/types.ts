export type LeadStage =
  | "lead"
  | "contact"
  | "demo"
  | "offer"
  | "contract"
  | "won"
  | "onboarding"
  | "active"
  | "risk"
  | "churned"
  | "lost";

export const STAGE_LABELS: Record<LeadStage, string> = {
  lead: "Lead",
  contact: "Kontakt",
  demo: "Demo",
  offer: "Oferta",
  contract: "Szykowanie umowy",
  won: "Wygrana",
  onboarding: "Onboarding",
  active: "Aktywny",
  risk: "Ryzyko rezygnacji",
  churned: "Churned",
  lost: "Utracony",
};

export const STAGE_ORDER: LeadStage[] = [
  "lead",
  "contact",
  "demo",
  "offer",
  "contract",
  "won",
  "onboarding",
  "active",
  "risk",
  "churned",
  "lost",
];

// UWAGA: musi zawierać WSZYSTKIE etapy z LeadStage. Lead, ktorego stage nie ma
// tutaj, znika calkowicie z Pipeline (brak kolumny = brak miejsca na karte).
// Kolejnosc odzwierciedla naturalna podroz klienta: sprzedaz (Lead -> Wygrana),
// potem cykl zycia klienta (Onboarding -> Aktywny -> Ryzyko), na koncu wyjscia
// (Utracony, Churned) - zgodnie z prosba: "onboarding dodaj na koniec listy".
export const SALES_STAGES: LeadStage[] = [
  "lead",
  "contact",
  "demo",
  "offer",
  "contract",
  "won",
  "onboarding",
  "active",
  "risk",
  "lost",
  "churned",
];

export const STAGE_HEX: Record<LeadStage, string> = {
  lead: "#3E7BD6",
  contact: "#173A6A",
  demo: "#F2A900",
  offer: "#C98800",
  contract: "#8B5CF6",
  won: "#2E9E6B",
  onboarding: "#3E7BD6",
  active: "#2E9E6B",
  risk: "#C0392B",
  churned: "#6B7A90",
  lost: "#8A98AB",
};

export const CLIENT_LIFECYCLE_STAGES: LeadStage[] = [
  "onboarding",
  "active",
  "risk",
  "churned",
  "lost",
];

export const STAGE_COLORS: Record<LeadStage, string> = {
  lead: "bg-mist text-ink/70",
  contact: "bg-azure/10 text-azure",
  demo: "bg-azure/20 text-azure-dark",
  offer: "bg-amber/20 text-amber-light",
  contract: "bg-[#8B5CF6]/15 text-[#8B5CF6]",
  won: "bg-success/15 text-success",
  onboarding: "bg-blueprint/10 text-blueprint",
  active: "bg-success/20 text-success",
  risk: "bg-warning/20 text-warning",
  churned: "bg-danger/15 text-danger",
  lost: "bg-danger/10 text-danger",
};

export interface CrmLead {
  id: string;
  company_name: string;
  contact_name: string | null;
  contact_email: string | null;
  contact_phone: string | null;
  nip: string | null;
  source: string;
  stage: LeadStage;
  plan: string | null;
  mrr: number;
  estate_id: string | null;
  contract_end: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface CrmInteraction {
  id: string;
  lead_id: string;
  type: string;
  summary: string;
  created_at: string;
}

export interface CrmTask {
  id: string;
  lead_id: string | null;
  title: string;
  due_date: string | null;
  done: boolean;
  priority: string;
  created_at: string;
}

export interface InvoiceLineItem {
  name: string;
  qty: number;
  net: number; // cena jednostkowa netto
  vat: number; // stawka VAT w %
}

export interface CrmInvoice {
  id: string;
  lead_id: string;
  number: string;
  amount: number;
  currency: string;
  status: "issued" | "paid" | "overdue";
  issued_at: string;
  due_date: string | null;
  line_items: InvoiceLineItem[] | null;
  paid_at: string | null;
  stripe_invoice_id: string | null;
  ksef_status: "pending" | "sent" | "confirmed" | "error";
  ksef_reference: string | null;
  created_at: string;
}

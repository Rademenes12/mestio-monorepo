"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { CrmLead, LeadStage, STAGE_LABELS, STAGE_HEX } from "@/lib/types";
import { getSellerSettings, createInvoice, SellerSettings, DEFAULT_SELLER } from "@/lib/invoices";

const STAGE_FILTERS: { value: LeadStage | "all"; label: string }[] = [
  { value: "all", label: "Wszystkie" },
  { value: "lead", label: "Lead" },
  { value: "contact", label: "Kontakt" },
  { value: "demo", label: "Demo" },
  { value: "offer", label: "Oferta" },
  { value: "contract", label: "Umowa" },
  { value: "won", label: "Wygrana" },
  { value: "onboarding", label: "Onboarding" },
  { value: "active", label: "Aktywny" },
  { value: "risk", label: "Ryzyko" },
  { value: "churned", label: "Churned" },
  { value: "lost", label: "Utracony" },
];

const AV_COLORS = [
  "#3E7BD6", "#173A6A", "#F2A900", "#2E9E6B",
  "#C98800", "#6B7A90", "#C0392B", "#3E7BD6",
];

const PLAN_PRICE: Record<string, string> = {
  start: "79 zł",
  standard: "179 zł",
  pro: "349 zł",
  enterprise: "wg wyceny",
};

const CONTRACT_PLANS = ["start", "standard", "pro", "enterprise"];

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${a})`;
}

interface Rep {
  name: string;
  position: string;
  email: string;
}

interface ClientMeta {
  bank: string;
  reps: Rep[];
}

interface ClientDoc {
  id: string;
  type: string;
  title: string;
  status: string;
  created_at: string;
}

const DOC_STATUS_LABELS: Record<string, string> = {
  generated: "Wygenerowana",
  sent: "Wysłana",
  signed: "Podpisana",
  draft: "Szkic",
};

export default function CustomersPage() {
  const [leads, setLeads] = useState<CrmLead[]>([]);
  const [loading, setLoading] = useState(true);
  const [stageFilter, setStageFilter] = useState<LeadStage | "all">("all");
  const [modalLead, setModalLead] = useState<CrmLead | null>(null);
  const [meta, setMeta] = useState<ClientMeta>({ bank: "", reps: [] });
  const [metaDirty, setMetaDirty] = useState(false);
  const [contactForm, setContactForm] = useState({ phone: "", email: "", nip: "" });
  const [contactDirty, setContactDirty] = useState(false);
  const [savingContact, setSavingContact] = useState(false);
  const [docs, setDocs] = useState<ClientDoc[]>([]);
  const [contractPlan, setContractPlan] = useState("standard");
  const [docPreview, setDocPreview] = useState<{ kind: string; title: string; text: string } | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const [seller, setSeller] = useState<SellerSettings>(DEFAULT_SELLER);
  const [sendingDoc, setSendingDoc] = useState(false);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2600);
  };

  const fetchLeads = async () => {
    setLoading(true);
    let query = supabase.from("crm_leads").select("*").order("created_at", { ascending: false });
    if (stageFilter !== "all") query = query.eq("stage", stageFilter);
    const { data } = await query;
    setLeads((data as CrmLead[]) ?? []);
    setLoading(false);
  };

  useEffect(() => {
    void fetchLeads();
  }, [stageFilter]); // eslint-disable-line react-hooks/exhaustive-deps

  // Dane sprzedawcy z Ustawień - jedno źródło prawdy (audyt: wcześniej tu było
  // hardcoded "AIVOLUX, NIP 000-000-00-00" niezależnie od tego co wpisano w Ustawieniach).
  useEffect(() => {
    void getSellerSettings(supabase).then(setSeller);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const openModal = async (lead: CrmLead) => {
    setModalLead(lead);
    setContractPlan((lead.plan ?? "standard").toLowerCase());
    setMetaDirty(false);
    setContactForm({
      phone: lead.contact_phone ?? "",
      email: lead.contact_email ?? "",
      nip: lead.nip ?? "",
    });
    setContactDirty(false);
    const [metaRes, docsRes] = await Promise.all([
      supabase.from("crm_settings").select("value").eq("key", `client_meta:${lead.id}`).maybeSingle(),
      supabase
        .from("client_documents")
        .select("id, type, title, status, created_at")
        .eq("lead_id", lead.id)
        .order("created_at", { ascending: false }),
    ]);
    const m = (metaRes.data?.value as ClientMeta) ?? null;
    setMeta(
      m ?? {
        bank: "",
        reps: lead.contact_name
          ? [{ name: lead.contact_name, position: "Prezes zarządu", email: lead.contact_email ?? "" }]
          : [],
      }
    );
    setDocs((docsRes.data as ClientDoc[]) ?? []);
  };

  const saveMeta = async () => {
    if (!modalLead) return;
    const { error } = await supabase
      .from("crm_settings")
      .upsert({ key: `client_meta:${modalLead.id}`, value: meta });
    if (error) {
      notify("Błąd zapisu: " + error.message);
      return;
    }
    setMetaDirty(false);
    notify("Zapisano dane klienta");
  };

  const updateMeta = (patch: Partial<ClientMeta>) => {
    setMeta((m) => ({ ...m, ...patch }));
    setMetaDirty(true);
  };

  // Dane kontaktowe (telefon/e-mail/NIP) zyja w crm_leads, w odroznieniu od
  // meta (numer konta, reprezentanci) ktore sa w crm_settings.client_meta:{id}.
  const saveContact = async () => {
    if (!modalLead) return;
    setSavingContact(true);
    const patch = {
      contact_phone: contactForm.phone.trim() || null,
      contact_email: contactForm.email.trim() || null,
      nip: contactForm.nip.trim() || null,
    };
    const { error } = await supabase
      .from("crm_leads")
      .update({ ...patch, updated_at: new Date().toISOString() })
      .eq("id", modalLead.id);
    setSavingContact(false);
    if (error) {
      notify("Błąd zapisu: " + error.message);
      return;
    }
    setModalLead((m) => (m ? { ...m, ...patch } : m));
    setLeads((prev) => prev.map((l) => (l.id === modalLead.id ? { ...l, ...patch } : l)));
    setContactDirty(false);
    notify("Zapisano dane kontaktowe");
  };

  const genContract = () => {
    if (!modalLead) return;
    const today = new Date().toLocaleDateString("pl-PL", { day: "numeric", month: "long", year: "numeric" });

    // Reprezentanci z karty klienta uzupelniaja umowe - jesli brak, fallback
    // na kontakt glowny z crm_leads (jak poprzednio).
    const primaryRep = meta.reps.find((r) => r.name.trim());
    const repLine = primaryRep
      ? `${primaryRep.name}${primaryRep.position ? ` (${primaryRep.position})` : ""}`
      : modalLead.contact_name ?? "—";
    const otherReps = meta.reps.filter((r) => r !== primaryRep && r.name.trim());
    const otherRepsLine =
      otherReps.length > 0
        ? `\nPozostali reprezentanci: ${otherReps
            .map((r) => `${r.name}${r.position ? ` (${r.position})` : ""}`)
            .join(", ")}.`
        : "";

    const text = `UMOWA O ŚWIADCZENIE USŁUGI MESTIO

zawarta dnia ${today} pomiędzy:
Usługodawcą: ${seller.company}, NIP ${seller.nip || "—"}
a
Usługobiorcą: ${modalLead.company_name}, NIP ${modalLead.nip ?? "—"}, reprezentowanym przez ${repLine}.${otherRepsLine}

§1. Przedmiot umowy: dostęp do systemu Mestio w planie ${contractPlan}.
§2. Opłata: ${PLAN_PRICE[contractPlan] ?? "—"} netto / mies.
§3. Zwroty i rozliczenia na numer konta: ${meta.bank.trim() || "— (nie podano, uzupełnij w karcie klienta)"}.
§4. Umowa obowiązuje do odwołania, okres wypowiedzenia 30 dni.
${seller.stopka ? "\n" + seller.stopka : ""}`;
    setDocPreview({ kind: "umowa", title: `Podgląd umowy — ${modalLead.company_name}`, text });
  };

  const genInvoice = () => {
    if (!modalLead) return;
    const plan = (modalLead.plan ?? contractPlan).toLowerCase();
    const net = modalLead.mrr > 0 ? modalLead.mrr : null;
    const text = `FAKTURA VAT

Sprzedawca: ${seller.company}, NIP ${seller.nip || "—"}
Nabywca: ${modalLead.company_name}, NIP ${modalLead.nip ?? "—"}

Pozycja: Abonament Mestio — plan ${plan}
Kwota netto: ${net ? `${net} zł` : PLAN_PRICE[plan] ?? "—"}
VAT 23%
Termin płatności: ${seller.termin}`;
    setDocPreview({ kind: "faktura", title: `Podgląd faktury — ${modalLead.company_name}`, text });
  };

  const confirmSendDoc = async () => {
    if (!docPreview || !modalLead) return;
    setSendingDoc(true);

    if (docPreview.kind === "faktura") {
      // Faktura trafia do rejestru crm_invoices przez wspólną funkcję lib/invoices.ts
      // (numeracja atomowa przez RPC - eliminuje race condition wcześniejszego
      // wzorca COUNT(*)+1, ta sama logika co w module Faktury).
      const due = new Date();
      due.setDate(due.getDate() + 14);
      const net = modalLead.mrr || 0;
      const { number, error } = await createInvoice(supabase, {
        leadId: modalLead.id,
        items: [
          {
            name: `Abonament Mestio — plan ${modalLead.plan ?? contractPlan}`,
            qty: 1,
            net,
            vat: 23,
          },
        ],
        dueDate: due.toISOString().slice(0, 10),
      });
      setSendingDoc(false);
      if (error) {
        notify("Błąd: " + error);
        return;
      }
      notify(`Faktura ${number} zapisana w CRM (KSeF nieaktywny — skonfiguruj w Ustawieniach)`);
    } else {
      const { error } = await supabase.from("client_documents").insert({
        lead_id: modalLead.id,
        type: docPreview.kind,
        title: "Umowa główna Mestio",
        body: docPreview.text,
        status: "generated",
      });
      setSendingDoc(false);
      if (error) {
        notify("Błąd: " + error.message);
        return;
      }
      notify(
        `Umowa dla ${modalLead.company_name} zapisana w CRM (e-podpis Autenti nieaktywny — skonfiguruj w Ustawieniach)`
      );
    }

    setDocPreview(null);
    const { data } = await supabase
      .from("client_documents")
      .select("id, type, title, status, created_at")
      .eq("lead_id", modalLead.id)
      .order("created_at", { ascending: false });
    setDocs((data as ClientDoc[]) ?? []);
  };

  const cols = ["Firma", "Kontakt", "Status", "MRR", "Umowa do", "Plan"];
  const lbl = "font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase";

  return (
    <div className="max-w-7xl mx-auto space-y-4">
      <div className="flex gap-[8px] flex-wrap items-center justify-between">
        <div className="flex gap-[8px] flex-wrap">
          {STAGE_FILTERS.map((f) => (
            <button
              key={f.value}
              onClick={() => setStageFilter(f.value)}
              className={`px-[13px] py-[7px] rounded-full text-[12.5px] font-medium transition-colors ${
                stageFilter === f.value
                  ? "bg-blueprint text-white"
                  : "bg-white text-[#5A6B80] border border-[#E4EBF3] hover:border-blueprint/30"
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
        <Link
          href="/customers/new"
          className="px-[14px] py-[7px] rounded-full bg-azure text-white text-[12.5px] font-medium hover:bg-azure-dark transition-colors shrink-0 flex items-center gap-[5px]"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 5v14M5 12h14" />
          </svg>
          Dodaj leada
        </Link>
      </div>

      <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] overflow-hidden">
        {loading ? (
          <div className="p-12 text-center text-[#9AA7B8] text-sm">Ładowanie...</div>
        ) : leads.length === 0 ? (
          <div className="p-12 text-center text-[#9AA7B8] text-[13.5px]">
            {stageFilter !== "all" ? "Brak wyników." : "Brak klientów."}
          </div>
        ) : (
          <>
            <div className="grid grid-cols-[2fr_1.2fr_.8fr_.8fr_.8fr_.6fr] bg-ink px-[18px]">
              {cols.map((c) => (
                <div key={c} className="py-[11px] px-[6px] font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-white/60 uppercase">
                  {c}
                </div>
              ))}
            </div>
            {leads.map((lead, i) => {
              const sc = STAGE_HEX[lead.stage] ?? "#6B7A90";
              return (
                <button
                  key={lead.id}
                  onClick={() => openModal(lead)}
                  className="w-full text-left grid grid-cols-[2fr_1.2fr_.8fr_.8fr_.8fr_.6fr] px-[18px] border-b border-[#F4F7FB] last:border-0 hover:bg-[#F8FAFC] transition-colors"
                >
                  <div className="py-3 px-[6px] flex items-center gap-[9px]">
                    <div
                      className="w-[30px] h-[30px] rounded-full flex items-center justify-center shrink-0"
                      style={{ background: AV_COLORS[i % AV_COLORS.length] }}
                    >
                      <span className="font-[family-name:var(--font-heading)] font-semibold text-[11px] text-white">
                        {lead.company_name.slice(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <div>
                      <div className="text-[13px] font-semibold text-ink">{lead.company_name}</div>
                      <div className="font-[family-name:var(--font-mono)] text-[10px] text-[#9AA7B8]">{lead.contact_name ?? "—"}</div>
                    </div>
                  </div>
                  <div className="py-3 px-[6px] text-[12.5px] text-[#5A6B80] flex items-center">{lead.contact_email ?? "—"}</div>
                  <div className="py-3 px-[6px] flex items-center">
                    <span
                      className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full"
                      style={{ background: tint(sc, 0.13), color: sc }}
                    >
                      {STAGE_LABELS[lead.stage]}
                    </span>
                  </div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs font-semibold text-blueprint flex items-center">
                    {lead.mrr > 0 ? `${lead.mrr.toLocaleString("pl-PL")} zł` : "—"}
                  </div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] text-[#7C8AA0] flex items-center">
                    {lead.contract_end ? new Date(lead.contract_end).toLocaleDateString("pl-PL") : "—"}
                  </div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] text-[#5A6B80] flex items-center">
                    {lead.plan ?? "—"}
                  </div>
                </button>
              );
            })}
          </>
        )}
      </div>

      {/* Modal karty klienta */}
      {modalLead && (
        <div
          className="fixed inset-0 bg-ink/45 flex items-center justify-center z-50 p-6"
          onClick={() => setModalLead(null)}
        >
          <div
            className="bg-[#F6F8FB] rounded-[22px] shadow-[0_20px_60px_rgba(14,26,43,.3)] w-[740px] max-w-full max-h-[88vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Nagłówek */}
            <div className="p-6 bg-ink rounded-t-[22px] flex items-center justify-between sticky top-0 z-10">
              <div>
                <div className="font-[family-name:var(--font-heading)] font-bold text-xl text-white">
                  {modalLead.company_name}
                </div>
                <div className="font-[family-name:var(--font-mono)] text-[12.5px] text-white/60 mt-[4px]">
                  {modalLead.contact_name ?? "—"}
                </div>
              </div>
              <button
                onClick={() => setModalLead(null)}
                className="w-9 h-9 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center text-white text-[15px] transition-colors"
              >
                ✕
              </button>
            </div>

            <div className="p-[22px] px-6">
              {/* Statystyki */}
              <div className="grid grid-cols-3 gap-[10px]">
                <div className="bg-white rounded-xl p-3.5 px-4">
                  <div className={lbl}>Status</div>
                  <div className="text-[15px] font-semibold mt-1.5">{STAGE_LABELS[modalLead.stage]}</div>
                </div>
                <div className="bg-white rounded-xl p-3.5 px-4">
                  <div className={lbl}>MRR</div>
                  <div className="text-[15px] font-semibold mt-1.5">
                    {modalLead.mrr > 0 ? `${modalLead.mrr.toLocaleString("pl-PL")} zł` : "—"}
                  </div>
                </div>
                <div className="bg-white rounded-xl p-3.5 px-4">
                  <div className={lbl}>Umowa do</div>
                  <div className="text-[15px] font-semibold mt-1.5">
                    {modalLead.contract_end
                      ? new Date(modalLead.contract_end).toLocaleDateString("pl-PL")
                      : "—"}
                  </div>
                </div>
              </div>

              {/* Dane kontaktowe - edytowalne bezposrednio w karcie */}
              <div className="flex items-center justify-between mt-6 mb-2">
                <span className={lbl}>Dane kontaktowe</span>
                <span className="text-[11px] text-[#9AA7B8]">Źródło: {modalLead.source}</span>
              </div>
              <div className="bg-white rounded-xl p-4 flex flex-col gap-3">
                <div>
                  <label className="text-[12px] text-[#7C8AA0] mb-1.5 block">Telefon</label>
                  <input
                    value={contactForm.phone}
                    onChange={(e) => {
                      setContactForm((f) => ({ ...f, phone: e.target.value }));
                      setContactDirty(true);
                    }}
                    placeholder="+48 000 000 000"
                    className="w-full font-[family-name:var(--font-mono)] text-[14.5px] bg-[#F4F7FB] rounded-[10px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                  />
                </div>
                <div>
                  <label className="text-[12px] text-[#7C8AA0] mb-1.5 block">E-mail</label>
                  <input
                    value={contactForm.email}
                    onChange={(e) => {
                      setContactForm((f) => ({ ...f, email: e.target.value }));
                      setContactDirty(true);
                    }}
                    placeholder="kontakt@firma.pl"
                    className="w-full font-[family-name:var(--font-mono)] text-[14.5px] bg-[#F4F7FB] rounded-[10px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                  />
                </div>
                <div>
                  <label className="text-[12px] text-[#7C8AA0] mb-1.5 block">NIP</label>
                  <input
                    value={contactForm.nip}
                    onChange={(e) => {
                      setContactForm((f) => ({ ...f, nip: e.target.value }));
                      setContactDirty(true);
                    }}
                    placeholder="000-000-00-00"
                    className="w-full font-[family-name:var(--font-mono)] text-[14.5px] bg-[#F4F7FB] rounded-[10px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                  />
                </div>
                {contactDirty && (
                  <button
                    onClick={saveContact}
                    disabled={savingContact}
                    className="mt-1 px-4 py-2.5 rounded-[10px] bg-blueprint text-white text-[13px] font-semibold disabled:opacity-50"
                  >
                    {savingContact ? "Zapisywanie..." : "Zapisz dane kontaktowe"}
                  </button>
                )}
              </div>
              {modalLead.notes && (
                <div className="mt-[10px] bg-azure/5 border-l-[3px] border-azure rounded-[10px] py-[12px] px-4 text-[13.5px] text-[#1f3a5f] leading-relaxed">
                  {modalLead.notes}
                </div>
              )}

              {/* Numer konta */}
              <div className={`${lbl} mt-6 mb-2`}>Numer konta klienta (do zwrotów)</div>
              <input
                value={meta.bank}
                onChange={(e) => updateMeta({ bank: e.target.value })}
                placeholder="PL00 0000 0000 0000 0000 0000 0000"
                className="w-full font-[family-name:var(--font-mono)] text-[14.5px] bg-white rounded-[10px] px-4 py-[13px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
              />

              {/* Reprezentanci */}
              <div className="flex items-center justify-between mt-5 mb-2">
                <span className={lbl}>Reprezentanci do umowy</span>
                <button
                  onClick={() => updateMeta({ reps: [...meta.reps, { name: "", position: "", email: "" }] })}
                  className="text-[12.5px] font-semibold text-azure"
                >
                  + Dodaj osobę
                </button>
              </div>
              {meta.reps.length === 0 && (
                <p className="text-[12px] text-[#9AA7B8] mb-2">
                  Brak reprezentantów — umowa użyje osoby kontaktowej z karty klienta.
                </p>
              )}
              <div className="flex flex-col gap-2.5">
                {meta.reps.map((r, idx) => (
                  <div key={idx} className="bg-white rounded-xl p-3.5 flex flex-col gap-2.5">
                    <div className="flex items-center justify-between">
                      <span className="text-[11px] font-semibold text-[#9AA7B8] uppercase tracking-wide">
                        Osoba {idx + 1}
                      </span>
                      <button
                        onClick={() => updateMeta({ reps: meta.reps.filter((_, k) => k !== idx) })}
                        className="w-7 h-7 rounded-full bg-danger/10 text-danger flex items-center justify-center text-[14px]"
                      >
                        ✕
                      </button>
                    </div>
                    <input
                      value={r.name}
                      onChange={(e) => updateMeta({ reps: meta.reps.map((x, k) => (k === idx ? { ...x, name: e.target.value } : x)) })}
                      placeholder="Imię i nazwisko"
                      className="text-[14px] bg-[#F4F7FB] rounded-[10px] px-[13px] py-[11px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                    />
                    <input
                      value={r.position}
                      onChange={(e) => updateMeta({ reps: meta.reps.map((x, k) => (k === idx ? { ...x, position: e.target.value } : x)) })}
                      placeholder="Stanowisko (np. Prezes zarządu)"
                      className="text-[14px] bg-[#F4F7FB] rounded-[10px] px-[13px] py-[11px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                    />
                    <input
                      value={r.email}
                      onChange={(e) => updateMeta({ reps: meta.reps.map((x, k) => (k === idx ? { ...x, email: e.target.value } : x)) })}
                      placeholder="E-mail"
                      className="text-[14px] bg-[#F4F7FB] rounded-[10px] px-[13px] py-[11px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all"
                    />
                  </div>
                ))}
              </div>

              {metaDirty && (
                <button
                  onClick={saveMeta}
                  className="mt-3 px-4 py-2.5 rounded-[10px] bg-blueprint text-white text-[13px] font-semibold"
                >
                  Zapisz zmiany
                </button>
              )}

              {/* Wybór planu */}
              <div className={`${lbl} mt-5 mb-2`}>Wybierz plan do umowy</div>
              <div className="flex gap-2">
                {CONTRACT_PLANS.map((p) => (
                  <button
                    key={p}
                    onClick={() => setContractPlan(p)}
                    className={`flex-1 text-center py-[11px] px-[6px] rounded-[10px] text-[13px] font-semibold capitalize transition-colors ${
                      contractPlan === p ? "bg-blueprint text-white" : "bg-[#F4F7FB] text-[#5A6B80]"
                    }`}
                  >
                    {p}
                  </button>
                ))}
              </div>

              {/* Akcje dokumentów */}
              <div className="mt-5 flex flex-col gap-[10px]">
                <button
                  onClick={genContract}
                  className="flex items-center gap-3 p-4 rounded-[13px] bg-gradient-to-br from-azure to-blueprint text-left hover:brightness-105 active:scale-[0.99] transition-all"
                >
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
                    <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z" />
                  </svg>
                  <div>
                    <div className="font-[family-name:var(--font-heading)] font-semibold text-[14.5px] text-white">Wygeneruj umowę</div>
                    <div className="text-[12px] text-white/80 mt-[2px]">Wypełnia wzór danymi klienta i reprezentantami → podgląd → PDF</div>
                  </div>
                </button>
                <button
                  onClick={genInvoice}
                  className="flex items-center gap-3 p-4 rounded-[13px] bg-white border border-[#E4EBF3] text-left hover:border-blueprint/30 active:scale-[0.99] transition-all"
                >
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#173A6A" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
                    <path d="M9 7h6M9 11h6M9 15h4M5 3h14a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z" />
                  </svg>
                  <div>
                    <div className="font-[family-name:var(--font-heading)] font-semibold text-[14.5px] text-blueprint">Wystaw fakturę</div>
                    <div className="text-[12px] text-[#7C8AA0] mt-[2px]">PDF + wysyłka do KSeF</div>
                  </div>
                </button>
              </div>

              {/* Historia dokumentów */}
              <div className={`${lbl} mt-5 mb-2`}>Historia dokumentów</div>
              <div className="flex flex-col gap-2">
                {docs.length === 0 ? (
                  <div className="text-[13px] text-[#9AA7B8] py-2">
                    Brak wygenerowanych dokumentów. Trafią tu automatycznie po wygenerowaniu.
                  </div>
                ) : (
                  docs.map((d) => (
                    <div key={d.id} className="bg-white rounded-[11px] py-3 px-[14px] flex items-center gap-3">
                      <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#173A6A" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
                        <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z" />
                      </svg>
                      <div className="flex-1 min-w-0">
                        <div className="text-[13.5px] font-semibold capitalize">{d.type}</div>
                        <div className="font-[family-name:var(--font-mono)] text-[11px] text-[#9AA7B8] mt-[2px]">
                          {new Date(d.created_at).toLocaleDateString("pl-PL")} · {DOC_STATUS_LABELS[d.status] ?? d.status}
                        </div>
                      </div>
                    </div>
                  ))
                )}
              </div>

              <Link
                href={`/customers/${modalLead.id}`}
                className="block text-center mt-5 text-[13px] font-semibold text-azure hover:text-azure-dark transition-colors"
              >
                Pełna historia interakcji i zadań →
              </Link>
            </div>
          </div>
        </div>
      )}

      {/* Modal podglądu dokumentu */}
      {docPreview && (
        <div
          className="fixed inset-0 bg-ink/55 flex items-center justify-center z-[60] p-6"
          onClick={() => setDocPreview(null)}
        >
          <div
            className="bg-white rounded-[20px] shadow-[0_24px_70px_rgba(14,26,43,.4)] w-[560px] max-w-full max-h-[88vh] flex flex-col overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-[18px] px-[22px] border-b border-[#EEF2F8] flex items-center justify-between">
              <div className="font-[family-name:var(--font-heading)] font-bold text-base text-ink">
                {docPreview.title}
              </div>
              <button
                onClick={() => setDocPreview(null)}
                className="w-7 h-7 rounded-full bg-[#F4F7FB] flex items-center justify-center text-sm text-[#5A6B80]"
              >
                ✕
              </button>
            </div>
            <div className="p-[22px] overflow-y-auto flex-1 bg-[#FAFBFD]">
              <pre className="whitespace-pre-wrap font-[family-name:var(--font-mono)] text-[12.5px] leading-[1.7] text-[#1f2937] bg-white rounded-xl p-[18px] shadow-[0_1px_4px_rgba(14,26,43,.06)] m-0">
                {docPreview.text}
              </pre>
            </div>
            <div className="p-4 px-[22px] border-t border-[#EEF2F8] flex gap-[10px]">
              <button
                onClick={() => setDocPreview(null)}
                disabled={sendingDoc}
                className="flex-1 text-center py-3 rounded-[11px] bg-[#F4F7FB] text-[#5A6B80] font-semibold text-[13.5px] disabled:opacity-50"
              >
                Anuluj, chcę poprawić
              </button>
              <button
                onClick={confirmSendDoc}
                disabled={sendingDoc}
                className="flex-[1.4] text-center py-3 rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50"
              >
                {sendingDoc ? "Wysyłanie..." : "Wygląda dobrze — wyślij"}
              </button>
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

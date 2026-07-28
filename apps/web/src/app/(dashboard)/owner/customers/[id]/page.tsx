"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState, use } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import {
  CrmLead,
  CrmInteraction,
  CrmTask,
  CrmInvoice,
  LeadStage,
  STAGE_LABELS,
  STAGE_COLORS,
  STAGE_ORDER,
} from "@/lib/types";

interface TimelineEvent {
  id: string;
  kind: "note" | "stage_change" | "email" | "invoice" | "document" | "auto";
  text: string;
  when: string;
}

const EVENT_META: Record<TimelineEvent["kind"], { label: string; color: string }> = {
  note: { label: "Notatka", color: "#3E7BD6" },
  stage_change: { label: "Etap", color: "#173A6A" },
  email: { label: "E-mail", color: "#2E9E6B" },
  invoice: { label: "Faktura", color: "#F2A900" },
  document: { label: "Dokument", color: "#8B5CF6" },
  auto: { label: "Auto", color: "#6B7A90" },
};

export default function CustomerDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const supabase = createClient();

  const [lead, setLead] = useState<CrmLead | null>(null);
  const [timeline, setTimeline] = useState<TimelineEvent[]>([]);
  const [tasks, setTasks] = useState<CrmTask[]>([]);
  const [invoices, setInvoices] = useState<CrmInvoice[]>([]);
  const [loading, setLoading] = useState(true);
  const [noteText, setNoteText] = useState("");
  const [savingNote, setSavingNote] = useState(false);
  const [notFound, setNotFound] = useState(false);
  const [editing, setEditing] = useState(false);
  const [editForm, setEditForm] = useState({
    contact_name: "", contact_email: "", contact_phone: "", nip: "",
    plan: "", mrr: "", contract_end: "", notes: "",
  });
  const [savingEdit, setSavingEdit] = useState(false);
  const [newTask, setNewTask] = useState("");
  const [anonymizing, setAnonymizing] = useState(false);

  const fetchAll = async () => {
    setLoading(true);
    const [leadRes, interactionsRes, tasksRes, invoicesRes, emailsRes, docsRes] = await Promise.all([
      supabase.from("crm_leads").select("*").eq("id", id).single(),
      supabase
        .from("crm_interactions")
        .select("*")
        .eq("lead_id", id)
        .order("created_at", { ascending: false }),
      supabase
        .from("crm_tasks")
        .select("*")
        .eq("lead_id", id)
        .order("due_date", { ascending: true }),
      supabase
        .from("crm_invoices")
        .select("*")
        .eq("lead_id", id)
        .order("issued_at", { ascending: false }),
      supabase
        .from("crm_emails")
        .select("id, subject, status, created_at, sent_at")
        .eq("lead_id", id),
      supabase
        .from("client_documents")
        .select("id, title, status, created_at")
        .eq("lead_id", id),
    ]);

    if (leadRes.error || !leadRes.data) {
      setNotFound(true);
      setLoading(false);
      return;
    }

    const leadData = leadRes.data as CrmLead;
    setLead(leadData);
    const invs = (invoicesRes.data as CrmInvoice[]) ?? [];
    setInvoices(invs);
    setTasks((tasksRes.data as CrmTask[]) ?? []);

    // Timeline (wzorzec HubSpot Record): jedna oś czasu z wszystkich modułów
    const events: TimelineEvent[] = [];
    for (const it of (interactionsRes.data as CrmInteraction[]) ?? []) {
      events.push({
        id: `i-${it.id}`,
        kind: it.type === "stage_change" ? "stage_change" : it.type === "auto" ? "auto" : "note",
        text: it.summary,
        when: it.created_at,
      });
    }
    for (const e of emailsRes.data ?? []) {
      events.push({
        id: `e-${e.id}`,
        kind: "email",
        text: `${e.status === "draft" ? "Szkic" : "Wysłano"}: ${e.subject}`,
        when: e.sent_at ?? e.created_at,
      });
    }
    for (const inv of invs) {
      events.push({
        id: `f-${inv.id}`,
        kind: "invoice",
        text: `Faktura ${inv.number} — ${inv.amount.toLocaleString("pl-PL")} ${inv.currency} (${inv.status === "paid" ? "opłacona" : inv.status === "overdue" ? "zaległa" : "wystawiona"})`,
        when: inv.issued_at,
      });
    }
    for (const d of docsRes.data ?? []) {
      events.push({
        id: `d-${d.id}`,
        kind: "document",
        text: `${d.title} (${d.status})`,
        when: d.created_at,
      });
    }
    events.sort((a, b) => b.when.localeCompare(a.when));
    setTimeline(events);

    setEditForm({
      contact_name: leadData.contact_name ?? "",
      contact_email: leadData.contact_email ?? "",
      contact_phone: leadData.contact_phone ?? "",
      nip: leadData.nip ?? "",
      plan: leadData.plan ?? "",
      mrr: leadData.mrr ? String(leadData.mrr) : "",
      contract_end: leadData.contract_end ?? "",
      notes: leadData.notes ?? "",
    });
    setLoading(false);
  };

  const saveEdit = async () => {
    if (!lead) return;
    setSavingEdit(true);
    const { error } = await supabase
      .from("crm_leads")
      .update({
        contact_name: editForm.contact_name || null,
        contact_email: editForm.contact_email || null,
        contact_phone: editForm.contact_phone || null,
        nip: editForm.nip || null,
        plan: editForm.plan || null,
        mrr: Number(editForm.mrr) || 0,
        contract_end: editForm.contract_end || null,
        notes: editForm.notes || null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", lead.id);
    setSavingEdit(false);
    if (!error) {
      await supabase.from("crm_interactions").insert({
        lead_id: lead.id,
        type: "note",
        summary: "Zaktualizowano dane klienta",
      });
      setEditing(false);
      fetchAll();
    }
  };

  const toggleTask = async (task: CrmTask) => {
    setTasks((prev) => prev.map((t) => (t.id === task.id ? { ...t, done: !t.done } : t)));
    const { error } = await supabase.from("crm_tasks").update({ done: !task.done }).eq("id", task.id);
    if (error) {
      // Rollback optymistycznej aktualizacji - inaczej UI pokazuje stan
      // niezgodny z bazą bez żadnego ostrzeżenia.
      setTasks((prev) => prev.map((t) => (t.id === task.id ? { ...t, done: task.done } : t)));
    }
  };

  const addTask = async () => {
    if (!newTask.trim() || !lead) return;
    const { error } = await supabase.from("crm_tasks").insert({
      lead_id: lead.id,
      title: newTask.trim(),
      due_date: new Date().toISOString().slice(0, 10),
      priority: "Normalny",
    });
    if (error) return;
    setNewTask("");
    fetchAll();
  };

  const handleAnonymize = async () => {
    if (!lead) return;
    if (
      !confirm(
        `Zanonimizować dane osobowe klienta "${lead.company_name}"? Usuniesz dane kontaktowe, historię interakcji, e-maile i treść dokumentów (nieodwracalne). Faktury zostają dla celów podatkowych.`
      )
    )
      return;
    setAnonymizing(true);
    const { error } = await supabase.rpc("crm_anonymize_lead", { p_lead_id: lead.id });
    setAnonymizing(false);
    if (error) {
      alert("Błąd: " + error.message);
      return;
    }
    fetchAll();
  };

   
  useEffect(() => {
    void fetchAll();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const handleStageChange = async (newStage: LeadStage) => {
    if (!lead) return;
    const { error } = await supabase
      .from("crm_leads")
      .update({ stage: newStage, updated_at: new Date().toISOString() })
      .eq("id", lead.id);

    if (!error) {
      await supabase.from("crm_interactions").insert({
        lead_id: lead.id,
        type: "stage_change",
        summary: `Zmiana etapu: ${STAGE_LABELS[lead.stage]} → ${STAGE_LABELS[newStage]}`,
      });
      fetchAll();
    }
  };

  const handleAddNote = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!noteText.trim() || !lead) return;
    setSavingNote(true);

    const { error } = await supabase.from("crm_interactions").insert({
      lead_id: lead.id,
      type: "note",
      summary: noteText.trim(),
    });

    if (!error) {
      setNoteText("");
      fetchAll();
    }
    setSavingNote(false);
  };

  if (loading) {
    return (
      <div className="max-w-5xl mx-auto py-20 text-center text-ink/40">
        Ładowanie...
      </div>
    );
  }

  if (notFound || !lead) {
    return (
      <div className="max-w-5xl mx-auto py-20 text-center">
        <p className="text-ink/50 mb-4">Nie znaleziono klienta.</p>
        <Link href="/customers" className="text-azure hover:text-azure-dark">
          Wróć do listy klientów
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div>
        <Link
          href="/customers"
          className="text-sm text-ink/50 hover:text-azure transition-colors inline-flex items-center gap-1.5 mb-3"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
          </svg>
          Wróć do listy
        </Link>
        <div className="flex items-start justify-between">
          <div>
            <h1 className="text-2xl font-bold text-ink">{lead.company_name}</h1>
            <p className="text-sm text-ink/50 mt-1">
              {lead.contact_name} {lead.contact_email && `· ${lead.contact_email}`}
            </p>
          </div>
          <span
            className={`inline-block px-3 py-1.5 rounded-full text-sm font-medium ${STAGE_COLORS[lead.stage]}`}
          >
            {STAGE_LABELS[lead.stage]}
          </span>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-ink">Dane firmy</h2>
              <button
                onClick={() => setEditing((v) => !v)}
                className="text-xs font-semibold text-azure hover:text-azure-dark"
              >
                {editing ? "Anuluj" : "Edytuj"}
              </button>
            </div>

            {editing ? (
              <div className="space-y-3">
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">Osoba kontaktowa</label>
                    <input value={editForm.contact_name} onChange={(e) => setEditForm({ ...editForm, contact_name: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">Telefon</label>
                    <input value={editForm.contact_phone} onChange={(e) => setEditForm({ ...editForm, contact_phone: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">E-mail</label>
                    <input value={editForm.contact_email} onChange={(e) => setEditForm({ ...editForm, contact_email: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">NIP</label>
                    <input value={editForm.nip} onChange={(e) => setEditForm({ ...editForm, nip: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">Plan</label>
                    <input value={editForm.plan} onChange={(e) => setEditForm({ ...editForm, plan: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div>
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">MRR (zł)</label>
                    <input type="number" value={editForm.mrr} onChange={(e) => setEditForm({ ...editForm, mrr: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure font-[family-name:var(--font-mono)]" />
                  </div>
                  <div className="col-span-2">
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">Koniec umowy</label>
                    <input type="date" value={editForm.contract_end} onChange={(e) => setEditForm({ ...editForm, contract_end: e.target.value })} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure" />
                  </div>
                  <div className="col-span-2">
                    <label className="text-ink/40 text-xs uppercase tracking-wider mb-1 block">Notatki</label>
                    <textarea value={editForm.notes} onChange={(e) => setEditForm({ ...editForm, notes: e.target.value })} rows={3} className="w-full px-3 py-2 border border-mist rounded-lg text-sm outline-none focus:border-azure resize-none" />
                  </div>
                </div>
                <button
                  onClick={saveEdit}
                  disabled={savingEdit}
                  className="px-5 py-2 bg-azure text-white text-sm font-semibold rounded-lg disabled:opacity-50"
                >
                  {savingEdit ? "Zapisywanie..." : "Zapisz zmiany"}
                </button>
              </div>
            ) : (
              <dl className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">NIP</dt>
                  <dd className="text-ink">{lead.nip ?? "—"}</dd>
                </div>
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">Telefon</dt>
                  <dd className="text-ink">{lead.contact_phone ?? "—"}</dd>
                </div>
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">Plan</dt>
                  <dd className="text-ink">{lead.plan ?? "—"}</dd>
                </div>
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">MRR</dt>
                  <dd className="text-ink font-[family-name:var(--font-mono)]">
                    {lead.mrr > 0 ? `${lead.mrr.toLocaleString("pl-PL")} PLN` : "—"}
                  </dd>
                </div>
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">Źródło</dt>
                  <dd className="text-ink capitalize">{lead.source}</dd>
                </div>
                <div>
                  <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">Koniec umowy</dt>
                  <dd className="text-ink">
                    {lead.contract_end
                      ? new Date(lead.contract_end).toLocaleDateString("pl-PL")
                      : "—"}
                  </dd>
                </div>
              </dl>
            )}
            {!editing && lead.notes && (
              <div className="mt-4 pt-4 border-t border-mist">
                <dt className="text-ink/40 text-xs uppercase tracking-wider mb-1">Notatki</dt>
                <dd className="text-ink/70 text-sm">{lead.notes}</dd>
              </div>
            )}
            {lead.estate_id && (
              <div className="mt-4 pt-4 border-t border-mist">
                <a
                  href={`https://panel.mestio.pl/estates/${lead.estate_id}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-sm text-azure hover:text-azure-dark transition-colors inline-flex items-center gap-1.5"
                >
                  Otwórz panel zarządu →
                  <svg className="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                </a>
              </div>
            )}
          </div>

          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-ink">Timeline</h2>
              <span className="text-[10.5px] text-ink/40">notatki · e-maile · faktury · dokumenty · etapy</span>
            </div>
            <form onSubmit={handleAddNote} className="flex gap-2 mb-5">
              <input
                type="text"
                value={noteText}
                onChange={(e) => setNoteText(e.target.value)}
                placeholder="Dodaj notatkę..."
                className="flex-1 px-4 py-2 border border-mist rounded-[var(--radius-btn)] text-sm text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
              />
              <button
                type="submit"
                disabled={savingNote || !noteText.trim()}
                className="px-4 py-2 bg-azure text-white text-sm font-medium rounded-[var(--radius-btn)] hover:bg-azure-dark transition-colors disabled:opacity-50"
              >
                Dodaj
              </button>
            </form>

            {timeline.length === 0 ? (
              <p className="text-sm text-ink/40 text-center py-6">
                Brak historii. Wszystko co się dzieje z tym klientem (maile, faktury, dokumenty, notatki) pojawi się tutaj.
              </p>
            ) : (
              <ul className="space-y-3">
                {timeline.map((ev) => {
                  const meta = EVENT_META[ev.kind];
                  return (
                    <li key={ev.id} className="flex gap-3 text-sm">
                      <div className="w-2 h-2 rounded-full mt-1.5 shrink-0" style={{ background: meta.color }} />
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <span
                            className="font-[family-name:var(--font-mono)] text-[9px] font-semibold px-[7px] py-[1px] rounded-full uppercase shrink-0"
                            style={{ background: `${meta.color}22`, color: meta.color }}
                          >
                            {meta.label}
                          </span>
                          <p className="text-ink">{ev.text}</p>
                        </div>
                        <p className="text-xs text-ink/40 mt-0.5">
                          {new Date(ev.when).toLocaleString("pl-PL")}
                        </p>
                      </div>
                    </li>
                  );
                })}
              </ul>
            )}
          </div>
        </div>

        <div className="space-y-6">
          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <h2 className="text-sm font-semibold text-ink mb-3">Zmień etap</h2>
            <select
              value={lead.stage}
              onChange={(e) => handleStageChange(e.target.value as LeadStage)}
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-sm text-ink focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            >
              {STAGE_ORDER.map((s) => (
                <option key={s} value={s}>
                  {STAGE_LABELS[s]}
                </option>
              ))}
            </select>
          </div>

          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <h2 className="text-sm font-semibold text-ink mb-3">Zadania</h2>
            <div className="flex gap-2 mb-3">
              <input
                value={newTask}
                onChange={(e) => setNewTask(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && addTask()}
                placeholder="Nowe zadanie..."
                className="flex-1 px-3 py-1.5 border border-mist rounded-lg text-xs outline-none focus:border-azure"
              />
              <button onClick={addTask} disabled={!newTask.trim()} className="px-3 py-1.5 bg-azure text-white text-xs font-semibold rounded-lg disabled:opacity-50">
                +
              </button>
            </div>
            {tasks.length === 0 ? (
              <p className="text-xs text-ink/40 text-center py-4">Brak zadań.</p>
            ) : (
              <ul className="space-y-2">
                {tasks.map((task) => (
                  <li key={task.id} className="flex items-start gap-2 text-sm">
                    <button
                      onClick={() => toggleTask(task)}
                      className={`w-4 h-4 rounded border mt-0.5 shrink-0 flex items-center justify-center transition-colors ${
                        task.done ? "bg-success border-success" : "border-mist hover:border-azure"
                      }`}
                    >
                      {task.done && (
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5 9-11" /></svg>
                      )}
                    </button>
                    <div>
                      <p className={task.done ? "text-ink/40 line-through" : "text-ink"}>
                        {task.title}
                      </p>
                      {task.due_date && (
                        <p className="text-xs text-ink/40">
                          {new Date(task.due_date).toLocaleDateString("pl-PL")}
                        </p>
                      )}
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>

          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <h2 className="text-sm font-semibold text-ink mb-3">Faktury</h2>
            {invoices.length === 0 ? (
              <p className="text-xs text-ink/40 text-center py-4">Brak faktur.</p>
            ) : (
              <ul className="space-y-3">
                {invoices.map((inv) => (
                  <li key={inv.id} className="flex justify-between items-center text-sm">
                    <div>
                      <p className="text-ink font-[family-name:var(--font-mono)]">
                        {inv.number}
                      </p>
                      <p className="text-xs text-ink/40">
                        {new Date(inv.issued_at).toLocaleDateString("pl-PL")}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="text-ink font-medium">
                        {inv.amount.toLocaleString("pl-PL")} {inv.currency}
                      </p>
                      <p
                        className={`text-xs ${
                          inv.status === "paid"
                            ? "text-success"
                            : inv.status === "overdue"
                            ? "text-danger"
                            : "text-ink/40"
                        }`}
                      >
                        {inv.status === "paid"
                          ? "Opłacona"
                          : inv.status === "overdue"
                          ? "Zaległa"
                          : "Wystawiona"}
                      </p>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>

          <div className="bg-white rounded-[var(--radius-card)] border border-[#E9EEF5] p-6">
            <h2 className="text-sm font-semibold text-ink mb-2">RODO</h2>
            <p className="text-xs text-ink/40 mb-3 leading-relaxed">
              Realizuje prawo do bycia zapomnianym (art. 17 RODO). Usuwa dane osobowe osoby kontaktowej,
              historię, e-maile i treść dokumentów. Faktury zostają (5 lat, obowiązek podatkowy).
            </p>
            <button
              onClick={handleAnonymize}
              disabled={anonymizing}
              className="w-full px-4 py-2 border border-danger/30 text-danger text-xs font-semibold rounded-lg hover:bg-danger/5 transition-colors disabled:opacity-50"
            >
              {anonymizing ? "Anonimizowanie..." : "Zanonimizuj klienta"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

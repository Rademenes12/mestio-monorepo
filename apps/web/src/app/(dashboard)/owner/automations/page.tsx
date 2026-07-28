"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { Automation } from "@/lib/automations";
import { STAGE_LABELS, LeadStage } from "@/lib/types";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${a})`;
}

const TRIGGER_META: Record<string, { label: string; icon: string; color: string; daysLabel: string | null }> = {
  new_lead: {
    label: "Nowy lead",
    icon: "M12 6v12M6 12h12",
    color: "#3E7BD6",
    daysLabel: null,
  },
  contract_expiring: {
    label: "Umowa wygasa za X dni",
    icon: "M12 8v4l3 2M12 3a9 9 0 100 18 9 9 0 000-18z",
    color: "#F2A900",
    daysLabel: "Ile dni przed końcem umowy?",
  },
  invoice_overdue: {
    label: "Faktura zaległa od X dni",
    icon: "M12 9v4M12 17h.01M10.3 3.9 2.4 18a2 2 0 0 0 1.7 3h15.8a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z",
    color: "#C0392B",
    daysLabel: "Ile dni po terminie płatności?",
  },
  inactive_client: {
    label: "Klient nieaktywny od X dni",
    icon: "M12 12.5a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM5 20a7 7 0 0 1 14 0",
    color: "#173A6A",
    daysLabel: "Ile dni bez aktywności?",
  },
};

const ACTION_META: Record<string, string> = {
  create_task: "Utwórz zadanie",
  email_draft: "Przygotuj szkic e-maila (do akceptacji w Poczcie)",
};

const SEGMENT_STAGES: LeadStage[] = ["lead", "contact", "demo", "offer", "contract", "won", "onboarding", "active", "risk", "churned", "lost"];
const SEGMENT_PLANS = ["start", "standard", "pro", "enterprise"];
const SEGMENT_SOURCES = ["website", "referral", "cold", "other"];

const EMPTY_FORM = {
  name: "",
  trigger_type: "new_lead" as Automation["trigger_type"],
  trigger_days: 14,
  segment: { stages: [] as string[], plans: [] as string[], sources: [] as string[] },
  action_type: "create_task" as Automation["action_type"],
  action_config: { title: "", subject: "", body: "" },
};

export default function AutomationsPage() {
  const [autos, setAutos] = useState<Automation[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2600);
  };

  const fetchAll = async () => {
    const { data, error } = await supabase
      .from("crm_automations")
      .select("*")
      .order("created_at", { ascending: true });
    if (error) notify("Błąd wczytywania: " + error.message);
    setAutos((data as Automation[]) ?? []);
    setLoading(false);
  };

  useEffect(() => {
    void fetchAll();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const toggle = async (a: Automation) => {
    // optymistycznie
    setAutos((prev) => prev.map((x) => (x.id === a.id ? { ...x, enabled: !x.enabled } : x)));
    const { error } = await supabase
      .from("crm_automations")
      .update({ enabled: !a.enabled })
      .eq("id", a.id);
    if (error) {
      notify("Błąd: " + error.message);
      fetchAll();
    }
  };

  const openNew = () => {
    setEditingId(null);
    setForm(EMPTY_FORM);
    setModalOpen(true);
  };

  const openEdit = (a: Automation) => {
    setEditingId(a.id);
    setForm({
      name: a.name,
      trigger_type: a.trigger_type,
      trigger_days: a.trigger_days,
      segment: {
        stages: a.segment?.stages ?? [],
        plans: a.segment?.plans ?? [],
        sources: a.segment?.sources ?? [],
      },
      action_type: a.action_type,
      action_config: {
        title: a.action_config?.title ?? "",
        subject: a.action_config?.subject ?? "",
        body: a.action_config?.body ?? "",
      },
    });
    setModalOpen(true);
  };

  const remove = async (a: Automation) => {
    if (!confirm(`Usunąć automatyzację „${a.name}"?`)) return;
    const { error } = await supabase.from("crm_automations").delete().eq("id", a.id);
    if (error) notify("Błąd: " + error.message);
    else {
      notify("Usunięto automatyzację");
      fetchAll();
    }
  };

  const save = async () => {
    if (!form.name.trim()) {
      notify("Podaj nazwę automatyzacji");
      return;
    }
    setSaving(true);
    const payload = {
      name: form.name.trim(),
      trigger_type: form.trigger_type,
      trigger_days: form.trigger_days,
      segment: form.segment,
      action_type: form.action_type,
      action_config:
        form.action_type === "create_task"
          ? { title: form.action_config.title || form.name }
          : { subject: form.action_config.subject || form.name, body: form.action_config.body },
    };
    const { error } = editingId
      ? await supabase.from("crm_automations").update(payload).eq("id", editingId)
      : await supabase.from("crm_automations").insert(payload);
    setSaving(false);
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    setModalOpen(false);
    notify(editingId ? "Zapisano zmiany" : "Dodano automatyzację");
    fetchAll();
  };

  const toggleSeg = (kind: "stages" | "plans" | "sources", value: string) => {
    setForm((f) => {
      const arr = f.segment[kind];
      return {
        ...f,
        segment: {
          ...f.segment,
          [kind]: arr.includes(value) ? arr.filter((v) => v !== value) : [...arr, value],
        },
      };
    });
  };

  const segSummary = (a: Automation) => {
    const parts: string[] = [];
    if (a.segment?.stages?.length) parts.push("etapy: " + a.segment.stages.map((s) => STAGE_LABELS[s as LeadStage] ?? s).join(", "));
    if (a.segment?.plans?.length) parts.push("plany: " + a.segment.plans.join(", "));
    if (a.segment?.sources?.length) parts.push("źródła: " + a.segment.sources.join(", "));
    return parts.length ? parts.join(" · ") : "wszyscy klienci";
  };

  const lbl = "font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase";
  const inp = "w-full text-[13.5px] bg-white rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all";
  const chip = (active: boolean) =>
    `px-[12px] py-[7px] rounded-full text-[12px] font-semibold cursor-pointer transition-colors ${
      active ? "bg-blueprint text-white" : "bg-white text-[#5A6B80] border border-[#E4EBF3] hover:border-blueprint/30"
    }`;

  if (loading) {
    return (
      <div className="max-w-3xl mx-auto space-y-3 animate-pulse">
        {[0, 1, 2].map((i) => (
          <div key={i} className="h-[86px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />
        ))}
      </div>
    );
  }

  return (
    <div className="max-w-3xl mx-auto space-y-3">
      <div className="flex items-center justify-between">
        <div className="text-[12.5px] text-[#7C8AA0]">
          Reguły działają automatycznie: sprawdzane przy każdym wejściu na Pulpit, każda akcja wykonuje się dokładnie raz.
        </div>
        <button
          onClick={openNew}
          className="px-[16px] py-[10px] rounded-[10px] bg-gradient-to-br from-azure to-blueprint text-white text-[13.5px] font-semibold flex items-center gap-[6px] shrink-0 hover:brightness-105 active:scale-[0.98] transition-all"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.4" strokeLinecap="round"><path d="M12 6v12M6 12h12" /></svg>
          Nowa automatyzacja
        </button>
      </div>

      {autos.length === 0 ? (
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
          Brak automatyzacji. Kliknij „Nowa automatyzacja”, aby dodać pierwszą regułę.
        </div>
      ) : (
        autos.map((a) => {
          const tm = TRIGGER_META[a.trigger_type] ?? TRIGGER_META.new_lead;
          return (
            <div key={a.id} className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-[18px] px-5 flex items-center gap-[14px]">
              <div
                className="w-10 h-10 rounded-[12px] flex items-center justify-center shrink-0"
                style={{ background: tint(tm.color, 0.12), color: tm.color }}
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
                  <path d={tm.icon} />
                </svg>
              </div>
              <div className="flex-1 min-w-0">
                <div className="font-[family-name:var(--font-heading)] font-semibold text-[14px] text-ink">{a.name}</div>
                <div className="text-[12.5px] text-[#7C8AA0] mt-[3px]">
                  {tm.label.replace("X", String(a.trigger_days))} → {ACTION_META[a.action_type]}
                </div>
                <div className="font-[family-name:var(--font-mono)] text-[10.5px] text-[#9AA7B8] mt-[3px]">
                  Segment: {segSummary(a)}
                </div>
              </div>
              <div className="flex items-center gap-[8px] shrink-0">
                <button onClick={() => openEdit(a)} className="px-[13px] py-[8px] rounded-[9px] bg-[#F4F7FB] text-blueprint text-[12.5px] font-semibold hover:bg-[#EAEFF5] transition-colors">
                  Edytuj
                </button>
                <button onClick={() => remove(a)} className="px-[13px] py-[8px] rounded-[9px] bg-danger/10 text-danger text-[12.5px] font-semibold hover:bg-danger/20 transition-colors">
                  Usuń
                </button>
                <button
                  onClick={() => toggle(a)}
                  className="w-11 h-6 rounded-full p-[2px] flex items-center shrink-0 transition-colors"
                  style={{
                    background: a.enabled ? "#2E9E6B" : "#CBD6E4",
                    justifyContent: a.enabled ? "flex-end" : "flex-start",
                  }}
                >
                  <div className="w-5 h-5 rounded-full bg-white shadow-[0_1px_3px_rgba(0,0,0,.2)]" />
                </button>
              </div>
            </div>
          );
        })
      )}

      {/* ===== KREATOR / EDYTOR REGUŁY ===== */}
      {modalOpen && (
        <div className="fixed inset-0 bg-ink/50 flex items-center justify-center z-50 p-6" onClick={() => setModalOpen(false)}>
          <div
            className="bg-[#F6F8FB] rounded-[20px] shadow-[0_24px_70px_rgba(14,26,43,.4)] w-[560px] max-w-full max-h-[90vh] overflow-y-auto p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between">
              <div className="font-[family-name:var(--font-heading)] font-bold text-lg text-ink">
                {editingId ? "Edytuj automatyzację" : "Nowa automatyzacja"}
              </div>
              <button onClick={() => setModalOpen(false)} className="w-7 h-7 rounded-full bg-[#EAF0F7] flex items-center justify-center text-sm text-[#5A6B80]">✕</button>
            </div>

            <div className={`${lbl} mt-4 mb-[6px]`}>Nazwa</div>
            <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} placeholder="np. Ponaglenie po 7 dniach" className={inp} />

            {/* WYZWALACZ */}
            <div className={`${lbl} mt-4 mb-[7px]`}>1. Wyzwalacz</div>
            <div className="flex flex-wrap gap-[7px]">
              {Object.entries(TRIGGER_META).map(([k, v]) => (
                <button key={k} onClick={() => setForm({ ...form, trigger_type: k as Automation["trigger_type"] })} className={chip(form.trigger_type === k)}>
                  {v.label}
                </button>
              ))}
            </div>
            {TRIGGER_META[form.trigger_type].daysLabel && (
              <div className="mt-3 flex items-center gap-3">
                <span className="text-xs text-[#5A6B80]">{TRIGGER_META[form.trigger_type].daysLabel}</span>
                <input
                  type="number"
                  min={1}
                  value={form.trigger_days}
                  onChange={(e) => setForm({ ...form, trigger_days: Number(e.target.value) || 1 })}
                  className="w-20 text-sm bg-white rounded-[9px] px-3 py-[9px] text-center outline-none focus:ring-2 focus:ring-azure/30 transition-all font-[family-name:var(--font-mono)]"
                />
                <span className="text-xs text-[#9AA7B8]">dni</span>
              </div>
            )}

            {/* SEGMENT */}
            <div className={`${lbl} mt-4 mb-[7px]`}>2. Segment (puste = wszyscy, także przyszli klienci)</div>
            <div className="text-[10px] text-[#9AA7B8] mb-1">Etapy:</div>
            <div className="flex flex-wrap gap-[6px]">
              {SEGMENT_STAGES.map((s) => (
                <button key={s} onClick={() => toggleSeg("stages", s)} className={chip(form.segment.stages.includes(s))}>
                  {STAGE_LABELS[s]}
                </button>
              ))}
            </div>
            <div className="text-[10px] text-[#9AA7B8] mt-2 mb-1">Plany:</div>
            <div className="flex flex-wrap gap-[6px]">
              {SEGMENT_PLANS.map((p) => (
                <button key={p} onClick={() => toggleSeg("plans", p)} className={`${chip(form.segment.plans.includes(p))} capitalize`}>
                  {p}
                </button>
              ))}
            </div>
            <div className="text-[10px] text-[#9AA7B8] mt-2 mb-1">Źródła:</div>
            <div className="flex flex-wrap gap-[6px]">
              {SEGMENT_SOURCES.map((s) => (
                <button key={s} onClick={() => toggleSeg("sources", s)} className={chip(form.segment.sources.includes(s))}>
                  {s}
                </button>
              ))}
            </div>

            {/* AKCJA */}
            <div className={`${lbl} mt-4 mb-[7px]`}>3. Akcja</div>
            <div className="flex flex-wrap gap-[7px]">
              {Object.entries(ACTION_META).map(([k, v]) => (
                <button key={k} onClick={() => setForm({ ...form, action_type: k as Automation["action_type"] })} className={chip(form.action_type === k)}>
                  {v}
                </button>
              ))}
            </div>

            {form.action_type === "create_task" ? (
              <>
                <div className={`${lbl} mt-3 mb-[6px]`}>Treść zadania (zmienne: {"{{firma}}"}, {"{{data}}"})</div>
                <input
                  value={form.action_config.title}
                  onChange={(e) => setForm({ ...form, action_config: { ...form.action_config, title: e.target.value } })}
                  placeholder="np. Zadzwoń do {{firma}} w sprawie odnowienia"
                  className={inp}
                />
              </>
            ) : (
              <>
                <div className={`${lbl} mt-3 mb-[6px]`}>Temat e-maila (zmienne: {"{{firma}}"}, {"{{numer}}"}, {"{{kwota}}"}, {"{{data}}"})</div>
                <input
                  value={form.action_config.subject}
                  onChange={(e) => setForm({ ...form, action_config: { ...form.action_config, subject: e.target.value } })}
                  placeholder="np. Przypomnienie o płatności {{numer}}"
                  className={inp}
                />
                <div className={`${lbl} mt-3 mb-[6px]`}>Treść e-maila</div>
                <textarea
                  value={form.action_config.body}
                  onChange={(e) => setForm({ ...form, action_config: { ...form.action_config, body: e.target.value } })}
                  rows={5}
                  placeholder={"Dzień dobry,\n\nprzypominam o fakturze {{numer}} na {{kwota}} zł...\n\nPozdrawiam"}
                  className={`${inp} resize-y`}
                />
                <div className="text-[10.5px] text-[#9AA7B8] mt-1">
                  Szkic trafi do Poczty i czeka na Twoją akceptację — nic nie wysyła się samo.
                </div>
              </>
            )}

            <div className="flex gap-[10px] mt-5">
              <button onClick={() => setModalOpen(false)} className="flex-1 py-3 rounded-[11px] bg-[#EAF0F7] text-[#5A6B80] font-semibold text-[13.5px]">
                Anuluj
              </button>
              <button
                onClick={save}
                disabled={saving || !form.name.trim()}
                className="flex-[1.6] py-3 rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50"
              >
                {saving ? "Zapisywanie..." : editingId ? "Zapisz zmiany" : "Dodaj automatyzację"}
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

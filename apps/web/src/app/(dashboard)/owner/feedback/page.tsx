"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Feedback {
  id: string;
  source: string;
  author_email: string | null;
  category: string;
  title: string;
  description: string | null;
  status: string;
  created_at: string;
}

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${a})`;
}

const TYPE_META: Record<string, { label: string; color: string }> = {
  bug: { label: "Błąd", color: "#C0392B" },
  idea: { label: "Pomysł", color: "#3E7BD6" },
  complaint: { label: "Skarga", color: "#C98800" },
};

const STATUS_META: Record<string, { label: string; color: string }> = {
  new: { label: "nowe", color: "#3E7BD6" },
  in_review: { label: "w analizie", color: "#F2A900" },
  planned: { label: "zaplanowane", color: "#3E7BD6" },
  done: { label: "zrobione", color: "#2E9E6B" },
  rejected: { label: "odrzucone", color: "#6B7A90" },
};

const FILTERS = [
  { value: "all", label: "Wszystkie" },
  { value: "bug", label: "Błędy" },
  { value: "idea", label: "Pomysły" },
  { value: "complaint", label: "Skargi" },
];

export default function FeedbackPage() {
  const [items, setItems] = useState<Feedback[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("all");
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ title: "", description: "", category: "idea" });
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const supabase = createClient();

  const fetchAll = async () => {
    setLoading(true);
    const { data } = await supabase
      .from("feedback")
      .select("*")
      .order("created_at", { ascending: false });
    setItems((data as Feedback[]) ?? []);
    setLoading(false);
  };

   
  useEffect(() => {
    void fetchAll();
    // Otwórz formularz gdy przyszliśmy z przycisku "+ Dodaj pomysł" (?new=1)
    if (new URLSearchParams(window.location.search).get("new") === "1") {
      setShowForm(true);
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const filtered = filter === "all" ? items : items.filter((i) => i.category === filter);

  const updateStatus = async (id: string, status: string) => {
    const { error } = await supabase.from("feedback").update({ status }).eq("id", id);
    if (error) {
      setError("Nie udało się zmienić statusu: " + error.message);
      return;
    }
    fetchAll();
  };

  const handleSubmit = async () => {
    if (!form.title.trim()) return;
    setSaving(true);
    setError(null);
    const { error } = await supabase.from("feedback").insert({
      title: form.title,
      description: form.description || null,
      category: form.category,
      source: "own",
    });
    setSaving(false);
    if (error) {
      setError("Błąd zapisu: " + error.message);
      return;
    }
    setForm({ title: "", description: "", category: "idea" });
    setShowForm(false);
    fetchAll();
  };

  return (
    <div className="max-w-4xl mx-auto space-y-4">
      {showForm && (
        <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-6 space-y-4">
          <div>
            <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Tytuł</label>
            <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full text-sm bg-[#F4F7FB] rounded-[11px] px-3 py-[11px] text-ink outline-none" />
          </div>
          <div>
            <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Kategoria</label>
            <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full text-sm bg-[#F4F7FB] rounded-[11px] px-3 py-[11px] text-ink outline-none">
              <option value="idea">Pomysł</option>
              <option value="bug">Błąd</option>
              <option value="complaint">Skarga</option>
            </select>
          </div>
          <div>
            <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Opis</label>
            <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={4} className="w-full text-sm bg-[#F4F7FB] rounded-[11px] px-3 py-[11px] text-ink outline-none resize-none" />
          </div>
          {error && <div className="bg-danger/5 text-danger text-sm px-4 py-2.5 rounded-[11px] border border-danger/20">{error}</div>}
          <button onClick={handleSubmit} disabled={saving} className="px-6 py-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold rounded-[11px] disabled:opacity-50">
            {saving ? "Zapisywanie..." : "Dodaj pomysł"}
          </button>
        </div>
      )}

      <div className="flex gap-[8px] flex-wrap items-center justify-between">
        <div className="flex gap-[8px] flex-wrap">
        {FILTERS.map((f) => {
          const count = f.value === "all" ? items.length : items.filter((i) => i.category === f.value).length;
          const active = filter === f.value;
          return (
            <button
              key={f.value}
              onClick={() => setFilter(f.value)}
              className={`inline-flex items-center gap-[6px] px-[13px] py-[7px] rounded-full text-[12.5px] font-medium transition-colors ${
                active ? "bg-blueprint text-white" : "bg-white text-[#5A6B80] border border-[#E4EBF3]"
              }`}
            >
              {f.label}
              <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold opacity-80">{count}</span>
            </button>
          );
        })}
        </div>
        <button
          onClick={() => setShowForm((v) => !v)}
          className="px-[14px] py-[7px] rounded-full bg-azure text-white text-[12.5px] font-medium hover:bg-azure-dark transition-colors shrink-0"
        >
          {showForm ? "Zamknij formularz" : "+ Dodaj pomysł"}
        </button>
      </div>

      <div className="flex flex-col gap-[10px]">
        {loading ? (
          <div className="text-center text-[#9AA7B8] py-10">Ładowanie...</div>
        ) : filtered.length === 0 ? (
          <div className="text-center text-[#9AA7B8] py-[30px]">Brak zgłoszeń w tej kategorii.</div>
        ) : (
          filtered.map((fb) => {
            const tm = TYPE_META[fb.category] ?? TYPE_META.idea;
            return (
              <div key={fb.id} className="bg-white rounded-2xl shadow-[0_2px_12px_rgba(14,26,43,.06)] p-[15px] px-[17px]">
                <div className="flex items-center justify-between gap-[8px] flex-wrap">
                  <div className="flex items-center gap-[8px]">
                    <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full" style={{ background: tint(tm.color, 0.13), color: tm.color }}>
                      {tm.label}
                    </span>
                    <span className="font-[family-name:var(--font-mono)] text-[10.5px] text-[#8A98AB]">
                      {fb.source === "own" ? "Ty" : fb.author_email ?? "—"} · {fb.source === "own" ? "własny" : fb.source}
                    </span>
                  </div>
                  <span className="font-[family-name:var(--font-mono)] text-[10px] text-[#9AA7B8]">
                    {new Date(fb.created_at).toLocaleDateString("pl-PL")}
                  </span>
                </div>
                <div className="text-[13.5px] leading-[1.55] text-ink mt-[9px]">
                  <strong>{fb.title}</strong>
                  {fb.description && <> — {fb.description}</>}
                </div>
                <div className="flex gap-[7px] mt-[11px] flex-wrap">
                  {Object.entries(STATUS_META).map(([k, v]) => {
                    const active = fb.status === k;
                    return (
                      <button
                        key={k}
                        onClick={() => updateStatus(fb.id, k)}
                        className="px-[11px] py-[5px] rounded-full text-[11px] font-semibold transition-colors"
                        style={{
                          background: active ? v.color : "#F4F7FB",
                          color: active ? "#fff" : "#5A6B80",
                        }}
                      >
                        {v.label}
                      </button>
                    );
                  })}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export type MaintenanceTask = {
  id: string;
  title: string;
  recurrence_interval: number | null;
  recurrence_unit: string | null;
  recurrence_end_date: string | null;
};

const UNIT_LABEL: Record<string, string> = {
  Tydzien: "tygodni",
  Miesiac: "miesięcy",
  Rok: "lat",
};

export function MaintenanceList({ tasks }: { tasks: MaintenanceTask[] }) {
  if (tasks.length === 0) {
    return (
      <div className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-6 text-center">
        <p className="text-ink/40 text-[12.5px]">
          Brak zadań cyklicznych. Dodaj pierwsze, np. coroczny przegląd
          konstrukcyjny.
        </p>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      {tasks.map((t) => (
        <MaintenanceRow key={t.id} task={t} />
      ))}
    </div>
  );
}

function MaintenanceRow({ task }: { task: MaintenanceTask }) {
  const router = useRouter();
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleDelete = async () => {
    setError(null);
    setDeleting(true);
    const supabase = createClient();
    const { error: deleteError } = await supabase.from("fixflow_tasks").delete().eq("id", task.id);
    setDeleting(false);
    if (deleteError) {
      setError(`Nie udało się usunąć: ${deleteError.message}`);
      return;
    }
    router.refresh();
  };

  const cycleLabel = task.recurrence_interval
    ? `co ${task.recurrence_interval} ${UNIT_LABEL[task.recurrence_unit ?? ""] ?? task.recurrence_unit}`
    : "cykliczne";
  const endLabel = task.recurrence_end_date
    ? `do ${new Date(task.recurrence_end_date).toLocaleDateString("pl-PL")}`
    : "bez daty końca";

  return (
    <div className="bg-white rounded-[14px] shadow-[0_2px_10px_rgba(14,26,43,.05)] px-4 py-3.5 flex items-center gap-3">
      <div className="w-9 h-9 rounded-[10px] bg-[#2E9E6B]/10 flex items-center justify-center shrink-0">
        <svg
          className="w-[18px] h-[18px] text-[#2E9E6B]"
          fill="none"
          stroke="currentColor"
          strokeWidth={1.8}
          viewBox="0 0 24 24"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M4 4v6h6M20 20v-6h-6M20 9A8 8 0 0 0 6 5M4 15a8 8 0 0 0 14 4"
          />
        </svg>
      </div>
      <div className="flex-1 min-w-0">
        <p className="font-heading font-semibold text-[13.5px] text-ink">
          {task.title}
        </p>
        <p className="text-[11px] font-mono text-ink/40 mt-0.5">
          {cycleLabel} · {endLabel}
        </p>
      </div>
      <div>
        <button
          type="button"
          onClick={handleDelete}
          disabled={deleting}
          className="w-[30px] h-[30px] rounded-[9px] bg-paper flex items-center justify-center shrink-0 hover:bg-red-50 transition-colors disabled:opacity-50"
          title="Usuń"
        >
          <svg
            className="w-3.5 h-3.5 text-[#B0392B]"
            fill="none"
            stroke="currentColor"
            strokeWidth={2}
            viewBox="0 0 24 24"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M4 7h16M9 7V5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2M6 7l1 13a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1l1-13"
            />
          </svg>
        </button>
        {error && <p className="text-[11.5px] text-danger mt-1">{error}</p>}
      </div>
    </div>
  );
}

export function AddMaintenanceModal({ estateId }: { estateId: string }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    title: "",
    every: "1",
    unit: "Rok",
    hasEnd: false,
    end: "",
  });

  const resetAndClose = () => {
    setOpen(false);
    setForm({ title: "", every: "1", unit: "Rok", hasEnd: false, end: "" });
    setError(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!form.title.trim()) {
      setError("Podaj nazwę zadania.");
      return;
    }
    setLoading(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_tasks").insert({
      estate_id: estateId,
      title: form.title.trim(),
      kind: "maintenance",
      status: "Otwarte",
      is_recurring: true,
      recurrence_interval: parseInt(form.every, 10) || 1,
      recurrence_unit: form.unit,
      recurrence_end_date:
        form.hasEnd && form.end ? new Date(form.end).toISOString() : null,
    });
    setLoading(false);
    if (insertError) {
      setError(`Nie udało się dodać zadania: ${insertError.message}`);
      return;
    }
    resetAndClose();
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="flex items-center gap-1.5 text-azure text-[12.5px] font-semibold hover:text-azure/80 transition-colors"
      >
        + Nowe zadanie
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm p-6"
          onClick={resetAndClose}
        >
          <div
            className="bg-paper rounded-[20px] shadow-[0_20px_60px_rgba(14,26,43,.3)] w-full max-w-md p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-4">
              Nowe zadanie cykliczne
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Nazwa zadania
                </label>
                <input
                  type="text"
                  value={form.title}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                  placeholder="np. Przegląd konstrukcyjny budynku"
                  className="w-full px-3 py-2.5 rounded-xl bg-white text-sm focus:outline-none focus:ring-2 focus:ring-azure/40"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Powtarzaj co
                </label>
                <div className="flex gap-2">
                  <input
                    type="number"
                    min={1}
                    value={form.every}
                    onChange={(e) => setForm({ ...form, every: e.target.value })}
                    className="w-20 px-3 py-2.5 rounded-xl bg-white text-sm focus:outline-none focus:ring-2 focus:ring-azure/40"
                  />
                  <select
                    value={form.unit}
                    onChange={(e) => setForm({ ...form, unit: e.target.value })}
                    className="flex-1 px-3 py-2.5 rounded-xl bg-white text-sm focus:outline-none focus:ring-2 focus:ring-azure/40"
                  >
                    <option value="Tydzien">tygodni</option>
                    <option value="Miesiac">miesięcy</option>
                    <option value="Rok">lat</option>
                  </select>
                </div>
              </div>
              <label className="flex items-center gap-2.5 cursor-pointer">
                <button
                  type="button"
                  onClick={() => setForm({ ...form, hasEnd: !form.hasEnd })}
                  className={`relative w-[42px] h-6 rounded-full transition-colors shrink-0 ${
                    form.hasEnd ? "bg-[#2E9E6B]" : "bg-[#D4DEEA]"
                  }`}
                >
                  <span
                    className={`absolute top-0.5 left-0.5 w-[18px] h-[18px] rounded-full bg-white transition-transform ${
                      form.hasEnd ? "translate-x-[18px]" : ""
                    }`}
                  />
                </button>
                <span className="text-[13px] text-ink/70">
                  Ustaw datę zakończenia cyklu
                </span>
              </label>
              {form.hasEnd && (
                <input
                  type="date"
                  value={form.end}
                  onChange={(e) => setForm({ ...form, end: e.target.value })}
                  className="w-full px-3 py-2.5 rounded-xl bg-white text-sm focus:outline-none focus:ring-2 focus:ring-azure/40"
                />
              )}

              {error && <p className="text-[12.5px] text-danger">{error}</p>}

              <div className="flex gap-2.5 pt-1">
                <button
                  type="button"
                  onClick={resetAndClose}
                  className="flex-1 text-center py-3 rounded-xl bg-[#EAF0F7] text-[#5A6B80] font-semibold text-sm hover:bg-[#dde6f0] transition-colors"
                >
                  Anuluj
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-[1.5] text-center py-3 rounded-xl text-white font-semibold text-sm disabled:opacity-50 transition-opacity"
                  style={{
                    background: "linear-gradient(135deg,#3E7BD6,#173A6A)",
                  }}
                >
                  {loading ? "Dodawanie…" : "Dodaj zadanie"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

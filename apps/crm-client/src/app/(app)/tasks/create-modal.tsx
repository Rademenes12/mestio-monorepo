"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

const PRIORITIES = [
  { value: "low", label: "Niski", color: "#6B7A90" },
  { value: "normal", label: "Normalny", color: "#3E7BD6" },
  { value: "high", label: "Wysoki", color: "#F2A900" },
  { value: "critical", label: "Krytyczny", color: "#C0392B" },
];

export function CreateTaskModal({
  residents,
  estateId,
  userId,
}: {
  residents: { id: string; name: string | null }[];
  estateId: string;
  userId: string;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [kind, setKind] = useState<"resident" | "internal">("resident");
  const [form, setForm] = useState({
    title: "",
    description: "",
    priority: "normal",
    deadline: "",
    related_resident_id: "",
    assigned_group: "zarzad",
    recurrence_interval: "1",
    recurrence_unit: "Miesiac",
  });

  const resetAndClose = () => {
    setOpen(false);
    setKind("resident");
    setForm({
      title: "",
      description: "",
      priority: "normal",
      deadline: "",
      related_resident_id: "",
      assigned_group: "zarzad",
      recurrence_interval: "1",
      recurrence_unit: "Miesiac",
    });
    setError(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (!form.title.trim()) {
      setError(
        kind === "internal" ? "Podaj nazwę zadania wewnętrznego." : "Podaj treść zadania."
      );
      return;
    }

    setLoading(true);
    const supabase = createClient();

    const { error: insertError } =
      kind === "internal"
        ? await supabase.from("fixflow_tasks").insert({
            estate_id: estateId,
            title: form.title.trim(),
            description: form.description || null,
            kind: "internal",
            assigned_group: form.assigned_group,
            status: "Otwarte",
            is_recurring: true,
            recurrence_interval: parseInt(form.recurrence_interval, 10) || 1,
            recurrence_unit: form.recurrence_unit,
            created_by: userId,
          })
        : await supabase.from("fixflow_tasks").insert({
            estate_id: estateId,
            title: form.title.trim(),
            description: form.description || null,
            kind: "resident",
            priority: form.priority,
            deadline: form.deadline ? new Date(form.deadline).toISOString() : null,
            related_resident_id: form.related_resident_id || null,
            assigned_group: form.assigned_group,
            status: "Otwarte",
            created_by: userId,
          });

    setLoading(false);
    if (insertError) {
      setError(`Nie udało się zapisać zadania: ${insertError.message}`);
      return;
    }
    resetAndClose();
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
      >
        + Nowe zadanie
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={resetAndClose}
        >
          <div
            className="bg-white rounded-[22px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-lg mx-4 max-h-[88vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-5">
              Nowe zadanie
            </h2>

            <div className="flex gap-2 mb-5">
              {(
                [
                  { k: "resident" as const, label: "Do mieszkańca" },
                  { k: "internal" as const, label: "Wewnętrzne cykliczne" },
                ]
              ).map((t) => (
                <button
                  key={t.k}
                  type="button"
                  onClick={() => setKind(t.k)}
                  className={`flex-1 text-center px-3 py-2.5 rounded-xl text-sm font-semibold transition-colors ${
                    kind === t.k
                      ? "bg-[#173A6A] text-white"
                      : "bg-white text-ink/60 border border-ink/10"
                  }`}
                >
                  {t.label}
                </button>
              ))}
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  {kind === "internal" ? "Nazwa zadania wewnętrznego *" : "Treść zadania *"}
                </label>
                <input
                  type="text"
                  required
                  value={form.title}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder={
                    kind === "internal"
                      ? "np. Coroczna polisa OC budynku"
                      : "Np. Oddzwonić ws. kranu"
                  }
                />
              </div>

              {kind === "internal" && (
                <>
                  <div>
                    <label className="block text-xs font-medium text-ink/50 mb-1">
                      Krótki opis
                    </label>
                    <input
                      type="text"
                      value={form.description}
                      onChange={(e) => setForm({ ...form, description: e.target.value })}
                      className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
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
                        value={form.recurrence_interval}
                        onChange={(e) =>
                          setForm({ ...form, recurrence_interval: e.target.value })
                        }
                        className="w-20 px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                      />
                      <select
                        value={form.recurrence_unit}
                        onChange={(e) => setForm({ ...form, recurrence_unit: e.target.value })}
                        className="flex-1 px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure"
                      >
                        <option value="Tydzien">tygodni</option>
                        <option value="Miesiac">miesięcy</option>
                        <option value="Rok">lat</option>
                      </select>
                    </div>
                  </div>
                </>
              )}

              {kind === "resident" && (
                <>
                  <div>
                    <label className="block text-xs font-medium text-ink/50 mb-1">
                      Powiąż z mieszkańcem
                    </label>
                    <select
                      value={form.related_resident_id}
                      onChange={(e) =>
                        setForm({ ...form, related_resident_id: e.target.value })
                      }
                      className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure"
                    >
                      <option value="">Brak</option>
                      {residents.map((r) => (
                        <option key={r.id} value={r.id}>
                          {r.name ?? r.id.slice(0, 8)}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-medium text-ink/50 mb-1">
                        Termin
                      </label>
                      <input
                        type="date"
                        value={form.deadline}
                        onChange={(e) => setForm({ ...form, deadline: e.target.value })}
                        className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-medium text-ink/50 mb-1">
                        Do kogo
                      </label>
                      <div className="flex gap-2">
                        {["zarzad", "serwis"].map((g) => (
                          <button
                            key={g}
                            type="button"
                            onClick={() => setForm({ ...form, assigned_group: g })}
                            className={`flex-1 text-center px-2 py-2 rounded-lg text-xs font-semibold transition-colors ${
                              form.assigned_group === g
                                ? "bg-[#173A6A] text-white"
                                : "bg-white text-ink/60 border border-ink/10"
                            }`}
                          >
                            {g === "zarzad" ? "Zarząd" : "Serwis"}
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-medium text-ink/50 mb-1">
                      Priorytet
                    </label>
                    <div className="flex flex-wrap gap-2">
                      {PRIORITIES.map((p) => {
                        const on = form.priority === p.value;
                        return (
                          <button
                            key={p.value}
                            type="button"
                            onClick={() => setForm({ ...form, priority: p.value })}
                            className="px-3 py-1.5 rounded-full text-xs font-semibold transition-colors border"
                            style={{
                              backgroundColor: on ? p.color : "#fff",
                              color: on ? "#fff" : "#5A6B80",
                              borderColor: on ? p.color : "#E4EBF3",
                            }}
                          >
                            {p.label}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                </>
              )}

              {kind === "internal" && (
                <div>
                  <label className="block text-xs font-medium text-ink/50 mb-1">
                    Do kogo
                  </label>
                  <div className="flex gap-2">
                    {["zarzad", "serwis"].map((g) => (
                      <button
                        key={g}
                        type="button"
                        onClick={() => setForm({ ...form, assigned_group: g })}
                        className={`flex-1 text-center px-2 py-2 rounded-lg text-xs font-semibold transition-colors ${
                          form.assigned_group === g
                            ? "bg-[#173A6A] text-white"
                            : "bg-white text-ink/60 border border-ink/10"
                        }`}
                      >
                        {g === "zarzad" ? "Zarząd" : "Serwis"}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {error && <p className="text-[12.5px] text-danger">{error}</p>}

              <div className="flex gap-3 justify-end pt-2">
                <button
                  type="button"
                  onClick={resetAndClose}
                  className="px-4 py-2 rounded-xl text-sm text-ink/60 hover:bg-paper transition-colors"
                >
                  Anuluj
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 disabled:opacity-50 transition-colors"
                >
                  {loading ? "Zapisywanie..." : "Dodaj zadanie"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

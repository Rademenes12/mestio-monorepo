"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function CreateAnnouncementModal({
  buildings,
  stairwells,
  estateIds,
  userId,
  userName,
}: {
  buildings: { id: string; name: string; estate_id: string }[];
  stairwells: { id: string; name: string; building_id: string }[];
  estateIds: string[];
  userId: string;
  userName: string;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [scopeType, setScopeType] = useState<string>("estate");
  const [form, setForm] = useState({
    title: "",
    content: "",
    estate_id: estateIds[0] ?? "",
    scope_building_id: "",
    scope_stairwell_id: "",
  });

  const filteredStairwells = stairwells.filter((s) => {
    if (scopeType !== "stairwell") return false;
    if (!form.scope_building_id) return false;
    return s.building_id === form.scope_building_id;
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_announcements").insert({
      title: form.title,
      content: form.content,
      author_id: userId,
      author_name: userName,
      estate_id: form.estate_id || null,
      scope_type: scopeType,
      scope_building_id:
        scopeType === "building" || scopeType === "stairwell"
          ? form.scope_building_id || null
          : null,
      scope_stairwell_id:
        scopeType === "stairwell" ? form.scope_stairwell_id || null : null,
    });
    setLoading(false);
    if (insertError) {
      setError(`Nie udało się opublikować ogłoszenia: ${insertError.message}`);
      return;
    }
    setOpen(false);
    setForm({
      title: "",
      content: "",
      estate_id: estateIds[0] ?? "",
      scope_building_id: "",
      scope_stairwell_id: "",
    });
    setScopeType("estate");
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
      >
        + Nowe ogłoszenie
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white rounded-[22px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-xl mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-5">
              Nowe ogłoszenie
            </h2>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Tytuł *
                </label>
                <input
                  type="text"
                  required
                  value={form.title}
                  onChange={(e) =>
                    setForm({ ...form, title: e.target.value })
                  }
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Przerwa w dostawie wody"
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Treść *
                </label>
                <textarea
                  required
                  value={form.content}
                  onChange={(e) =>
                    setForm({ ...form, content: e.target.value })
                  }
                  rows={4}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure resize-none"
                  placeholder="Treść ogłoszenia..."
                />
              </div>

              <div>
                <label className="block text-xs font-medium text-ink/50 mb-2">
                  Zakres
                </label>
                <div className="flex gap-2 mb-3">
                  {[
                    { key: "estate", label: "Całe osiedle" },
                    { key: "building", label: "Budynek" },
                    { key: "stairwell", label: "Klatka" },
                  ].map((s) => (
                    <button
                      key={s.key}
                      type="button"
                      onClick={() => setScopeType(s.key)}
                      className={`px-3 py-1.5 rounded-xl text-xs font-medium transition-all ${
                        scopeType === s.key
                          ? "bg-azure text-white"
                          : "bg-paper text-ink/60 hover:bg-azure/5"
                      }`}
                    >
                      {s.label}
                    </button>
                  ))}
                </div>

                {scopeType !== "estate" && (
                  <select
                    value={form.scope_building_id}
                    onChange={(e) =>
                      setForm({
                        ...form,
                        scope_building_id: e.target.value,
                        scope_stairwell_id: "",
                      })
                    }
                    className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure mb-2"
                  >
                    <option value="">Wybierz budynek...</option>
                    {buildings.map((b) => (
                      <option key={b.id} value={b.id}>
                        {b.name}
                      </option>
                    ))}
                  </select>
                )}

                {scopeType === "stairwell" && form.scope_building_id && (
                  <select
                    value={form.scope_stairwell_id}
                    onChange={(e) =>
                      setForm({
                        ...form,
                        scope_stairwell_id: e.target.value,
                      })
                    }
                    className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure"
                  >
                    <option value="">Wybierz klatkę...</option>
                    {filteredStairwells.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.name}
                      </option>
                    ))}
                  </select>
                )}
              </div>

              {error && <p className="text-[12.5px] text-danger">{error}</p>}

              <div className="flex gap-3 justify-end pt-2">
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  className="px-4 py-2 rounded-xl text-sm text-ink/60 hover:bg-paper transition-colors"
                >
                  Anuluj
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 disabled:opacity-50 transition-colors"
                >
                  {loading ? "Publikowanie..." : "Opublikuj"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

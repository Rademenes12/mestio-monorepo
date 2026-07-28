"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function CreateResolutionModal({
  estateId,
  userId,
  suggestedNumber,
}: {
  estateId: string;
  userId: string;
  suggestedNumber: string;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    number: suggestedNumber,
    title: "",
    description: "",
    deadline: "",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!form.deadline) return;
    setLoading(true);
    const supabase = createClient();

    // fixflow_resolutions jest kanoniczna tabela (patrz komentarz w page.tsx) -
    // kolumna 'number' jest gwarantowana przez migracje 0014, bez potrzeby fallbacku.
    const { error: insertError } = await supabase.from("fixflow_resolutions").insert({
      estate_id: estateId,
      title: form.title,
      description: form.description || null,
      deadline: new Date(form.deadline).toISOString(),
      created_by: userId,
      number: form.number || null,
    });

    setLoading(false);
    if (insertError) {
      setError(`Nie udało się utworzyć uchwały: ${insertError.message}`);
      return;
    }
    setOpen(false);
    setForm({ number: suggestedNumber, title: "", description: "", deadline: "" });
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
      >
        + Nowa uchwała
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white rounded-[12px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-lg mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-5">
              Nowa uchwała
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Numer uchwały
                </label>
                <input
                  type="text"
                  value={form.number}
                  onChange={(e) => setForm({ ...form, number: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm font-mono focus:outline-none focus:border-azure"
                  placeholder="np. U-7/2026"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Tytuł *
                </label>
                <input
                  type="text"
                  required
                  value={form.title}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Remont dachu — budynek A"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Opis
                </label>
                <textarea
                  value={form.description}
                  onChange={(e) =>
                    setForm({ ...form, description: e.target.value })
                  }
                  rows={4}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure resize-none"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Termin głosowania *
                </label>
                <input
                  type="datetime-local"
                  required
                  value={form.deadline}
                  onChange={(e) =>
                    setForm({ ...form, deadline: e.target.value })
                  }
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                />
              </div>
              <div className="px-3 py-2.5 rounded-xl bg-azure/[.06] text-[11.5px] text-ink/70 leading-relaxed">
                Po terminie głosowanie blokuje się automatycznie, a wynik
                liczony jest wagą udziału % przypisaną do każdego lokalu.
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
                  {loading ? "Tworzenie..." : "Utwórz uchwałę"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

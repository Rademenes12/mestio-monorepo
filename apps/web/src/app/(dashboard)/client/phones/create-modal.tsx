"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function AddPhoneModal({ estateId }: { estateId: string }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [form, setForm] = useState({
    name: "",
    role: "",
    phone: "",
    email: "",
    category: "emergency",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_emergency_contacts").insert({
      estate_id: estateId,
      name: form.name,
      role: form.role,
      phone: form.phone,
      email: form.email || null,
      category: form.category,
      is_active: true,
    });
    setLoading(false);
    if (insertError) {
      setError(`Nie udało się dodać kontaktu: ${insertError.message}`);
      return;
    }
    setOpen(false);
    setForm({ name: "", role: "", phone: "", email: "", category: "emergency" });
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
      >
        + Dodaj kontakt
      </button>
      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white rounded-[12px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-md mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-4">
              Nowy kontakt
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Nazwa *
                </label>
                <input
                  type="text"
                  required
                  value={form.name}
                  onChange={(e) => setForm({ ...form, name: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Pogotowie gazowe"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Rola / opis
                </label>
                <input
                  type="text"
                  value={form.role}
                  onChange={(e) => setForm({ ...form, role: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Dyżurny"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Telefon *
                </label>
                <input
                  type="text"
                  required
                  value={form.phone}
                  onChange={(e) => setForm({ ...form, phone: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure font-mono"
                  placeholder="+48 123 456 789"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  E-mail
                </label>
                <input
                  type="email"
                  value={form.email}
                  onChange={(e) => setForm({ ...form, email: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Kategoria
                </label>
                <select
                  value={form.category}
                  onChange={(e) =>
                    setForm({ ...form, category: e.target.value })
                  }
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure"
                >
                  <option value="emergency">Alarmowe</option>
                  <option value="administration">Administracja</option>
                  <option value="maintenance">Serwis</option>
                </select>
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
                  {loading ? "Dodawanie..." : "Dodaj"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

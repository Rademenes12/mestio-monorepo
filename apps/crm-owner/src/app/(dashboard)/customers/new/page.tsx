"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

export default function NewCustomerPage() {
  const router = useRouter();
  const supabase = createClient();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [form, setForm] = useState({
    company_name: "",
    contact_name: "",
    contact_email: "",
    contact_phone: "",
    nip: "",
    source: "website",
    plan: "",
    mrr: "",
    notes: "",
  });

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>
  ) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const { data, error } = await supabase
      .from("crm_leads")
      .insert({
        company_name: form.company_name,
        contact_name: form.contact_name || null,
        contact_email: form.contact_email || null,
        contact_phone: form.contact_phone || null,
        nip: form.nip || null,
        source: form.source,
        plan: form.plan || null,
        mrr: form.mrr ? parseFloat(form.mrr) : 0,
        notes: form.notes || null,
        stage: "lead",
      })
      .select()
      .single();

    if (error) {
      setError(error.message);
      setLoading(false);
      return;
    }

    await supabase.from("crm_interactions").insert({
      lead_id: data.id,
      type: "note",
      summary: `Lead utworzony (źródło: ${form.source})`,
    });

    router.push(`/customers/${data.id}`);
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6">
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
        <h1 className="text-2xl font-bold text-ink">Nowy lead</h1>
        <p className="text-sm text-ink/50 mt-1">
          Dodaj nową firmę do pipeline sprzedażowego.
        </p>
      </div>

      <form
        onSubmit={handleSubmit}
        className="bg-white rounded-[var(--radius-card)] shadow-[var(--shadow-card)] p-8 space-y-5"
      >
        <div>
          <label className="block text-sm font-medium text-ink mb-1.5">
            Nazwa firmy *
          </label>
          <input
            name="company_name"
            required
            value={form.company_name}
            onChange={handleChange}
            placeholder="np. Zarząd Osiedla Słoneczne"
            className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              Osoba kontaktowa
            </label>
            <input
              name="contact_name"
              value={form.contact_name}
              onChange={handleChange}
              placeholder="Jan Kowalski"
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              Telefon
            </label>
            <input
              name="contact_phone"
              value={form.contact_phone}
              onChange={handleChange}
              placeholder="+48 000 000 000"
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              E-mail
            </label>
            <input
              type="email"
              name="contact_email"
              value={form.contact_email}
              onChange={handleChange}
              placeholder="kontakt@firma.pl"
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              NIP
            </label>
            <input
              name="nip"
              value={form.nip}
              onChange={handleChange}
              placeholder="0000000000"
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              Źródło
            </label>
            <select
              name="source"
              value={form.source}
              onChange={handleChange}
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            >
              <option value="website">Strona WWW</option>
              <option value="referral">Polecenie</option>
              <option value="cold">Cold outreach</option>
              <option value="other">Inne</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              Plan
            </label>
            <select
              name="plan"
              value={form.plan}
              onChange={handleChange}
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            >
              <option value="">— wybierz —</option>
              <option value="start">Start</option>
              <option value="standard">Standard</option>
              <option value="pro">Pro</option>
              <option value="enterprise">Enterprise</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-ink mb-1.5">
              MRR (PLN)
            </label>
            <input
              type="number"
              step="0.01"
              name="mrr"
              value={form.mrr}
              onChange={handleChange}
              placeholder="0"
              className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-ink mb-1.5">
            Notatki
          </label>
          <textarea
            name="notes"
            value={form.notes}
            onChange={handleChange}
            rows={4}
            placeholder="Dodatkowe informacje o leadzie..."
            className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all resize-none"
          />
        </div>

        {error && (
          <div className="bg-danger/5 text-danger text-sm px-4 py-2.5 rounded-[var(--radius-btn)] border border-danger/20">
            {error}
          </div>
        )}

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={loading}
            className="px-6 py-2.5 bg-azure text-white font-medium rounded-[var(--radius-btn)] hover:bg-azure-dark transition-colors disabled:opacity-50"
          >
            {loading ? "Zapisywanie..." : "Dodaj leada"}
          </button>
          <Link
            href="/customers"
            className="px-6 py-2.5 border border-mist text-ink/70 font-medium rounded-[var(--radius-btn)] hover:bg-mist/50 transition-colors"
          >
            Anuluj
          </Link>
        </div>
      </form>
    </div>
  );
}

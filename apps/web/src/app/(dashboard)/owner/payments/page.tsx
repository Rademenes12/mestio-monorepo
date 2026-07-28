"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

interface TransferPayment {
  id: string;
  user_id: string;
  estate_name: string;
  plan: string;
  amount: number;
  status: "pending" | "confirmed" | "expired";
  transfer_title: string;
  due_date: string;
  created_at: string;
}

const STATUS_META: Record<string, { label: string; color: string }> = {
  pending: { label: "Oczekuje", color: "#F2A900" },
  confirmed: { label: "Potwierdzona", color: "#2E9E6B" },
  expired: { label: "Wygasła", color: "#6B7A90" },
};

const money = (v: number) =>
  (v / 100).toLocaleString("pl-PL", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

export default function PaymentsPage() {
  const [payments, setPayments] = useState<TransferPayment[]>([]);
  const [loading, setLoading] = useState(true);
  const [confirming, setConfirming] = useState<string | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2600);
  };

  const fetchPayments = async () => {
    setLoading(true);
    const { data } = await supabase
      .from("fixflow_transfer_payments")
      .select("*")
      .order("created_at", { ascending: false });
    setPayments((data as TransferPayment[]) ?? []);
    setLoading(false);
  };

  useEffect(() => {
    void fetchPayments();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const confirmPayment = async (id: string) => {
    setConfirming(id);
    const res = await fetch("/api/confirm-transfer", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ paymentId: id }),
    });
    setConfirming(null);

    const data = await res.json();
    if (res.ok) {
      notify("Przelew potwierdzony! Osiedle zostało utworzone.");
      fetchPayments();
    } else {
      notify(`Błąd: ${data.error}${data.details ? " — " + data.details : ""}`);
    }
  };

  const pendingCount = payments.filter((p) => p.status === "pending").length;

  const cols = ["Tytuł przelewu", "Osiedle", "Plan", "Kwota", "Status", "Termin", ""];

  return (
    <div className="max-w-6xl mx-auto space-y-4">
      <div className="grid grid-cols-3 gap-[12px]">
        <div className="bg-white rounded-2xl border border-[#E9EEF5] px-4 py-[15px]">
          <div className="text-[12.5px] text-[#7C8AA0] font-medium">Oczekujące</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-ink mt-[5px]">{pendingCount}</div>
        </div>
        <div className="bg-white rounded-2xl border border-[#E9EEF5] px-4 py-[15px]">
          <div className="text-[12.5px] text-[#7C8AA0] font-medium">Potwierdzone</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-success mt-[5px]">{payments.filter((p) => p.status === "confirmed").length}</div>
        </div>
        <div className="bg-white rounded-2xl border border-[#E9EEF5] px-4 py-[15px]">
          <div className="text-[12.5px] text-[#7C8AA0] font-medium">Wygasłe</div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-[#6B7A90] mt-[5px]">{payments.filter((p) => p.status === "expired").length}</div>
        </div>
      </div>

      <div className="bg-white rounded-[12px] border border-[#E9EEF5] overflow-hidden">
        {loading ? (
          <div className="p-12 text-center text-[#9AA7B8] text-sm">Ładowanie...</div>
        ) : payments.length === 0 ? (
          <div className="p-12 text-center text-[#9AA7B8] text-[13.5px]">
            Brak przelewów. Przelewy oczekujące na potwierdzenie pojawią się tu automatycznie po rejestracji osiedla.
          </div>
        ) : (
          <>
            <div className="grid grid-cols-[1.5fr_1fr_.8fr_.8fr_.8fr_.8fr_1fr] bg-ink px-[18px]">
              {cols.map((c) => (
                <div key={c} className="py-[11px] px-[6px] font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-white/60 uppercase">{c}</div>
              ))}
            </div>
            {payments.map((p) => {
              const sm = STATUS_META[p.status] ?? STATUS_META.pending;
              return (
                <div key={p.id} className="grid grid-cols-[1.5fr_1fr_.8fr_.8fr_.8fr_.8fr_1fr] px-[18px] border-b border-[#F4F7FB] last:border-0 items-center hover:bg-[#F8FAFC] transition-colors">
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] font-semibold text-blueprint">{p.transfer_title}</div>
                  <div className="py-3 px-[6px] text-[13px] text-[#3A4759]">{p.estate_name}</div>
                  <div className="py-3 px-[6px] text-[12.5px] text-[#3A4759] capitalize">{p.plan}</div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-xs font-semibold text-ink">{money(p.amount)} PLN</div>
                  <div className="py-3 px-[6px]">
                    <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full" style={{ background: tint(sm.color, 0.13), color: sm.color }}>{sm.label}</span>
                  </div>
                  <div className="py-3 px-[6px] font-[family-name:var(--font-mono)] text-[11px] text-[#7C8AA0]">
                    {p.due_date ? new Date(p.due_date).toLocaleDateString("pl-PL") : "—"}
                  </div>
                  <div className="py-3 px-[6px]">
                    {p.status === "pending" && (
                      <button
                        onClick={() => confirmPayment(p.id)}
                        disabled={confirming === p.id}
                        className="flex items-center gap-[5px] px-[13px] py-[8px] rounded-[9px] bg-success text-[12.5px] font-semibold text-white hover:brightness-105 active:scale-[0.97] transition-all disabled:opacity-50"
                      >
                        {confirming === p.id ? (
                          "Potwierdzanie..."
                        ) : (
                          <>
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5 9-11" /></svg>
                            Potwierdź
                          </>
                        )}
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </>
        )}
      </div>

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-[70]">
          {toast}
        </div>
      )}
    </div>
  );
}

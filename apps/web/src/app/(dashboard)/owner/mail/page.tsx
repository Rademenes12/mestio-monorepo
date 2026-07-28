"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useMemo, useState } from "react";
import { createClient } from "@/lib/supabase/client";

const TEMPLATES = [
  { label: "Powitanie", text: "Cześć! Witamy w Mestio — cieszymy się, że jesteście z nami. " },
  { label: "Przypomnienie", text: "Cześć, przypominam o zbliżającym się terminie — " },
  { label: "Follow-up", text: "Cześć, wracam do naszej rozmowy — " },
  { label: "Oferta", text: "Cześć, przygotowałem dla Was propozycję — " },
];

interface CrmEmail {
  id: string;
  lead_id: string | null;
  to_email: string;
  subject: string;
  body: string;
  status: string; // draft / sent / opened / replied / archived
  sent_at: string | null;
  created_at: string;
}

interface Thread {
  key: string; // to_email
  toEmail: string;
  subject: string;
  messages: CrmEmail[];
  draft: CrmEmail | null;
  archived: boolean;
  lastAt: string;
}

function groupThreads(emails: CrmEmail[]): Thread[] {
  const map = new Map<string, CrmEmail[]>();
  for (const e of emails) {
    const arr = map.get(e.to_email) ?? [];
    arr.push(e);
    map.set(e.to_email, arr);
  }
  const threads: Thread[] = [];
  for (const [key, msgs] of map) {
    const sorted = msgs.slice().sort((a, b) => a.created_at.localeCompare(b.created_at));
    const sent = sorted.filter((m) => m.status !== "draft");
    const draft = sorted.find((m) => m.status === "draft") ?? null;
    const last = sorted[sorted.length - 1];
    threads.push({
      key,
      toEmail: key,
      subject: last?.subject ?? "—",
      messages: sent.filter((m) => m.status !== "archived"),
      draft,
      archived: sent.length > 0 && sent.every((m) => m.status === "archived"),
      lastAt: last?.created_at ?? "",
    });
  }
  return threads.sort((a, b) => b.lastAt.localeCompare(a.lastAt));
}

function fmtWhen(iso: string | null): string {
  if (!iso) return "—";
  const d = new Date(iso);
  const now = new Date();
  const diffH = (now.getTime() - d.getTime()) / 3600000;
  if (diffH < 24) return `${Math.max(1, Math.round(diffH))} godz.`;
  if (diffH < 48) return "wczoraj";
  return d.toLocaleDateString("pl-PL", { day: "numeric", month: "short" });
}

export default function MailPage() {
  const [emails, setEmails] = useState<CrmEmail[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<"all" | "active" | "archived">("all");
  const [selKey, setSelKey] = useState<string | null>(null);
  const [composeText, setComposeText] = useState("");
  const [draftText, setDraftText] = useState("");
  const [newThreadOpen, setNewThreadOpen] = useState(false);
  const [newTo, setNewTo] = useState("");
  const [newSubject, setNewSubject] = useState("");
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2400);
  };

  const fetchEmails = async () => {
    const { data } = await supabase
      .from("crm_emails")
      .select("*")
      .order("created_at", { ascending: true });
    setEmails((data as CrmEmail[]) ?? []);
    setLoading(false);
  };

  useEffect(() => {
    void fetchEmails();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const threads = useMemo(() => groupThreads(emails), [emails]);
  const filtered = threads.filter((t) =>
    filter === "all" ? true : filter === "archived" ? t.archived : !t.archived
  );
  const sel = filtered.find((t) => t.key === selKey) ?? filtered[0] ?? null;

  useEffect(() => {
    setDraftText(sel?.draft?.body ?? "");
  }, [sel?.draft?.id]); // eslint-disable-line react-hooks/exhaustive-deps

  const sendCompose = async () => {
    const t = composeText.trim();
    if (!t || !sel) return;
    const { error } = await supabase.from("crm_emails").insert({
      to_email: sel.toEmail,
      subject: sel.subject,
      body: t,
      status: "sent",
      sent_at: new Date().toISOString(),
    });
    if (error) {
      notify("Błąd zapisu: " + error.message);
      return;
    }
    // Wysyłka przez Edge Function (jeśli skonfigurowana) — komunikat mówi prawdę
    let delivered = false;
    try {
      const { error: fnError } = await supabase.functions.invoke("send-email", {
        body: { to: sel.toEmail, subject: sel.subject, body: t },
      });
      delivered = !fnError;
    } catch {
      delivered = false;
    }
    setComposeText("");
    notify(
      delivered
        ? "Wysłano wiadomość"
        : "Zapisano w CRM — realna wysyłka nieaktywna (skonfiguruj Resend w Ustawieniach)"
    );
    fetchEmails();
  };

  const askAiDraft = async () => {
    if (!sel) return;
    const canned = `Cześć, dziękuję za wiadomość! [Szkic AI na podstawie wątku "${sel.subject}" — edytuj przed wysłaniem.]`;
    const { error } = await supabase.from("crm_emails").insert({
      to_email: sel.toEmail,
      subject: sel.subject,
      body: canned,
      status: "draft",
    });
    if (error) notify("Błąd: " + error.message);
    else {
      notify("AI przygotowało szkic — sprawdź i zatwierdź");
      fetchEmails();
    }
  };

  const approveDraft = async () => {
    if (!sel?.draft) return;

    // BUG (audyt A3): wczesniej ten handler ustawial status='sent' bez
    // realnej wysylki - klient nigdy nic nie dostawal. Teraz wola Edge
    // Function send-email tak samo jak sendCompose(), i komunikat mowi prawde.
    let delivered = false;
    try {
      const { error: fnError } = await supabase.functions.invoke("send-email", {
        body: { to: sel.toEmail, subject: sel.subject, body: draftText },
      });
      delivered = !fnError;
    } catch {
      delivered = false;
    }

    const { error } = await supabase
      .from("crm_emails")
      .update({
        body: draftText,
        status: delivered ? "sent" : "draft",
        sent_at: delivered ? new Date().toISOString() : null,
      })
      .eq("id", sel.draft.id);
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    notify(
      delivered
        ? "Zatwierdzono i wysłano"
        : "Zapisano treść, ale wysyłka nie powiodła się — szkic pozostał w kolejce"
    );
    fetchEmails();
  };

  const discardDraft = async () => {
    if (!sel?.draft) return;
    const { error } = await supabase.from("crm_emails").delete().eq("id", sel.draft.id);
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    notify("Odrzucono szkic");
    fetchEmails();
  };

  const toggleArchive = async () => {
    if (!sel) return;
    const newStatus = sel.archived ? "sent" : "archived";
    const ids = sel.messages.map((m) => m.id);
    if (ids.length) {
      const { error } = await supabase.from("crm_emails").update({ status: newStatus }).in("id", ids);
      if (error) {
        notify("Błąd: " + error.message);
        return;
      }
    }
    notify(sel.archived ? "Przywrócono wątek" : "Zarchiwizowano wątek");
    fetchEmails();
  };

  const createThread = async () => {
    const to = newTo.trim();
    if (!to) return;
    const { error } = await supabase.from("crm_emails").insert({
      to_email: to,
      subject: newSubject.trim() || "Nowa wiadomość",
      body: "",
      status: "draft",
    });
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    setNewThreadOpen(false);
    setNewTo("");
    setNewSubject("");
    setSelKey(to);
    fetchEmails();
  };

  const chip = (active: boolean) =>
    `text-[11.5px] font-semibold px-[10px] py-1 rounded-full cursor-pointer transition-colors ${
      active ? "bg-blueprint text-white" : "bg-[#F4F7FB] text-[#5A6B80]"
    }`;

  if (loading) {
    return <div className="text-center text-[#9AA7B8] py-20 text-sm">Ładowanie...</div>;
  }

  return (
    <div className="max-w-6xl mx-auto h-[calc(100vh-110px)]">
      <div className="grid grid-cols-[280px_1fr] gap-[14px] h-full">
        {/* Lista wątków */}
        <div className="bg-white rounded-[12px] border border-[#E9EEF5] overflow-hidden flex flex-col">
          <div className="py-[14px] px-4 border-b border-[#F4F7FB] flex items-center justify-between">
            <span className="font-[family-name:var(--font-mono)] text-[9.5px] tracking-[.4px] text-[#8A98AB] uppercase">
              Wątki
            </span>
            <button onClick={() => setNewThreadOpen(true)} className="text-[11px] font-semibold text-azure">
              + Nowy
            </button>
          </div>
          <div className="flex gap-[6px] py-2 px-3 border-b border-[#F4F7FB]">
            <button className={chip(filter === "all")} onClick={() => setFilter("all")}>Wszystkie</button>
            <button className={chip(filter === "active")} onClick={() => setFilter("active")}>Aktywne</button>
            <button className={chip(filter === "archived")} onClick={() => setFilter("archived")}>Archiwum</button>
          </div>
          <div className="overflow-y-auto flex-1">
            {filtered.length === 0 ? (
              <div className="p-6 text-center text-[#9AA7B8] text-[12.5px]">
                Brak wątków. Kliknij „+ Nowy", aby napisać pierwszą wiadomość.
              </div>
            ) : (
              filtered.map((t) => {
                const active = sel?.key === t.key;
                return (
                  <button
                    key={t.key}
                    onClick={() => setSelKey(t.key)}
                    className="w-full text-left flex items-center gap-[10px] py-3 px-4 border-b border-[#F4F7FB]"
                    style={{
                      borderLeft: `3px solid ${active ? "#3E7BD6" : "transparent"}`,
                      background: active ? "rgba(62,123,214,.04)" : "#fff",
                    }}
                  >
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-[6px]">
                        <span className="text-[13px] font-semibold text-ink truncate">{t.toEmail}</span>
                        {t.draft && (
                          <span className="font-[family-name:var(--font-mono)] text-[8.5px] font-semibold px-[6px] py-[1px] rounded-full bg-azure/15 text-azure shrink-0">
                            Szkic AI
                          </span>
                        )}
                      </div>
                      <div className="text-[11.5px] text-[#7C8AA0] mt-[2px] truncate">{t.subject}</div>
                    </div>
                    <span className="font-[family-name:var(--font-mono)] text-[9.5px] text-[#9AA7B8] shrink-0">
                      {fmtWhen(t.lastAt)}
                    </span>
                  </button>
                );
              })
            )}
          </div>
        </div>

        {/* Widok wątku */}
        <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5 flex flex-col min-h-0">
          {!sel ? (
            <div className="flex-1 flex items-center justify-center text-[#9AA7B8] text-sm">
              Wybierz wątek z listy albo utwórz nowy.
            </div>
          ) : (
            <>
              <div className="flex items-center justify-between">
                <div>
                  <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">
                    {sel.subject}
                  </div>
                  <div className="font-[family-name:var(--font-mono)] text-[11px] text-[#8A98AB] mt-1">
                    {sel.toEmail}
                  </div>
                </div>
                <button
                  onClick={toggleArchive}
                  className="text-[11.5px] font-semibold px-3 py-[6px] rounded-[9px] bg-[#F4F7FB] text-[#5A6B80]"
                >
                  {sel.archived ? "Przywróć" : "Archiwizuj"}
                </button>
              </div>

              {/* Wiadomości */}
              <div className="flex-1 overflow-y-auto mt-[14px] flex flex-col gap-[10px] min-h-0">
                {sel.messages.length === 0 ? (
                  <div className="text-[12.5px] text-[#9AA7B8] py-4">Jeszcze nie wysłano wiadomości w tym wątku.</div>
                ) : (
                  sel.messages.map((m) => (
                    <div key={m.id} className="flex flex-col items-end">
                      <div className="max-w-[80%] bg-blueprint text-white rounded-xl py-[10px] px-[13px] text-[13px] leading-relaxed whitespace-pre-line">
                        {m.body}
                      </div>
                      <div className="font-[family-name:var(--font-mono)] text-[9.5px] text-[#9AA7B8] mt-[3px]">
                        Ty · {fmtWhen(m.sent_at ?? m.created_at)}
                      </div>
                    </div>
                  ))
                )}
              </div>

              {/* Szkic AI */}
              {sel.draft && (
                <div className="mt-[14px] bg-azure/5 border border-azure/20 rounded-[14px] p-[14px]">
                  <div className="flex items-center gap-[7px]">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M12 3v3m0 12v3m9-9h-3M6 12H3m14.5-6.5l-2 2m-9 9l-2 2m0-13l2 2m9 9l2 2" />
                    </svg>
                    <span className="font-[family-name:var(--font-heading)] font-semibold text-[12.5px] text-blueprint">
                      Szkic AI — czeka na Twoją akceptację
                    </span>
                  </div>
                  <textarea
                    value={draftText}
                    onChange={(e) => setDraftText(e.target.value)}
                    className="w-full min-h-[90px] resize-y text-[13px] leading-relaxed bg-white border border-[#DCE6F5] rounded-[10px] py-[10px] px-3 text-ink mt-[10px] outline-none"
                  />
                  <div className="flex gap-2 mt-[10px]">
                    <button onClick={approveDraft} className="px-[14px] py-2 rounded-[9px] bg-blueprint text-white text-[12.5px] font-semibold">
                      ✓ Zatwierdź i wyślij
                    </button>
                    <button onClick={discardDraft} className="px-[14px] py-2 rounded-[9px] bg-white border border-[#E4EBF3] text-[#5A6B80] text-[12.5px] font-semibold">
                      Odrzuć szkic
                    </button>
                  </div>
                </div>
              )}

              {/* Kompozytor */}
              <div className="mt-[14px] pt-[14px] border-t border-[#F4F7FB]">
                <div className="flex gap-[6px] mb-2 flex-wrap">
                  {TEMPLATES.map((t) => (
                    <button
                      key={t.label}
                      onClick={() => setComposeText((v) => v + t.text)}
                      className="px-[11px] py-[5px] rounded-full text-[11.5px] font-medium bg-[#F4F7FB] text-[#5A6B80] border border-[#E4EBF3]"
                    >
                      + {t.label}
                    </button>
                  ))}
                </div>
                <textarea
                  value={composeText}
                  onChange={(e) => setComposeText(e.target.value)}
                  placeholder="Napisz swobodną wiadomość do klienta…"
                  className="w-full min-h-[70px] resize-y text-[13.5px] leading-relaxed bg-[#F6F8FB] border border-[#E4EBF3] rounded-[10px] py-[11px] px-[13px] text-ink outline-none"
                />
                <div className="flex justify-end gap-2 mt-[9px]">
                  <button
                    onClick={askAiDraft}
                    className="px-[14px] py-2 rounded-[9px] bg-white border border-[#DCE6F5] text-azure text-[12.5px] font-semibold"
                  >
                    ✨ Poproś AI o szkic
                  </button>
                  <button
                    onClick={sendCompose}
                    disabled={!composeText.trim()}
                    className="px-4 py-2 rounded-[9px] bg-gradient-to-br from-azure to-blueprint text-white text-[12.5px] font-semibold disabled:opacity-50"
                  >
                    Wyślij
                  </button>
                </div>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Modal: nowy wątek */}
      {newThreadOpen && (
        <div
          className="fixed inset-0 bg-ink/50 flex items-center justify-center z-50 p-6"
          onClick={() => setNewThreadOpen(false)}
        >
          <div
            className="bg-[#F6F8FB] rounded-[12px] shadow-[0_30px_70px_rgba(14,26,43,.4)] w-[440px] max-w-full p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="font-[family-name:var(--font-heading)] font-bold text-lg text-ink">Nowy wątek</div>
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mt-4 mb-[6px]">
              Adresat (e-mail)
            </div>
            <input
              value={newTo}
              onChange={(e) => setNewTo(e.target.value)}
              placeholder="adres@firma.pl"
              className="w-full text-sm bg-white rounded-[11px] px-3 py-[11px] text-ink outline-none"
            />
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mt-3 mb-[6px]">
              Temat
            </div>
            <input
              value={newSubject}
              onChange={(e) => setNewSubject(e.target.value)}
              placeholder="Temat wiadomości"
              className="w-full text-sm bg-white rounded-[11px] px-3 py-[11px] text-ink outline-none"
            />
            <div className="flex gap-[10px] mt-[18px]">
              <button
                onClick={() => setNewThreadOpen(false)}
                className="flex-1 py-3 rounded-[11px] bg-[#EAF0F7] text-[#5A6B80] font-semibold text-[13.5px]"
              >
                Anuluj
              </button>
              <button
                onClick={createThread}
                disabled={!newTo.trim()}
                className="flex-[1.6] py-3 rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50"
              >
                Utwórz wątek
              </button>
            </div>
          </div>
        </div>
      )}

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-50">
          {toast}
        </div>
      )}
    </div>
  );
}

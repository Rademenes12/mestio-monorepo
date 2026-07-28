"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Subscriber {
  id: string;
  email: string;
  subscribed_at: string;
  unsubscribed: boolean;
  unsubscribed_at: string | null;
}

interface Draft {
  id: string;
  subject: string;
  html_content: string;
  status: "draft" | "pending_review" | "approved" | "sent";
  plagiarism_score: number | null;
  plagiarism_report: Record<string, unknown> | null;
  ai_generated_probability: number | null;
  phishing_risk_level: string | null;
  created_at: string;
  updated_at: string;
  sent_to_count: number | null;
}

interface ApprovalLog {
  id: string;
  action: string;
  review_notes: string | null;
  created_at: string;
}

export default function NewsletterPage() {
  const [subscribers, setSubscribers] = useState<Subscriber[]>([]);
  const [drafts, setDrafts] = useState<Draft[]>([]);
  const [loading, setLoading] = useState(true);
  const [email, setEmail] = useState("");
  const [adding, setAdding] = useState(false);
  const [aiTopic, setAiTopic] = useState("");
  const [aiGenerating, setAiGenerating] = useState(false);
  const [aiResult, setAiResult] = useState<string | null>(null);
  const [sendSubject, setSendSubject] = useState("");
  const [sendHtml, setSendHtml] = useState("");
  const [sending, setSending] = useState(false);
  const [sendResult, setSendResult] = useState<{ total: number; sent: number; failed: number; sent_today: number; daily_limit: number } | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const [selectedDraft, setSelectedDraft] = useState<Draft | null>(null);
  const [showPreview, setShowPreview] = useState(false);
  const [previewType, setPreviewType] = useState<"desktop" | "mobile" | "tablet">("desktop");
  const [previewHtml, setPreviewHtml] = useState<string | null>(null);
  const [extractingUrl, setExtractingUrl] = useState(false);
  const [extractUrl, setExtractUrl] = useState("");
  const [approvalLogs, setApprovalLogs] = useState<ApprovalLog[]>([]);
  const [showApprovalPanel, setShowApprovalPanel] = useState(false);
  const [reviewNotes, setReviewNotes] = useState("");
  const [approvingDraft, setApprovingDraft] = useState(false);
  const [requireApproval, setRequireApproval] = useState(true);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2800);
  };

  const fetchSubscribers = async () => {
    const { data } = await supabase
      .from("newsletter_subscribers")
      .select("*")
      .order("subscribed_at", { ascending: false });
    setSubscribers((data as Subscriber[]) ?? []);
  };

  const fetchDrafts = async () => {
    const res = await fetch("/api/newsletter-draft");
    const json = await res.json();
    setDrafts((json.drafts as Draft[]) ?? []);
  };

  useEffect(() => {
    setLoading(true);
    Promise.all([fetchSubscribers(), fetchDrafts()]).then(() => setLoading(false));
  }, []);

  const handleAdd = async () => {
    if (!email.trim()) return;
    setAdding(true);
    const { error } = await supabase
      .from("newsletter_subscribers")
      .insert({ email: email.trim().toLowerCase() });
    if (error) {
      notify("Błąd: " + error.message);
    } else {
      notify("Dodano subskrybenta");
      setEmail("");
      fetchSubscribers();
    }
    setAdding(false);
  };

  const handleUnsubscribe = async (id: string) => {
    const { error } = await supabase
      .from("newsletter_subscribers")
      .update({ unsubscribed: true, unsubscribed_at: new Date().toISOString() })
      .eq("id", id);
    if (error) {
      notify("Błąd: " + error.message);
    } else {
      notify("Wypisano");
      fetchSubscribers();
    }
  };

  const handleResubscribe = async (id: string) => {
    const { error } = await supabase
      .from("newsletter_subscribers")
      .update({ unsubscribed: false, unsubscribed_at: null })
      .eq("id", id);
    if (error) {
      notify("Błąd: " + error.message);
    } else {
      notify("Ponownie zapisano");
      fetchSubscribers();
    }
  };

  const handleDelete = async (id: string, email: string) => {
    if (!confirm(`Usunąć ${email}?`)) return;
    const { error } = await supabase.from("newsletter_subscribers").delete().eq("id", id);
    if (error) {
      notify("Błąd: " + error.message);
    } else {
      notify("Usunięto");
      fetchSubscribers();
    }
  };

  const handleExport = () => {
    const active = subscribers.filter((s) => !s.unsubscribed);
    const csv = ["email,subscribed_at", ...active.map((s) => `${s.email},${s.subscribed_at}`)].join("\n");
    const blob = new Blob([csv], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `newsletter-subscribers-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleGenerateNewsletter = async () => {
    if (!aiTopic.trim()) return;
    setAiGenerating(true);
    try {
      const res = await fetch("/api/ai-assist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          prompt: `Jesteś ekspertem od newsletterów dla branży nieruchomości i zarządzania osiedlami (Mestio). Wygeneruj kompletny e-mail HTML do wysyłki newslettera do ${activeCount} subskrybentów. Musi zawierać:\n- Temat wiadomości (Subject:) na początku, w osobnej linii\n- Treść HTML z nagłówkami, akapitami, listami (użyj <h2>, <p>, <ul>/<li>, <strong>)\n- 2-3 miejsca na grafiki oznaczone jako [IMAGE: opis]\n- Przycisk CTA jako <a> ostylowany inline\n- Stopkę z linkiem do wypisania\n- Całość w <div style=\"max-width:600px;margin:0 auto;font-family:Arial,sans-serif\">\n\nTemat newslettera: ${aiTopic.trim()}`,
        }),
      });
      const data = await res.json();
      if (data.error) {
        notify("Błąd AI: " + data.error);
      } else {
        setAiResult(data.result);
      }
    } catch {
      notify("Nie można połączyć z AI");
    }
    setAiGenerating(false);
  };

  const handleExtractContent = async () => {
    if (!extractUrl.trim()) return;
    setExtractingUrl(true);
    try {
      const res = await fetch("/api/extract-content", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ url: extractUrl.trim() }),
      });
      const data = await res.json();
      if (data.error) {
        notify("Błąd: " + data.error);
      } else {
        setSendSubject(data.newsletter.subject);
        setSendHtml(data.newsletter.html);
        setExtractUrl("");
        notify("Zawartość zaimportowana! " + (data.cached ? "(z cache)" : ""));
      }
    } catch {
      notify("Błąd importu zawartości");
    }
    setExtractingUrl(false);
  };

  const handlePreview = async () => {
    if (!sendHtml.trim()) {
      notify("Wpisz HTML do podglądu");
      return;
    }
    try {
      const res = await fetch("/api/preview-email", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ html: sendHtml.trim(), viewtype: previewType }),
      });
      const data = await res.json();
      if (data.preview) {
        setPreviewHtml(data.preview);
        setShowPreview(true);
      }
    } catch {
      notify("Błąd generowania podglądu");
    }
  };

  const handleSaveDraft = async () => {
    if (!sendSubject.trim() || !sendHtml.trim()) {
      notify("Wpisz temat i HTML");
      return;
    }

    try {
      const res = await fetch("/api/newsletter-draft", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "save-draft",
          subject: sendSubject.trim(),
          html_content: sendHtml.trim(),
          ai_topic: aiTopic.trim() || null,
        }),
      });
      const data = await res.json();
      if (data.error) {
        notify("Błąd: " + data.error);
      } else {
        const plagiarism = data.plagiarism.score;
        const color = plagiarism > 60 ? "🔴" : plagiarism > 30 ? "🟡" : "🟢";
        notify(`Draft zapisany! ${color} Plagiarism: ${plagiarism}%`);
        setSendSubject("");
        setSendHtml("");
        setAiTopic("");
        setAiResult(null);
        await fetchDrafts();
      }
    } catch {
      notify("Błąd zapisu draftu");
    }
  };

  const handleCopyHtml = () => {
    if (!aiResult) return;
    navigator.clipboard.writeText(aiResult);
    notify("Skopiowano HTML do schowka");
  };

  const handleUseDraft = (draft: Draft) => {
    setSendSubject(draft.subject);
    setSendHtml(draft.html_content);
    setSelectedDraft(draft);
    setShowApprovalPanel(true);
    fetchApprovalLogs(draft.id);
  };

  const fetchApprovalLogs = async (draftId: string) => {
    const res = await fetch(`/api/newsletter-draft?id=${draftId}`);
    const data = await res.json();
    setApprovalLogs(data.approvals || []);
  };

  const handleSubmitForReview = async () => {
    if (!selectedDraft) return;
    setApprovingDraft(true);
    try {
      const res = await fetch("/api/newsletter-draft", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "submit-for-review",
          draft_id: selectedDraft.id,
          review_notes: "User submitted for review",
        }),
      });
      const data = await res.json();
      if (data.error) {
        notify("Błąd: " + data.error);
      } else {
        notify("Wysłano do przeglądu");
        await fetchDrafts();
      }
    } catch {
      notify("Błąd wysyłki do przeglądu");
    }
    setApprovingDraft(false);
  };

  const handleApproveDraft = async () => {
    if (!selectedDraft) return;
    setApprovingDraft(true);
    try {
      const res = await fetch("/api/newsletter-draft", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "approve",
          draft_id: selectedDraft.id,
          review_notes: reviewNotes || "Approved",
        }),
      });
      const data = await res.json();
      if (data.error) {
        notify("❌ " + data.error);
      } else {
        notify("✅ Newsletter zatwierdził!");
        setReviewNotes("");
        await fetchDrafts();
      }
    } catch {
      notify("Błąd zatwierdzenia");
    }
    setApprovingDraft(false);
  };

  const handleSendNewsletter = async () => {
    if (!sendSubject.trim() || !sendHtml.trim()) return;
    if (!confirm(`Wysłać newsletter do ${activeCount} odbiorców?`)) return;
    setSending(true);
    setSendResult(null);
    try {
      const res = await fetch("/api/send-newsletter", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          subject: sendSubject.trim(),
          html: sendHtml.trim(),
          draft_id: selectedDraft?.id,
          require_approval: requireApproval,
        }),
      });
      const data = await res.json();
      if (data.error) {
        notify("Błąd: " + data.error);
      } else {
        setSendResult(data);
        notify(`✅ Wysłano: ${data.sent} z ${data.total}`);
        await fetchDrafts();
      }
    } catch {
      notify("Błąd wysyłki");
    }
    setSending(false);
  };

  const activeCount = subscribers.filter((s) => !s.unsubscribed).length;
  const unsubscribedCount = subscribers.filter((s) => s.unsubscribed).length;

  return (
    <div className="max-w-7xl mx-auto space-y-4">
      {/* Header */}
      <div className="bg-gradient-to-br from-azure to-blueprint rounded-[18px] p-5 px-[22px] text-white">
        <div className="font-[family-name:var(--font-heading)] font-bold text-base">Newsletter Manager</div>
        <div className="text-[12.5px] text-white/85 mt-[5px]">
          Profesjonalny system zarządzania newsletterami z zatwierdzeniami i podglądami
        </div>
      </div>

       {/* Quick Start Guide */}
       <div className="bg-gradient-to-r from-emerald-50 to-teal-50 rounded-[18px] border border-emerald-200/50 p-4">
         <div className="flex items-start gap-3">
           <div className="text-2xl shrink-0">💡</div>
           <div className="flex-1">
             <div className="font-semibold text-[13px] text-ink mb-1">Jak pracować z newsletterami:</div>
             <ul className="text-[12px] text-[#7C8AA0] space-y-1">
               <li>✅ <strong>Generuj z AI:</strong> Opisz temat → kliknij "Generuj" →  HTML pojawi się w polu poniżej</li>
               <li>✅ <strong>Importuj z URL:</strong> Wklej link do artykułu (np. z mestio.pl/blog) → kliknij "Importuj" → treść autouzupełni się</li>
               <li>✅ <strong>Edytuj HTML:</strong> Możesz ręcznie edytować wygenerowaną treść w polu edytora</li>
               <li>✅ <strong>Opublikuj na blogu:</strong> Przejdź do sekcji Blog (w menu) → edytuj artykuł → dodaj zdjęcia przez przycisk 📷 w edytorze</li>
             </ul>
           </div>
         </div>
       </div>

       {/* Stats */}
       <div className="grid grid-cols-3 gap-3">
         <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 text-center">
           <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-ink">{subscribers.length}</div>
           <div className="text-[11px] text-[#8A98AB] mt-1">Łącznie subskrybentów</div>
         </div>
         <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 text-center">
           <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-success">{activeCount}</div>
           <div className="text-[11px] text-[#8A98AB] mt-1">Aktywni</div>
         </div>
         <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 text-center">
           <div className="font-[family-name:var(--font-heading)] font-bold text-2xl text-danger">{unsubscribedCount}</div>
           <div className="text-[11px] text-[#8A98AB] mt-1">Wypisani</div>
         </div>
       </div>

      <div className="grid grid-cols-3 gap-4">
        {/* Left Column: Content Generation */}
        <div className="col-span-2 space-y-4">
          {/* AI Generator */}
          <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
              🤖 Generuj z AI
            </div>
            <div className="flex gap-2">
              <input
                type="text"
                value={aiTopic}
                onChange={(e) => setAiTopic(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleGenerateNewsletter()}
                placeholder="Temat newslettera..."
                className="flex-1 text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-purple-400/30"
              />
              <button
                onClick={handleGenerateNewsletter}
                disabled={aiGenerating || !aiTopic.trim()}
                className="px-5 py-[12px] rounded-[11px] bg-gradient-to-br from-purple-600 to-indigo-600 text-white font-semibold text-[13px] hover:brightness-105 disabled:opacity-50"
              >
                {aiGenerating ? "..." : "Generuj"}
              </button>
            </div>
            {aiResult && (
              <div className="space-y-2">
                <div className="flex gap-2">
                  <button
                    onClick={() => { setSendHtml(aiResult); setSendSubject(aiResult.split('\n')[0].replace('Subject: ', '').trim()); notify("✅ HTML wklejony!"); }}
                    className="flex-1 px-3 py-[8px] rounded-[9px] bg-purple-50 text-purple-600 text-[11px] font-semibold hover:bg-purple-100"
                  >
                    👉 Użyj tego HTML-a
                  </button>
                  <button
                    onClick={handleCopyHtml}
                    className="px-3 py-[8px] rounded-[9px] bg-[#F4F7FB] text-[#7C8AA0] text-[11px] font-semibold hover:bg-[#EAEFF5]"
                  >
                    📋 Kopiuj
                  </button>
                </div>
                <div className="max-h-[200px] overflow-y-auto p-3 bg-[#F8FAFC] rounded-[11px] text-[10px] font-mono whitespace-pre-wrap text-[#5A6B80]">
                  {aiResult.substring(0, 500)}...
                </div>
              </div>
            )}
          </div>

          {/* URL Content Extraction */}
          <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
              🔗 Importuj z URL
            </div>
            <div className="flex gap-2">
              <input
                type="url"
                value={extractUrl}
                onChange={(e) => setExtractUrl(e.target.value)}
                placeholder="https://..."
                className="flex-1 text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30"
              />
              <button
                onClick={handleExtractContent}
                disabled={extractingUrl || !extractUrl.trim()}
                className="px-5 py-[12px] rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold disabled:opacity-50"
              >
                {extractingUrl ? "..." : "Importuj"}
              </button>
            </div>
          </div>

          {/* Editor */}
          <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
              ✏️ Edytor
            </div>
            <input
              type="text"
              value={sendSubject}
              onChange={(e) => setSendSubject(e.target.value)}
              placeholder="Temat wiadomości"
              className="w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-success/30"
            />
            <textarea
              value={sendHtml}
              onChange={(e) => setSendHtml(e.target.value)}
              placeholder="HTML treści"
              rows={8}
              className="w-full text-[12px] font-mono bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-success/30 resize-y"
            />
            <div className="flex gap-2">
              <button
                onClick={handlePreview}
                disabled={!sendHtml.trim()}
                className="flex-1 px-4 py-2 rounded-[11px] bg-cyan-50 text-cyan text-[12px] font-semibold hover:bg-cyan-100 disabled:opacity-40"
              >
                👁️ Podgląd
              </button>
              <button
                onClick={handleSaveDraft}
                disabled={!sendSubject.trim() || !sendHtml.trim()}
                className="flex-1 px-4 py-2 rounded-[11px] bg-amber-50 text-amber text-[12px] font-semibold hover:bg-amber-100 disabled:opacity-40"
              >
                💾 Zapisz Draft
              </button>
            </div>
          </div>
        </div>

        {/* Right Column: Approval & Preview */}
        <div className="space-y-4">
          {/* Approval Panel */}
          {selectedDraft && (
            <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
              <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
                ✅ Zatwierdzenie
              </div>

              <div className="space-y-2">
                <div className="text-[11px]">
                  <span className="font-semibold text-ink">Status:</span>
                  <span
                    className={`ml-2 font-bold ${
                      selectedDraft.status === "draft"
                        ? "text-amber"
                        : selectedDraft.status === "approved"
                          ? "text-success"
                          : "text-azure"
                    }`}
                  >
                    {selectedDraft.status.toUpperCase()}
                  </span>
                </div>

                {selectedDraft.plagiarism_score !== null && (
                  <div className="text-[11px]">
                    <span className="font-semibold text-ink">Plagiarism:</span>
                    <span
                      className={`ml-2 font-bold ${
                        selectedDraft.plagiarism_score > 60
                          ? "text-danger"
                          : selectedDraft.plagiarism_score > 30
                            ? "text-amber"
                            : "text-success"
                      }`}
                    >
                      {selectedDraft.plagiarism_score}%
                    </span>
                  </div>
                )}

                {selectedDraft.phishing_risk_level && (
                  <div className="text-[11px]">
                    <span className="font-semibold text-ink">Phishing Risk:</span>
                    <span
                      className={`ml-2 font-bold ${
                        selectedDraft.phishing_risk_level === "high"
                          ? "text-danger"
                          : selectedDraft.phishing_risk_level === "medium"
                            ? "text-amber"
                            : "text-success"
                      }`}
                    >
                      {selectedDraft.phishing_risk_level.toUpperCase()}
                    </span>
                  </div>
                )}
              </div>

              <textarea
                value={reviewNotes}
                onChange={(e) => setReviewNotes(e.target.value)}
                placeholder="Notatki do przeglądu..."
                rows={3}
                className="w-full text-[11px] bg-[#F8FAFC] rounded-[9px] px-3 py-2 outline-none focus:ring-2 focus:ring-purple-200"
              />

              <div className="space-y-2">
                {selectedDraft.status === "draft" && (
                  <button
                    onClick={handleSubmitForReview}
                    disabled={approvingDraft}
                    className="w-full py-2 rounded-[9px] bg-blue-50 text-blue-600 text-[11px] font-semibold hover:bg-blue-100 disabled:opacity-50"
                  >
                    Wyślij do przeglądu
                  </button>
                )}
                {selectedDraft.status === "pending_review" && (
                  <button
                    onClick={handleApproveDraft}
                    disabled={approvingDraft || (selectedDraft.plagiarism_score ?? 0) > 60}
                    className="w-full py-2 rounded-[9px] bg-success/10 text-success text-[11px] font-semibold hover:bg-success/20 disabled:opacity-50"
                  >
                    {approvingDraft ? "..." : "Zatwierdź"}
                  </button>
                )}
                {selectedDraft.status === "approved" && (
                  <div className="text-center text-[11px] font-semibold text-success p-2 bg-success/10 rounded-[9px]">
                    ✅ Zatwierdzony i gotowy do wysyłki
                  </div>
                )}
              </div>

              {/* Approval History */}
              {approvalLogs.length > 0 && (
                <div className="border-t pt-2 max-h-[150px] overflow-y-auto">
                  <div className="text-[9px] font-semibold text-[#8A98AB] mb-1">Historia zatwierdzeń:</div>
                  {approvalLogs.map((log) => (
                    <div key={log.id} className="text-[9px] text-[#8A98AB] mb-1">
                      <span className="font-semibold">{log.action}</span> -{" "}
                      {new Date(log.created_at).toLocaleString("pl-PL")}
                      {log.review_notes && <p className="italic">{log.review_notes}</p>}
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Send Panel */}
          <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
              📤 Wysyłka
            </div>

            <label className="flex items-center gap-2 text-[11px]">
              <input
                type="checkbox"
                checked={requireApproval}
                onChange={(e) => setRequireApproval(e.target.checked)}
              />
              <span className="text-ink font-semibold">Wymagaj zatwierdzenia</span>
            </label>

            <button
              onClick={handleSendNewsletter}
              disabled={
                sending ||
                !sendSubject.trim() ||
                !sendHtml.trim() ||
                activeCount === 0 ||
                (requireApproval && selectedDraft?.status !== "approved")
              }
              className="w-full py-3 rounded-[11px] bg-gradient-to-br from-success to-emerald-600 text-white font-semibold text-[13px] hover:brightness-105 disabled:opacity-50"
            >
              {sending ? "Wysyłanie..." : `Wyślij do ${activeCount}`}
            </button>

            {sendResult && (
              <div className="p-3 bg-[#F6F8FB] rounded-[11px] text-[11px] space-y-1">
                <div className="font-semibold text-success">✅ Wysłano: {sendResult.sent}/{sendResult.total}</div>
                {sendResult.failed > 0 && (
                  <div className="text-danger">❌ Błędy: {sendResult.failed}</div>
                )}
                <div className="text-[#8A98AB]">
                  Dzisiaj: {sendResult.sent_today}/{sendResult.daily_limit}
                </div>
              </div>
            )}
          </div>

          {/* Preview Panel */}
          {showPreview && previewHtml && (
            <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3 max-h-[500px] overflow-y-auto">
              <div className="flex items-center justify-between">
                <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
                  👁️ Podgląd
                </div>
                <div className="flex gap-1">
                  {(["desktop", "mobile", "tablet"] as const).map((type) => (
                    <button
                      key={type}
                      onClick={() => setPreviewType(type)}
                      className={`px-2 py-1 text-[10px] rounded-[6px] ${
                        previewType === type
                          ? "bg-purple-600 text-white"
                          : "bg-[#F0F0F0] text-[#8A98AB]"
                      }`}
                    >
                      {type}
                    </button>
                  ))}
                </div>
              </div>
              <button
                onClick={() => setShowPreview(false)}
                className="w-full py-1 text-[11px] text-[#8A98AB] hover:text-ink"
              >
                Zamknij podgląd
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Drafts */}
      {drafts.length > 0 && (
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
          <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-2">
            📋 Drafty ({drafts.length})
          </div>
          <div className="space-y-2 max-h-[400px] overflow-y-auto">
            {drafts.map((d) => (
              <div
                key={d.id}
                className="flex items-center gap-3 p-3 bg-[#F8FAFC] rounded-[11px] border border-[#EDF1F7] hover:bg-[#F0F4F9] cursor-pointer"
                onClick={() => handleUseDraft(d)}
              >
                <div className="flex-1 min-w-0">
                  <div className="text-[13px] font-semibold text-ink truncate">{d.subject}</div>
                  <div className="text-[10px] text-[#8A98AB] mt-1">
                    Status: <span className="font-bold">{d.status}</span>
                    {d.plagiarism_score !== null && (
                      <span
                        className={`ml-2 ${
                          d.plagiarism_score > 60
                            ? "text-danger"
                            : d.plagiarism_score > 30
                              ? "text-amber"
                              : "text-success"
                        }`}
                      >
                        • Plagiarism: {d.plagiarism_score}%
                      </span>
                    )}
                  </div>
                </div>
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    handleUseDraft(d);
                  }}
                  className="px-3 py-2 rounded-[9px] bg-azure/10 text-azure text-[11px] font-semibold hover:bg-azure/20 shrink-0"
                >
                  Użyj
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Subscribers Management */}
      <div className="grid grid-cols-2 gap-4">
        {/* Add Subscriber */}
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 space-y-3">
          <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
            ➕ Dodaj subskrybenta
          </div>
          <div className="flex gap-2">
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleAdd()}
              placeholder="email@example.com"
              className="flex-1 text-[13px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30"
            />
            <button
              onClick={handleAdd}
              disabled={adding || !email.trim()}
              className="px-5 py-[12px] rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold disabled:opacity-50"
            >
              {adding ? "..." : "Dodaj"}
            </button>
          </div>
        </div>

        {/* Export */}
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-4 flex items-center justify-between">
          <div>
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
              📊 Export
            </div>
            <div className="text-[12px] text-[#8A98AB] mt-2">{activeCount} aktywnych subskrybentów</div>
          </div>
          <button
            onClick={handleExport}
            disabled={activeCount === 0}
            className="px-5 py-2 rounded-[11px] bg-[#F0F0F0] text-[#8A98AB] text-[12px] font-semibold hover:bg-[#E0E0E0] disabled:opacity-50"
          >
            CSV
          </button>
        </div>
      </div>

      {/* Subscribers List */}
      <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] overflow-hidden">
        <div className="flex items-center justify-between p-4 border-b border-[#EDF1F7]">
          <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB]">
            Subskrybenci ({subscribers.length})
          </div>
        </div>

        {loading ? (
          <div className="p-8 text-center text-[#9AA7B8]">Ładowanie...</div>
        ) : subscribers.length === 0 ? (
          <div className="p-8 text-center text-[#9AA7B8]">Brak subskrybentów</div>
        ) : (
          <div className="divide-y divide-[#EDF1F7] max-h-[500px] overflow-y-auto">
            {subscribers.map((s) => (
              <div key={s.id} className="flex items-center gap-3 px-4 py-3 hover:bg-[#F8FAFC]">
                <div className={`w-2 h-2 rounded-full shrink-0 ${s.unsubscribed ? "bg-[#D0D5DD]" : "bg-success"}`} />
                <div className="flex-1 min-w-0">
                  <div className="text-[13px] text-ink font-medium truncate">{s.email}</div>
                  <div className="text-[10px] text-[#8A98AB]">
                    {new Date(s.subscribed_at).toLocaleDateString("pl-PL")}
                    {s.unsubscribed && (
                      <span className="ml-2 text-danger">
                        · wypisany {new Date(s.unsubscribed_at!).toLocaleDateString("pl-PL")}
                      </span>
                    )}
                  </div>
                </div>
                <div className="flex gap-1 shrink-0">
                  {s.unsubscribed ? (
                    <button
                      onClick={() => handleResubscribe(s.id)}
                      className="px-3 py-1.5 rounded-[7px] bg-success/10 text-[11px] font-semibold text-success hover:bg-success/20"
                    >
                      Przywróć
                    </button>
                  ) : (
                    <button
                      onClick={() => handleUnsubscribe(s.id)}
                      className="px-3 py-1.5 rounded-[7px] bg-amber/10 text-[11px] font-semibold text-amber hover:bg-amber/20"
                    >
                      Wypisz
                    </button>
                  )}
                  <button
                    onClick={() => handleDelete(s.id, s.email)}
                    className="px-3 py-1.5 rounded-[7px] bg-danger/10 text-[11px] font-semibold text-danger hover:bg-danger/20"
                  >
                    Usuń
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-lg z-50">
          {toast}
        </div>
      )}
    </div>
  );
}

"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { getSellerSettings, SellerSettings, DEFAULT_SELLER } from "@/lib/invoices";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

const DOC_TYPES = [
  {
    key: "umowa",
    label: "Umowa o świadczenie usług",
    color: "#3E7BD6",
    desc: "Główna umowa Mestio ↔ klient (plan, cena, okres wypowiedzenia).",
    template: `UMOWA O ŚWIADCZENIE USŁUGI MESTIO

zawarta dnia {{data_start}} pomiędzy:

Usługodawcą: AIVOLUX, NIP 000-000-00-00
a
Usługobiorcą: {{firma}}, NIP {{nip}}

§1. Przedmiot umowy: dostęp do systemu Mestio w planie {{plan}}.
§2. Opłata: {{cena}} zł netto / mies.
§3. Umowa obowiązuje do odwołania, okres wypowiedzenia {{okres_wypowiedzenia}} dni.`,
  },
  {
    key: "dpa_rodo",
    label: "Umowa powierzenia danych (RODO)",
    color: "#2E9E6B",
    desc: "Art. 28 RODO — zakres przetwarzania danych mieszkańców, poddostawcy, obowiązki.",
    template: `UMOWA POWIERZENIA PRZETWARZANIA DANYCH OSOBOWYCH (DPA)

zawarta dnia {{data_start}} pomiędzy:
{{firma}}, NIP {{nip}} — zwanym dalej „Administratorem"
a
AIVOLUX — zwanym dalej „Podmiotem przetwarzającym" (Procesorem)

§1. PRZEDMIOT I CHARAKTER PRZETWARZANIA
1. Administrator powierza Procesorowi przetwarzanie danych osobowych w celu świadczenia usługi Mestio (system obsługi zgłoszeń w osiedlu mieszkaniowym), w planie {{plan}}.
2. Charakter przetwarzania: przechowywanie, porządkowanie, udostępnianie upoważnionym użytkownikom, usuwanie — w systemie informatycznym Procesora.
3. Kategorie osób: mieszkańcy, członkowie zarządu/administracji, serwisanci, pracownicy ochrony osiedla.
4. Rodzaje danych: imię i nazwisko, adres e-mail, numer telefonu, adres lokalu, treść zgłoszeń (w tym zdjęcia), historia realizacji zgłoszeń.

§2. UDOKUMENTOWANE POLECENIE (art. 28 ust. 3 lit. a)
Procesor przetwarza dane wyłącznie na udokumentowane polecenie Administratora — za które uważa się niniejszą umowę oraz dyspozycje wydawane przez panel administracyjny usługi. Dotyczy to również przekazywania danych do państwa trzeciego lub organizacji międzynarodowej, chyba że obowiązek taki nakłada na Procesora prawo Unii lub prawo państwa członkowskiego.

§3. POUFNOŚĆ PERSONELU (art. 28 ust. 3 lit. b)
Procesor zapewnia, by osoby upoważnione do przetwarzania danych osobowych zobowiązały się do zachowania tajemnicy lub podlegały odpowiedniemu ustawowemu obowiązkowi zachowania tajemnicy.

§4. BEZPIECZEŃSTWO PRZETWARZANIA (art. 28 ust. 3 lit. c, art. 32)
Procesor wdraża środki techniczne i organizacyjne, w tym: szyfrowanie transmisji (TLS), kontrolę dostępu na poziomie wierszy bazy danych (RLS), uwierzytelnianie użytkowników, kopie zapasowe, rozdzielenie środowisk oraz zasadę minimalnych uprawnień.

§5. PODPOWIERZENIE (art. 28 ust. 3 lit. d)
1. Administrator wyraża ogólną zgodę na korzystanie przez Procesora z następujących podprocesorów: Supabase Inc. (baza danych i uwierzytelnianie), Vercel Inc. (hosting aplikacji), Stripe Inc. (płatności — wyłącznie dane rozliczeniowe Administratora).
2. Procesor poinformuje Administratora o wszelkich zamierzonych zmianach dotyczących dodania lub zastąpienia podprocesorów, dając Administratorowi możliwość wyrażenia sprzeciwu.
3. Na podprocesorów nałożone są te same obowiązki ochrony danych, jakie przewidziano w niniejszej umowie.
4. Jeżeli przetwarzanie przez podprocesora odbywa się poza EOG, następuje ono wyłącznie na podstawie standardowych klauzul umownych (SCC) lub innego mechanizmu z rozdziału V RODO.

§6. POMOC W REALIZACJI PRAW PODMIOTÓW (art. 28 ust. 3 lit. e)
Procesor, biorąc pod uwagę charakter przetwarzania, w miarę możliwości pomaga Administratorowi — poprzez odpowiednie środki techniczne i organizacyjne — wywiązać się z obowiązku odpowiadania na żądania osób, których dane dotyczą (art. 12–23 RODO), w tym udostępnia funkcje eksportu i anonimizacji danych.

§7. POMOC PRZY NARUSZENIACH I DPIA (art. 28 ust. 3 lit. f)
1. Procesor pomaga Administratorowi wywiązać się z obowiązków określonych w art. 32–36 RODO.
2. Procesor zawiadamia Administratora o stwierdzonym naruszeniu ochrony danych bez zbędnej zwłoki, nie później niż w ciągu 36 godzin od wykrycia, przekazując informacje niezbędne do zgłoszenia naruszenia organowi nadzorczemu (art. 33 RODO).

§8. USUNIĘCIE LUB ZWROT DANYCH (art. 28 ust. 3 lit. g)
Po zakończeniu świadczenia usługi Procesor — zależnie od decyzji Administratora — usuwa lub zwraca Administratorowi wszelkie dane osobowe w terminie 90 dni (proces: archiwizacja → powiadomienie o możliwości eksportu → trwałe usunięcie) oraz usuwa istniejące kopie, chyba że prawo Unii lub państwa członkowskiego nakazuje przechowywanie danych (np. dane rozliczeniowe — 5 lat).

§9. AUDYTY (art. 28 ust. 3 lit. h)
Procesor udostępnia Administratorowi wszelkie informacje niezbędne do wykazania spełnienia obowiązków z art. 28 RODO oraz umożliwia Administratorowi lub upoważnionemu audytorowi przeprowadzanie audytów (w tym inspekcji) i przyczynia się do nich — po uprzednim uzgodnieniu terminu, nie częściej niż raz w roku, chyba że audyt jest następstwem naruszenia.

§10. CZAS TRWANIA
Umowa obowiązuje przez okres świadczenia usługi głównej Mestio oraz przez okres realizacji obowiązków z §8.

Administrator: ______________________  Procesor: ______________________`,
  },
  {
    key: "polityka_prywatnosci",
    label: "Polityka prywatności",
    color: "#173A6A",
    desc: "Dokument publiczny — link wysyłany klientowi i publikowany na stronie.",
    template: `POLITYKA PRYWATNOŚCI MESTIO

dla osiedla: {{firma}}

1. Administrator danych: {{firma}}, NIP {{nip}}
2. Cel przetwarzania: obsługa zgłoszeń usterek
3. Podstawa prawna: art. 6 ust. 1 lit. b RODO (umowa)
4. Okres przechowywania: czas trwania umowy + 90 dni
5. Prawa: dostęp, sprostowanie, usunięcie, przenoszenie, sprzeciw`,
  },
  {
    key: "nda",
    label: "NDA — poufność",
    color: "#C98800",
    desc: "Klauzula poufności przy rozmowach handlowych, przed podpisaniem umowy głównej.",
    template: `UMOWA O ZACHOWANIU POUFNOŚCI (NDA)

zawarta pomiędzy:

{{firma}} (Strona Otrzymująca), NIP {{nip}}
a
AIVOLUX (Strona Ujawniająca)

§1. Informacje poufne: dane techniczne, handlowe i operacyjne dot. Mestio.
§2. Strona Otrzymująca nie ujawnia informacji poufnych osobom trzecim.
§3. Obowiązuje {{okres_wypowiedzenia}} miesięcy od podpisania.`,
  },
];

const DOC_VARS = [
  "{{firma}}",
  "{{nip}}",
  "{{data_start}}",
  "{{plan}}",
  "{{cena}}",
  "{{okres_wypowiedzenia}}",
];

const STATUS_LABELS: Record<string, string> = {
  draft: "Szkic",
  generated: "Wygenerowana",
  sent: "Wysłana",
  signed: "Podpisana",
};

const STATUS_COLORS: Record<string, string> = {
  draft: "#6B7A90",
  generated: "#3E7BD6",
  sent: "#F2A900",
  signed: "#2E9E6B",
};

interface ClientDoc {
  id: string;
  lead_id: string;
  type: string;
  title: string;
  body: string;
  status: string;
  signed_at: string | null;
  created_at: string;
  crm_leads?: { company_name: string } | null;
}

export default function DocumentsPage() {
  const [selKey, setSelKey] = useState("umowa");
  const [docs, setDocs] = useState<ClientDoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [editorOpen, setEditorOpen] = useState(false);
  const [editorText, setEditorText] = useState("");
  const [overrides, setOverrides] = useState<Record<string, string>>({});
  const [savingTemplate, setSavingTemplate] = useState(false);
  const [seller, setSeller] = useState<SellerSettings>(DEFAULT_SELLER);
  const [toast, setToast] = useState<string | null>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2400);
  };

  const fetchDocs = async () => {
    setLoading(true);
    const [docsRes, overridesRes, sellerData] = await Promise.all([
      supabase
        .from("client_documents")
        .select("*, crm_leads(company_name)")
        .order("created_at", { ascending: false }),
      supabase.from("crm_settings").select("value").eq("key", "doc_template_overrides").maybeSingle(),
      getSellerSettings(supabase),
    ]);
    setDocs((docsRes.data as ClientDoc[]) ?? []);
    if (overridesRes.data?.value) setOverrides(overridesRes.data.value as Record<string, string>);
    setSeller(sellerData);
    setLoading(false);
  };

  useEffect(() => {
    void fetchDocs();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const selDoc = DOC_TYPES.find((d) => d.key === selKey) ?? DOC_TYPES[0];
  // Wzory wypełniają nazwę i NIP sprzedawcy z Ustawień (audyt: wcześniej hardcoded "AIVOLUX").
  const selTemplate = (overrides[selKey] ?? selDoc.template)
    .replaceAll("AIVOLUX", seller.company || "AIVOLUX")
    .replaceAll("NIP 000-000-00-00", `NIP ${seller.nip || "000-000-00-00"}`);
  const generatedForSel = docs.filter((d) => d.type === selKey);

  const openEditor = () => {
    setEditorText(selTemplate);
    setEditorOpen(true);
  };

  const saveEditor = async () => {
    setSavingTemplate(true);
    const next = { ...overrides, [selKey]: editorText };
    const { error } = await supabase
      .from("crm_settings")
      .upsert({ key: "doc_template_overrides", value: next });
    setSavingTemplate(false);
    if (error) {
      notify("Błąd zapisu: " + error.message);
      return;
    }
    setOverrides(next);
    setEditorOpen(false);
    notify("Zapisano wzór: " + selDoc.label);
  };

  const updateStatus = async (id: string, status: string) => {
    const patch: Record<string, string | null> = { status };
    if (status === "signed") patch.signed_at = new Date().toISOString();
    const { error } = await supabase.from("client_documents").update(patch).eq("id", id);
    if (error) {
      notify("Błąd: " + error.message);
      return;
    }
    fetchDocs();
  };

  return (
    <div className="max-w-6xl mx-auto">
      <div className="grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-[14px]">
        {/* Lewa kolumna: biblioteka wzorów */}
        <div className="flex flex-col gap-[10px]">
          {DOC_TYPES.map((d) => {
            const active = selKey === d.key;
            return (
              <button
                key={d.key}
                onClick={() => setSelKey(d.key)}
                className="bg-white rounded-2xl border border-[#E9EEF5] p-4 px-[17px] text-left transition-colors"
                style={{ border: `2px solid ${active ? d.color : "transparent"}` }}
              >
                <div className="flex items-center gap-2">
                  <span className="w-[9px] h-[9px] rounded-full shrink-0" style={{ background: d.color }} />
                  <span className="font-[family-name:var(--font-heading)] font-semibold text-[13.5px] text-ink">
                    {d.label}
                  </span>
                </div>
                <div className="text-[11.5px] text-[#7C8AA0] mt-[6px] leading-[1.45]">{d.desc}</div>
              </button>
            );
          })}
          <button
            onClick={() => notify("Dodawanie własnego wzoru — wkrótce")}
            className="border-[1.5px] border-dashed border-[#D4DEEA] rounded-2xl p-[14px] text-center text-[#8A98AB] text-[12.5px] font-semibold hover:border-azure/40 hover:text-azure transition-colors"
          >
            + Dodaj własny wzór
          </button>
          <button
            onClick={() => notify("Wgrywanie pliku .docx/.pdf — wkrótce")}
            className="border-[1.5px] border-dashed border-[#D4DEEA] rounded-2xl p-[14px] text-center text-[#8A98AB] text-[12.5px] font-semibold hover:border-azure/40 hover:text-azure transition-colors"
          >
            ⬆ Wgraj plik (.docx/.pdf)
          </button>
        </div>

        {/* Prawa kolumna: szczegóły wzoru */}
        <div className="flex flex-col gap-[14px]">
          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <div className="flex items-center justify-between">
              <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">
                {selDoc.label}
              </div>
              <button onClick={openEditor} className="text-xs font-semibold text-azure hover:text-azure-dark">
                Edytuj wzór
              </button>
            </div>

            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase mt-4 mb-2">
              Dostępne zmienne — wstawiane automatycznie
            </div>
            <div className="flex flex-wrap gap-[6px]">
              {DOC_VARS.map((v) => (
                <span
                  key={v}
                  className="font-[family-name:var(--font-mono)] text-[11px] px-[9px] py-1 rounded-full bg-[#F4F7FB] text-[#5A6B80]"
                >
                  {v}
                </span>
              ))}
            </div>

            <div className="mt-4 py-[12px] px-[14px] rounded-[11px] bg-azure/5 border border-azure/20 text-[12.5px] text-[#3A4759] leading-relaxed">
              Ten wzór generujesz z poziomu karty klienta (zakładka Klienci → wybierz klienta →
              „Wygeneruj umowę”/„Wystaw fakturę”). Tutaj zarządzasz tylko szablonami.
            </div>

            {editorOpen && (
              <div className="mt-4">
                <textarea
                  value={editorText}
                  onChange={(e) => setEditorText(e.target.value)}
                  rows={14}
                  className="w-full text-[12.5px] font-[family-name:var(--font-mono)] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all resize-y leading-relaxed"
                />
                <div className="flex gap-[10px] mt-3">
                  <button
                    onClick={saveEditor}
                    disabled={savingTemplate}
                    className="px-5 py-[10px] rounded-[10px] bg-blueprint text-white text-[13px] font-semibold hover:brightness-110 active:scale-[0.98] transition-all disabled:opacity-50"
                  >
                    {savingTemplate ? "Zapisywanie..." : "Zapisz wzór"}
                  </button>
                  <button
                    onClick={() => setEditorOpen(false)}
                    disabled={savingTemplate}
                    className="px-5 py-[10px] rounded-[10px] bg-[#F4F7FB] text-[#5A6B80] text-[13px] font-semibold hover:bg-[#EAEFF5] transition-colors disabled:opacity-50"
                  >
                    Anuluj
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Wygenerowane dokumenty tego typu */}
          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <div className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.4px] text-[#8A98AB] uppercase mb-3">
              Wygenerowane — {selDoc.label}
            </div>
            {loading ? (
              <div className="flex flex-col gap-2 animate-pulse">
                {[0, 1].map((i) => (
                  <div key={i} className="h-[64px] bg-[#F4F7FB] rounded-[12px]" />
                ))}
              </div>
            ) : generatedForSel.length === 0 ? (
              <div className="text-[12.5px] text-[#9AA7B8] py-2">
                Brak wygenerowanych dokumentów tego typu. Trafią tu automatycznie po wygenerowaniu z karty klienta.
              </div>
            ) : (
              <div className="flex flex-col gap-2">
                {generatedForSel.map((doc) => {
                  const sc = STATUS_COLORS[doc.status] ?? "#6B7A90";
                  return (
                    <div key={doc.id} className="border border-[#F1F5FA] rounded-[12px] p-[14px] px-4">
                      <div className="flex items-center justify-between flex-wrap gap-2">
                        <div className="flex items-center gap-3">
                          <span className="text-[13.5px] font-semibold text-ink">
                            {doc.crm_leads?.company_name ?? "—"}
                          </span>
                          <span
                            className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full"
                            style={{ background: tint(sc, 0.13), color: sc }}
                          >
                            {STATUS_LABELS[doc.status] ?? doc.status}
                          </span>
                        </div>
                        <div className="flex gap-[8px]">
                          {doc.status === "generated" && (
                            <button
                              onClick={() => updateStatus(doc.id, "sent")}
                              className="px-[12px] py-[7px] rounded-[9px] bg-[#F4F7FB] text-blueprint text-[12px] font-semibold hover:bg-[#EAEFF5] transition-colors"
                            >
                              Oznacz wysłaną
                            </button>
                          )}
                          {doc.status !== "signed" && (
                            <button
                              onClick={() => updateStatus(doc.id, "signed")}
                              className="px-[12px] py-[7px] rounded-[9px] bg-success/10 text-success text-[12px] font-semibold hover:bg-success/20 transition-colors"
                            >
                              Oznacz podpisaną
                            </button>
                          )}
                        </div>
                      </div>
                      <div className="font-[family-name:var(--font-mono)] text-[11px] text-[#9AA7B8] mt-[6px]">
                        {new Date(doc.created_at).toLocaleDateString("pl-PL")}
                        {doc.signed_at && ` · podpisana ${new Date(doc.signed_at).toLocaleDateString("pl-PL")}`}
                      </div>
                      <details className="mt-[8px]">
                        <summary className="text-[12px] text-azure cursor-pointer font-medium">Pokaż treść</summary>
                        <pre className="mt-2 p-3 bg-[#F4F7FB] rounded-[10px] text-[11.5px] text-ink whitespace-pre-wrap font-[family-name:var(--font-mono)]">
                          {doc.body}
                        </pre>
                      </details>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-50">
          {toast}
        </div>
      )}
    </div>
  );
}

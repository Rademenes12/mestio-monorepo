"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { SellerSettings, DEFAULT_SELLER } from "@/lib/invoices";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${a})`;
}

const INV_VARS = [
  "{{nr_faktury}}",
  "{{nabywca}}",
  "{{nip_nabywcy}}",
  "{{kwota_netto}}",
  "{{vat}}",
  "{{brutto}}",
  "{{okres}}",
  "{{data_sprzedazy}}",
];

const TABS = ["Dane", "Integracje", "Dokumenty", "AI"];

const lbl = "font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block";
const inp = "w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all";

// ---- INTEGRACJE ----
interface Integration {
  name: string;
  desc: string;
  keyPlaceholder: string;
  webhookUrl?: string;
}

const INTEGRATIONS: Integration[] = [
  { name: "Stripe", desc: "Płatności i subskrypcje", keyPlaceholder: "sk_live_...", webhookUrl: "https://rtyywhbisjaxlpjcugdk.supabase.co/functions/v1/stripe-webhook" },
  { name: "Resend", desc: "Wysyłka e-mail", keyPlaceholder: "re_..." },
  { name: "KSeF", desc: "Krajowy System e-Faktur", keyPlaceholder: "Token API KSeF..." },
  { name: "Autenti (e-podpis)", desc: "Podpisywanie umów online przez API — status wraca do CRM automatycznie", keyPlaceholder: "autenti_live_...", webhookUrl: "https://rtyywhbisjaxlpjcugdk.supabase.co/functions/v1/autenti-webhook" },
];

// ---- DOKUMENTY ----
const DOC_TEMPLATES = [
  { type: "umowa", label: "Umowa główna", desc: "Umowa o świadczenie usług Mestio" },
  { type: "dpa_rodo", label: "DPA (RODO)", desc: "Umowa powierzenia przetwarzania danych" },
  { type: "polityka_prywatnosci", label: "Polityka prywatności", desc: "Dokument dla mieszkańców osiedla" },
  { type: "nda", label: "NDA", desc: "Umowa o zachowaniu poufności" },
];

interface AiSettings {
  provider: "openai" | "anthropic" | "opencode" | "openrouter";
  apiKey: string | null;
  opencodeKey: string | null;
  openrouterKey: string | null;
}

const DEFAULT_AI: AiSettings = { provider: "openai", apiKey: null, opencodeKey: null, openrouterKey: null };

const AI_PROVIDERS = [
  { key: "openai" as const, label: "OpenAI", url: "https://platform.openai.com", placeholder: "sk-..." },
  { key: "anthropic" as const, label: "Anthropic", url: "https://console.anthropic.com", placeholder: "sk-ant-..." },
  { key: "opencode" as const, label: "OpenCode", url: "https://opencode.ai", placeholder: "oc-..." },
  { key: "openrouter" as const, label: "OpenRouter", url: "https://openrouter.ai", placeholder: "sk-or-..." },
];

interface IntegrationSettings {
  autentiMode: "sandbox" | "live";
  ksefMode: "test" | "live";
  keys: Record<string, boolean>; // czy klucz jest ustawiony (nie przechowujemy samego sekretu w tabeli czytelnej z klienta)
}

const DEFAULT_INTEGRATIONS: IntegrationSettings = { autentiMode: "sandbox", ksefMode: "test", keys: {} };

export default function SettingsPage() {
  const [tab, setTab] = useState("Dane");
  const [saved, setSaved] = useState(false);
  const [aiKeyInputs, setAiKeyInputs] = useState<Record<string, string>>({});
  const [ai, setAi] = useState<AiSettings>(DEFAULT_AI);
  const [integrations, setIntegrations] = useState<IntegrationSettings>(DEFAULT_INTEGRATIONS);
  const [integrationKeyInputs, setIntegrationKeyInputs] = useState<Record<string, string>>({});
  const [testResults, setTestResults] = useState<Record<string, string>>({});
  const [owner, setOwner] = useState<SellerSettings>(DEFAULT_SELLER);
  const [ownerDirty, setOwnerDirty] = useState(false);
  const [savingIntegrations, setSavingIntegrations] = useState(false);
  const [savingAi, setSavingAi] = useState(false);
  const [automationsCount, setAutomationsCount] = useState<{ total: number; enabled: number } | null>(null);
  const supabase = createClient();

  useEffect(() => {
    supabase
      .from("crm_settings")
      .select("value")
      .eq("key", "owner_settings")
      .maybeSingle()
      .then(({ data }) => {
        if (data?.value) setOwner({ ...DEFAULT_SELLER, ...(data.value as SellerSettings) });
      });
    supabase
      .from("crm_settings")
      .select("value")
      .eq("key", "ai_provider")
      .maybeSingle()
      .then(({ data }) => {
        if (data?.value) setAi({ ...DEFAULT_AI, ...(data.value as AiSettings) });
      });
    supabase
      .from("crm_settings")
      .select("value")
      .eq("key", "integration_settings")
      .maybeSingle()
      .then(({ data }) => {
        if (data?.value) setIntegrations({ ...DEFAULT_INTEGRATIONS, ...(data.value as IntegrationSettings) });
      });
    // Realny stan silnika automatyzacji (Faza B) - zamiast fikcyjnej osobnej listy
    supabase
      .from("crm_automations")
      .select("enabled")
      .then(({ data }) => {
        if (data) setAutomationsCount({ total: data.length, enabled: data.filter((a) => a.enabled).length });
      });
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const notify = () => { setSaved(true); setTimeout(() => setSaved(false), 2500); };

  const setOwnerField = (k: keyof SellerSettings, v: string) => {
    setOwner((o) => ({ ...o, [k]: v }));
    setOwnerDirty(true);
  };

  const saveOwner = async () => {
    const { error } = await supabase
      .from("crm_settings")
      .upsert({ key: "owner_settings", value: owner });
    if (!error) {
      setOwnerDirty(false);
      notify();
    }
  };

  // Klucze API integracji: trzymamy tylko FLAG "ustawiony/nie" w crm_settings
  // (czytelnej tabeli), nie sam sekret — prawdziwe wdrożenie powinno trzymać
  // klucz w Supabase Vault/Edge Function secrets, nigdy w tabeli odpytywanej
  // z przeglądarki. To pole tylko sygnalizuje właścicielowi status konfiguracji.
  const saveIntegrations = async () => {
    setSavingIntegrations(true);
    const keys = { ...integrations.keys };
    for (const [name, val] of Object.entries(integrationKeyInputs)) {
      if (val.trim()) keys[name] = true;
    }
    const next = { ...integrations, keys };
    const { error } = await supabase
      .from("crm_settings")
      .upsert({ key: "integration_settings", value: next });
    setSavingIntegrations(false);
    if (error) {
      setTestResults((prev) => ({ ...prev, _global: "Błąd zapisu: " + error.message }));
      return;
    }
    setIntegrations(next);
    setIntegrationKeyInputs({});
    notify();
  };

  const aiConnected = (p: string) => {
    if (p === "openai" || p === "anthropic") return !!ai.apiKey;
    if (p === "opencode") return !!ai.opencodeKey;
    if (p === "openrouter") return !!ai.openrouterKey;
    return false;
  };

  const saveAi = async (p: string) => {
    const keyVal = aiKeyInputs[p]?.trim();
    if (!keyVal) {
      setTestResults((prev) => ({ ...prev, _ai: `Wklej klucz API dla ${p}, aby połączyć` }));
      setTimeout(() => setTestResults((prev) => ({ ...prev, _ai: "" })), 3000);
      return;
    }
    setSavingAi(true);
    const next = { ...ai };
    if (p === "openai" || p === "anthropic") {
      next.apiKey = keyVal;
      next.provider = p;
    } else if (p === "opencode") {
      next.opencodeKey = keyVal;
    } else if (p === "openrouter") {
      next.openrouterKey = keyVal;
    }
    const { error } = await supabase.from("crm_settings").upsert({ key: "ai_provider", value: next });
    setSavingAi(false);
    if (error) return;
    setAi(next as AiSettings);
    setAiKeyInputs({});
    notify();
  };

  const disconnectAi = async (p: string) => {
    const next = { ...ai };
    if (p === "openai" || p === "anthropic") {
      next.apiKey = null;
    } else if (p === "opencode") {
      next.opencodeKey = null;
    } else if (p === "openrouter") {
      next.openrouterKey = null;
    }
    await supabase.from("crm_settings").upsert({ key: "ai_provider", value: next });
    setAi(next as AiSettings);
  };

  const setAutentiMode = (m: "sandbox" | "live") => setIntegrations((i) => ({ ...i, autentiMode: m }));
  const setKsefMode = (m: "test" | "live") => setIntegrations((i) => ({ ...i, ksefMode: m }));

  const testConnection = (name: string) => {
    // Naprawiony stale closure: funkcyjny setState, żeby szybkie kolejne kliknięcia
    // (różne integracje) nie nadpisywały się nawzajem przestarzałym stanem.
    setTestResults((prev) => ({ ...prev, [name]: "testowanie..." }));
    const hasKey = !!integrationKeyInputs[name]?.trim() || !!integrations.keys[name];
    setTimeout(() => {
      setTestResults((prev) => ({
        ...prev,
        [name]: hasKey
          ? "Klucz zapisany — integracja wymaga wdrożenia Edge Function ⚠️"
          : "Brak klucza — wpisz klucz API ❌",
      }));
    }, 800);
    setTimeout(() => setTestResults((prev) => ({ ...prev, [name]: "" })), 6000);
  };

  return (
    <div className="max-w-[720px] mx-auto space-y-4">
      <div className="flex gap-[8px] border-b border-[#E4EBF3] pb-0 mb-4">
        {TABS.map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`px-4 py-2.5 text-[12.5px] font-semibold border-b-2 transition-colors ${
              tab === t ? "border-azure text-azure" : "border-transparent text-[#7C8AA0] hover:text-ink"
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      {/* ---- DANE ---- */}
      {tab === "Dane" && (
        <div className="space-y-4">
          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <h2 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink mb-4">Twoje dane</h2>
            <div className="grid grid-cols-2 gap-3">
              <div><div className={lbl}>Firma</div><input value={owner.company} onChange={(e) => setOwnerField("company", e.target.value)} className={inp} /></div>
              <div><div className={lbl}>NIP</div><input value={owner.nip} onChange={(e) => setOwnerField("nip", e.target.value)} placeholder="000-000-00-00" className={inp} /></div>
              <div><div className={lbl}>E-mail</div><input value={owner.email} onChange={(e) => setOwnerField("email", e.target.value)} className={inp} /></div>
              <div><div className={lbl}>Telefon</div><input value={owner.phone} onChange={(e) => setOwnerField("phone", e.target.value)} placeholder="600 000 000" className={inp} /></div>
              <div className="col-span-2"><div className={lbl}>Adres</div><input value={owner.address} onChange={(e) => setOwnerField("address", e.target.value)} placeholder="ul. Przykładowa 1, 00-000 Warszawa" className={inp} /></div>
            </div>
          </div>

          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <h2 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">Dane sprzedawcy i wzór faktury</h2>
            <p className="text-[12.5px] text-[#7C8AA0] leading-normal mt-1">
              Ustawiasz raz — te dane trafiają automatycznie na każdą fakturę i umowę generowaną z karty klienta oraz z modułu Faktury.
            </p>
            <div className="grid grid-cols-2 gap-3 mt-4">
              <div><div className={lbl}>Nr konta (IBAN)</div><input value={owner.iban} onChange={(e) => setOwnerField("iban", e.target.value)} placeholder="PL00 0000 0000 0000 0000 0000 0000" className={`${inp} font-[family-name:var(--font-mono)]`} /></div>
              <div><div className={lbl}>Domyślny termin płatności</div><input value={owner.termin} onChange={(e) => setOwnerField("termin", e.target.value)} placeholder="14 dni" className={inp} /></div>
              <div className="col-span-2"><div className={lbl}>Stopka / uwagi na fakturze</div><input value={owner.stopka} onChange={(e) => setOwnerField("stopka", e.target.value)} className={inp} /></div>
            </div>

            <div className={`${lbl} mt-4 mb-2`}>Zmienne wypełniane automatycznie</div>
            <div className="flex flex-wrap gap-[6px]">
              {INV_VARS.map((v) => (
                <span key={v} className="font-[family-name:var(--font-mono)] text-[11px] px-[9px] py-1 rounded-full bg-[#F4F7FB] text-[#5A6B80]">
                  {v}
                </span>
              ))}
            </div>

            <div className="flex items-center gap-[9px] mt-4 py-[11px] px-[13px] rounded-[11px] bg-azure/5 border border-azure/25">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
                <path d="M12 8v4l3 2M12 3a9 9 0 100 18 9 9 0 000-18z" />
              </svg>
              <span className="text-xs text-[#1f3a5f] leading-snug">
                Faktury wystawiasz ręcznie (kreator w module Faktury albo z karty klienta) — automatyczne wystawianie po
                płatności Stripe wymaga jeszcze wdrożenia webhooka.
              </span>
            </div>
          </div>

          {ownerDirty && (
            <div className="flex items-center gap-[10px] py-[12px] px-[16px] rounded-[11px] bg-amber/10 border border-amber/35">
              <span className="text-[12.5px] text-[#8a6200] flex-1">Masz niezapisane zmiany danych sprzedawcy.</span>
              <button onClick={() => { setOwnerDirty(false); window.location.reload(); }} className="px-[14px] py-[8px] rounded-[9px] bg-white text-[#5A6B80] text-[12.5px] font-semibold hover:bg-white/70 transition-colors">
                Cofnij
              </button>
              <button onClick={saveOwner} className="px-[16px] py-[8px] rounded-[9px] bg-blueprint text-white text-[12.5px] font-semibold hover:brightness-110 transition-all">
                Zapisz zmiany
              </button>
            </div>
          )}
        </div>
      )}

      {/* ---- INTEGRACJE ---- */}
      {tab === "Integracje" && (
        <div className="space-y-4">
          {INTEGRATIONS.map((ig) => {
            const hasKey = !!integrationKeyInputs[ig.name]?.trim() || !!integrations.keys[ig.name];
            const statusColor = hasKey ? "#2E9E6B" : "#6B7A90";
            return (
              <div key={ig.name} className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">{ig.name}</h3>
                    <p className="text-[12.5px] text-[#7C8AA0] mt-1">{ig.desc}</p>
                  </div>
                  <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full shrink-0" style={{ background: tint(statusColor, 0.13), color: statusColor }}>
                    {hasKey ? "Klucz ustawiony" : "Brak klucza"}
                  </span>
                </div>
                <div className={`${lbl} mt-4`}>Klucz API {integrations.keys[ig.name] && "(już zapisany — wklej nowy, aby zmienić)"}</div>
                <input
                  type="password"
                  placeholder={ig.keyPlaceholder}
                  className={`${inp} font-[family-name:var(--font-mono)]`}
                  value={integrationKeyInputs[ig.name] || ""}
                  onChange={(e) => setIntegrationKeyInputs({ ...integrationKeyInputs, [ig.name]: e.target.value })}
                />
                {ig.webhookUrl && (
                  <div className="mt-2">
                    <div className={lbl}>Webhook URL (odbiera status)</div>
                    <div className={`${inp} font-[family-name:var(--font-mono)] text-[11px] text-[#7C8AA0] select-all`}>{ig.webhookUrl}</div>
                  </div>
                )}
                {ig.name.startsWith("Autenti") && (
                  <div className="flex gap-2 mt-3">
                    {(["sandbox", "live"] as const).map((m) => (
                      <button
                        key={m}
                        onClick={() => setAutentiMode(m)}
                        className={`px-[14px] py-2 rounded-[10px] text-[12.5px] font-semibold ${
                          integrations.autentiMode === m ? "bg-blueprint text-white" : "bg-[#F4F7FB] text-[#5A6B80]"
                        }`}
                      >
                        {m === "sandbox" ? "Sandbox" : "Produkcja"}
                      </button>
                    ))}
                  </div>
                )}
                {ig.name === "KSeF" && (
                  <div className="flex gap-2 mt-3">
                    {(["test", "live"] as const).map((m) => (
                      <button
                        key={m}
                        onClick={() => setKsefMode(m)}
                        className={`px-[14px] py-2 rounded-[10px] text-[12.5px] font-semibold ${
                          integrations.ksefMode === m ? "bg-blueprint text-white" : "bg-[#F4F7FB] text-[#5A6B80]"
                        }`}
                      >
                        {m === "test" ? "Testowy" : "Produkcyjny"}
                      </button>
                    ))}
                  </div>
                )}
                <div className="flex items-center gap-[12px] mt-4 flex-wrap">
                  <button
                    onClick={() => testConnection(ig.name)}
                    className="px-[16px] py-[9px] rounded-[9px] bg-[#F4F7FB] text-blueprint text-[12.5px] font-semibold hover:bg-[#EAEFF5] transition-colors shrink-0"
                  >
                    Testuj połączenie
                  </button>
                  {testResults[ig.name] && (
                    <span className="text-[12px] text-[#5A6B80] leading-snug">{testResults[ig.name]}</span>
                  )}
                </div>
              </div>
            );
          })}
          <button
            onClick={saveIntegrations}
            disabled={savingIntegrations}
            className="w-full py-[13px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[14px] rounded-[11px] disabled:opacity-50"
          >
            {savingIntegrations ? "Zapisywanie..." : saved ? "Zapisano!" : "Zapisz integracje"}
          </button>
        </div>
      )}

      {/* ---- DOKUMENTY ---- */}
      {tab === "Dokumenty" && (
        <div className="space-y-4">
          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <h2 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink mb-4">Biblioteka wzorów</h2>
            <div className="space-y-3">
              {DOC_TEMPLATES.map((dt) => (
                <div key={dt.type} className="flex items-center justify-between py-3 border-b border-[#F4F7FB] last:border-0">
                  <div>
                    <div className="font-semibold text-sm text-ink">{dt.label}</div>
                    <div className="text-xs text-[#7C8AA0]">{dt.desc}</div>
                  </div>
                  <a href="/documents" className="text-xs font-medium text-azure px-3 py-1.5 rounded-full bg-azure/10 hover:bg-azure/20">Generuj →</a>
                </div>
              ))}
            </div>
          </div>

          {/* Realny stan silnika automatyzacji (Faza B), nie fikcyjna lista -
              wcześniej ta zakładka miała OSOBNY, niezapisywany zestaw 4 przełączników
              niepowiązany z prawdziwym silnikiem crm_automations (audyt 09.07.2026). */}
          <div className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
            <div className="flex items-center justify-between">
              <h2 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">Automatyzacje</h2>
              {automationsCount && (
                <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full bg-success/10 text-success">
                  {automationsCount.enabled}/{automationsCount.total} aktywnych
                </span>
              )}
            </div>
            <p className="text-[12.5px] text-[#7C8AA0] mt-1">
              Reguły (wyzwalacz → segment → akcja) zarządzasz w osobnej zakładce — tam też włączasz/wyłączasz i edytujesz.
            </p>
          </div>
          <a href="/automations" className="block w-full text-center py-[13px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[14px] rounded-[11px]">
            Przejdź do Automatyzacji
          </a>

          <a href="/documents" className="block w-full text-center py-[13px] bg-[#F4F7FB] text-blueprint font-semibold text-[14px] rounded-[11px]">
            Przejdź do Dokumentów
          </a>
        </div>
      )}

      {/* ---- AI ---- */}
      {tab === "AI" && (
        <div className="space-y-4">
          <p className="text-[12.5px] text-[#7C8AA0] leading-normal">Podłącz klucze API od jednego lub kilku dostawców AI. AI Asystent użyje pierwszego dostępnego. Klucze nigdy nie opuszczają serwera.</p>

          {AI_PROVIDERS.map((prov) => {
            const connected = aiConnected(prov.key);
            return (
              <div key={prov.key} className="bg-white rounded-[12px] border border-[#E9EEF5] p-5">
                <div className="flex items-center justify-between mb-3">
                  <div>
                    <h2 className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">{prov.label}</h2>
                    <a href={prov.url} target="_blank" rel="noopener" className="text-[11px] text-azure hover:underline">{prov.url}</a>
                  </div>
                  <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full" style={{ background: tint(connected ? "#2E9E6B" : "#6B7A90", 0.13), color: connected ? "#2E9E6B" : "#6B7A90" }}>{connected ? "Połączony" : "Niepołączony"}</span>
                </div>
                <div className={`${lbl}`}>Klucz API {connected && "(już zapisany — wklej nowy, aby zmienić)"}</div>
                <input
                  type="password"
                  value={aiKeyInputs[prov.key] ?? ""}
                  onChange={(e) => setAiKeyInputs((prev) => ({ ...prev, [prov.key]: e.target.value }))}
                  placeholder={prov.placeholder}
                  className={`${inp} font-[family-name:var(--font-mono)]`}
                />
                {prov.key === "openai" && (
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-[11px] text-[#7C8AA0]">Domyślny do generowania:</span>
                    <label className="flex items-center gap-1 text-[12px] cursor-pointer">
                      <input type="checkbox" checked={ai.provider === "openai"} onChange={() => setAi({ ...ai, provider: "openai" })} /> OpenAI
                    </label>
                    <label className="flex items-center gap-1 text-[12px] cursor-pointer">
                      <input type="checkbox" checked={ai.provider === "anthropic"} onChange={() => setAi({ ...ai, provider: "anthropic" })} /> Anthropic
                    </label>
                  </div>
                )}
                <div className="flex gap-[10px] mt-4">
                  <button onClick={() => saveAi(prov.key)} disabled={savingAi} className="flex-1 py-[11px] rounded-[11px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] disabled:opacity-50">
                    {savingAi ? "Zapisywanie..." : connected ? "Zmień klucz" : "Połącz i zapisz"}
                  </button>
                  {connected && <button onClick={() => disconnectAi(prov.key)} className="px-4 py-[11px] rounded-[11px] bg-[#F4F7FB] text-danger font-semibold text-[13.5px]">Odłącz</button>}
                </div>
              </div>
            );
          })}

          {testResults._ai && <div className="text-xs text-danger -mt-2">{testResults._ai}</div>}

          <a href="/ai" className="block w-full text-center py-[13px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[14px] rounded-[11px]">
            Otwórz AI Asystenta
          </a>
        </div>
      )}

      {saved && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-50 flex items-center gap-2">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#2E9E6B" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
            <path d="M5 12l5 5 9-11" />
          </svg>
          Zapisano!
        </div>
      )}
    </div>
  );
}

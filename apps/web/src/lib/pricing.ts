import { unstable_cache } from "next/cache";
import { supabase } from "./supabase";
import {
  FALLBACK_PLAN_PRICES,
  FALLBACK_PLAN_AMOUNTS_MAP,
} from "./pricing-fallback";

/**
 * Centralna konfiguracja cen.
 *
 * Czyta z tabeli `pricing_config` w Supabase (edytowalnej z CRM Owner
 * przez PUT /api/admin/pricing). Jeśli tabela nie istnieje — używa fallbacku.
 *
 * Cache: 60 sekund. Po zmianie cen w CRM Owner, nowe wartości
 * pojawią się na stronie w ciągu minuty.
 */

export interface PlanConfig {
  key: string;
  name: string;
  forWho: string;
  amountGrosze: number;
  priceDisplay: string;
  per: string;
  popular: boolean;
  cta: string;
  feats: string[];
}

const STATIC_META: Record<string, Omit<PlanConfig, "amountGrosze" | "priceDisplay">> = {
  start: {
    key: "start",
    name: "Start",
    forWho: "Małe wspólnoty · do 30 mieszkań",
    per: "/ mies.",
    popular: false,
    cta: "Wybierz Start",
    feats: [
      "1 osiedle · do 30 mieszkań",
      "Zgłoszenia + statusy",
      "Ogłoszenia i telefony",
      "Powiadomienia push",
    ],
  },
  standard: {
    key: "standard",
    name: "Standard",
    forWho: "Średnie osiedla · do 100 mieszkań",
    per: "/ mies.",
    popular: true,
    cta: "Wybierz Standard",
    feats: [
      "Do 100 mieszkań",
      "Priorytety + SLA",
      "Ślad audytowy i CSAT",
      "Integracja Trello",
    ],
  },
  pro: {
    key: "pro",
    name: "Pro",
    forWho: "Duże osiedla · do 300 mieszkań",
    per: "/ mies.",
    popular: false,
    cta: "Wybierz Pro",
    feats: [
      "Do 300 mieszkań",
      "Wszystkie funkcje",
      "Priorytetowe wsparcie",
      "Onboarding zespołu",
    ],
  },
  enterprise: {
    key: "enterprise",
    name: "Enterprise",
    forWho: "Zarządcy z kilkoma osiedlami",
    per: "indywidualna",
    popular: false,
    cta: "Porozmawiajmy",
    feats: [
      "Kilka osiedli w jednym panelu",
      "Wszystkie funkcje",
      "Dedykowany opiekun",
      "Umowa SLA i wdrożenie",
    ],
  },
};

/** Synchroniczny fallback — używany w API routes i client components */
export const PLANS: PlanConfig[] = Object.entries(STATIC_META).map(([key, meta]) => {
  const fb = FALLBACK_PLAN_PRICES[key] || { amountGrosze: 0, priceDisplay: "—" };
  return { ...meta, amountGrosze: fb.amountGrosze, priceDisplay: fb.priceDisplay };
});

export const PLAN_AMOUNTS_MAP: Record<string, number> = { ...FALLBACK_PLAN_AMOUNTS_MAP };

/** Pobiera ceny z Supabase (z cachem 60s) — dla komponentów serwerowych */
const getCachedPrices = unstable_cache(
  async (): Promise<Record<string, { amountGrosze: number; priceDisplay: string }>> => {
    try {
      const { data, error } = await supabase
        .from("pricing_config")
        .select("plan_key, amount_grosze, price_display");

      if (error || !data || data.length === 0) return FALLBACK_PLAN_PRICES;

      const result: Record<string, { amountGrosze: number; priceDisplay: string }> = {};
      for (const row of data) {
        result[row.plan_key] = {
          amountGrosze: row.amount_grosze,
          priceDisplay: row.price_display,
        };
      }
      return result;
    } catch {
      return FALLBACK_PLAN_PRICES;
    }
  },
  ["pricing-config-v1"],
  { revalidate: 60, tags: ["pricing"] },
);

/** Pobiera pełną konfigurację planów z aktualnymi cenami (async, dla komponentów serwerowych) */
export async function getPlansLive(): Promise<PlanConfig[]> {
  const prices = await getCachedPrices();
  return Object.entries(STATIC_META).map(([key, meta]) => {
    const price = prices[key] || FALLBACK_PLAN_PRICES[key] || {
      amountGrosze: 0,
      priceDisplay: "—",
    };
    return { ...meta, amountGrosze: price.amountGrosze, priceDisplay: price.priceDisplay };
  });
}

/** Kwota w groszach z bazy (async, dla API routes) */
export async function getPlanAmountGrosze(key: string): Promise<number> {
  const prices = await getCachedPrices();
  return prices[key]?.amountGrosze ?? FALLBACK_PLAN_PRICES[key]?.amountGrosze ?? 0;
}

/** Label z ceną do emaili (async) */
export async function getPlanEmailLabel(key: string): Promise<string> {
  const prices = await getCachedPrices();
  const meta = STATIC_META[key];
  const price = prices[key] || FALLBACK_PLAN_PRICES[key];
  if (!meta) return key;
  return `${meta.name} — ${price?.priceDisplay || "—"}/mc`;
}

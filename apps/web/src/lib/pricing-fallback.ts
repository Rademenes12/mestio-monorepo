/**
 * Fallbackowe ceny — używane gdy Supabase niedostępny.
 * Nie importuj bezpośrednio — użyj pricing.ts.
 */
export const FALLBACK_PLAN_PRICES: Record<string, { amountGrosze: number; priceDisplay: string }> = {
  start: { amountGrosze: 7900, priceDisplay: "79 zł" },
  standard: { amountGrosze: 17900, priceDisplay: "179 zł" },
  pro: { amountGrosze: 34900, priceDisplay: "349 zł" },
  enterprise: { amountGrosze: 0, priceDisplay: "Wycena" },
};

export const FALLBACK_PLAN_AMOUNTS_MAP: Record<string, number> = {
  start: 7900,
  standard: 17900,
  pro: 34900,
  enterprise: 0,
};

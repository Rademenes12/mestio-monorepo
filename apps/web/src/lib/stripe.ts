import Stripe from "stripe";

let _stripe: Stripe | null = null;

export function getStripe(): Stripe {
  if (!_stripe) {
    _stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
      apiVersion: "2026-06-24.dahlia",
    });
  }
  return _stripe;
}

// `price` to kwota w groszach (Stripe unit_amount) - uzywana przez
// jednorazowe platnosci BLIK/P24 w /api/create-payment, ktore nie moga
// uzyc gotowego Stripe Price ID subskrypcji (tamten flow uzywa `priceId`
// przez /api/create-checkout). Enterprise ma price=0 celowo - wycena
// indywidualna, nie do samoobslugowej platnosci jednorazowej.
export const PLANS: Record<
  string,
  { name: string; priceId: string | undefined; price: number }
> = {
  start: { name: "Start", priceId: process.env.STRIPE_PRICE_START, price: 7900 },
  standard: { name: "Standard", priceId: process.env.STRIPE_PRICE_STANDARD, price: 17900 },
  pro: { name: "Pro", priceId: process.env.STRIPE_PRICE_PRO, price: 34900 },
  enterprise: {
    name: "Enterprise",
    priceId: process.env.STRIPE_PRICE_ENTERPRISE,
    price: 0,
  },
};

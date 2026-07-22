import Link from "next/link";
import { getPlansLive } from "@/lib/pricing";

export default async function PricingSection() {
  const PLANS = await getPlansLive();
  return (
    <section id="cennik" className="max-w-[1160px] mx-auto px-6 py-10">
      <div className="text-center">
        <h2 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
          Prosty cennik za osiedle
        </h2>
        <p className="text-base text-[#4A5A6E] mt-[10px]">
          Płaci firma zarządzająca. Rozliczenie miesięczne, faktura VAT. Anuluj
          kiedy chcesz.
        </p>
        <div className="inline-flex items-center gap-2 mt-4 px-4 py-2 rounded-full bg-[rgba(46,158,107,.12)] text-[#1f7a4d] font-semibold text-sm">
          <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#2E9E6B"
            strokeWidth="2.4"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M20 6L9 17l-5-5" />
          </svg>
          Pierwsze 3 miesiące gratis — bez zobowiązań
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mt-[34px] items-stretch">
        {PLANS.map((plan) => {
          const isDark = plan.popular;
          return (
            <div
              key={plan.key}
              className="flex flex-col rounded-[20px] p-[28px_24px] relative"
              style={{
                background: isDark ? "#0E1A2B" : "#fff",
                border: `1px solid ${isDark ? "#0E1A2B" : "#EAF0F7"}`,
                boxShadow: isDark
                  ? "0 24px 50px rgba(14,26,43,.28)"
                  : "0 2px 10px rgba(14,26,43,.05)",
              }}
            >
              {plan.popular && (
                <div className="absolute -top-[11px] left-1/2 -translate-x-1/2 bg-amber text-[#3a2a00] font-mono text-[10.5px] font-semibold px-3 py-1 rounded-full whitespace-nowrap">
                  Najczęściej wybierany
                </div>
              )}

              <h3
                className="font-heading font-semibold text-lg"
                style={{ color: isDark ? "#fff" : "#0E1A2B" }}
              >
                {plan.name}
              </h3>
              <p
                className="text-[13px] mt-1"
                style={{ color: isDark ? "#9FB2CC" : "#7C8AA0" }}
              >
                {plan.forWho}
              </p>

              <div className="flex items-baseline gap-[6px] mt-4 flex-wrap">
                <span
                  className="font-heading font-bold text-[26px] tracking-[-0.6px]"
                  style={{ color: isDark ? "#fff" : "#0E1A2B" }}
                >
                  {plan.priceDisplay}
                </span>
                <span
                  className="text-[13px]"
                  style={{ color: isDark ? "#9FB2CC" : "#7C8AA0" }}
                >
                  {plan.per}
                </span>
              </div>

              <div
                className="h-px my-[18px]"
                style={{
                  background: isDark
                    ? "rgba(255,255,255,.14)"
                    : "#EEF2F8",
                }}
              />

              <div className="flex flex-col gap-[10px]">
                {plan.feats.map((feat) => (
                  <div key={feat} className="flex gap-[9px] items-start">
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke={isDark ? "#7FE0AE" : "#2E9E6B"}
                      strokeWidth="2.4"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="shrink-0 mt-[1px]"
                    >
                      <path d="M5 12l5 5 9-11" />
                    </svg>
                    <span
                      className="text-[13.5px] leading-relaxed"
                      style={{ color: isDark ? "#D5DEEC" : "#3A4759" }}
                    >
                      {feat}
                    </span>
                  </div>
                ))}
              </div>

              <Link
                href={`/zamow?plan=${plan.key}`}
                className="block text-center mt-[22px] py-[13px] rounded-[12px] font-semibold text-[14.5px] cursor-pointer transition-opacity hover:opacity-90"
                style={{
                  background: isDark
                    ? "#fff"
                    : "linear-gradient(135deg, #3E7BD6, #173A6A)",
                  color: isDark ? "#0E1A2B" : "#fff",
                }}
              >
                {plan.cta}
              </Link>
            </div>
          );
        })}
      </div>
    </section>
  );
}

"use client";

import { useRef, useState } from "react";
import { motion, useInView } from "framer-motion";
import Link from "next/link";
import { Check, Sparkles, ArrowRight } from "lucide-react";
import { colors } from "@mestio/design-tokens";

interface PlanConfig {
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

export default function PricingSectionClient({ plans }: { plans: PlanConfig[] }) {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });
  const [annual, setAnnual] = useState(false);

  return (
    <section ref={ref} id="cennik" className="relative py-28" style={{ background: "#FFFFFF" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-12"
        >
          <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: colors.textMuted }}>
            Cennik
          </p>
          <h2
            className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05]"
            style={{ color: colors.text }}
          >
            Prosty cennik{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              za osiedle
            </span>
          </h2>
          <p className="text-[15px] mt-4 w-full max-w-xl mx-auto" style={{ color: colors.textSecondary }}>
            Płaci firma zarządzająca. Rozliczenie miesięczne, faktura VAT. Anuluj kiedy chcesz.
          </p>

          {/* Free badge */}
          <div
            className="inline-flex items-center gap-2 mt-5 px-4 py-2 rounded-full text-sm font-semibold"
            style={{
              background: colors.successMuted,
              color: colors.success,
              border: `1px solid ${colors.success}30`,
            }}
          >
            <Check className="w-4 h-4" />
            Pierwsze 3 miesiące gratis — bez zobowiązań
          </div>

          {/* Billing toggle */}
          <div className="flex items-center justify-center gap-4 mt-8">
            <span
              className="text-sm font-medium transition-colors"
              style={{ color: annual ? colors.textMuted : colors.text }}
            >
              Miesięcznie
            </span>
            <button
              onClick={() => setAnnual(!annual)}
              className="relative w-12 h-6 rounded-full transition-colors"
              style={{
                background: annual ? "#3E7BD6" : colors.bgSecondary,
                border: `1px solid ${annual ? "#3E7BD6" : colors.cardBorder}`,
              }}
              aria-label="Przełącz tryb rozliczeń"
            >
              <motion.div
                animate={{ x: annual ? 22 : 1 }}
                transition={{ type: "spring", stiffness: 500, damping: 30 }}
                className="w-4 h-4 rounded-full bg-white shadow-sm"
                style={{ position: "absolute", top: 1 }}
              />
            </button>
            <span
              className="text-sm font-medium transition-colors"
              style={{ color: annual ? colors.text : colors.textMuted }}
            >
              Rocznie
            </span>
            <span
              className="text-[11px] font-semibold px-2 py-0.5 rounded-full"
              style={{ background: colors.successMuted, color: colors.success }}
            >
              -20%
            </span>
          </div>
        </motion.div>

        {/* Pricing cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 items-stretch">
          {plans.map((plan, i) => {
            const isDark = plan.popular;

            return (
              <motion.div
                key={plan.key}
                initial={{ opacity: 0, y: 30 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.5, delay: 0.15 + i * 0.08 }}
                className="flex flex-col rounded-2xl p-7 relative transition-all duration-300 hover:translate-y-[-4px]"
                style={{
                  background: isDark ? "#0E1A2B" : "#FFFFFF",
                  border: `1px solid ${isDark ? "#0E1A2B" : colors.cardBorder}`,
                  boxShadow: isDark
                    ? "0 20px 50px rgba(14,26,43,0.25)"
                    : "0 2px 10px rgba(14,26,43,0.04)",
                }}
              >
                {plan.popular && (
                  <div
                    className="absolute -top-3 left-1/2 -translate-x-1/2 px-3 py-1 rounded-full text-[10px] font-bold whitespace-nowrap flex items-center gap-1"
                    style={{
                      background: "#F2A900",
                      color: "#3a2a00",
                    }}
                  >
                    <Sparkles className="w-3 h-3" />
                    Najczęściej wybierany
                  </div>
                )}

                {/* Plan name */}
                <h3
                  className="font-heading font-semibold text-lg"
                  style={{ color: isDark ? "#FFF" : colors.text }}
                >
                  {plan.name}
                </h3>
                <p className="text-[12px] mt-1" style={{ color: isDark ? "#9FB2CC" : colors.textMuted }}>
                  {plan.forWho}
                </p>

                {/* Price */}
                <div className="flex items-baseline gap-1.5 mt-5 flex-wrap">
                  <span
                    className="font-heading font-bold text-[28px] tracking-[-0.6px]"
                    style={{ color: isDark ? "#FFF" : colors.text }}
                  >
                    {annual && plan.amountGrosze > 0
                      ? `${Math.round(plan.amountGrosze / 100 * 0.8)} zł`
                      : plan.priceDisplay}
                  </span>
                  <span className="text-[12px]" style={{ color: isDark ? "#9FB2CC" : colors.textMuted }}>
                    {plan.per}
                  </span>
                </div>
                {annual && plan.amountGrosze > 0 && (
                  <span className="text-[11px] mt-1" style={{ color: colors.success }}>
                    Oszczędzasz {Math.round(plan.amountGrosze / 100 * 0.2)} zł/mc
                  </span>
                )}

                {/* Divider */}
                <div
                  className="h-px my-5"
                  style={{ background: isDark ? "rgba(255,255,255,0.12)" : colors.cardBorder }}
                />

                {/* Features */}
                <div className="flex flex-col gap-3 flex-1">
                  {plan.feats.map((feat) => (
                    <div key={feat} className="flex gap-2.5 items-start">
                      <div
                        className="w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-[1px]"
                        style={{ background: isDark ? "rgba(34,197,94,0.12)" : colors.successMuted }}
                      >
                        <Check
                          className="w-3 h-3"
                          style={{ color: isDark ? "#7FE0AE" : colors.success, strokeWidth: 3 }}
                        />
                      </div>
                      <span
                        className="text-[13.5px] leading-relaxed"
                        style={{ color: isDark ? "#D5DEEC" : colors.textSecondary }}
                      >
                        {feat}
                      </span>
                    </div>
                  ))}
                </div>

                {/* CTA */}
                <Link
                  href={`/zamow?plan=${plan.key}`}
                  className="flex items-center justify-center gap-1.5 mt-6 py-3.5 rounded-xl font-semibold text-[14px] transition-all hover:brightness-110"
                  style={{
                    background: isDark ? "#FFF" : "#3E7BD6",
                    color: isDark ? "#0E1A2B" : "#FFF",
                  }}
                >
                  {plan.cta}
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </motion.div>
            );
          })}
        </div>

        {/* Bottom note */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={isInView ? { opacity: 1 } : {}}
          transition={{ delay: 0.6, duration: 0.5 }}
          className="text-center mt-8 text-sm"
          style={{ color: colors.textMuted }}
        >
          Bez limitu użytkowników · bez prowizji · bez ukrytych kosztów · faktura VAT co miesiąc
        </motion.p>
      </div>
    </section>
  );
}

"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { ShoppingCart, QrCode, Users, ArrowRight, Sparkles } from "lucide-react";

const STEPS = [
  {
    n: "1",
    icon: ShoppingCart,
    label: "Zamawiasz na stronie",
    sublabel: "BEZ ZOBOWIĄZAŃ",
    desc: "Rejestrujesz firmę, zarząd lub zarządcę nieruchomości i opłacasz plan. Faktura VAT automatycznie. Pierwsze 3 miesiące gratis.",
    visual: "gradient-blue",
  },
  {
    n: "2",
    icon: QrCode,
    label: "Tworzymy osiedle",
    sublabel: "GOTOWE W MINUTY",
    desc: "Po płatności powstaje Twoje osiedle, a Ty dostajesz kody zaproszeń dla mieszkańców. Każdy kod działa na jedną osobę.",
    visual: "gradient-amber",
  },
  {
    n: "3",
    icon: Users,
    label: "Mieszkańcy dołączają",
    sublabel: "ZERO OPŁAT W APCE",
    desc: "Pobierają darmową aplikację, wpisują kod i od razu mogą zgłaszać usterki, dostawać powiadomienia i śledzić status napraw.",
    visual: "gradient-green",
  },
];

const colorMap: Record<string, string[]> = {
  "gradient-blue": ["#3E7BD6", "#173A6A"],
  "gradient-amber": ["#F2A900", "#C98800"],
  "gradient-green": ["#22C55E", "#166534"],
};

export default function HowItWorksSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} id="jak-to-dziala" className="max-w-7xl mx-auto px-6 py-[80px]">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={isInView ? { opacity: 1, y: 0 } : {}}
        transition={{ duration: 0.6 }}
        className="text-center mb-14"
      >
        <div
          className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-4"
          style={{
            background: `${colors.accent}10`,
            color: colors.accent,
            border: `1px solid ${colors.accent}20`,
          }}
        >
          <Sparkles className="w-3.5 h-3.5" />
          Jak to działa
        </div>
        <h2
          className="font-heading font-bold text-[36px] sm:text-[42px] tracking-[-1px] leading-[1.1]"
          style={{ color: colors.text }}
        >
          Trzy kroki do{" "}
          <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
            uruchomienia
          </span>
        </h2>
        <p className="text-[15px] mt-3 max-w-xl mx-auto" style={{ color: colors.textSecondary }}>
          Od zamówienia do pierwszych zgłoszeń w kilka minut.
        </p>
      </motion.div>

      {/* Steps — Daylight alternating layout */}
      <div className="flex flex-col gap-8">
        {STEPS.map((step, i) => {
          const [from, to] = colorMap[step.visual];
          const Icon = step.icon;
          const isEven = i % 2 === 0;

          return (
            <motion.div
              key={step.n}
              initial={{ opacity: 0, y: 40 }}
              animate={isInView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.7, delay: 0.2 + i * 0.15, ease: "easeOut" as const }}
              className={`flex flex-col ${isEven ? "lg:flex-row" : "lg:flex-row-reverse"} gap-10 lg:gap-16 items-center`}
            >
              {/* Visual block */}
              <div className="flex-1 w-full">
                <div
                  className="rounded-[24px] h-[300px] lg:h-[360px] relative overflow-hidden"
                  style={{
                    background: `linear-gradient(135deg, ${from}18, ${to}08)`,
                    border: `1px solid ${colors.cardBorder}`,
                  }}
                >
                  {/* Abstract geometric visual — Daylight-style */}
                  <div className="absolute inset-0 flex items-center justify-center">
                    {/* Large step number */}
                    <span
                      className="font-heading font-bold text-[140px] leading-none select-none opacity-[0.06]"
                      style={{ color: from }}
                    >
                      {step.n}
                    </span>
                    {/* Center icon */}
                    <div
                      className="absolute w-20 h-20 rounded-[20px] flex items-center justify-center"
                      style={{
                        background: `linear-gradient(135deg, ${from}, ${to})`,
                        boxShadow: `0 12px 40px ${from}30`,
                      }}
                    >
                      <Icon className="w-9 h-9 text-white" />
                    </div>
                    {/* Decorative dots */}
                    <div className="absolute top-8 right-8 flex gap-2">
                      {[...Array(3)].map((_, j) => (
                        <div key={j} className="w-2 h-2 rounded-full" style={{ background: from, opacity: 0.3 - j * 0.08 }} />
                      ))}
                    </div>
                    <div className="absolute bottom-10 left-8 w-32 h-0.5 rounded" style={{ background: `linear-gradient(90deg, ${from}40, transparent)` }} />
                  </div>
                </div>
              </div>

              {/* Text block */}
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-3">
                  <span
                    className="font-mono text-sm font-bold"
                    style={{ color: from }}
                  >
                    Krok {step.n}
                  </span>
                </div>
                <h3
                  className="font-heading font-semibold text-[22px] sm:text-[26px] tracking-[-0.5px] mb-1"
                  style={{ color: colors.text }}
                >
                  {step.label}
                </h3>
                <p
                  className="font-mono text-[10.5px] tracking-[0.5px] uppercase mb-4"
                  style={{ color: colors.textMuted }}
                >
                  {step.sublabel}
                </p>
                <p
                  className="text-[15px] leading-relaxed max-w-[460px]"
                  style={{ color: colors.textSecondary }}
                >
                  {step.desc}
                </p>
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* Footer note */}
      <motion.p
        initial={{ opacity: 0 }}
        animate={isInView ? { opacity: 1 } : {}}
        transition={{ delay: 1, duration: 0.5 }}
        className="text-center mt-14 text-sm"
        style={{ color: colors.textMuted }}
      >
        Firma płaci raz na stronie — mieszkańcy pobierają aplikację za darmo i wpisują kod. Zero opłat w aplikacji.
      </motion.p>
    </section>
  );
}

"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { Sparkles } from "lucide-react";

const STEPS = [
  {
    n: "01",
    label: "Zamawiasz na stronie",
    sublabel: "Bez zobowiązań",
    desc: "Rejestrujesz firmę, zarząd lub zarządcę. Opłacasz plan — faktura VAT automatycznie. Pierwsze 3 miesiące gratis, anulujesz kiedy chcesz.",
    image: "https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&q=80",
    imageAlt: "Nowoczesny budynek mieszkalny",
  },
  {
    n: "02",
    label: "Tworzymy osiedle",
    sublabel: "Gotowe w kilka minut",
    desc: "Po płatności powstaje Twoje osiedle. Dostajesz kody zaproszeń dla mieszkańców — każdy kod działa na jedną osobę. Struktura: budynki, klatki, piętra.",
    image: "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800&q=80",
    imageAlt: "Nowoczesna architektura biurowa",
  },
  {
    n: "03",
    label: "Mieszkańcy dołączają",
    sublabel: "Zero opłat w aplikacji",
    desc: "Pobierają darmową aplikację, wpisują kod i od razu zgłaszają usterki ze zdjęciami. Dostają powiadomienia push o każdej zmianie statusu.",
    image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80",
    imageAlt: "Osoba korzystająca z telefonu",
  },
];

export default function HowItWorksSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} id="jak-to-dziala" className="relative py-28" style={{ background: "#FFF" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="mb-20"
        >
          <div className="flex items-center gap-3 mb-4">
            <span className="font-mono text-[11px] tracking-[0.6px] uppercase" style={{ color: colors.textMuted }}>
              Jak to działa
            </span>
          </div>
          <h2
            className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05]"
            style={{ color: colors.text }}
          >
            Trzy kroki do{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              uruchomienia
            </span>
          </h2>
        </motion.div>

        {/* Steps — Daylight alternating layout with photos */}
        <div className="flex flex-col gap-20 lg:gap-28">
          {STEPS.map((step, i) => {
            const isEven = i % 2 === 0;

            return (
              <motion.div
                key={step.n}
                initial={{ opacity: 0, y: 50 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.8, delay: 0.15 + i * 0.15, ease: "easeOut" as const }}
                className={`flex flex-col ${isEven ? "lg:flex-row" : "lg:flex-row-reverse"} gap-12 lg:gap-20 items-center`}
              >
                {/* Image */}
                <div className="flex-1 w-full">
                  <div className="rounded-2xl overflow-hidden" style={{ boxShadow: `0 4px 24px rgba(14,26,43,0.08)` }}>
                    <img
                      src={step.image}
                      alt={step.imageAlt}
                      className="w-full h-[340px] lg:h-[420px] object-cover"
                      loading="lazy"
                    />
                  </div>
                </div>

                {/* Text */}
                <div className="flex-1">
                  <div className="flex items-center gap-4 mb-4">
                    <span
                      className="font-mono text-sm font-bold tracking-tight"
                      style={{ color: colors.accent }}
                    >
                      {step.n}
                    </span>
                    <div className="h-px flex-1" style={{ background: colors.cardBorder, maxWidth: 60 }} />
                  </div>
                  <h3
                    className="font-heading font-semibold text-[26px] sm:text-[30px] tracking-[-0.5px] mb-3"
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
                    className="text-[15px] leading-relaxed max-w-[440px]"
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
          transition={{ delay: 0.8, duration: 0.5 }}
          className="text-center mt-20 text-sm"
          style={{ color: colors.textMuted }}
        >
          Firma płaci raz na stronie — mieszkańcy pobierają aplikację za darmo. Zero opłat w aplikacji.
        </motion.p>
      </div>
    </section>
  );
}

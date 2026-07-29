"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { Camera, Send, Bell, CircleCheck as CheckCircle2, ArrowRight, Smartphone, Building2, Users } from "lucide-react";
import Link from "next/link";

const STEPS = [
  {
    n: "01",
    icon: Camera,
    label: "Mieszkaniec zgłasza usterkę",
    sublabel: "W 60 sekund z telefonu",
    desc: "Robi zdjęcie usterki, wybiera kategorię i lokalizację (budynek, klatka, mieszkanie), krótki opis. Zgłoszenie ląduje w systemie z unikalnym numerem — MS-2041.",
    color: "#3E7BD6",
    flow: ["Zdjęcie", "Kategoria", "Lokalizacja", "Wyślij"],
  },
  {
    n: "02",
    icon: Bell,
    label: "Zarząd i serwis dostają powiadomienie",
    sublabel: "Push w czasie rzeczywistym",
    desc: "Zarząd widzi nowe zgłoszenie na tablicy spraw. Serwisant dostaje push. Mieszkaniec dostaje potwierdzenie. Nikt nie dzwoni, nikt nie czeka.",
    color: "#F2A900",
    flow: ["Push → Zarząd", "Push → Serwis", "Push → Mieszkaniec"],
  },
  {
    n: "03",
    icon: CheckCircle2,
    label: "Status zmienia się na żywo",
    sublabel: "Nowe → W realizacji → Zamknięte",
    desc: "Zarząd nadaje priorytet. Serwis przejmuje, dodaje komentarz i zdjęcia z naprawy. Mieszkaniec widzi status w aplikacji — bez telefonów, bez pytań.",
    color: "#22C55E",
    flow: ["Nowe", "W realizacji", "Zamknięte"],
  },
];

export default function HowItWorksSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  const fadeUp = (delay: number) => ({
    initial: { opacity: 0, y: 30 },
    animate: isInView ? { opacity: 1, y: 0 } : {},
    transition: { duration: 0.7, delay, ease: "easeOut" as const },
  });

  return (
    <section ref={ref} id="jak-to-dziala" className="relative py-28 overflow-hidden" style={{ background: "#FFF" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div {...fadeUp(0)} className="mb-20">
          <div className="flex items-center gap-3 mb-4">
            <Smartphone className="w-4 h-4" style={{ color: colors.accent }} />
            <span className="font-mono text-[11px] tracking-[0.6px] uppercase" style={{ color: colors.textMuted }}>
              Aplikacja mobilna
            </span>
          </div>
          <h2 className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05] max-w-[600px]">
            <span style={{ color: colors.text }}>Od usterki do</span>{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              naprawy
            </span>{" "}
            <span style={{ color: colors.text }}>w 3 krokach</span>
          </h2>
          <p className="text-[15px] mt-4 max-w-[500px]" style={{ color: colors.textSecondary }}>
            To jest serce Mestio — flow, które widzi mieszkaniec, zarząd i serwis. Każdy w swojej roli,
            wszyscy w jednej aplikacji.
          </p>
        </motion.div>

        {/* Steps — mobile-first vertical flow */}
        <div className="flex flex-col gap-8 lg:gap-6">
          {STEPS.map((step, i) => {
            const Icon = step.icon;
            const isLast = i === STEPS.length - 1;

            return (
              <motion.div key={step.n} {...fadeUp(0.15 + i * 0.12)}>
                <div className="flex gap-6 lg:gap-8 items-start">
                  {/* Step number + connecting line */}
                  <div className="flex flex-col items-center shrink-0">
                    <div
                      className="w-14 h-14 rounded-2xl flex items-center justify-center relative z-10"
                      style={{
                        background: `${step.color}12`,
                        border: `1px solid ${step.color}25`,
                      }}
                    >
                      <Icon className="w-6 h-6" style={{ color: step.color }} />
                    </div>
                    {!isLast && (
                      <div
                        className="w-0.5 flex-1 mt-2 mb-2"
                        style={{
                          background: `linear-gradient(180deg, ${step.color}30, ${step.color}08)`,
                          minHeight: 40,
                        }}
                      />
                    )}
                  </div>

                  {/* Content */}
                  <div className="flex-1 pt-1 pb-8">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="font-mono text-sm font-bold" style={{ color: step.color }}>
                        {step.n}
                      </span>
                      <span
                        className="font-mono text-[10.5px] tracking-[0.5px] uppercase"
                        style={{ color: colors.textMuted }}
                      >
                        {step.sublabel}
                      </span>
                    </div>
                    <h3
                      className="font-heading font-semibold text-[24px] sm:text-[28px] tracking-[-0.5px] mb-3"
                      style={{ color: colors.text }}
                    >
                      {step.label}
                    </h3>
                    <p className="text-[15px] leading-relaxed max-w-[520px] mb-5" style={{ color: colors.textSecondary }}>
                      {step.desc}
                    </p>

                    {/* Flow chips */}
                    <div className="flex flex-wrap items-center gap-2">
                      {step.flow.map((chip, ci) => (
                        <div key={chip} className="flex items-center gap-2">
                          <motion.div
                            className="px-3 py-1.5 rounded-lg text-[12px] font-medium"
                            style={{
                              background: `${step.color}0A`,
                              color: step.color,
                              border: `1px solid ${step.color}20`,
                            }}
                            initial={{ opacity: 0, x: -10 }}
                            animate={isInView ? { opacity: 1, x: 0 } : {}}
                            transition={{ delay: 0.3 + i * 0.12 + ci * 0.08 }}
                          >
                            {chip}
                          </motion.div>
                          {ci < step.flow.length - 1 && (
                            <ArrowRight className="w-3 h-3" style={{ color: colors.textLight }} />
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>

        {/* Ecosystem note */}
        <motion.div
          {...fadeUp(0.6)}
          className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-4 pt-12"
          style={{ borderTop: `1px solid ${colors.cardBorder}` }}
        >
          {[
            { icon: Smartphone, label: "Aplikacja mobilna", desc: "Mieszkaniec, serwis, ochrona — na co dzień", color: "#3E7BD6" },
            { icon: Building2, label: "Panel osiedla", desc: "Zarząd i administrator — praca biurowa", color: "#173A6A" },
            { icon: Users, label: "CRM właściciela", desc: "Ty — pipeline, faktury, KPI", color: "#22C55E" },
          ].map((item) => {
            const Icon = item.icon;
            return (
              <div key={item.label} className="flex items-start gap-3 p-4 rounded-xl" style={{ background: colors.bgSecondary }}>
                <div
                  className="w-9 h-9 rounded-lg flex items-center justify-center shrink-0"
                  style={{ background: `${item.color}12` }}
                >
                  <Icon className="w-4 h-4" style={{ color: item.color }} />
                </div>
                <div>
                  <div className="text-[13px] font-semibold" style={{ color: colors.text }}>{item.label}</div>
                  <div className="text-[12px] mt-0.5" style={{ color: colors.textMuted }}>{item.desc}</div>
                </div>
              </div>
            );
          })}
        </motion.div>

        {/* Footer CTA */}
        <motion.div {...fadeUp(0.7)} className="flex justify-center mt-12">
          <Link
            href="/zamow"
            className="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl text-sm font-semibold text-white transition-all hover:brightness-110"
            style={{
              background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
              boxShadow: "0 4px 16px rgba(62,123,214,0.25)",
            }}
          >
            Uruchom dla swojego osiedla
            <ArrowRight className="w-4 h-4" />
          </Link>
        </motion.div>
      </div>
    </section>
  );
}

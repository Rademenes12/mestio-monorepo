"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { X, Check, Sparkles } from "lucide-react";

const PAIN_POINTS = [
  "Zgłoszenia giną w SMS-ach, telefonach i grupach na Facebooku",
  "Mieszkaniec nie wie, czy ktoś się zajął sprawą",
  "Zarząd nie ma historii ani dowodu, co i kiedy naprawiono",
  "Serwis dostaje niejasne opisy bez zdjęć i lokalizacji",
];

const GAIN_POINTS = [
  "Jeden strumień zgłoszeń ze statusem i historią",
  "Mieszkaniec widzi status i dostaje powiadomienia",
  "Pełny ślad audytowy — kto, co i kiedy zrobił",
  "Zdjęcia, PDF i dokładna lokalizacja w każdym zgłoszeniu",
];

const PROBLEM_STATS = [
  { value: "78%", label: "zgłoszeń gubi się poza systemem" },
  { value: "3 dni", label: "średni czas reakcji bez narzędzia" },
];

const GAIN_STATS = [
  { value: "<60s", label: "czas zgłoszenia usterki" },
  { value: "0", label: "zgubionych zgłoszeń" },
];

export default function ProblemSolutionSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  const anim = (delay: number, xDir = -1) => ({
    initial: { opacity: 0, x: 20 * xDir },
    animate: isInView ? { opacity: 1, x: 0 } : { opacity: 0, x: 20 * xDir },
    transition: { duration: 0.5, delay: 0.3 + delay * 0.08, ease: "easeOut" as const },
  });

  return (
    <section ref={ref} className="relative py-24 overflow-hidden" style={{ background: colors.bg }}>
      {/* Subtle grid background — Daylight blueprint feel */}
      <div
        className="absolute inset-0 opacity-[0.35] pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(${colors.cardBorder} 1px, transparent 1px),
                            linear-gradient(90deg, ${colors.cardBorder} 1px, transparent 1px)`,
          backgroundSize: "60px 60px",
          maskImage: "radial-gradient(ellipse 80% 60% at 50% 0%, black 40%, transparent 80%)",
          WebkitMaskImage: "radial-gradient(ellipse 80% 60% at 50% 0%, black 40%, transparent 80%)",
        }}
      />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        {/* Section header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
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
            Dlaczego Mestio
          </div>
          <h2
            className="font-heading font-bold text-[36px] sm:text-[42px] tracking-[-1px] leading-[1.1]"
            style={{ color: colors.text }}
          >
            Koniec z chaosem{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              zgłoszeń
            </span>
          </h2>
          <p className="text-[15px] mt-3 max-w-xl mx-auto" style={{ color: colors.textSecondary }}>
            Tradycyjny obieg zgłoszeń to strata czasu. Mestio zamienia bałagan w przejrzysty proces.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
          {/* ── BEFORE ── */}
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            animate={isInView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.7, delay: 0.2, ease: "easeOut" as const }}
            className="rounded-[24px] p-10 relative overflow-hidden"
            style={{
              background: "#FFF",
              border: `1px solid ${colors.cardBorder}`,
              boxShadow: "0 1px 3px rgba(14,26,43,0.04)",
            }}
          >
            <div
              className="absolute top-0 left-0 w-1 h-16 rounded-full -translate-x-0.5"
              style={{ background: "linear-gradient(180deg, #EF4444, transparent)" }}
            />

            <div
              className="flex items-center gap-2 font-mono text-[11px] tracking-[0.6px] uppercase mb-6"
              style={{ color: "#EF4444" }}
            >
              <X className="w-3.5 h-3.5" />
              Bez Mestio
            </div>

            <div className="flex gap-6 mb-8">
              {PROBLEM_STATS.map((s, i) => (
                <motion.div key={s.label} {...anim(i, -1)}>
                  <div
                    className="font-heading font-bold text-[28px] tracking-[-0.5px]"
                    style={{ color: "#EF4444" }}
                  >
                    {s.value}
                  </div>
                  <div className="text-[12px] mt-0.5" style={{ color: colors.textMuted }}>
                    {s.label}
                  </div>
                </motion.div>
              ))}
            </div>

            <div className="flex flex-col gap-[14px]">
              {PAIN_POINTS.map((point, i) => (
                <motion.div key={point} className="flex gap-3 items-start" {...anim(i + 2, -1)}>
                  <div
                    className="w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-0.5"
                    style={{ background: "rgba(239,68,68,0.1)" }}
                  >
                    <X className="w-3 h-3" style={{ color: "#EF4444" }} />
                  </div>
                  <span className="text-[14.5px] leading-relaxed" style={{ color: colors.textSecondary }}>
                    {point}
                  </span>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* ── AFTER ── */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            animate={isInView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.7, delay: 0.3, ease: "easeOut" as const }}
            className="rounded-[24px] p-10 relative overflow-hidden"
            style={{
              background: colors.accent,
              boxShadow: `0 24px 50px ${colors.darkBlueShadow}`,
            }}
          >
            <div
              className="flex items-center gap-2 font-mono text-[11px] tracking-[0.6px] uppercase mb-6"
              style={{ color: "rgba(255,255,255,0.8)" }}
            >
              <Check className="w-3.5 h-3.5" />
              Z Mestio
            </div>

            <div className="flex gap-6 mb-8">
              {GAIN_STATS.map((s, i) => (
                <motion.div key={s.label} {...anim(i, 1)}>
                  <div
                    className="font-heading font-bold text-[28px] tracking-[-0.5px]"
                    style={{ color: "#FFF" }}
                  >
                    {s.value}
                  </div>
                  <div className="text-[12px] mt-0.5" style={{ color: "rgba(255,255,255,0.7)" }}>
                    {s.label}
                  </div>
                </motion.div>
              ))}
            </div>

            <div className="flex flex-col gap-[14px]">
              {GAIN_POINTS.map((point, i) => (
                <motion.div key={point} className="flex gap-3 items-start" {...anim(i + 2, 1)}>
                  <div
                    className="w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-0.5"
                    style={{ background: "rgba(255,255,255,0.2)" }}
                  >
                    <Check className="w-3 h-3" style={{ color: "#FFF", strokeWidth: 3 }} />
                  </div>
                  <span className="text-[14.5px] leading-relaxed" style={{ color: "rgba(255,255,255,0.95)" }}>
                    {point}
                  </span>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}

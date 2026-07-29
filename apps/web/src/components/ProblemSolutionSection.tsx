"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { X, Check } from "lucide-react";

const PAIN = [
  "Zgłoszenia giną w SMS-ach, telefonach i grupach na Facebooku",
  "Mieszkaniec nie wie, czy ktoś się zajął sprawą",
  "Zarząd nie ma historii ani dowodu, co i kiedy naprawiono",
  "Serwis dostaje niejasne opisy bez zdjęć i lokalizacji",
];

const GAIN = [
  "Jeden strumień zgłoszeń ze statusem i historią",
  "Mieszkaniec widzi status i dostaje powiadomienia push",
  "Pełny ślad audytowy — kto, co i kiedy zrobił",
  "Zdjęcia i dokładna lokalizacja w każdym zgłoszeniu",
];

export default function ProblemSolutionSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-15%" });

  const fadeSlide = (delay: number, xDir = -1) => ({
    initial: { opacity: 0, x: 24 * xDir },
    animate: isInView ? { opacity: 1, x: 0 } : {},
    transition: { duration: 0.6, delay: 0.2 + delay * 0.07, ease: "easeOut" as const },
  });

  return (
    <section ref={ref} className="relative py-28 overflow-hidden" style={{ background: colors.bg }}>
      {/* Blueprint grid — Daylight signature */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(${colors.cardBorder} 1px, transparent 1px),
                            linear-gradient(90deg, ${colors.cardBorder} 1px, transparent 1px)`,
          backgroundSize: "80px 80px",
          backgroundPosition: "center center",
          opacity: 0.5,
          maskImage: "radial-gradient(ellipse 70% 50% at 50% 30%, black 30%, transparent 80%)",
          WebkitMaskImage: "radial-gradient(ellipse 70% 50% at 50% 30%, black 30%, transparent 80%)",
        }}
      />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        {/* Header — Daylight: small label + big headline */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="mb-20"
        >
          <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: colors.textMuted }}>
            Problem
          </p>
          <h2
            className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05]"
            style={{ color: colors.text }}
          >
            Koniec z chaosem{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              zgłoszeń
            </span>
          </h2>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
          {/* ── BEZ MESTIO ── */}
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            animate={isInView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.7, delay: 0.2, ease: "easeOut" as const }}
          >
            <p className="font-mono text-[11px] tracking-[0.5px] uppercase mb-6" style={{ color: "#EF4444" }}>
              Bez Mestio
            </p>

            {/* Big stat */}
            <div className="mb-8">
              <span className="font-heading font-bold text-[72px] leading-none tracking-[-2px]" style={{ color: "#EF4444" }}>
                78%
              </span>
              <p className="text-[15px] mt-2 max-w-[320px]" style={{ color: colors.textSecondary }}>
                zgłoszeń gubi się w SMS-ach i na telefonach
              </p>
            </div>

            <div className="flex flex-col gap-4">
              {PAIN.map((p, i) => (
                <motion.div key={p} className="flex gap-3 items-start" {...fadeSlide(i, -1)}>
                  <div className="w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-0.5" style={{ background: "rgba(239,68,68,0.08)" }}>
                    <X className="w-3 h-3" style={{ color: "#EF4444" }} />
                  </div>
                  <span className="text-[15px] leading-relaxed" style={{ color: colors.textSecondary }}>{p}</span>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* ── Z MESTIO ── */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            animate={isInView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.7, delay: 0.3, ease: "easeOut" as const }}
          >
            <p className="font-mono text-[11px] tracking-[0.5px] uppercase mb-6" style={{ color: colors.success }}>
              Z Mestio
            </p>

            <div className="mb-8">
              <span className="font-heading font-bold text-[72px] leading-none tracking-[-2px]" style={{ color: colors.success }}>
                0
              </span>
              <p className="text-[15px] mt-2 max-w-[320px]" style={{ color: colors.textSecondary }}>
                zgubionych zgłoszeń — każde ma status i historię
              </p>
            </div>

            <div className="flex flex-col gap-4">
              {GAIN.map((g, i) => (
                <motion.div key={g} className="flex gap-3 items-start" {...fadeSlide(i, 1)}>
                  <div className="w-5 h-5 rounded-full flex items-center justify-center shrink-0 mt-0.5" style={{ background: "rgba(34,197,94,0.1)" }}>
                    <Check className="w-3 h-3" style={{ color: colors.success, strokeWidth: 3 }} />
                  </div>
                  <span className="text-[15px] leading-relaxed" style={{ color: colors.text }}>{g}</span>
                </motion.div>
              ))}
            </div>

            {/* Small stat badge */}
            <motion.div
              {...fadeSlide(4, 1)}
              className="inline-flex items-center gap-3 mt-8 px-5 py-3 rounded-xl"
              style={{ background: "rgba(34,197,94,0.06)", border: "1px solid rgba(34,197,94,0.12)" }}
            >
              <span className="font-heading font-bold text-xl" style={{ color: colors.success }}>&lt;60s</span>
              <span className="text-sm" style={{ color: colors.textSecondary }}>czas zgłoszenia usterki</span>
            </motion.div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}

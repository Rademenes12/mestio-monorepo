"use client";

import { useRef } from "react";
import { motion, useScroll, useTransform } from "framer-motion";
import Link from "next/link";
import { ArrowRight } from "lucide-react";
import PhoneMockup from "./PhoneMockup";
import LiveStatsWidget from "./LiveStatsWidget";

const HERO_STATS = [
  { value: "5", label: "ról w jednej apce" },
  { value: "∞", label: "użytkowników bez limitu" },
  { value: "0%", label: "prowizji" },
  { value: "<60s", label: "zgłoszenie usterki" },
];

export default function HeroSection() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start start", "end start"] });
  const bgY = useTransform(scrollYProgress, [0, 1], ["0%", "25%"]);
  const contentOpacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);

  const fadeIn = (delay: number) => ({
    initial: { opacity: 0, y: 30 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.7, delay, ease: [0.25, 0.4, 0.25, 1] as const },
  });

  return (
    <section ref={ref} className="relative min-h-screen flex items-center overflow-hidden">
      {/* Dark background with subtle gradient */}
      <motion.div className="absolute inset-0" style={{ y: bgY }}>
        <div
          className="absolute inset-0"
          style={{
            background: "linear-gradient(180deg, #0A1524 0%, #0D1A2E 40%, #0E1A2B 70%, #0A1524 100%)",
          }}
        />
        {/* Blueprint grid */}
        <div
          className="absolute inset-0"
          style={{
            backgroundImage: `linear-gradient(rgba(62,123,214,0.04) 1px, transparent 1px),
                              linear-gradient(90deg, rgba(62,123,214,0.04) 1px, transparent 1px)`,
            backgroundSize: "80px 80px",
            maskImage: "radial-gradient(ellipse 70% 60% at 50% 40%, black 20%, transparent 80%)",
            WebkitMaskImage: "radial-gradient(ellipse 70% 60% at 50% 40%, black 20%, transparent 80%)",
          }}
        />
        {/* Blue glow */}
        <div
          className="absolute inset-0"
          style={{
            background: "radial-gradient(ellipse 50% 40% at 70% 30%, rgba(62,123,214,0.12) 0%, transparent 60%)",
          }}
        />
      </motion.div>

      <motion.div className="relative z-10 w-full max-w-7xl mx-auto px-6 pt-28 pb-24" style={{ opacity: contentOpacity }}>
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_0.85fr] gap-12 lg:gap-8 items-center">
          {/* ── Left: Content + Live Stats ── */}
          <div>
            {/* Badge */}
            <motion.div
              {...fadeIn(0)}
              className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold"
              style={{
                background: "rgba(255,255,255,0.06)",
                color: "rgba(255,255,255,0.85)",
                border: "1px solid rgba(255,255,255,0.1)",
                backdropFilter: "blur(10px)",
              }}
            >
              <motion.span
                className="w-1.5 h-1.5 rounded-full"
                style={{ background: "#22C55E" }}
                animate={{ opacity: [1, 0.3, 1] }}
                transition={{ duration: 1.5, repeat: Infinity }}
              />
              Na żywo · 12 zgłoszeń aktywnych teraz
            </motion.div>

            {/* Heading */}
            <motion.h1
              {...fadeIn(0.15)}
              className="font-heading font-bold text-[44px] sm:text-[52px] lg:text-[56px] leading-[1.04] tracking-[-1.8px] mt-6"
            >
              <span style={{ color: "#FFF", display: "block" }}>
                Zarządzanie{" "}
                <span style={{ fontStyle: "italic", color: "#F2A900" }}>osiedlem</span>
              </span>
              <span className="block bg-gradient-to-r from-[#3E7BD6] via-[#5B9AE8] to-[#3E7BD6] bg-clip-text text-transparent">
                wreszcie pod kontrolą
              </span>
            </motion.h1>

            <motion.p
              {...fadeIn(0.3)}
              className="text-[15px] sm:text-base leading-relaxed mt-5 max-w-[460px]"
              style={{ color: "rgba(255,255,255,0.55)" }}
            >
              Mestio to aplikacja, w której mieszkaniec zgłasza usterkę w kilka sekund,
              a zarządca, zarząd i serwis prowadzą ją od &bdquo;Nowe&rdquo; aż do
              &bdquo;Zamknięte&rdquo; — z historią, powiadomieniami i pełną kontrolą.
            </motion.p>

            {/* Glass pill CTA */}
            <motion.div {...fadeIn(0.45)} className="mt-8">
              <div
                className="flex items-center max-w-[400px] h-[56px] rounded-[14px] overflow-hidden transition-all duration-300"
                style={{
                  background: "rgba(255,255,255,0.05)",
                  backdropFilter: "blur(12px)",
                  border: "1px solid rgba(255,255,255,0.14)",
                  boxShadow: "0 8px 32px rgba(0,0,0,0.25), 0 0 0 1px rgba(255,255,255,0.04)",
                }}
              >
                <input
                  placeholder="Nazwa Twojego osiedla"
                  className="flex-1 h-full bg-transparent border-none outline-none px-5 text-[15px] placeholder:text-white/35"
                  style={{ color: "#FFF", letterSpacing: "-0.02em" }}
                  aria-label="Nazwa osiedla"
                />
                <Link
                  href="/zamow"
                  className="flex items-center justify-center h-[44px] px-6 m-[6px] rounded-[10px] text-sm font-semibold text-white transition-all hover:brightness-110 shrink-0"
                  style={{
                    background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                    boxShadow: "0 4px 20px rgba(62,123,214,0.35)",
                  }}
                >
                  <span className="hidden sm:inline">Sprawdź dostępność</span>
                  <span className="sm:hidden">Sprawdź</span>
                  <ArrowRight className="w-4 h-4 ml-1.5" />
                </Link>
              </div>
            </motion.div>

            {/* Stats row */}
            <motion.div
              {...fadeIn(0.6)}
              className="flex gap-8 mt-10 pt-6"
              style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}
            >
              {HERO_STATS.map((stat) => (
                <div key={stat.label}>
                  <div
                    className="font-heading font-bold text-[22px] tracking-[-0.4px]"
                    style={{ color: "#FFF" }}
                  >
                    {stat.value}
                  </div>
                  <div className="text-[11px] mt-0.5 whitespace-nowrap" style={{ color: "rgba(255,255,255,0.35)" }}>
                    {stat.label}
                  </div>
                </div>
              ))}
            </motion.div>

            {/* Live stats widgets — below content on desktop */}
            <motion.div {...fadeIn(0.75)} className="mt-10 hidden lg:block">
              <LiveStatsWidget />
            </motion.div>
          </div>

          {/* ── Right: Animated Phone Mockup ── */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ duration: 0.9, delay: 0.3, ease: [0.25, 0.4, 0.25, 1] as const }}
            className="flex justify-center lg:justify-end"
          >
            <PhoneMockup />
          </motion.div>
        </div>
      </motion.div>

      {/* Scroll indicator */}
      <motion.div
        className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.4, duration: 0.8 }}
      >
        <span className="text-[10px] uppercase tracking-[0.2em]" style={{ color: "rgba(255,255,255,0.25)" }}>
          Przewiń
        </span>
        <motion.div
          animate={{ y: [0, 6, 0] }}
          transition={{ duration: 1.8, repeat: Infinity, ease: "easeInOut" }}
          style={{ color: "rgba(255,255,255,0.25)" }}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 5v14M19 12l-7 7-7-7" />
          </svg>
        </motion.div>
      </motion.div>
    </section>
  );
}

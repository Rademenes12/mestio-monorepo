"use client";

import { useRef } from "react";
import { motion, useScroll, useTransform } from "framer-motion";
import Link from "next/link";
import { colors } from "@mestio/design-tokens";
import { Sparkles, ArrowRight, Smartphone, Bell, MessageSquare, Wrench } from "lucide-react";

const HERO_STATS = [
  { value: 5, display: "5", label: "ról w jednej apce" },
  { value: Infinity, display: "∞", label: "użytkowników bez limitu" },
  { value: 0, display: "0%", label: "prowizji" },
  { value: 60, display: "<60s", label: "zgłoszenie usterki" },
];

const STATUS_FLOW = [
  { label: "Nowe", icon: "M12 7v10M7 12h10", color: colors.info, done: true },
  { label: "W realizacji", icon: "M9.5 8l6 4-6 4z", color: colors.warning, done: true, active: true },
  { label: "Zamknięte", icon: "M6 12l3.5 4 8.5-8", color: colors.success, done: false },
];

export default function HeroSection() {
  const ref = useRef<HTMLElement>(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start start", "end start"] });
  const bgY = useTransform(scrollYProgress, [0, 1], ["0%", "30%"]);
  const opacity = useTransform(scrollYProgress, [0, 0.6], [1, 0]);

  const fadeIn = (delay: number) => ({
    initial: { opacity: 0, y: 30 },
    animate: { opacity: 1, y: 0 },
    transition: { duration: 0.7, delay, ease: [0.25, 0.4, 0.25, 1] as const },
  });

  return (
    <section ref={ref} className="relative min-h-screen flex items-center overflow-hidden">
      {/* Dark background with gradient glow */}
      <motion.div className="absolute inset-0" style={{ y: bgY }}>
        <div
          className="absolute inset-0"
          style={{ background: "linear-gradient(180deg, #0A1628 0%, #0E1A2B 40%, #13243D 100%)" }}
        />
        <div
          className="absolute inset-0"
          style={{
            background: `radial-gradient(ellipse 70% 50% at 50% -10%, rgba(62,123,214,0.18) 0%, transparent 65%),
                          radial-gradient(ellipse 40% 50% at 20% 80%, rgba(62,123,214,0.08) 0%, transparent 70%),
                          radial-gradient(ellipse 30% 50% at 80% 50%, rgba(242,169,0,0.06) 0%, transparent 60%)`,
          }}
        />
        <div
          className="absolute inset-0 opacity-[0.03]"
          style={{
            backgroundImage: `linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px),
                              linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)`,
            backgroundSize: "80px 80px",
          }}
        />
      </motion.div>

      <motion.div className="relative z-10 w-full max-w-7xl mx-auto px-6 pt-24 pb-20" style={{ opacity }}>
        <div className="grid grid-cols-1 lg:grid-cols-[1.15fr_0.85fr] gap-16 items-center">
          {/* ── Left: Content ── */}
          <div>
            {/* Badge */}
            <motion.div
              {...fadeIn(0)}
              className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold"
              style={{
                background: "rgba(255,255,255,0.06)",
                color: "rgba(255,255,255,0.9)",
                border: "1px solid rgba(255,255,255,0.12)",
                backdropFilter: "blur(10px)",
              }}
            >
              <Sparkles className="w-3.5 h-3.5" style={{ color: "#3E7BD6" }} />
              Dla zarządców nieruchomości, wspólnot i osiedli
            </motion.div>

            {/* Heading */}
            <motion.h1
              {...fadeIn(0.15)}
              className="font-heading font-bold text-[44px] sm:text-[52px] lg:text-[56px] leading-[1.05] tracking-[-1.8px] mt-6"
              style={{ color: "#FFF" }}
            >
              Zarządzanie{" "}
              <span style={{ color: "#F2A900" }}>osiedlem</span>
              <br />
              wreszcie pod{" "}
              <span className="bg-gradient-to-r from-[#3E7BD6] to-[#6DB3F2] bg-clip-text text-transparent">
                kontrolą
              </span>
            </motion.h1>

            <motion.p
              {...fadeIn(0.3)}
              className="text-[15px] leading-relaxed mt-5 max-w-[460px]"
              style={{ color: "rgba(255,255,255,0.6)" }}
            >
              Mestio to aplikacja, w której mieszkaniec zgłasza usterkę w kilka sekund,
              a zarządca, zarząd i serwis prowadzą ją od &bdquo;Nowe&rdquo; aż do
              &bdquo;Zamknięte&rdquo; — z historią, powiadomieniami i pełną kontrolą.
            </motion.p>

            {/* Glass pill CTA */}
            <motion.div {...fadeIn(0.45)} className="mt-8">
              <div
                className="flex items-center max-w-[380px] h-[54px] rounded-[12px] overflow-hidden"
                style={{
                  background: "rgba(255,255,255,0.04)",
                  backdropFilter: "blur(8px)",
                  border: "1px solid rgba(255,255,255,0.15)",
                  boxShadow: "0 8px 32px rgba(0,0,0,0.3)",
                }}
              >
                <input
                  placeholder="Nazwa Twojego osiedla"
                  className="flex-1 h-full bg-transparent border-none outline-none px-5 text-[15px] placeholder:text-white/40"
                  style={{ color: "#FFF", letterSpacing: "-0.02em" }}
                />
                <Link
                  href="/zamow"
                  className="flex items-center justify-center h-[42px] px-5 m-[6px] rounded-[8px] text-sm font-semibold text-white transition-all hover:brightness-110 shrink-0"
                  style={{
                    background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                    boxShadow: "0 4px 16px rgba(62,123,214,0.3)",
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
                    {stat.display}
                  </div>
                  <div className="text-[11px] mt-0.5" style={{ color: "rgba(255,255,255,0.4)" }}>
                    {stat.label}
                  </div>
                </div>
              ))}
            </motion.div>
          </div>

          {/* ── Right: Floating mockup card ── */}
          <motion.div
            initial={{ opacity: 0, scale: 0.92 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.9, delay: 0.3, ease: [0.25, 0.4, 0.25, 1] as const }}
            className="rounded-2xl p-6"
            style={{
              background: "rgba(255,255,255,0.035)",
              backdropFilter: "blur(12px)",
              border: "1px solid rgba(255,255,255,0.1)",
              boxShadow: "0 30px 60px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.05)",
            }}
          >
            {/* Card header */}
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Smartphone className="w-4 h-4" style={{ color: "rgba(255,255,255,0.5)" }} />
                <span className="font-mono text-xs font-semibold" style={{ color: "rgba(255,255,255,0.5)" }}>
                  MS-2041
                </span>
              </div>
              <span
                className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-semibold"
                style={{
                  background: "rgba(242,169,0,0.15)",
                  color: "#F2A900",
                  border: "1px solid rgba(242,169,0,0.25)",
                }}
              >
                <span className="w-1.5 h-1.5 rounded-full bg-current inline-block animate-pulse" />
                W realizacji
              </span>
            </div>

            <h3 className="font-heading font-semibold text-lg" style={{ color: "#FFF" }}>
              Cieknący kran w łazience
            </h3>
            <p className="font-mono text-xs mt-1.5" style={{ color: "rgba(255,255,255,0.4)" }}>
              Hydraulika · Budynek A · m. 14
            </p>

            {/* Status flow */}
            <div className="flex items-center mt-6 mb-5">
              {STATUS_FLOW.map((status, i) => (
                <div key={status.label} className="flex items-center flex-1">
                  {i > 0 && (
                    <div
                      className="flex-1 h-0.5 mx-1 rounded"
                      style={{
                        background: STATUS_FLOW[i - 1].done
                          ? `${status.color}60`
                          : "rgba(255,255,255,0.1)",
                        height: 2,
                      }}
                    />
                  )}
                  <div className="flex flex-col items-center">
                    <div
                      className="w-8 h-8 rounded-full flex items-center justify-center"
                      style={{
                        background: status.done ? status.color : "transparent",
                        border: status.done ? "none" : "2px solid rgba(255,255,255,0.15)",
                        color: status.done ? "#fff" : "rgba(255,255,255,0.3)",
                        boxShadow: status.active ? `0 0 0 4px ${status.color}30` : "none",
                      }}
                    >
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                        <path d={status.icon} />
                      </svg>
                    </div>
                    <span
                      className="mt-1.5 font-heading font-semibold text-[10px]"
                      style={{ color: status.done ? "#FFF" : "rgba(255,255,255,0.3)" }}
                    >
                      {status.label}
                    </span>
                  </div>
                </div>
              ))}
            </div>

            {/* Activity line */}
            <div className="flex items-center gap-3 pt-4 mt-2" style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}>
              <div
                className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-semibold"
                style={{ background: "rgba(62,123,214,0.2)", color: "#3E7BD6" }}
              >
                MW
              </div>
              <div className="flex-1 min-w-0">
                <div className="text-sm font-medium" style={{ color: "#FFF" }}>Marek Wójcik · Serwis</div>
                <div className="flex items-center gap-1.5 text-xs mt-0.5" style={{ color: "rgba(255,255,255,0.4)" }}>
                  <MessageSquare className="w-3 h-3" />
                  <span className="truncate">Wymiana zaworu, ETA 14:00</span>
                </div>
              </div>
              <Bell className="w-4 h-4" style={{ color: "rgba(255,255,255,0.4)" }} />
            </div>

            {/* Actions */}
            <div className="flex items-center gap-3 mt-4 pt-3" style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}>
              <button
                className="flex-1 flex items-center justify-center gap-1.5 text-xs font-semibold py-2 rounded-lg"
                style={{ background: "rgba(62,123,214,0.15)", color: "#3E7BD6" }}
              >
                <MessageSquare className="w-3.5 h-3.5" />
                Wyślij wiadomość
              </button>
              <button
                className="flex-1 flex items-center justify-center gap-1.5 text-xs font-semibold py-2 rounded-lg"
                style={{ background: "rgba(34,197,94,0.15)", color: "#22C55E" }}
              >
                <Wrench className="w-3.5 h-3.5" />
                Zmień status
              </button>
            </div>
          </motion.div>
        </div>
      </motion.div>

      {/* Scroll indicator */}
      <motion.div
        className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.5, duration: 0.8 }}
      >
        <span className="text-[10px] uppercase tracking-[0.2em]" style={{ color: "rgba(255,255,255,0.3)" }}>
          Przewiń
        </span>
        <motion.div
          animate={{ y: [0, 6, 0] }}
          transition={{ duration: 1.8, repeat: Infinity, ease: "easeInOut" }}
          style={{ color: "rgba(255,255,255,0.3)" }}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 5v14M19 12l-7 7-7-7" />
          </svg>
        </motion.div>
      </motion.div>
    </section>
  );
}

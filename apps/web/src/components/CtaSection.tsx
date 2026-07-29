"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { ArrowRight, Sparkles } from "lucide-react";
import Link from "next/link";

export default function CtaSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} className="relative py-24 overflow-hidden">
      {/* Dark background — Daylight final CTA style */}
      <div
        className="absolute inset-0"
        style={{
          background: "linear-gradient(180deg, #0A1628 0%, #0E1A2B 50%, #13243D 100%)",
        }}
      />
      {/* Glow */}
      <div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[400px] pointer-events-none"
        style={{
          background: `radial-gradient(ellipse, ${colors.accent}15, transparent 70%)`,
        }}
      />

      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={isInView ? { opacity: 1, y: 0 } : {}}
        transition={{ duration: 0.8, ease: "easeOut" as const }}
        className="relative z-10 max-w-2xl mx-auto px-6 text-center"
      >
        {/* Badge */}
        <div
          className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-6"
          style={{
            background: "rgba(255,255,255,0.06)",
            color: "rgba(255,255,255,0.9)",
            border: "1px solid rgba(255,255,255,0.12)",
            backdropFilter: "blur(10px)",
          }}
        >
          <Sparkles className="w-3.5 h-3.5" style={{ color: "#3E7BD6" }} />
          Zacznij już dziś
        </div>

        <h2
          className="font-heading font-bold text-[36px] sm:text-[44px] tracking-[-1px] leading-[1.1] mb-4"
          style={{ color: "#FFF" }}
        >
          Gotowy uporządkować{" "}
          <span className="bg-gradient-to-r from-[#3E7BD6] to-[#6DB3F2] bg-clip-text text-transparent">
            zgłoszenia
          </span>
          ?
        </h2>
        <p className="text-[15px] mb-10" style={{ color: "rgba(255,255,255,0.55)" }}>
          Uruchom Mestio dla swojego osiedla w kilka minut. Bez karty, bez zobowiązań.
        </p>

        {/* Glass pill CTA */}
        <div className="flex justify-center">
          <div
            className="flex items-center max-w-[400px] w-full h-[56px] rounded-[16px] overflow-hidden"
            style={{
              background: "rgba(255,255,255,0.04)",
              backdropFilter: "blur(8px)",
              border: "1px solid rgba(255,255,255,0.12)",
              boxShadow: "0 8px 32px rgba(0,0,0,0.3)",
            }}
          >
            <input
              placeholder="Nazwa Twojego osiedla"
              className="flex-1 h-full bg-transparent border-none outline-none px-5 text-[15px] placeholder:text-white/35"
              style={{ color: "#FFF", letterSpacing: "-0.02em" }}
            />
            <Link
              href="/zamow"
              className="flex items-center justify-center h-[44px] px-6 m-[6px] rounded-[10px] text-sm font-semibold text-white transition-all hover:brightness-110 shrink-0"
              style={{
                background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                boxShadow: "0 4px 16px rgba(62,123,214,0.3)",
              }}
            >
              Zamów Mestio
              <ArrowRight className="w-4 h-4 ml-1.5" />
            </Link>
          </div>
        </div>

        <p
          className="text-[13px] mt-5"
          style={{ color: "rgba(255,255,255,0.35)" }}
        >
          Pierwsze 3 miesiące gratis · anuluj kiedy chcesz · bez karty na start
        </p>
      </motion.div>
    </section>
  );
}

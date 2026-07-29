"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import Link from "next/link";
import { Gift, ArrowRight, Users } from "lucide-react";

export default function ReferralSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} className="relative py-20 overflow-hidden" style={{ background: "#0A1524" }}>
      {/* Grid background */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(rgba(62,123,214,0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(62,123,214,0.03) 1px, transparent 1px)`,
          backgroundSize: "60px 60px",
        }}
      />
      {/* Glow */}
      <div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[300px] pointer-events-none"
        style={{ background: "radial-gradient(ellipse, rgba(62,123,214,0.08), transparent 70%)" }}
      />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.7 }}
          className="rounded-2xl p-10 sm:p-14 flex flex-col lg:flex-row items-center justify-between gap-8 relative overflow-hidden"
          style={{
            background: "rgba(255,255,255,0.03)",
            border: "1px solid rgba(255,255,255,0.08)",
            backdropFilter: "blur(16px)",
          }}
        >
          {/* Left content */}
          <div className="max-w-[520px]">
            <div
              className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-semibold mb-5"
              style={{
                background: "rgba(242,169,0,0.12)",
                color: "#F2A900",
                border: "1px solid rgba(242,169,0,0.25)",
              }}
            >
              <Gift className="w-3.5 h-3.5" />
              Program poleceń
            </div>

            <h2
              className="font-heading font-bold text-[28px] sm:text-[34px] tracking-[-0.6px] leading-[1.1]"
              style={{ color: "#FFF" }}
            >
              Polecasz Mestio innemu zarządcy?{" "}
              <span className="bg-gradient-to-r from-[#3E7BD6] to-[#6DB3F2] bg-clip-text text-transparent">
                Oboje zyskujecie.
              </span>
            </h2>

            <p className="text-[15px] mt-4 leading-relaxed" style={{ color: "rgba(255,255,255,0.55)" }}>
              Za każde osiedle, które dołączy z Twojego polecenia, dostajesz{" "}
              <b className="font-semibold" style={{ color: "#FFF" }}>1 miesiąc gratis</b>
              , a polecony — <b className="font-semibold" style={{ color: "#FFF" }}>20% zniżki</b> na start przez pierwsze 6 miesięcy.
            </p>

            {/* Benefit chips */}
            <div className="flex flex-wrap gap-2.5 mt-6">
              <div
                className="inline-flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm"
                style={{ background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.08)" }}
              >
                <span className="font-heading font-bold text-lg" style={{ color: "#3E7BD6" }}>+1</span>
                <span style={{ color: "rgba(255,255,255,0.6)" }}>miesiąc dla Ciebie</span>
              </div>
              <div
                className="inline-flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm"
                style={{ background: "rgba(255,255,255,0.04)", border: "1px solid rgba(255,255,255,0.08)" }}
              >
                <span className="font-heading font-bold text-lg" style={{ color: "#22C55E" }}>-20%</span>
                <span style={{ color: "rgba(255,255,255,0.6)" }}>dla poleconego</span>
              </div>
            </div>
          </div>

          {/* Right: CTA + illustration */}
          <div className="flex flex-col items-center gap-5 shrink-0">
            {/* Circle illustration */}
            <div className="relative w-32 h-32 flex items-center justify-center">
              <motion.div
                animate={{ rotate: 360 }}
                transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
                className="absolute inset-0 rounded-full"
                style={{
                  border: "1px dashed rgba(62,123,214,0.3)",
                }}
              />
              <div
                className="w-16 h-16 rounded-2xl flex items-center justify-center"
                style={{
                  background: "linear-gradient(135deg, #3E7BD6, #173A6A)",
                  boxShadow: "0 8px 24px rgba(62,123,214,0.3)",
                }}
              >
                <Users className="w-7 h-7 text-white" />
              </div>
            </div>

            <Link
              href="/zamow"
              className="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl text-sm font-semibold text-white transition-all hover:brightness-110"
              style={{
                background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                boxShadow: "0 4px 16px rgba(62,123,214,0.3)",
              }}
            >
              Zdobądź swój link
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </motion.div>
      </div>
    </section>
  );
}

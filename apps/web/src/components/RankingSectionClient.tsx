"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Trophy, ArrowRight } from "lucide-react";
import Link from "next/link";

interface RankingEntry {
  estate_name: string;
  resolved_count: number;
  avg_hours: number;
}

interface Props {
  ranking: RankingEntry[];
}

export default function RankingSection({ ranking }: Props) {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  const top5 = ranking.slice(0, 5);
  const isEmpty = top5.length === 0;

  const medalColors = ["#F2A900", "#9CA3AF", "#CD7F32"];

  return (
    <section ref={ref} id="ranking" className="relative py-28 overflow-hidden" style={{ background: "#0A1524" }}>
      {/* Grid background */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(rgba(242,169,0,0.02) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(242,169,0,0.02) 1px, transparent 1px)`,
          backgroundSize: "80px 80px",
        }}
      />
      {/* Glow */}
      <div
        className="absolute top-0 left-1/2 -translate-x-1/2 w-[600px] h-[300px] pointer-events-none"
        style={{ background: "radial-gradient(ellipse, rgba(242,169,0,0.06), transparent 70%)" }}
      />

      <div className="max-w-4xl mx-auto px-6 relative z-10">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-14"
        >
          <div
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-5"
            style={{
              background: "rgba(242,169,0,0.1)",
              color: "#F2A900",
              border: "1px solid rgba(242,169,0,0.2)",
            }}
          >
            <Trophy className="w-3.5 h-3.5" />
            Ranking osiedli
          </div>
          <h2
            className="font-heading font-bold text-[36px] sm:text-[44px] tracking-[-1px] leading-[1.1]"
            style={{ color: "#FFF" }}
          >
            Który zarząd działa{" "}
            <span className="bg-gradient-to-r from-[#F2A900] to-[#FFD55E] bg-clip-text text-transparent">
              najszybciej
            </span>
            ?
          </h2>
          <p className="text-[15px] mt-4 max-w-lg mx-auto" style={{ color: "rgba(255,255,255,0.5)" }}>
            Osiedla z najkrótszym czasem reakcji i największą liczbą rozwiązanych zgłoszeń.
            Rywalizacja podnosi jakość obsługi.
          </p>
        </motion.div>

        {isEmpty ? (
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={isInView ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="rounded-2xl p-12 text-center"
            style={{
              background: "rgba(255,255,255,0.03)",
              border: "1px solid rgba(255,255,255,0.08)",
              backdropFilter: "blur(10px)",
            }}
          >
            <Trophy className="w-10 h-10 mx-auto mb-4 opacity-30" style={{ color: "#F2A900" }} />
            <p className="text-base max-w-md mx-auto" style={{ color: "rgba(255,255,255,0.5)" }}>
              Ranking jest jeszcze pusty — Twoje osiedle może być pierwsze.
              Uruchom Mestio i wejdź na szczyt zestawienia.
            </p>
            <Link
              href="/zamow"
              className="inline-flex items-center gap-2 mt-6 px-6 py-3.5 rounded-xl text-sm font-semibold text-white transition-all hover:brightness-110"
              style={{
                background: "linear-gradient(135deg, #F2A900, #C98800)",
                boxShadow: "0 4px 16px rgba(242,169,0,0.25)",
              }}
            >
              Dołącz i wejdź do rankingu
              <ArrowRight className="w-4 h-4" />
            </Link>
          </motion.div>
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={isInView ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="rounded-2xl overflow-hidden"
            style={{
              background: "rgba(255,255,255,0.03)",
              border: "1px solid rgba(255,255,255,0.08)",
              backdropFilter: "blur(10px)",
            }}
          >
            {/* Table header */}
            <div
              className="hidden sm:grid grid-cols-[60px_1fr_140px_140px] gap-4 px-6 py-3.5 font-mono text-[11px] uppercase tracking-[0.5px]"
              style={{ background: "rgba(255,255,255,0.02)", borderBottom: "1px solid rgba(255,255,255,0.06)" }}
            >
              <span className="text-center" style={{ color: "rgba(255,255,255,0.3)" }}>#</span>
              <span style={{ color: "rgba(255,255,255,0.3)" }}>Osiedle</span>
              <span className="text-center" style={{ color: "rgba(255,255,255,0.3)" }}>Rozwiązane</span>
              <span className="text-center" style={{ color: "rgba(255,255,255,0.3)" }}>Śr. czas</span>
            </div>

            {/* Rows */}
            {top5.map((entry, i) => {
              const isLast = i === top5.length - 1;
              const hoursStr =
                entry.avg_hours < 24
                  ? `${entry.avg_hours.toFixed(1)} h`
                  : `${Math.round(entry.avg_hours / 24)} dni`;

              return (
                <motion.div
                  key={entry.estate_name}
                  initial={{ opacity: 0, x: -20 }}
                  animate={isInView ? { opacity: 1, x: 0 } : {}}
                  transition={{ duration: 0.4, delay: 0.3 + i * 0.08 }}
                  className={`grid grid-cols-1 sm:grid-cols-[60px_1fr_140px_140px] gap-3 sm:gap-4 px-6 py-[18px] items-center transition-colors hover:bg-white/[0.02] ${
                    isLast ? "" : ""
                  }`}
                  style={{ borderBottom: isLast ? "none" : "1px solid rgba(255,255,255,0.05)" }}
                >
                  {/* Position / Medal */}
                  <div className="flex sm:justify-center items-center gap-2">
                    {i < 3 ? (
                      <div
                        className="w-8 h-8 rounded-lg flex items-center justify-center font-mono text-[13px] font-bold"
                        style={{
                          background: `${medalColors[i]}15`,
                          color: medalColors[i],
                          border: `1px solid ${medalColors[i]}30`,
                        }}
                      >
                        {i + 1}
                      </div>
                    ) : (
                      <div
                        className="w-8 h-8 rounded-lg flex items-center justify-center font-mono text-[13px] font-semibold"
                        style={{
                          background: "rgba(255,255,255,0.04)",
                          color: "rgba(255,255,255,0.4)",
                        }}
                      >
                        {i + 1}
                      </div>
                    )}
                    <span className="sm:hidden font-heading font-semibold text-base" style={{ color: "#FFF" }}>
                      {entry.estate_name}
                    </span>
                  </div>

                  {/* Estate name */}
                  <span className="hidden sm:block font-heading font-semibold text-base" style={{ color: "#FFF" }}>
                    {entry.estate_name}
                  </span>

                  {/* Resolved count */}
                  <div className="sm:text-center">
                    <span className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] mr-2" style={{ color: "rgba(255,255,255,0.3)" }}>
                      Rozwiązane:
                    </span>
                    <span className="font-mono text-[14px] font-semibold" style={{ color: "rgba(255,255,255,0.9)" }}>
                      {entry.resolved_count}
                    </span>
                  </div>

                  {/* Avg time */}
                  <div className="sm:text-center">
                    <span className="sm:hidden font-mono text-[10.5px] uppercase tracking-[0.4px] mr-2" style={{ color: "rgba(255,255,255,0.3)" }}>
                      Śr. czas:
                    </span>
                    <span className="font-mono text-[14px] font-semibold" style={{ color: "#F2A900" }}>
                      {hoursStr}
                    </span>
                  </div>
                </motion.div>
              );
            })}
          </motion.div>
        )}

        {/* Bottom note */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={isInView ? { opacity: 1 } : {}}
          transition={{ delay: 0.8, duration: 0.5 }}
          className="text-center mt-6 text-sm"
          style={{ color: "rgba(255,255,255,0.3)" }}
        >
          Aktualizowane co godzinę · ranking odzwierciedla realne zgłoszenia w Mestio
        </motion.p>
      </div>
    </section>
  );
}

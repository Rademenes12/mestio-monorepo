"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Phone, FileText, MessageSquare, Search, Check } from "lucide-react";

const BROKEN = [
  {
    icon: Phone,
    label: "Telefon do administracji",
    desc: "Mieszkaniec dzwoni, nikt nie odbiera, próbuje jutro. Usterka zapomniana.",
  },
  {
    icon: FileText,
    label: "Papierowe formularze",
    desc: "Ktoś coś zapisał, gdzieś położył, przepadło. Nie ma śladu po zgłoszeniu.",
  },
  {
    icon: MessageSquare,
    label: "Grupa na Facebooku / SMS",
    desc: "Zgłoszenie ląduje w grupie sąsiedzkiej. Serwis tego nie widzi. Statusu nie ma.",
  },
  {
    icon: Search,
    label: "Brak historii",
    desc: "Zarząd nie wie, co naprawiono w tym roku, ile to kosztowało i kto to robił.",
  },
];

const FIXED = [
  {
    img: "/images/stock-reporting.jpg",
    label: "Zdjęcie + lokalizacja w 60 sekund",
    desc: "Mieszkaniec robi zdjęcie usterki, wybiera budynek i mieszkanie, wysyła. Koniec.",
    color: "#3E7BD6",
  },
  {
    img: "/images/stock-notifications.jpg",
    label: "Powiadomienia push na żywo",
    desc: "Każda zmiana statusu trafia do mieszkańca, zarządu i serwisu. Zero telefonów.",
    color: "#F2A900",
  },
  {
    img: "/images/stock-collaboration.jpg",
    label: "Pełny ślad audytowy",
    desc: "Kto, co i kiedy — każda akcja zapisana. Dowód dla mieszkańców i zarządu.",
    color: "#22C55E",
  },
  {
    img: "/images/stock-analytics.jpg",
    label: "Statystyki i ranking",
    desc: "Średni czas reakcji, liczba zgłoszeń, ranking osiedli. Dane, nie domysły.",
    color: "#3E7BD6",
  },
];

export default function ProblemSolutionSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-15%" });

  const fadeUp = (delay: number) => ({
    initial: { opacity: 0, y: 24 },
    animate: isInView ? { opacity: 1, y: 0 } : {},
    transition: { duration: 0.6, delay, ease: "easeOut" as const },
  });

  return (
    <section ref={ref} className="relative py-28 overflow-hidden" style={{ background: "#0A1524" }}>
      {/* Blueprint grid */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(rgba(62,123,214,0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(62,123,214,0.03) 1px, transparent 1px)`,
          backgroundSize: "80px 80px",
          maskImage: "radial-gradient(ellipse 70% 60% at 50% 30%, black 20%, transparent 80%)",
          WebkitMaskImage: "radial-gradient(ellipse 70% 60% at 50% 30%, black 20%, transparent 80%)",
        }}
      />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        {/* ── "Dzisiejsze zarządzanie jest zepsute" header ── */}
        <motion.div {...fadeUp(0)} className="mb-20">
          <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: "rgba(239,68,68,0.7)" }}>
            Dzisiejsze zarządzanie jest zepsute
          </p>
          <h2 className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05] max-w-[700px]">
            <span style={{ color: "rgba(255,255,255,0.9)" }}>Zgłoszenia gubią się w</span>{" "}
            <span style={{ color: "#EF4444", fontStyle: "italic" }}>telefonach</span>,{" "}
            <span style={{ color: "#EF4444", fontStyle: "italic" }}>SMS-ach</span>{" "}
            <span style={{ color: "rgba(255,255,255,0.9)" }}>i</span>{" "}
            <span style={{ color: "#EF4444", fontStyle: "italic" }}>grupach na FB</span>
          </h2>
          <p className="text-[15px] mt-4 max-w-[480px]" style={{ color: "rgba(255,255,255,0.45)" }}>
            Nikt nie wie na czym jest sprawa. Mieszkaniec dzwoni, żeby zapytać. Zarząd nie ma dowodu. Serwis
            dostaje niejasny opis. Wszyscy sfrustrowani.
          </p>
        </motion.div>

        {/* ── Broken items ── */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-24">
          {BROKEN.map((item, i) => {
            const Icon = item.icon;
            return (
              <motion.div
                key={item.label}
                {...fadeUp(0.1 + i * 0.07)}
                className="rounded-2xl p-5"
                style={{
                  background: "rgba(239,68,68,0.04)",
                  border: "1px solid rgba(239,68,68,0.08)",
                }}
              >
                <div
                  className="w-10 h-10 rounded-xl flex items-center justify-center mb-4"
                  style={{ background: "rgba(239,68,68,0.08)" }}
                >
                  <Icon className="w-4 h-4" style={{ color: "#EF4444" }} />
                </div>
                <h3 className="text-[14px] font-semibold mb-2" style={{ color: "rgba(255,255,255,0.8)" }}>
                  {item.label}
                </h3>
                <p className="text-[13px] leading-relaxed" style={{ color: "rgba(255,255,255,0.4)" }}>
                  {item.desc}
                </p>
              </motion.div>
            );
          })}
        </div>

        {/* ── "Mestio rozwiązuje to" divider ── */}
        <motion.div
          {...fadeUp(0.2)}
          className="flex items-center gap-6 mb-16"
        >
          <div className="h-px flex-1" style={{ background: "rgba(255,255,255,0.08)" }} />
          <div className="flex items-center gap-3 px-5 py-2.5 rounded-full" style={{ background: "rgba(62,123,214,0.1)", border: "1px solid rgba(62,123,214,0.2)" }}>
            <span className="font-mono text-[11px] uppercase tracking-wider font-semibold" style={{ color: "#3E7BD6" }}>
              Mestio rozwiązuje to
            </span>
          </div>
          <div className="h-px flex-1" style={{ background: "rgba(255,255,255,0.08)" }} />
        </motion.div>

        {/* ── Fixed items ── */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {FIXED.map((item, i) => {
            return (
              <motion.div
                key={item.label}
                {...fadeUp(0.1 + i * 0.07)}
                className="rounded-2xl relative overflow-hidden group"
                style={{
                  background: "rgba(255,255,255,0.03)",
                  border: "1px solid rgba(255,255,255,0.08)",
                  backdropFilter: "blur(10px)",
                }}
              >
                {/* Photo */}
                <div className="relative h-32 overflow-hidden rounded-t-2xl">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={item.img}
                    alt={item.label}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                  />
                  <div
                    className="absolute inset-0"
                    style={{ background: `linear-gradient(180deg, transparent 40%, rgba(10,21,36,0.9))` }}
                  />
                  {/* Check mark */}
                  <motion.div
                    className="absolute top-3 right-3"
                    initial={{ scale: 0 }}
                    animate={isInView ? { scale: 1 } : {}}
                    transition={{ delay: 0.3 + i * 0.1, type: "spring", stiffness: 300, damping: 20 }}
                  >
                    <div
                      className="w-6 h-6 rounded-full flex items-center justify-center backdrop-blur-sm"
                      style={{ background: `${item.color}30`, border: `1px solid ${item.color}40` }}
                    >
                      <Check className="w-3.5 h-3.5" style={{ color: item.color, strokeWidth: 3 }} />
                    </div>
                  </motion.div>
                </div>

                <div className="p-5 relative z-10">
                  <h3 className="text-[14px] font-semibold mb-2" style={{ color: "#FFF" }}>
                    {item.label}
                  </h3>
                  <p className="text-[13px] leading-relaxed" style={{ color: "rgba(255,255,255,0.5)" }}>
                    {item.desc}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

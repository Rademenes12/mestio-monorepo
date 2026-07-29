"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { Star, Quote } from "lucide-react";

const TESTIMONIALS = [
  {
    name: "Anna Kowalska",
    role: "Zarządca nieruchomości",
    estate: "Osiedle Zielone Wzgórze",
    avatar: "AK",
    text: "Mieszkańcy przestali dzwonić z pytaniem 'czy ktoś to widział?'. Sami sprawdzają status w aplikacji. Oszczędzam kilka godzin tygodniowo na telefonach.",
    stars: 5,
    accent: "#3E7BD6",
  },
  {
    name: "Piotr Nowak",
    role: "Prezes Zarządu",
    estate: "Wspólnota Mieszkaniowa Sadyba",
    avatar: "PN",
    text: "Mam pełną historię zgłoszeń — wiem ile średnio trwa naprawa i który serwisant jest najskuteczniejszy. Ranking osiedli to świetna motywacja.",
    stars: 5,
    accent: "#22C55E",
  },
  {
    name: "Marek Wójcik",
    role: "Koordynator serwisu",
    estate: "Apartamenty Park",
    avatar: "MW",
    text: "Zdjęcia i lokalizacja w zgłoszeniu eliminują 'nie wiem o który kran chodzi'. Serwis dostaje pełne info od razu — zero nieporozumień.",
    stars: 5,
    accent: "#F2A900",
  },
];

const TRUST_STATS = [
  { stat: "5+", label: "osiedli" },
  { stat: "200+", label: "mieszkańców" },
  { stat: "500+", label: "zgłoszeń" },
  { stat: "99%", label: "zadowolonych" },
];

export default function TestimonialsSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} className="relative py-28 overflow-hidden" style={{ background: "#0A1524" }}>
      {/* Grid background */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(rgba(62,123,214,0.04) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(62,123,214,0.04) 1px, transparent 1px)`,
          backgroundSize: "80px 80px",
          maskImage: "radial-gradient(ellipse 60% 50% at 50% 50%, black 30%, transparent 80%)",
          WebkitMaskImage: "radial-gradient(ellipse 60% 50% at 50% 50%, black 30%, transparent 80%)",
        }}
      />
      {/* Top glow line */}
      <div
        className="absolute top-0 left-0 right-0 h-px"
        style={{ background: "linear-gradient(90deg, transparent, rgba(62,123,214,0.3), transparent)" }}
      />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: "rgba(255,255,255,0.35)" }}>
            Opinie
          </p>
          <h2
            className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05]"
            style={{ color: "#FFF" }}
          >
            Co mówią{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#6DB3F2] bg-clip-text text-transparent">
              nasi użytkownicy
            </span>
          </h2>
          <p className="text-[15px] mt-4 max-w-xl mx-auto" style={{ color: "rgba(255,255,255,0.5)" }}>
            Zarządcy, zarządy i serwisanci — każdy znajduje w Mestio coś dla siebie.
          </p>
        </motion.div>

        {/* Testimonial cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {TESTIMONIALS.map((t, i) => (
            <motion.div
              key={t.name}
              initial={{ opacity: 0, y: 40 }}
              animate={isInView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.6, delay: 0.2 + i * 0.12, ease: "easeOut" as const }}
              className="rounded-2xl p-7 relative overflow-hidden group transition-all duration-300 hover:translate-y-[-4px]"
              style={{
                background: "rgba(255,255,255,0.03)",
                border: "1px solid rgba(255,255,255,0.08)",
                backdropFilter: "blur(10px)",
              }}
            >
              {/* Quote icon */}
              <Quote
                className="w-8 h-8 mb-4 opacity-20"
                style={{ color: t.accent }}
              />

              {/* Stars */}
              <div className="flex gap-0.5 mb-4">
                {Array.from({ length: t.stars }).map((_, idx) => (
                  <Star
                    key={idx}
                    className="w-4 h-4"
                    style={{ color: "#F2A900", fill: "#F2A900" }}
                  />
                ))}
              </div>

              {/* Quote text */}
              <p className="text-[14px] leading-relaxed flex-1" style={{ color: "rgba(255,255,255,0.75)" }}>
                {t.text}
              </p>

              {/* Author */}
              <div
                className="flex items-center gap-3 mt-6 pt-5"
                style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}
              >
                <div
                  className="w-11 h-11 rounded-full flex items-center justify-center text-xs font-semibold shrink-0"
                  style={{
                    background: `linear-gradient(135deg, ${t.accent}, ${t.accent}80)`,
                    color: "#FFF",
                  }}
                >
                  {t.avatar}
                </div>
                <div className="min-w-0">
                  <div className="text-sm font-semibold truncate" style={{ color: "#FFF" }}>
                    {t.name}
                  </div>
                  <div className="text-xs mt-0.5 truncate" style={{ color: "rgba(255,255,255,0.4)" }}>
                    {t.role} · {t.estate}
                  </div>
                </div>
              </div>

              {/* Hover glow */}
              <div
                className="absolute -bottom-20 -right-20 w-40 h-40 rounded-full pointer-events-none transition-opacity duration-300 opacity-0 group-hover:opacity-100"
                style={{ background: `radial-gradient(circle, ${t.accent}08, transparent 70%)` }}
              />
            </motion.div>
          ))}
        </div>

        {/* Trust indicators bar */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 0.6 }}
          className="flex flex-wrap items-center justify-center gap-8 mt-14 pt-8"
          style={{ borderTop: "1px solid rgba(255,255,255,0.08)" }}
        >
          {TRUST_STATS.map((item) => (
            <div key={item.label} className="text-center min-w-[100px]">
              <div
                className="font-heading font-bold text-[28px] tracking-[-0.5px]"
                style={{ color: "#3E7BD6" }}
              >
                {item.stat}
              </div>
              <div className="text-xs mt-1" style={{ color: "rgba(255,255,255,0.4)" }}>
                {item.label}
              </div>
            </div>
          ))}
        </motion.div>
      </div>
    </section>
  );
}

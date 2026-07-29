"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import { ClipboardList, Users, Bell, History, Megaphone, Building2 } from "lucide-react";

const FEATURES = [
  {
    icon: ClipboardList,
    title: "Zgłoszenia ze statusem\ni priorytetem",
    desc: "Nowe → W realizacji → Zamknięte. Każde zgłoszenie ma priorytet i termin SLA. Mieszkaniec widzi status na żywo — nie musi dzwonić i pytać.",
    color: colors.accent,
    bg: "#EBF2FA",
  },
  {
    icon: Users,
    title: "5 ról,\njeden system",
    desc: "Mieszkaniec zgłasza. Zarząd zatwierdza. Zarządca koordynuje. Serwis naprawia. Ochrona widzi. Każdy ma swoje uprawnienia i widok.",
    color: colors.navyLight,
    bg: "#F0F3F8",
  },
  {
    icon: Bell,
    title: "Powiadomienia\npush w czasie rzeczywistym",
    desc: "Nowe zgłoszenie? Zmiana statusu? Awaria? Wszyscy dostają powiadomienie na telefon natychmiast. Zero przegapionych spraw.",
    color: colors.warning,
    bg: "#FFF8EB",
  },
  {
    icon: History,
    title: "Pełny ślad\naudytowy",
    desc: "Kto, co i kiedy — każda akcja zapisana. Dowód dla mieszkańców, zarządu i audytora. Historia dostępna jednym kliknięciem.",
    color: colors.success,
    bg: "#EDF9F2",
  },
  {
    icon: Megaphone,
    title: "Ogłoszenia\nz datą wygaśnięcia",
    desc: "Komunikaty do mieszkańców znikają automatycznie po terminie. Żadnego spamowania starymi treściami. Czysto i na temat.",
    color: colors.accent,
    bg: "#EBF2FA",
  },
  {
    icon: Building2,
    title: "Mapa osiedla:\nbudynki, klatki, piętra",
    desc: "Mieszkaniec wybiera dokładną lokalizację przy zgłoszeniu. Serwis wie, gdzie iść. Koniec z 'nie wiem, który kran'.",
    color: colors.navyLight,
    bg: "#F0F3F8",
  },
];

export default function FeaturesSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  return (
    <section ref={ref} id="funkcje" className="relative py-28" style={{ background: colors.bg }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="mb-16"
        >
          <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: colors.textMuted }}>
            Funkcje
          </p>
          <h2
            className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05] max-w-[600px]"
            style={{ color: colors.text }}
          >
            Wszystko, czego potrzebuje{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
              osiedle
            </span>
          </h2>
          <p className="text-[15px] mt-4 max-w-[480px]" style={{ color: colors.textSecondary }}>
            Jedna aplikacja dla mieszkańców, zarządu, zarządcy, serwisu i ochrony — każdy widzi to, co powinien.
          </p>
        </motion.div>

        {/* Features grid — 3 columns, varied cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {FEATURES.map((feature, i) => {
            const Icon = feature.icon;
            return (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 30 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.5, delay: 0.1 + i * 0.08, ease: "easeOut" as const }}
                className="rounded-2xl p-8 relative overflow-hidden group transition-all duration-300 hover:-translate-y-1"
                style={{
                  background: "#FFFFFF",
                  border: `1px solid ${colors.cardBorder}`,
                  boxShadow: "0 1px 3px rgba(14,26,43,0.04)",
                }}
              >
                {/* Colored top strip */}
                <div className="absolute top-0 left-0 right-0 h-1 rounded-t-2xl" style={{ background: feature.color, opacity: 0.3 }} />

                {/* Icon */}
                <div
                  className="w-12 h-12 rounded-xl flex items-center justify-center mb-5"
                  style={{ background: feature.bg }}
                >
                  <Icon className="w-5 h-5" style={{ color: feature.color }} />
                </div>

                {/* Title with line breaks */}
                <h3
                  className="font-heading font-semibold text-[17px] leading-[1.25] mb-3 whitespace-pre-line"
                  style={{ color: colors.text }}
                >
                  {feature.title}
                </h3>

                <p className="text-[14px] leading-relaxed" style={{ color: colors.textSecondary }}>
                  {feature.desc}
                </p>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

import Link from "next/link";
import { colors } from "@mestio/design-tokens";
import {
  Smartphone,
  CheckCircle,
  ArrowRight,
  Sparkles,
  Bell,
  MessageSquare,
  Wrench,
} from "lucide-react";

const HERO_STATS = [
  { value: "5", label: "ról w jednej apce" },
  { value: "∞", label: "użytkowników bez limitu" },
  { value: "0%", label: "prowizji" },
  { value: "<60s", label: "zgłoszenie usterki" },
];

const STATUS_FLOW = [
  { label: "Nowe", icon: "M12 7v10M7 12h10", color: colors.info, done: true },
  {
    label: "W realizacji",
    icon: "M9.5 8l6 4-6 4z",
    color: colors.warning,
    done: true,
    active: true,
  },
  {
    label: "Zamknięte",
    icon: "M6 12l3.5 4 8.5-8",
    color: colors.success,
    done: false,
  },
];

export default function HeroSection() {
  return (
    <section className="relative overflow-hidden">
      {/* Subtle background gradient — Erste-like soft glow */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background: `radial-gradient(ellipse 80% 60% at 50% -10%, ${colors.navyLight}15, transparent 70%)`,
        }}
      />

      <div className="max-w-7xl mx-auto px-6 pt-28 pb-16">
        <div className="grid grid-cols-[1.2fr_0.8fr] gap-14 items-center">
          {/* ── Left: Content ── */}
          <div>
            {/* Badge */}
            <div
              className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold"
              style={{
                background: `${colors.accent}12`,
                color: colors.accent,
                border: `1px solid ${colors.accent}25`,
              }}
            >
              <Sparkles className="w-3.5 h-3.5" />
              Dla zarządców nieruchomości, wspólnot i osiedli
            </div>

            {/* Heading */}
            <h1
              className="font-heading font-bold text-[52px] leading-[1.06] tracking-[-1.5px] mt-6"
              style={{ color: colors.text }}
            >
              Zgłoszenia usterek na osiedlu
              <br />
              <span
                className="bg-gradient-to-r from-[#8864f0] to-[#4da3ff] bg-clip-text text-transparent"
              >
                wreszcie pod kontrolą
              </span>
            </h1>

            <p
              className="text-base leading-relaxed mt-5 max-w-[480px]"
              style={{ color: colors.textSecondary }}
            >
              Mestio to aplikacja, w której mieszkaniec zgłasza usterkę w kilka
              sekund, a zarządca, zarząd i serwis prowadzą ją od &bdquo;Nowe&rdquo; aż
              do &bdquo;Zamknięte&rdquo; — z historią, powiadomieniami na telefonie i
              pełną kontrolą.
            </p>

            {/* CTA Buttons */}
            <div className="flex gap-3 mt-8">
              <Link
                href="/zamow"
                className="inline-flex items-center gap-2 text-sm font-semibold text-white px-5 py-3 rounded-xl transition-all duration-200 hover:brightness-110"
                style={{
                  background: `linear-gradient(135deg, #8864f0, ${colors.accent})`,
                  boxShadow: `0 8px 24px ${colors.accent}35`,
                }}
              >
                Zamów dla swojego osiedla
                <ArrowRight className="w-4 h-4" />
              </Link>
              <a
                href="#jak-to-dziala"
                className="inline-flex items-center text-sm font-semibold px-5 py-3 rounded-xl transition-colors duration-200"
                style={{
                  background: `${colors.surface}`,
                  color: colors.text,
                  border: `1px solid ${colors.cardBorder}`,
                }}
              >
                Jak to działa
              </a>
            </div>

            {/* Trust line */}
            <div className="flex items-center gap-2 mt-4 text-xs font-medium" style={{ color: colors.success }}>
              <CheckCircle className="w-4 h-4" />
              Pierwsze 3 miesiące gratis · bez karty na start
            </div>

            {/* Stats row */}
            <div className="flex gap-8 mt-10 pt-6" style={{ borderTop: `1px solid ${colors.cardBorder}` }}>
              {HERO_STATS.map((stat) => (
                <div key={stat.label}>
                  <div className="font-heading font-bold text-xl" style={{ color: colors.accent }}>
                    {stat.value}
                  </div>
                  <div className="text-xs mt-0.5" style={{ color: colors.textMuted }}>
                    {stat.label}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* ── Right: App preview card (Erste-inspired) ── */}
          <div
            className="rounded-2xl p-6"
            style={{
              background: colors.card,
              border: `1px solid ${colors.cardBorder}`,
              boxShadow: `0 20px 60px rgba(0,0,0,0.4), 0 0 0 1px ${colors.glassBorder}`,
            }}
          >
            {/* Card header */}
            <div className="flex items-center justify-between mb-4">
              {/* Device indicator */}
              <div className="flex items-center gap-2">
                <Smartphone className="w-4 h-4" style={{ color: colors.textMuted }} />
                <span className="font-mono text-xs font-semibold" style={{ color: colors.textMuted }}>
                  MS-2041
                </span>
              </div>
              {/* Status badge */}
              <span
                className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-semibold"
                style={{
                  background: `${colors.warning}15`,
                  color: colors.warning,
                  border: `1px solid ${colors.warning}30`,
                }}
              >
                <span className="w-1.5 h-1.5 rounded-full bg-current inline-block" />
                W realizacji
              </span>
            </div>

            {/* Title */}
            <h3 className="font-heading font-semibold text-lg" style={{ color: colors.text }}>
              Cieknący kran w łazience
            </h3>
            <p className="font-mono text-xs mt-1.5" style={{ color: colors.textMuted }}>
              Hydraulika · Budynek A · m. 14
            </p>

            {/* Progress steps (Erste-style status flow) */}
            <div className="flex items-center mt-6 mb-5">
              {STATUS_FLOW.map((status, i) => (
                <div key={status.label} className="flex items-center flex-1">
                  {i > 0 && (
                    <div
                      className="flex-1 h-0.5 mx-1 rounded"
                      style={{
                        background: STATUS_FLOW[i - 1].done
                          ? `${status.color}50`
                          : colors.cardBorder,
                        height: 2,
                      }}
                    />
                  )}
                  <div className="flex flex-col items-center">
                    <div
                      className="w-8 h-8 rounded-full flex items-center justify-center"
                      style={{
                        background: status.done ? status.color : "transparent",
                        border: status.done ? "none" : `2px solid ${colors.cardBorder}`,
                        color: status.done ? "#fff" : colors.textMuted,
                        boxShadow: status.active
                          ? `0 0 0 4px ${status.color}25`
                          : "none",
                      }}
                    >
                      <svg
                        width="14"
                        height="14"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d={status.icon} />
                      </svg>
                    </div>
                    <span
                      className="mt-1.5 font-heading font-semibold text-[10px]"
                      style={{ color: status.done ? colors.text : colors.textMuted }}
                    >
                      {status.label}
                    </span>
                  </div>
                </div>
              ))}
            </div>

            {/* Activity row */}
            <div
              className="flex items-center gap-3 pt-4 mt-2"
              style={{ borderTop: `1px solid ${colors.cardBorder}` }}
            >
              <div
                className="w-8 h-8 rounded-full flex items-center justify-center text-xs font-semibold"
                style={{ background: `${colors.accent}15`, color: colors.accent }}
              >
                MW
              </div>
              <div className="flex-1 min-w-0">
                <div className="text-sm font-medium" style={{ color: colors.text }}>
                  Marek Wójcik · Serwis
                </div>
                <div className="flex items-center gap-1.5 text-xs mt-0.5" style={{ color: colors.textMuted }}>
                  <MessageSquare className="w-3 h-3" />
                  <span className="truncate">Wymiana zaworu, ETA 14:00</span>
                </div>
              </div>
              <Bell className="w-4 h-4" style={{ color: colors.textMuted }} />
            </div>

            {/* Bottom action bar — Erste-inspired */}
            <div
              className="flex items-center gap-3 mt-4 pt-3"
              style={{ borderTop: `1px solid ${colors.cardBorder}` }}
            >
              <button
                className="flex-1 flex items-center justify-center gap-1.5 text-xs font-semibold py-2 rounded-lg transition-colors"
                style={{ background: `${colors.accent}12`, color: colors.accent }}
              >
                <MessageSquare className="w-3.5 h-3.5" />
                Wyślij wiadomość
              </button>
              <button
                className="flex-1 flex items-center justify-center gap-1.5 text-xs font-semibold py-2 rounded-lg transition-colors"
                style={{ background: `${colors.success}12`, color: colors.success }}
              >
                <Wrench className="w-3.5 h-3.5" />
                Zmień status
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

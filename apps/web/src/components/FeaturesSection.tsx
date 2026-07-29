"use client";

import { useRef, useState } from "react";
import { motion, useInView } from "framer-motion";
import { colors } from "@mestio/design-tokens";
import {
  ClipboardList, Users, Bell, History, Megaphone, Building2,
  Camera, ShieldCheck, TrendingUp, ArrowRight,
} from "lucide-react";
import Link from "next/link";

const FEATURES = [
  {
    icon: ClipboardList,
    title: "Zgłoszenia ze statusem i priorytetem",
    desc: "Nowe → W realizacji → Zamknięte. Każde zgłoszenie ma priorytet i termin SLA. Mieszkaniec widzi status na żywo — nie musi dzwonić i pytać.",
    color: "#3E7BD6",
    span: "lg:col-span-2",
    visual: "pipeline",
  },
  {
    icon: Bell,
    title: "Powiadomienia push",
    desc: "Nowe zgłoszenie, zmiana statusu, awaria — wszyscy dostają powiadomienie natychmiast.",
    color: "#F2A900",
    span: "",
    visual: "none",
  },
  {
    icon: Users,
    title: "5 ról, jeden system",
    desc: "Mieszkaniec zgłasza. Zarząd zatwierdza. Zarządca koordynuje. Serwis naprawia. Ochrona widzi. Każdy ma swoje uprawnienia.",
    color: "#3E7BD6",
    span: "",
    visual: "roles",
  },
  {
    icon: History,
    title: "Pełny ślad audytowy",
    desc: "Kto, co i kiedy — każda akcja zapisana. Dowód dla mieszkańców, zarządu i audytora. Historia jednym kliknięciem.",
    color: "#22C55E",
    span: "lg:col-span-2",
    visual: "timeline",
  },
  {
    icon: Megaphone,
    title: "Ogłoszenia z datą wygaśnięcia",
    desc: "Komunikaty znikają automatycznie po terminie. Czysto i na temat.",
    color: "#3E7BD6",
    span: "",
    visual: "none",
  },
  {
    icon: Building2,
    title: "Mapa osiedla: budynki, klatki, piętra",
    desc: "Mieszkaniec wybiera dokładną lokalizację przy zgłoszeniu. Serwis wie, gdzie iść. Koniec z 'nie wiem, który kran'.",
    color: "#3E7BD6",
    span: "lg:col-span-2",
    visual: "map",
  },
];

const PIPELINE_STEPS = [
  { label: "Nowe", color: "#3E7BD6" },
  { label: "W realizacji", color: "#F2A900" },
  { label: "Zamknięte", color: "#22C55E" },
];

const ROLES = [
  { label: "Mieszkaniec", color: "#3E7BD6", icon: Users },
  { label: "Zarząd", color: "#173A6A", icon: ShieldCheck },
  { label: "Zarządca", color: "#3E7BD6", icon: Building2 },
  { label: "Serwis", color: "#F2A900", icon: ClipboardList },
  { label: "Ochrona", color: "#22C55E", icon: ShieldCheck },
];

export default function FeaturesSection() {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);

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

        {/* Bento grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {FEATURES.map((feature, i) => {
            const Icon = feature.icon;
            const isHovered = hoveredIndex === i;

            return (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 30 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.5, delay: 0.1 + i * 0.07, ease: "easeOut" as const }}
                onMouseEnter={() => setHoveredIndex(i)}
                onMouseLeave={() => setHoveredIndex(null)}
                className={`rounded-2xl p-7 relative overflow-hidden group transition-all duration-300 ${feature.span}`}
                style={{
                  background: "#FFFFFF",
                  border: `1px solid ${isHovered ? `${feature.color}30` : colors.cardBorder}`,
                  boxShadow: isHovered ? `0 12px 32px ${feature.color}12` : "0 1px 3px rgba(14,26,43,0.04)",
                }}
              >
                {/* Hover glow */}
                <div
                  className="absolute -top-20 -right-20 w-40 h-40 rounded-full pointer-events-none transition-opacity duration-300"
                  style={{
                    background: `radial-gradient(circle, ${feature.color}10, transparent 70%)`,
                    opacity: isHovered ? 1 : 0,
                  }}
                />

                {/* Icon */}
                <motion.div
                  animate={isHovered ? { scale: 1.1 } : { scale: 1 }}
                  transition={{ duration: 0.3 }}
                  className="w-12 h-12 rounded-xl flex items-center justify-center mb-5 relative z-10"
                  style={{ background: `${feature.color}12` }}
                >
                  <Icon className="w-5 h-5" style={{ color: feature.color }} />
                </motion.div>

                {/* Title */}
                <h3
                  className="font-heading font-semibold text-[17px] leading-[1.25] mb-3 relative z-10"
                  style={{ color: colors.text }}
                >
                  {feature.title}
                </h3>
                <p className="text-[14px] leading-relaxed relative z-10" style={{ color: colors.textSecondary }}>
                  {feature.desc}
                </p>

                {/* ── Visual elements ── */}
                {feature.visual === "pipeline" && <PipelineVisual />}
                {feature.visual === "timeline" && <TimelineVisual />}
                {feature.visual === "roles" && <RolesVisual />}
                {feature.visual === "map" && <MapVisual />}
              </motion.div>
            );
          })}
        </div>

        {/* Bottom CTA */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.5, delay: 0.6 }}
          className="flex justify-center mt-12"
        >
          <Link
            href="/zamow"
            className="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl text-sm font-semibold text-white transition-all hover:brightness-110"
            style={{
              background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
              boxShadow: "0 4px 16px rgba(62,123,214,0.25)",
            }}
          >
            Wypróbuj wszystkie funkcje
            <ArrowRight className="w-4 h-4" />
          </Link>
        </motion.div>
      </div>
    </section>
  );
}

// ── Pipeline visual: Nowe → W realizacji → Zamknięte ──
function PipelineVisual() {
  return (
    <div className="flex items-center gap-2 mt-6 relative z-10">
      {PIPELINE_STEPS.map((step, i) => (
        <div key={step.label} className="flex items-center gap-2 flex-1">
          <div
            className="flex-1 rounded-lg px-3 py-2 text-center text-[11px] font-semibold"
            style={{ background: `${step.color}12`, color: step.color }}
          >
            {step.label}
          </div>
          {i < PIPELINE_STEPS.length - 1 && (
            <ArrowRight className="w-3 h-3 shrink-0" style={{ color: colors.textLight }} />
          )}
        </div>
      ))}
    </div>
  );
}

// ── Timeline visual: audit trail dots ──
function TimelineVisual() {
  const events = [
    { time: "09:14", text: "Mieszkaniec zgłosił usterkę", color: "#3E7BD6" },
    { time: "09:22", text: "Zarząd zatwierdził zgłoszenie", color: "#173A6A" },
    { time: "09:35", text: "Serwis przejął zadanie", color: "#F2A900" },
    { time: "10:01", text: "Zgłoszenie zamknięte", color: "#22C55E" },
  ];
  return (
    <div className="mt-5 relative z-10 space-y-2.5">
      {events.map((evt, i) => (
        <div key={i} className="flex items-center gap-3">
          <div className="flex flex-col items-center shrink-0">
            <div className="w-2 h-2 rounded-full" style={{ background: evt.color }} />
            {i < events.length - 1 && <div className="w-px h-5" style={{ background: colors.cardBorder }} />}
          </div>
          <span className="font-mono text-[10px]" style={{ color: colors.textMuted }}>{evt.time}</span>
          <span className="text-[12px]" style={{ color: colors.textSecondary }}>{evt.text}</span>
        </div>
      ))}
    </div>
  );
}

// ── Roles visual: 5 role chips ──
function RolesVisual() {
  return (
    <div className="flex flex-wrap gap-1.5 mt-5 relative z-10">
      {ROLES.map((role) => {
        const Icon = role.icon;
        return (
          <div
            key={role.label}
            className="inline-flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-[11px] font-medium"
            style={{ background: `${role.color}10`, color: role.color, border: `1px solid ${role.color}20` }}
          >
            <Icon className="w-3 h-3" />
            {role.label}
          </div>
        );
      })}
    </div>
  );
}

// ── Map visual: building grid mini ──
function MapVisual() {
  const buildings = ["A", "B", "C", "D", "E", "F", "G", "H"];
  return (
    <div className="mt-5 relative z-10">
      <div className="grid grid-cols-8 gap-1.5">
        {buildings.map((b, i) => (
          <div
            key={b}
            className="aspect-square rounded-md flex items-center justify-center text-[9px] font-mono font-semibold"
            style={{
              background: i === 2 || i === 5 ? "rgba(242,169,0,0.12)" : "rgba(62,123,214,0.08)",
              color: i === 2 || i === 5 ? "#F2A900" : "#3E7BD6",
              border: `1px solid ${i === 2 || i === 5 ? "rgba(242,169,0,0.2)" : "rgba(62,123,214,0.15)"}`,
            }}
          >
            {b}
          </div>
        ))}
      </div>
      <div className="flex items-center gap-3 mt-3">
        <div className="flex items-center gap-1">
          <div className="w-2 h-2 rounded-sm" style={{ background: "rgba(62,123,214,0.3)" }} />
          <span className="text-[10px]" style={{ color: colors.textMuted }}>OK</span>
        </div>
        <div className="flex items-center gap-1">
          <div className="w-2 h-2 rounded-sm" style={{ background: "rgba(242,169,0,0.3)" }} />
          <span className="text-[10px]" style={{ color: colors.textMuted }}>Zgłoszenie</span>
        </div>
      </div>
    </div>
  );
}

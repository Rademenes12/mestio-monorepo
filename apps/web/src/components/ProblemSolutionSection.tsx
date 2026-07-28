import { colors } from "@mestio/design-tokens";
import { X, Check, Sparkles } from "lucide-react";

const PAIN_POINTS = [
  "Zgłoszenia giną w SMS-ach, telefonach i grupach na Facebooku",
  "Mieszkaniec nie wie, czy ktoś się zajął sprawą",
  "Zarząd nie ma historii ani dowodu, co i kiedy naprawiono",
  "Serwis dostaje niejasne opisy bez zdjęć i lokalizacji",
];

const GAIN_POINTS = [
  "Jeden strumień zgłoszeń ze statusem i historią",
  "Mieszkaniec widzi status i dostaje powiadomienia",
  "Pełny ślad audytowy — kto, co i kiedy zrobił",
  "Zdjęcia, PDF i dokładna lokalizacja w każdym zgłoszeniu",
];

export default function ProblemSolutionSection() {
  return (
    <section className="max-w-7xl mx-auto px-6 py-[40px]">
      <div
        className="rounded-[24px] p-11 grid grid-cols-1 md:grid-cols-2 gap-10 relative overflow-hidden"
        style={{
          background: `radial-gradient(600px 400px at 90% 0%, ${colors.accent}20, transparent 60%), ${colors.bgSecondary}`,
          border: `1px solid ${colors.cardBorder}`,
        }}
      >
        {/* ── Before (pain) ── */}
        <div>
          <div
            className="flex items-center gap-2 font-mono text-[11px] tracking-[0.6px] uppercase"
            style={{ color: colors.textMuted }}
          >
            <X className="w-3.5 h-3.5" />
            Bez Mestio
          </div>
          <div className="flex flex-col gap-[14px] mt-4">
            {PAIN_POINTS.map((point) => (
              <div key={point} className="flex gap-[10px] items-start">
                <X
                  className="w-4 h-4 shrink-0 mt-[1px]"
                  style={{ color: colors.textMuted }}
                />
                <span
                  className="text-[14.5px] leading-relaxed"
                  style={{ color: colors.textSecondary }}
                >
                  {point}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* ── After (gain) ── */}
        <div>
          <div
            className="flex items-center gap-2 font-mono text-[11px] tracking-[0.6px] uppercase"
            style={{ color: colors.success }}
          >
            <Check className="w-3.5 h-3.5" />
            Z Mestio
          </div>
          <div className="flex flex-col gap-[14px] mt-4">
            {GAIN_POINTS.map((point) => (
              <div key={point} className="flex gap-[10px] items-start">
                <Check
                  className="w-4 h-4 shrink-0 mt-[1px]"
                  style={{ color: colors.success, strokeWidth: 2.4 }}
                />
                <span
                  className="text-[14.5px] leading-relaxed"
                  style={{ color: colors.text }}
                >
                  {point}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

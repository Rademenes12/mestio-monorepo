import { colors } from "@mestio/design-tokens";
import { ArrowRight, Sparkles } from "lucide-react";
import Link from "next/link";

export default function CtaSection() {
  return (
    <section className="max-w-7xl mx-auto px-6 pt-5 pb-[70px]">
      <div
        className="rounded-[24px] p-[52px] text-center relative overflow-hidden"
        style={{
          background: `linear-gradient(135deg, ${colors.navyLight}, ${colors.navy})`,
          boxShadow: `0 24px 50px ${colors.accent}25`,
        }}
      >
        {/* Glow decoration */}
        <div
          className="absolute -top-40 -left-40 w-[500px] h-[500px] rounded-full pointer-events-none"
          style={{
            background: `radial-gradient(circle, ${colors.accent}20, transparent 70%)`,
          }}
        />

        <div className="relative z-10">
          <div
            className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-5"
            style={{
              background: `${colors.text}12`,
              color: colors.text,
              border: `1px solid ${colors.text}20`,
            }}
          >
            <Sparkles className="w-3.5 h-3.5" />
            Zacznij już dziś
          </div>

          <h2
            className="font-heading font-bold text-[32px] tracking-[-0.6px]"
            style={{ color: colors.text }}
          >
            Gotowy uporządkować zgłoszenia?
          </h2>
          <p
            className="text-base mt-3"
            style={{ color: `${colors.textSecondary}` }}
          >
            Uruchom Mestio dla swojego osiedla w kilka minut.
          </p>

          <Link
            href="/zamow"
            className="inline-flex items-center gap-2 mt-6 text-base font-semibold px-[30px] py-[15px] rounded-[13px] transition-all duration-200 hover:brightness-110"
            style={{
              background: colors.text,
              color: colors.navy,
            }}
          >
            Zamów Mestio
            <ArrowRight className="w-4 h-4" />
          </Link>

          <p
            className="text-[13.5px] mt-[14px] font-medium"
            style={{ color: `${colors.textSecondary}` }}
          >
            Pierwsze 3 miesiące gratis &middot; anuluj kiedy chcesz &middot; bez karty na start
          </p>
        </div>
      </div>
    </section>
  );
}

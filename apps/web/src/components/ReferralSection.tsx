import { colors } from "@mestio/design-tokens";
import { Sparkles, Gift } from "lucide-react";
import Link from "next/link";

export default function ReferralSection() {
  return (
    <section className="max-w-7xl mx-auto px-6 py-[40px]">
      <div
        className="rounded-[24px] p-10 flex items-center justify-between gap-[30px] flex-wrap relative overflow-hidden"
        style={{
          background: `linear-gradient(135deg, ${colors.card}, ${colors.bgSecondary})`,
          border: `1px solid ${colors.glassBorder}`,
        }}
      >
        {/* Decorative glow */}
        <div
          className="absolute -top-20 -right-20 w-64 h-64 rounded-full pointer-events-none"
          style={{
            background: `radial-gradient(circle, ${colors.accent}15, transparent 70%)`,
          }}
        />

        <div className="max-w-[620px] relative z-10">
          <span
            className="inline-flex items-center gap-[7px] px-3 py-[5px] rounded-full text-xs font-semibold"
            style={{
              background: `${colors.warning}16`,
              color: colors.warning,
            }}
          >
            <Gift className="w-3.5 h-3.5" />
            Program poleceń
          </span>
          <h2
            className="font-heading font-bold text-[26px] mt-[14px] tracking-[-0.4px]"
            style={{ color: colors.text }}
          >
            Polecasz Mestio innemu zarządcy? Oboje zyskujecie.
          </h2>
          <p
            className="text-[15px] mt-[10px] leading-relaxed"
            style={{ color: colors.textSecondary }}
          >
            Za każde osiedle, które dołączy z Twojego polecenia, dostajesz{" "}
            <b className="font-semibold" style={{ color: colors.text }}>
              1 miesiąc gratis
            </b>
            , a polecony — 20% zniżki na start przez pierwsze 6 miesięcy.
          </p>
        </div>
        <Link
          href="/zamow"
          className="text-[15px] font-semibold px-6 py-[14px] rounded-[13px] whitespace-nowrap transition-all duration-200 hover:brightness-110 relative z-10"
          style={{
            background: `linear-gradient(135deg, ${colors.accent}, ${colors.navyLight})`,
            color: colors.text,
            boxShadow: `0 4px 16px ${colors.accent}35`,
          }}
        >
          Zdobądź swój link
        </Link>
      </div>
    </section>
  );
}

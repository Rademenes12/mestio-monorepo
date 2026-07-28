import { colors } from "@mestio/design-tokens";
import { ShoppingCart, QrCode, Users, ArrowRight, Sparkles } from "lucide-react";

const STEPS = [
  {
    n: "1",
    icon: ShoppingCart,
    title: "Zamawiasz na stronie",
    desc: "Rejestrujesz firmę, zarząd lub zarządcę nieruchomości i opłacasz plan. Faktura VAT automatycznie. Pierwsze 3 miesiące gratis.",
  },
  {
    n: "2",
    icon: QrCode,
    title: "Tworzymy osiedle i kody",
    desc: "Po płatności powstaje Twoje osiedle, a Ty dostajesz kody zaproszeń dla mieszkańców. Każdy kod działa na jedną osobę.",
  },
  {
    n: "3",
    icon: Users,
    title: "Mieszkańcy dołączają",
    desc: "Pobierają darmową aplikację, wpisują kod i od razu mogą zgłaszać usterki, dostawać powiadomienia i śledzić status napraw.",
  },
];

export default function HowItWorksSection() {
  return (
    <section
      id="jak-to-dziala"
      className="max-w-7xl mx-auto px-6 py-[60px]"
    >
      <div className="text-center">
        <div
          className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-4"
          style={{
            background: `${colors.accent}10`,
            color: colors.accent,
            border: `1px solid ${colors.accent}20`,
          }}
        >
          <Sparkles className="w-3.5 h-3.5" />
          Jak to działa
        </div>
        <h2
          className="font-heading font-bold text-[32px] tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Trzy kroki do uruchomienia
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Od zamówienia do pierwszych zgłoszeń w kilka minut.
        </p>
      </div>

      <div className="relative grid grid-cols-1 md:grid-cols-3 gap-[18px] mt-[34px]">
        {/* Connector line between steps (desktop) */}
        <div
          className="hidden md:block absolute top-[52px] left-[calc(16.66%+36px)] right-[calc(16.66%+36px)] h-0.5"
          style={{
            background: `linear-gradient(90deg, ${colors.accent}50, ${colors.cardBorder} 80%)`,
          }}
        />

        {STEPS.map((step, i) => {
          const Icon = step.icon;
          return (
            <div
              key={step.n}
              className="glass-card p-[28px] relative transition-all duration-300 hover:translate-y-[-4px]"
              style={{ borderColor: colors.cardBorder }}
            >
              {/* Step number badge */}
              <div
                className="w-[44px] h-[44px] rounded-xl flex items-center justify-center relative z-10"
                style={{
                  background: `linear-gradient(135deg, ${colors.accent}, ${colors.navyLight})`,
                  boxShadow: `0 4px 16px ${colors.accent}35`,
                }}
              >
                <Icon className="w-5 h-5 text-white" />
              </div>
              <h3
                className="font-heading font-semibold text-[17px] mt-[18px]"
                style={{ color: colors.text }}
              >
                {step.title}
              </h3>
              <p
                className="text-sm leading-relaxed mt-2"
                style={{ color: colors.textSecondary }}
              >
                {step.desc}
              </p>

              {/* Arrow hint for next step (mobile) */}
              {i < STEPS.length - 1 && (
                <div className="md:hidden flex justify-center mt-4">
                  <ArrowRight
                    className="w-5 h-5 rotate-90"
                    style={{ color: colors.textMuted }}
                  />
                </div>
              )}
            </div>
          );
        })}
      </div>

      <p
        className="text-center mt-[22px] text-[13.5px]"
        style={{ color: colors.textMuted }}
      >
        Firma płaci raz na stronie — mieszkańcy pobierają aplikację za darmo i
        wpisują kod. Zero opłat w aplikacji.
      </p>
    </section>
  );
}

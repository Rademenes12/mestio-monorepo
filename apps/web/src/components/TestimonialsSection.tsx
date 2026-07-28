import { colors } from "@mestio/design-tokens";
import { Sparkles, Star } from "lucide-react";

const TESTIMONIALS = [
  {
    name: "Anna Kowalska",
    role: "Zarządca nieruchomości",
    estate: "Osiedle Zielone Wzgórze",
    avatar: "AK",
    text: "Mieszkańcy przestali dzwonić z pytaniem 'czy ktoś to widział?'. Sami sprawdzają status w aplikacji. Oszczędzam kilka godzin tygodniowo na telefonach.",
    stars: 5,
  },
  {
    name: "Piotr Nowak",
    role: "Prezes Zarządu",
    estate: "Wspólnota Mieszkaniowa Sadyba",
    avatar: "PN",
    text: "Mam pełną historię zgłoszeń — wiem ile średnio trwa naprawa i który serwisant jest najskuteczniejszy. Ranking osiedli to świetna motywacja.",
    stars: 5,
  },
  {
    name: "Marek Wójcik",
    role: "Koordynator serwisu",
    estate: "Apartamenty Park",
    avatar: "MW",
    text: "Zdjęcia i lokalizacja w zgłoszeniu eliminują 'nie wiem o który kran chodzi'. Serwis dostaje pełne info od razu — zero nieporozumień.",
    stars: 5,
  },
];

export default function TestimonialsSection() {
  return (
    <section className="max-w-7xl mx-auto px-6 py-[60px]">
      <div className="text-center">
        <div
          className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-4"
          style={{
            background: `${colors.success}12`,
            color: colors.success,
            border: `1px solid ${colors.success}25`,
          }}
        >
          <Sparkles className="w-3.5 h-3.5" />
          Opinie
        </div>
        <h2
          className="font-heading font-bold text-[30px] tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Co mówią nasi użytkownicy
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Zarządcy, zarządy i serwisanci — każdy znajdzie coś dla siebie.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-[18px] mt-[34px]">
        {TESTIMONIALS.map((t) => (
          <div
            key={t.name}
            className="glass-card p-[26px] flex flex-col transition-all duration-300 hover:translate-y-[-4px]"
            style={{ borderColor: colors.cardBorder }}
          >
            {/* Stars */}
            <div className="flex gap-0.5 mb-4">
              {Array.from({ length: t.stars }).map((_, i) => (
                <Star
                  key={i}
                  className="w-4 h-4"
                  style={{ color: colors.warning, fill: colors.warning }}
                />
              ))}
            </div>

            {/* Quote */}
            <p
              className="text-sm leading-relaxed flex-1"
              style={{ color: colors.textSecondary }}
            >
              &bdquo;{t.text}&rdquo;
            </p>

            {/* Author */}
            <div className="flex items-center gap-3 mt-5 pt-4" style={{ borderTop: `1px solid ${colors.cardBorder}` }}>
              <div
                className="w-10 h-10 rounded-full flex items-center justify-center text-xs font-semibold"
                style={{
                  background: `linear-gradient(135deg, ${colors.accent}, ${colors.navyLight})`,
                  color: colors.text,
                }}
              >
                {t.avatar}
              </div>
              <div>
                <div
                  className="text-sm font-semibold"
                  style={{ color: colors.text }}
                >
                  {t.name}
                </div>
                <div
                  className="text-xs mt-0.5"
                  style={{ color: colors.textMuted }}
                >
                  {t.role} · {t.estate}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Trust indicators */}
      <div
        className="flex flex-wrap items-center justify-center gap-6 mt-10 pt-6"
        style={{ borderTop: `1px solid ${colors.cardBorder}` }}
      >
        {[
          { stat: "5+", label: "osiedli" },
          { stat: "200+", label: "mieszkańców" },
          { stat: "500+", label: "zgłoszeń" },
          { stat: "99%", label: "zadowolonych" },
        ].map((item) => (
          <div key={item.label} className="text-center min-w-[100px]">
            <div
              className="font-heading font-bold text-xl"
              style={{ color: colors.accent }}
            >
              {item.stat}
            </div>
            <div
              className="text-xs mt-0.5"
              style={{ color: colors.textMuted }}
            >
              {item.label}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

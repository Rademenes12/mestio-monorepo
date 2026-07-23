import { colors } from "@mestio/design-tokens";
import {
  ClipboardList,
  Users,
  Bell,
  History,
  Megaphone,
  Building2,
  Sparkles,
} from "lucide-react";

const FEATURES = [
  {
    icon: ClipboardList,
    title: "Zgłoszenia ze statusem",
    desc: "Nowe → W realizacji → Zamknięte, z priorytetem i terminem SLA. Jak ticket w profesjonalnym helpdesku.",
    color: colors.accent,
  },
  {
    icon: Users,
    title: "Pięć ról",
    desc: "Mieszkaniec, zarząd, zarządca nieruchomości, serwis, ochrona — każdy widzi to, co powinien. Role z precyzyjnymi uprawnieniami.",
    color: colors.navyLight,
  },
  {
    icon: Bell,
    title: "Powiadomienia push",
    desc: "Natychmiastowe powiadomienia o zmianie statusu i nowych ogłoszeniach na telefonach wszystkich użytkowników — nikt nic nie przegapi.",
    color: colors.warning,
  },
  {
    icon: History,
    title: "Ślad audytowy",
    desc: "Pełna historia każdej zmiany — dowód dla mieszkańców, zarządu i przy reklamacjach. Kto, kiedy, co zrobił.",
    color: colors.success,
  },
  {
    icon: Megaphone,
    title: "Ogłoszenia",
    desc: "Komunikaty do mieszkańców z datą wygaśnięcia — potem znikają automatycznie. Żadnego spamowania starszymi treściami.",
    color: colors.navyLight,
  },
  {
    icon: Building2,
    title: "Struktura osiedla",
    desc: "Budynki, klatki, piętra i garaże — mieszkaniec wybiera lokal przy rejestracji. Automatyczne przypisanie do odpowiedniego zarządcy.",
    color: colors.accent,
  },
];

export default function FeaturesSection() {
  return (
    <section id="funkcje" className="max-w-7xl mx-auto px-6 py-20">
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
          Funkcje
        </div>
        <h2
          className="font-heading font-bold text-3xl tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Wszystko, czego potrzebuje osiedle
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Jedna aplikacja dla mieszkańców, zarządu, zarządcy nieruchomości, serwisu i ochrony.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mt-10">
        {FEATURES.map((feature) => {
          const Icon = feature.icon;
          return (
            <div
              key={feature.title}
              className="group rounded-2xl border p-6 transition-all duration-200"
              style={{
                background: colors.card,
                borderColor: colors.cardBorder,
              }}
            >
              <div
                className="w-11 h-11 rounded-xl flex items-center justify-center transition-colors duration-200 mb-4"
                style={{ background: `${feature.color}14` }}
              >
                <Icon
                  className="w-5 h-5"
                  style={{ color: feature.color }}
                />
              </div>
              <h3
                className="font-heading font-semibold text-base"
                style={{ color: colors.text }}
              >
                {feature.title}
              </h3>
              <p
                className="text-sm leading-relaxed mt-2"
                style={{ color: colors.textSecondary }}
              >
                {feature.desc}
              </p>
            </div>
          );
        })}
      </div>
    </section>
  );
}

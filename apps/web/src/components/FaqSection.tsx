"use client";

import { useState } from "react";
import { colors } from "@mestio/design-tokens";
import { Sparkles, ChevronDown } from "lucide-react";

const FAQS = [
  {
    q: "Czy mieszkańcy płacą za aplikację?",
    a: "Nie. Aplikacja jest w pełni darmowa dla mieszkańców, serwisu i ochrony. Opłatę wnosi firma zarządzająca lub zarząd wspólnoty na stronie — a pierwsze 3 miesiące są gratis.",
  },
  {
    q: "Jak działa płatność?",
    a: "Płatność obsługuje Stripe na naszej stronie. Otrzymujesz fakturę VAT. Po opłaceniu tworzymy Twoje osiedle i kody zaproszeń dla mieszkańców.",
  },
  {
    q: "Czy mogę zrezygnować?",
    a: "Tak, subskrypcję możesz anulować w dowolnym momencie. Dostęp działa do końca opłaconego okresu.",
  },
  {
    q: "Czy dane są bezpieczne?",
    a: "Tak. Każde osiedle jest odseparowane, dostęp kontrolują reguły serwerowe, a zdjęcia trafiają do prywatnego magazynu. Zgodnie z RODO.",
  },
  {
    q: "Jak szybko mogę uruchomić system?",
    a: "Po opłaceniu osiedle jest gotowe w kilka minut. Kody zaproszeń wysyłasz do mieszkańców od razu — oni pobierają aplikację i są gotowi.",
  },
  {
    q: "Czy są jakieś ukryte koszty?",
    a: "Nie. Jedna miesięczna opłata za osiedle — bez limitów użytkowników, bez prowizji, bez dodatków. Faktura VAT co miesiąc.",
  },
];

export default function FaqSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section id="faq" className="max-w-[820px] mx-auto px-6 py-[60px]">
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
          FAQ
        </div>
        <h2
          className="font-heading font-bold text-[30px] tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Częste pytania
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Najważniejsze informacje o Mestio w pigułce.
        </p>
      </div>

      <div className="flex flex-col gap-3 mt-[26px]">
        {FAQS.map((faq, i) => {
          const isOpen = openIndex === i;
          return (
            <div
              key={faq.q}
              className="glass-card overflow-hidden transition-all duration-300"
              style={{
                cursor: "pointer",
                borderColor: isOpen
                  ? `${colors.accent}35`
                  : colors.cardBorder,
              }}
            >
              <button
                onClick={() => setOpenIndex(isOpen ? null : i)}
                className="w-full flex items-center justify-between gap-3 p-[18px_20px] text-left"
                aria-expanded={isOpen}
              >
                <span
                  className="font-heading font-semibold text-[15.5px]"
                  style={{ color: colors.text }}
                >
                  {faq.q}
                </span>
                <ChevronDown
                  className="w-5 h-5 shrink-0 transition-transform duration-300"
                  style={{
                    color: colors.accent,
                    transform: isOpen ? "rotate(180deg)" : "rotate(0deg)",
                  }}
                />
              </button>
              <div
                className="transition-all duration-300 ease-out overflow-hidden"
                style={{
                  maxHeight: isOpen ? "300px" : "0px",
                  opacity: isOpen ? 1 : 0,
                }}
              >
                <div
                  className="px-[20px] pb-[18px]"
                  style={{ borderTop: `1px solid ${colors.cardBorder}` }}
                >
                  <p
                    className="text-sm leading-relaxed pt-[14px]"
                    style={{ color: colors.textSecondary }}
                  >
                    {faq.a}
                  </p>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

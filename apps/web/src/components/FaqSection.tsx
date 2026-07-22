"use client";

import { useState } from "react";

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
];

export default function FaqSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section className="max-w-[820px] mx-auto px-6 py-[50px]">
      <h2 className="text-center font-heading font-bold text-[30px] tracking-[-0.5px] text-ink">
        Częste pytania
      </h2>

      <div className="flex flex-col gap-3 mt-[26px]">
        {FAQS.map((faq, i) => (
          <div
            key={faq.q}
            role="button"
            tabIndex={0}
            aria-expanded={openIndex === i}
            onClick={() => setOpenIndex(openIndex === i ? null : i)}
            onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); setOpenIndex(openIndex === i ? null : i); } }}
            className="bg-white rounded-[20px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-[18px_20px] cursor-pointer hover:shadow-[0_4px_16px_rgba(14,26,43,.08)] transition-shadow"
          >
            <div className="flex items-center justify-between gap-3">
              <span className="font-heading font-semibold text-[15.5px] text-ink">
                {faq.q}
              </span>
              <span
                className="font-heading font-semibold text-xl text-azure transition-transform duration-150"
                style={{
                  transform: openIndex === i ? "rotate(45deg)" : "none",
                }}
              >
                +
              </span>
            </div>
            {openIndex === i && (
              <p className="text-sm text-[#5A6B80] leading-relaxed mt-[11px]">
                {faq.a}
              </p>
            )}
          </div>
        ))}
      </div>
    </section>
  );
}

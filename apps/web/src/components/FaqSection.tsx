"use client";

import { useRef, useState } from "react";
import { motion, useInView, AnimatePresence } from "framer-motion";
import { Circle as HelpCircle, ChevronDown, MessageCircle } from "lucide-react";
import Link from "next/link";

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
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section ref={ref} id="faq" className="relative py-28 overflow-hidden" style={{ background: "#0A1524" }}>
      {/* Grid background */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: `linear-gradient(rgba(62,123,214,0.03) 1px, transparent 1px),
                            linear-gradient(90deg, rgba(62,123,214,0.03) 1px, transparent 1px)`,
          backgroundSize: "80px 80px",
          maskImage: "radial-gradient(ellipse 60% 50% at 50% 50%, black 30%, transparent 80%)",
          WebkitMaskImage: "radial-gradient(ellipse 60% 50% at 50% 50%, black 30%, transparent 80%)",
        }}
      />

      <div className="max-w-3xl mx-auto px-6 relative z-10">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-14"
        >
          <div
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold mb-5"
            style={{
              background: "rgba(62,123,214,0.1)",
              color: "#6DB3F2",
              border: "1px solid rgba(62,123,214,0.2)",
            }}
          >
            <HelpCircle className="w-3.5 h-3.5" />
            FAQ
          </div>
          <h2
            className="font-heading font-bold text-[36px] sm:text-[44px] tracking-[-1px] leading-[1.1]"
            style={{ color: "#FFF" }}
          >
            Częste{" "}
            <span className="bg-gradient-to-r from-[#3E7BD6] to-[#6DB3F2] bg-clip-text text-transparent">
              pytania
            </span>
          </h2>
          <p className="text-[15px] mt-4 max-w-lg mx-auto" style={{ color: "rgba(255,255,255,0.5)" }}>
            Najważniejsze informacje o Mestio w pigułce.
          </p>
        </motion.div>

        {/* Accordion */}
        <div className="flex flex-col gap-3">
          {FAQS.map((faq, i) => {
            const isOpen = openIndex === i;
            return (
              <motion.div
                key={faq.q}
                initial={{ opacity: 0, y: 20 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.4, delay: 0.1 + i * 0.06 }}
                className="rounded-xl overflow-hidden transition-all duration-300"
                style={{
                  background: isOpen ? "rgba(62,123,214,0.05)" : "rgba(255,255,255,0.02)",
                  border: `1px solid ${isOpen ? "rgba(62,123,214,0.25)" : "rgba(255,255,255,0.06)"}`,
                  backdropFilter: "blur(10px)",
                }}
              >
                <button
                  onClick={() => setOpenIndex(isOpen ? null : i)}
                  className="w-full flex items-center justify-between gap-3 p-5 text-left group"
                  aria-expanded={isOpen}
                >
                  <span
                    className="font-heading font-semibold text-[15.5px] transition-colors"
                    style={{ color: isOpen ? "#6DB3F2" : "#FFF" }}
                  >
                    {faq.q}
                  </span>
                  <motion.div
                    animate={{ rotate: isOpen ? 180 : 0 }}
                    transition={{ duration: 0.3 }}
                    className="shrink-0"
                    style={{ color: isOpen ? "#3E7BD6" : "rgba(255,255,255,0.3)" }}
                  >
                    <ChevronDown className="w-5 h-5" />
                  </motion.div>
                </button>

                <AnimatePresence initial={false}>
                  {isOpen && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: "auto", opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.3, ease: "easeInOut" }}
                      className="overflow-hidden"
                    >
                      <div className="px-5 pb-5">
                        <div className="h-px mb-4" style={{ background: "rgba(255,255,255,0.08)" }} />
                        <p className="text-[14px] leading-relaxed" style={{ color: "rgba(255,255,255,0.55)" }}>
                          {faq.a}
                        </p>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            );
          })}
        </div>

        {/* Contact prompt */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.5, delay: 0.6 }}
          className="text-center mt-12"
        >
          <p className="text-sm" style={{ color: "rgba(255,255,255,0.4)" }}>
            Nie znalazłeś odpowiedzi?
          </p>
          <Link
            href="/kontakt"
            className="inline-flex items-center gap-2 mt-3 px-5 py-3 rounded-xl text-sm font-semibold transition-all hover:brightness-110"
            style={{
              background: "rgba(255,255,255,0.05)",
              color: "#FFF",
              border: "1px solid rgba(255,255,255,0.12)",
            }}
          >
            <MessageCircle className="w-4 h-4" />
            Skontaktuj się z nami
          </Link>
        </motion.div>
      </div>
    </section>
  );
}

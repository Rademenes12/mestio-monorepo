const STEPS = [
  {
    n: "1",
    title: "Zamawiasz na stronie",
      desc: "Rejestrujesz firmę, zarząd lub zarządcę nieruchomości i opłacasz plan. Faktura VAT automatycznie.",
  },
  {
    n: "2",
    title: "Tworzymy osiedle i kody",
    desc: "Po płatności powstaje Twoje osiedle, a Ty dostajesz kody zaproszeń dla mieszkańców.",
  },
  {
    n: "3",
    title: "Mieszkańcy dołączają",
    desc: "Pobierają darmową aplikację, wpisują kod i od razu mogą zgłaszać usterki.",
  },
];

export default function HowItWorksSection() {
  return (
    <section id="jak-to-dziala" className="max-w-[1160px] mx-auto px-6 py-[56px]">
      <div className="text-center">
        <div className="font-mono text-[11px] tracking-[0.7px] uppercase text-[#8A98AB]">
          Jak to działa
        </div>
        <h2 className="font-heading font-bold text-[32px] tracking-[-0.6px] mt-2 text-ink">
          Trzy kroki do uruchomienia
        </h2>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-[18px] mt-[34px]">
        {STEPS.map((step) => (
          <div
            key={step.n}
            className="bg-white rounded-[22px] p-[26px] relative shadow-[0_2px_14px_rgba(14,26,43,.06)]"
          >
            <div className="font-heading font-bold text-[15px] text-white w-[34px] h-[34px] rounded-full bg-gradient-to-br from-azure to-blueprint flex items-center justify-center">
              {step.n}
            </div>
            <h3 className="font-heading font-semibold text-[17px] mt-[15px] text-ink">
              {step.title}
            </h3>
            <p className="text-sm text-[#5A6B80] leading-relaxed mt-2">
              {step.desc}
            </p>
          </div>
        ))}
      </div>

      <p className="text-center mt-[18px] text-[13.5px] text-[#7C8AA0]">
        Firma płaci raz na stronie — mieszkańcy pobierają aplikację za darmo i
        wpisują kod. Bez opłat w aplikacji.
      </p>
    </section>
  );
}

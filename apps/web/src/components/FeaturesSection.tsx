const FEATURES = [
  {
    icon: "M8 5H6.8A1.8 1.8 0 0 0 5 6.8V19a1.8 1.8 0 0 0 1.8 1.8h10.4A1.8 1.8 0 0 0 19 19V6.8A1.8 1.8 0 0 0 17.2 5H16M8.6 5.4a1.4 1.4 0 0 1 1.4-1.4h4a1.4 1.4 0 0 1 1.4 1.4 1 1 0 0 1-1 1H9.6a1 1 0 0 1-1-1zM8.5 11h7M8.5 14.5h5",
    title: "Zgłoszenia ze statusem",
    desc: "Nowe → W realizacji → Zamknięte, z priorytetem i terminem SLA.",
    color: "#3E7BD6",
  },
  {
    icon: "M12 12.5a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM5 20a7 7 0 0 1 14 0",
    title: "Pięć ról",
    desc: "Mieszkaniec, zarząd, zarządca nieruchomości, serwis, ochrona — każdy widzi to, co powinien.",
    color: "#173A6A",
  },
  {
    icon: "M12 4a5 5 0 0 0-5 5v3l-1.6 2.5h13.2L17 12V9a5 5 0 0 0-5-5zM9.5 18a2.5 2.5 0 0 0 5 0",
    title: "Powiadomienia",
    desc: "Push o zmianie statusu i nowych ogłoszeniach na telefonach wszystkich ról — nikt nic nie przegapi.",
    color: "#F2A900",
  },
  {
    icon: "M3 12a9 9 0 1 0 18 0 9 9 0 0 0-18 0zM12 7v5l3 2",
    title: "Ślad audytowy",
    desc: "Pełna historia zmian — dowód dla mieszkańców i przy reklamacjach.",
    color: "#2E9E6B",
  },
  {
    icon: "M5 10v4h3l7 4V6l-7 4H5zM18 9.2a3 3 0 0 1 0 5.6",
    title: "Ogłoszenia",
    desc: "Komunikaty do mieszkańców z datą wygaśnięcia — potem znikają.",
    color: "#173A6A",
  },
  {
    icon: "M4 21V9l8-5 8 5v12M9 21v-6h6v6",
    title: "Struktura osiedla",
    desc: "Budynki, klatki, piętra i garaże — mieszkaniec wybiera lokal przy rejestracji.",
    color: "#3E7BD6",
  },
];

function hexToRgba(hex: string, alpha: number): string {
  const num = parseInt(hex.slice(1), 16);
  return `rgba(${(num >> 16) & 255},${(num >> 8) & 255},${num & 255},${alpha})`;
}

export default function FeaturesSection() {
  return (
    <section id="funkcje" className="max-w-[1160px] mx-auto px-6 pt-[50px] pb-5">
      <div className="text-center">
        <h2 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
          Wszystko, czego potrzebuje osiedle
        </h2>
        <p className="text-base text-[#4A5A6E] mt-[10px]">
          Jedna aplikacja dla mieszkańców, zarządu, zarządcy nieruchomości, serwisu i ochrony.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[18px] mt-[34px]">
        {FEATURES.map((feature) => (
          <div
            key={feature.title}
            className="bg-white rounded-[22px] p-6 shadow-[0_2px_14px_rgba(14,26,43,.06)]"
          >
            <div
              className="w-11 h-11 rounded-[12px] flex items-center justify-center"
              style={{
                background: hexToRgba(feature.color, 0.12),
                color: feature.color,
              }}
            >
              <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.9"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d={feature.icon} />
              </svg>
            </div>
            <h3 className="font-heading font-semibold text-[17px] mt-[15px] text-ink">
              {feature.title}
            </h3>
            <p className="text-sm text-[#5A6B80] leading-relaxed mt-[7px]">
              {feature.desc}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
}

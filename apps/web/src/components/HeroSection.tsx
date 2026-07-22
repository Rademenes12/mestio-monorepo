import Link from "next/link";

const HERO_STATS = [
  { value: "5", label: "ról w jednej apce" },
  { value: "∞", label: "użytkowników bez limitu" },
  { value: "0%", label: "prowizji w aplikacji" },
  { value: "<60s", label: "na zgłoszenie usterki" },
];

const STATUSES = [
  { label: "Nowe", color: "#3E7BD6", reached: true, icon: "M12 7v10M7 12h10" },
  {
    label: "W realizacji",
    color: "#F2A900",
    reached: true,
    icon: "M9.5 8l6 4-6 4z",
    active: true,
  },
  {
    label: "Zamknięte",
    color: "#2E9E6B",
    reached: false,
    icon: "M6 12l3.5 4 8.5-8",
  },
];

export default function HeroSection() {
  return (
    <section className="max-w-[1160px] mx-auto px-6 pt-[70px] pb-10 grid grid-cols-[1.15fr_0.85fr] gap-12 items-center">
      <div>
        <span className="inline-flex items-center gap-2 px-[13px] py-[6px] rounded-full bg-[#EAF0F7] text-blueprint font-mono text-[11.5px] font-semibold tracking-[0.3px]">
          Dla zarządców nieruchomości, wspólnot i osiedli
        </span>

        <h1 className="font-heading font-bold text-[48px] leading-[1.08] tracking-[-1.2px] mt-5 text-ink">
          Zgłoszenia usterek na osiedlu — wreszcie pod kontrolą
        </h1>

        <p className="text-[17px] leading-relaxed text-[#4A5A6E] mt-[18px] max-w-[520px]">
          Mestio to aplikacja, w której mieszkaniec zgłasza usterkę w kilka
          sekund, a zarządca, zarząd i serwis prowadzą ją od &bdquo;Nowe&rdquo; aż po
          &bdquo;Zamknięte&rdquo; — z historią, powiadomieniami na telefonach
          wszystkich użytkowników i pełną kontrolą dostępu.
        </p>

        <div className="flex gap-3 mt-7">
          <Link
            href="/zamow"
            className="text-[15px] font-semibold text-white bg-gradient-to-br from-azure to-blueprint py-[14px] px-6 rounded-[13px] shadow-[0_10px_24px_rgba(23,58,106,.28)] hover:brightness-110 transition-all"
          >
            Zamów dla swojego osiedla
          </Link>
          <a
            href="#jak-to-dziala"
            className="text-[15px] font-semibold text-blueprint bg-white border border-[#D8E2EF] py-[14px] px-6 rounded-[13px] hover:bg-[#F4F7FB] transition-colors"
          >
            Jak to działa
          </a>
        </div>

        <div className="flex items-center gap-[7px] mt-4 text-sm text-[#1f7a4d] font-semibold">
          <svg
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#2E9E6B"
            strokeWidth="2.6"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M20 6L9 17l-5-5" />
          </svg>
          Pierwsze 3 miesiące gratis &middot; bez karty na start
        </div>

        <div className="flex gap-[26px] mt-[34px]">
          {HERO_STATS.map((stat) => (
            <div key={stat.label}>
              <div className="font-heading font-bold text-[26px] text-blueprint">
                {stat.value}
              </div>
              <div className="text-[12.5px] text-[#7C8AA0] mt-[2px]">
                {stat.label}
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="bg-white border border-[#E9EEF5] rounded-[22px] p-[22px] shadow-[0_30px_60px_rgba(14,26,43,.12)]">
        <div className="flex items-center justify-between">
          <span className="font-mono text-xs font-semibold text-[#8A98AB]">
            MS-2041
          </span>
          <span className="inline-flex items-center gap-[5px] px-[9px] py-[3px] rounded-full bg-amber/[.13] text-[#B37D00] font-mono text-[10.5px] font-semibold">
            <span className="w-[6px] h-[6px] rounded-full bg-amber inline-block" />
            W realizacji
          </span>
        </div>

        <div className="font-heading font-semibold text-lg mt-3">
          Cieknący kran w łazience
        </div>
        <div className="font-mono text-[11.5px] text-[#7C8AA0] mt-[6px]">
          Hydraulika &middot; Budynek A &middot; m. 14
        </div>

        <div className="flex items-start mt-[22px]">
          {STATUSES.map((status, i) => (
            <div key={status.label} className="flex items-start">
              {i > 0 && (
                <div
                  className="flex-1 h-[3px] mt-[18px] rounded-[2px]"
                  style={{
                    background:
                      STATUSES[i - 1].reached ? status.color : "#E2E9F2",
                    minWidth: 40,
                  }}
                />
              )}
              <div className="flex flex-col items-center w-[78px]">
                <div
                  className="w-[38px] h-[38px] rounded-full flex items-center justify-center shrink-0"
                  style={{
                    background: status.reached ? status.color : "#fff",
                    color: status.reached ? "#fff" : "#B6C2D2",
                    border: status.reached
                      ? "none"
                      : "2px solid #E2E9F2",
                    boxShadow: status.active
                      ? `0 0 0 5px ${status.color}29`
                      : "none",
                  }}
                >
                  <svg
                    width="18"
                    height="18"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2.2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <path d={status.icon} />
                  </svg>
                </div>
                <div
                  className="mt-2 font-heading font-semibold text-[11.5px]"
                  style={{
                    color: status.reached ? "#0E1A2B" : "#9FACBD",
                  }}
                >
                  {status.label}
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="mt-[22px] pt-4 border-t border-[#F0F3F8] flex items-center gap-[10px]">
          <div className="w-[30px] h-[30px] rounded-full bg-[#EAF0F7] flex items-center justify-center font-heading text-[11px] font-semibold text-blueprint">
            MW
          </div>
          <div>
            <div className="text-[12.5px] font-semibold">
              Marek Wójcik &middot; Serwis
            </div>
            <div className="font-mono text-[10.5px] text-[#9AA7B8]">
              Notatka: wymiana zaworu, ETA 14:00
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

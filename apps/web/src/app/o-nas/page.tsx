import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "O nas",
  description:
    "Mestio to cyfrowy ekosystem dla zarządców nieruchomości i wspólnot mieszkaniowych. Eliminujemy chaos komunikacyjny i biurokrację z życia osiedli.",
  alternates: { canonical: "https://mestio.pl/o-nas" },
};

const VALUES = [
  {
    icon: "M13 2L3 14h9l-1 8 10-12h-9l1-8z",
    title: "Zgłoszenia w kilka sekund",
    desc: "Mieszkaniec zgłasza awarię — od przepalonej żarówki po awarię bramy — przez aplikację, ze zdjęciem i opisem. Koniec z telefonami i mailami, które giną w skrzynce.",
  },
  {
    icon: "M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8zM12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6z",
    title: "Pełna transparentność",
    desc: "Każdy etap naprawy jest widoczny. Zarządca wie, komu zlecił zadanie. Mieszkaniec widzi, na jakim etapie jest jego sprawa.",
  },
  {
    icon: "M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83",
    title: "Automatyzacja pracy zarządu",
    desc: "Odciążamy administrację z powtarzalnych zadań — automatyczna kategoryzacja zgłoszeń, optymalizacja komunikacji z wykonawcami.",
  },
  {
    icon: "M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z",
    title: "Bezpieczeństwo i stabilność",
    desc: "Nowoczesna infrastruktura technologiczna gwarantuje niezawodność 24/7. Dane każdego osiedla są od siebie odseparowane.",
  },
];

const TESTIMONIALS = [
  {
    quote:
      "W końcu ktoś zrozumiał, jak powinno wyglądać zgłaszanie awarii w XXI wieku. Dawniej zgłoszenie pękniętej rury na parkingu podziemnym wymagało serii telefonów. Z Mestio po prostu robię zdjęcie, wysyłam i widzę, że ekipa już jedzie.",
    author: "Tomasz",
    role: "Członek wspólnoty mieszkaniowej",
  },
  {
    quote:
      "Jako zarządcy mierzyliśmy się z chaosem informacyjnym. Wprowadzenie Mestio pozwoliło nam uporządkować relacje z podwykonawcami i zamknąć tematy, które ciągnęły się miesiącami. Liczby mówią same za siebie — czas usunięcia awarii spadł o ponad połowę.",
    author: "Anna",
    role: "Licencjonowany zarządca nieruchomości",
  },
];

export default function OnasPage() {
  return (
    <div className="max-w-[1160px] mx-auto px-6 py-[50px] pb-[70px]">
      {/* Hero */}
      <section className="text-center max-w-[720px] mx-auto">
        <h1 className="font-heading font-bold text-[40px] leading-[1.1] tracking-[-1px] text-ink">
          Kim jesteśmy
        </h1>
        <p className="text-[17px] leading-relaxed text-[#4A5A6E] mt-5">
          W Mestio redefiniujemy sposób, w jaki zarządza się współczesnymi
          osiedlami mieszkaniowymi. Nie jesteśmy kolejną firmą administracyjną
          ukrytą za stertami papierów. Tworzymy cyfrowy ekosystem, który
          zdejmuje z barków zarządców rutynowe obowiązki, a mieszkańcom daje to,
          co najważniejsze: poczucie wpływu, spokój i błyskawiczną reakcję na
          każdy problem.
        </p>
        <p className="text-[17px] leading-relaxed text-[#4A5A6E] mt-3">
          Łączymy technologię z realnymi potrzebami społeczności, zamieniając
          codzienne wyzwania w proste, intuicyjne procesy.
        </p>
      </section>

      {/* Misja i Cel */}
      <section className="mt-[50px] grid grid-cols-1 md:grid-cols-2 gap-[18px]">
        <div className="bg-gradient-to-br from-azure to-blueprint rounded-[22px] p-[34px] text-white">
          <div className="font-mono text-[10.5px] tracking-[0.6px] uppercase text-white/70 mb-2">
            Misja
          </div>
          <h2 className="font-heading font-bold text-[22px] tracking-[-0.4px]">
            Eliminujemy chaos
          </h2>
          <p className="text-[15px] text-white/85 leading-relaxed mt-3">
            Naszą misją jest eliminacja chaosu komunikacyjnego i biurokracji z
            życia lokalnych społeczności. Wierzymy, że zarządzanie
            nieruchomościami może być transparentne, płynne i całkowicie
            bezstresowe.
          </p>
        </div>
        <div className="bg-ink rounded-[22px] p-[34px] text-white">
          <div className="font-mono text-[10.5px] tracking-[0.6px] uppercase text-[#7F96B5] mb-2">
            Cel
          </div>
          <h2 className="font-heading font-bold text-[22px] tracking-[-0.4px]">
            Nowoczesne osiedla
          </h2>
          <p className="text-[15px] text-[#C7D2E0] leading-relaxed mt-3">
            Dążymy do tego, aby każde osiedle obsługiwane przez Mestio stało się
            wzorem nowoczesnego i bezpiecznego miejsca do życia. Skracamy czas
            reakcji na usterki do minimum i dostarczamy zarządcom narzędzia do
            działania proaktywnego.
          </p>
        </div>
      </section>

      {/* Jak pomagamy */}
      <section className="mt-[50px]">
        <h2 className="font-heading font-bold text-[28px] tracking-[-0.5px] text-ink text-center">
          Jak pomagamy
        </h2>
        <p className="text-center text-[15px] text-[#4A5A6E] mt-2">
          Wprowadzamy standardy, które realnie zmieniają codzienność osiedli.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-[18px] mt-[26px]">
          {VALUES.map((v) => (
            <div
              key={v.title}
              className="bg-white rounded-[22px] p-6 shadow-[0_2px_14px_rgba(14,26,43,.06)]"
            >
              <div className="w-11 h-11 rounded-[12px] bg-[rgba(62,123,214,.12)] flex items-center justify-center text-azure">
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
                  <path d={v.icon} />
                </svg>
              </div>
              <h3 className="font-heading font-semibold text-[17px] mt-[15px] text-ink">
                {v.title}
              </h3>
              <p className="text-sm text-[#5A6B80] leading-relaxed mt-[7px]">
                {v.desc}
              </p>
            </div>
          ))}
        </div>
      </section>

      {/* Opinie */}
      <section className="mt-[50px]">
        <h2 className="font-heading font-bold text-[28px] tracking-[-0.5px] text-ink text-center">
          Co o nas mówią
        </h2>
        <p className="text-center text-[15px] text-[#4A5A6E] mt-2">
          Oto jak naszą obecność na osiedlach podsumowują ci, którzy korzystają
          z Mestio każdego dnia.
        </p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-[18px] mt-[26px]">
          {TESTIMONIALS.map((t) => (
            <div
              key={t.author}
              className="bg-white rounded-[22px] p-[28px] shadow-[0_2px_14px_rgba(14,26,43,.06)] border border-[#EAF0F7]"
            >
              <svg
                width="28"
                height="28"
                viewBox="0 0 24 24"
                fill="none"
                className="text-azure/30"
              >
                <path
                  d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z"
                  fill="currentColor"
                />
                <path
                  d="M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2h.75c0 2.25.259 2.203-2.5 4.938C15.187 18.062 15 18.688 15 19v2z"
                  fill="currentColor"
                />
              </svg>
              <p className="text-[15px] text-[#3A4759] leading-relaxed mt-3 italic">
                &bdquo;{t.quote}&rdquo;
              </p>
              <div className="mt-4 pt-4 border-t border-[#EEF2F8]">
                <div className="font-heading font-semibold text-[14px] text-ink">
                  {t.author}
                </div>
                <div className="text-[12.5px] text-[#7C8AA0] mt-[2px]">
                  {t.role}
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="mt-[50px] text-center">
        <div className="bg-gradient-to-br from-azure to-blueprint rounded-[24px] p-[44px] shadow-[0_24px_50px_rgba(23,58,106,.28)]">
          <h2 className="font-heading font-bold text-[26px] text-white tracking-[-0.5px]">
            Dołącz do osiedli, które już korzystają z Mestio
          </h2>
          <p className="text-base text-white/80 mt-3">
            Uruchom system dla swojego osiedla w kilka minut.
          </p>
          <Link
            href="/zamow"
            className="inline-block mt-6 text-base font-semibold text-blueprint bg-white px-[30px] py-[15px] rounded-[13px] hover:brightness-95 transition-all"
          >
            Zamów Mestio
          </Link>
          <p className="text-[13.5px] text-white/85 mt-[14px] font-medium">
            Pierwsze 3 miesiące gratis &middot; anuluj kiedy chcesz
          </p>
        </div>
      </section>
    </div>
  );
}

import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Regulamin",
  alternates: { canonical: "https://mestio.pl/regulamin" },
};

const SECTIONS = [
  {
    h: "1. Postanowienia ogólne",
    b: "Regulamin określa zasady korzystania z aplikacji i serwisu Mestio świadczonego przez Mestio.",
  },
  {
    h: "2. Rodzaje kont",
    b: "Konto płatnika (firma/zarząd) oraz konta użytkowników (mieszkaniec, serwis, ochrona) dołączające do osiedla kodem zaproszenia.",
  },
  {
    h: "3. Płatności",
    b: "Opłaty subskrypcyjne wnosi płatnik przez Stripe. Do każdej płatności wystawiamy fakturę VAT. Subskrypcję można anulować w dowolnym momencie.",
  },
  {
    h: "4. Odpowiedzialność",
    b: "Mestio jest narzędziem do obsługi zgłoszeń; nie zastępuje służb ratunkowych. W sytuacjach zagrożenia należy dzwonić pod numery alarmowe.",
  },
  {
    h: "5. Reklamacje",
    b: "Reklamacje przyjmujemy na adres kontakt@mestio.pl i rozpatrujemy w terminie 14 dni.",
  },
];

export default function RegulaminPage() {
  return (
    <div className="max-w-[820px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[30px] tracking-[-0.5px] text-ink">
        Regulamin
      </h1>
      <p className="font-mono text-[11px] text-[#9AA7B8] mt-2">
        Ostatnia aktualizacja: 27 lipca 2026
      </p>

      <div className="flex flex-col gap-[22px] mt-[26px]">
        {SECTIONS.map((section) => (
          <div key={section.h}>
            <h2 className="font-heading font-semibold text-lg text-ink">
              {section.h}
            </h2>
            <p className="text-[14.5px] text-[#4A5A6E] leading-relaxed mt-2">
              {section.b}
            </p>
          </div>
        ))}
      </div>

      <div className="mt-7 bg-[#EAF0F7] rounded-[12px] p-4 text-[13px] text-[#5A6B80] leading-relaxed">
        To szablon informacyjny, nie porada prawna. Przed publikacją uzupełnij
        pola [ ] i skonsultuj treść z prawnikiem / IOD.
      </div>
    </div>
  );
}

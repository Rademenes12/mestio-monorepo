import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Informacja RODO",
  alternates: { canonical: "https://mestio.pl/rodo" },
};

const SECTIONS = [
  {
    h: "Klauzula informacyjna",
    b: "Zgodnie z art. 13 RODO informujemy o zasadach przetwarzania danych osobowych użytkowników Mestio.",
  },
  {
    h: "Administrator i kontakt",
    b: 'Administrator: Mestio, NIP xxx. Kontakt w sprawie danych: rodo@mestio.pl. Inspektor Ochrony Danych: xxx.',
  },
  {
    h: "Zakres i cel",
    b: "Przetwarzamy dane niezbędne do obsługi zgłoszeń usterek i komunikacji na osiedlu. Nie sprzedajemy danych i nie profilujemy użytkowników w celach marketingowych bez zgody.",
  },
  {
    h: "Minimalizacja i bezpieczeństwo",
    b: "Zbieramy tylko dane potrzebne do działania usługi. Zdjęcia pozbawiamy metadanych lokalizacji (EXIF). Dostęp chronią serwerowe reguły izolujące dane każdego osiedla.",
  },
  {
    h: "Prawo do usunięcia",
    b: "Usunięcie konta w aplikacji trwale kasuje dane użytkownika: profil, zgłoszenia, komentarze, załączniki i tokeny powiadomień.",
  },
  {
    h: "Podmioty przetwarzające",
    b: "Supabase, Firebase (Google), Stripe — działający na podstawie umów powierzenia, z serwerami w UE lub z odpowiednimi zabezpieczeniami transferu.",
  },
];

export default function RodoPage() {
  return (
    <div className="max-w-[820px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[30px] tracking-[-0.5px] text-ink">
        Informacja RODO
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

import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Polityka prywatności",
  alternates: { canonical: "https://mestio.pl/polityka" },
};

const SECTIONS = [
  {
    h: "1. Administrator danych",
    b: "Administratorem danych osobowych jest Mestio, NIP xxx, e-mail: kontakt@mestio.pl.",
  },
  {
    h: "2. Jakie dane zbieramy",
    b: "Imię i nazwisko, adres e-mail, numer telefonu, adres lokalu (budynek, klatka, piętro, mieszkanie), treść i zdjęcia zgłoszeń oraz — za zgodą — lokalizację zgłoszenia.",
  },
  {
    h: "3. Cel i podstawa przetwarzania",
    b: "Dane przetwarzamy w celu świadczenia usługi Mestio (obsługa zgłoszeń), na podstawie umowy (art. 6 ust. 1 lit. b RODO) oraz uzasadnionego interesu (lit. f) i zgody tam, gdzie jest wymagana (lit. a).",
  },
  {
    h: "4. Odbiorcy danych",
    b: "Dostawcy infrastruktury: Supabase (baza i uwierzytelnianie), Firebase (powiadomienia), Stripe (płatności). Dane widzą wyłącznie osoby z Twojego osiedla w zakresie swojej roli.",
  },
  {
    h: "5. Okres przechowywania",
    b: "Dane przechowujemy przez czas trwania konta oraz przez okres wymagany przepisami. Zgłoszenia i zdjęcia usuwamy zgodnie z polityką retencji.",
  },
  {
    h: "6. Twoje prawa",
    b: "Masz prawo dostępu, sprostowania, usunięcia, ograniczenia i przenoszenia danych oraz wniesienia sprzeciwu i skargi do PUODO. Konto i dane usuniesz w aplikacji (&bdquo;Usuń konto&rdquo;).",
  },
  {
    h: "7. Pliki cookies",
    b: "Strona używa niezbędnych plików cookies oraz — za zgodą — analitycznych. Zgodę możesz wycofać w ustawieniach przeglądarki.",
  },
];

export default function PolitykaPage() {
  return (
    <div className="max-w-[820px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[30px] tracking-[-0.5px] text-ink">
        Polityka prywatności
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

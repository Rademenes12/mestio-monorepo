import Link from "next/link";

export default function Footer() {
  return (
    <footer className="bg-ink text-white mt-5">
      <div className="max-w-[1160px] mx-auto px-6 py-11 grid grid-cols-[1.4fr_1fr_1fr_1fr] gap-[30px]">
        <div>
          <div className="flex items-center gap-[9px]">
            <div className="w-[30px] h-[30px] rounded-[9px] bg-gradient-to-br from-azure to-blueprint flex items-center justify-center">
              <svg
                width="17"
                height="17"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#fff"
                strokeWidth="2.1"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z" />
              </svg>
            </div>
            <span className="font-heading font-bold text-lg">Mestio</span>
          </div>
          <p className="text-[13px] text-[#9FB2CC] mt-3 leading-relaxed max-w-[260px]">
            Zgłoszenia usterek na osiedlu — od &bdquo;Nowe&rdquo; po
            &bdquo;Zamknięte&rdquo;, pod pełną kontrolą.
          </p>
        </div>

        <nav aria-label="Nawigacja" className="contents">
          <div>
            <h4 className="font-mono text-[10.5px] tracking-[0.6px] uppercase text-[#7F96B5] mb-3">
              Produkt
            </h4>
            <div className="flex flex-col gap-[9px]">
              <Link href="/#funkcje" className="text-[13.5px] text-[#C7D2E0]">
                Funkcje
              </Link>
              <Link href="/#cennik" className="text-[13.5px] text-[#C7D2E0]">
                Cennik
              </Link>
              <Link href="/zamow" className="text-[13.5px] text-[#C7D2E0]">
                Zamów
              </Link>
            </div>
          </div>

          <div>
            <h4 className="font-mono text-[10.5px] tracking-[0.6px] uppercase text-[#7F96B5] mb-3">
              Firma
            </h4>
            <div className="flex flex-col gap-[9px]">
              <Link href="/blog" className="text-[13.5px] text-[#C7D2E0]">
                Blog
              </Link>
              <Link href="/o-nas" className="text-[13.5px] text-[#C7D2E0]">
                O nas
              </Link>
              <Link href="/kontakt" className="text-[13.5px] text-[#C7D2E0]">
                Kontakt
              </Link>
            </div>
          </div>

          <div>
            <h4 className="font-mono text-[10.5px] tracking-[0.6px] uppercase text-[#7F96B5] mb-3">
              Prawne
            </h4>
            <div className="flex flex-col gap-[9px]">
              <Link href="/polityka" className="text-[13.5px] text-[#C7D2E0]">
                Polityka prywatności
              </Link>
              <Link href="/rodo" className="text-[13.5px] text-[#C7D2E0]">
                RODO
              </Link>
              <Link href="/regulamin" className="text-[13.5px] text-[#C7D2E0]">
                Regulamin
              </Link>
            </div>
          </div>
        </nav>
      </div>

      <div className="border-t border-white/10">
        <div className="max-w-[1160px] mx-auto px-6 py-[18px] flex justify-between flex-wrap gap-[10px]">
          <span className="text-xs text-[#7F94B0]">
            &copy; 2026 Mestio &middot; xxxx &middot; NIP xxxx
          </span>
          <span className="font-mono text-xs text-[#7F94B0]">
            Zbudowano dla wspólnot i zarządców nieruchomości
          </span>
        </div>
      </div>
    </footer>
  );
}

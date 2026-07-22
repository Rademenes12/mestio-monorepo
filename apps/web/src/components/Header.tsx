import Link from "next/link";

const NAV_LINKS = [
  { label: "Funkcje", href: "/#funkcje" },
  { label: "Jak to działa", href: "/#jak-to-dziala" },
  { label: "Cennik", href: "/#cennik" },
  { label: "O nas", href: "/o-nas" },
  { label: "Blog", href: "/blog" },
];

export default function Header() {
  return (
    <header className="sticky top-0 z-50 bg-paper/85 backdrop-blur-[10px] border-b border-[#E2E9F2]">
      <div className="max-w-[1160px] mx-auto px-6 py-[14px] flex items-center justify-between gap-5">
        <Link href="/" className="flex items-center gap-[10px]">
          <div className="w-[34px] h-[34px] rounded-[10px] bg-gradient-to-br from-azure to-blueprint flex items-center justify-center">
            <svg
              width="19"
              height="19"
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
          <span className="font-heading font-bold text-xl tracking-[-0.4px] text-ink">
            Mestio
          </span>
        </Link>

        <nav aria-label="Nawigacja główna" className="hidden md:flex items-center gap-[26px]">
          {NAV_LINKS.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className="text-sm font-medium text-[#3A4759] hover:text-ink transition-colors"
            >
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-[10px]">
          <Link href="https://panel.mestio.pl" className="text-sm font-semibold text-blueprint px-[14px] py-[9px] cursor-pointer">
            Zaloguj
          </Link>
          <Link
            href="/zamow"
            className="text-sm font-semibold text-white bg-gradient-to-br from-azure to-blueprint px-[18px] py-[10px] rounded-[11px] shadow-[0_6px_16px_rgba(23,58,106,.25)] hover:brightness-110 transition-all"
          >
            Zamów Mestio
          </Link>
        </div>
      </div>
    </header>
  );
}

"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Menu, X } from "lucide-react";

export interface NavItem {
  label: string;
  href: string;
}

const NAV_ITEMS: NavItem[] = [
  { label: "Funkcje", href: "/#funkcje" },
  { label: "Jak to działa", href: "/#jak-to-dziala" },
  { label: "Cennik", href: "/#cennik" },
  { label: "O nas", href: "/o-nas" },
  { label: "Blog", href: "/blog" },
  { label: "Kontakt", href: "/kontakt" },
];

interface NavbarProps {
  logoHref?: string;
  ctaLabel?: string;
  ctaHref?: string;
}

export function Navbar({
  logoHref = "/",
  ctaLabel = "Zamów Mestio",
  ctaHref = "/zamow",
}: NavbarProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 60);
    };
    handleScroll();
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const isTransparent = !scrolled;

  const navBg = isTransparent
    ? "rgba(10,22,40,0.45)"
    : "rgba(255,255,255,0.92)";
  const navBlur = "blur(16px)";
  const navBorder = isTransparent
    ? "rgba(255,255,255,0.08)"
    : "#E2E9F2";
  const textSecondary = isTransparent ? "rgba(255,255,255,0.85)" : "#3A4759";
  const logoColor = isTransparent ? "#FFF" : "#0E1A2B";
  const loginColor = isTransparent ? "rgba(255,255,255,0.85)" : "#173A6A";
  const mobileBg = isTransparent ? "rgba(10,22,40,0.98)" : "#FFFFFF";

  return (
    <nav
      className="fixed top-0 left-0 right-0 z-50 transition-all duration-500"
      style={{
        background: navBg,
        backdropFilter: navBlur,
        WebkitBackdropFilter: navBlur,
        borderBottom: `1px solid ${navBorder}`,
      }}
    >
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex items-center justify-between h-[60px]">
          {/* Logo */}
          <Link href={logoHref} className="flex items-center gap-2.5">
            <div
              className="w-[34px] h-[34px] rounded-[8px] flex items-center justify-center transition-all duration-500"
              style={{ background: isTransparent ? "rgba(255,255,255,0.15)" : "#3E7BD6" }}
            >
              <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z" />
              </svg>
            </div>
            <span
              className="text-xl font-bold tracking-tight transition-all duration-500"
              style={{ fontFamily: "'Space Grotesk',sans-serif", color: logoColor }}
            >
              Mestio
            </span>
          </Link>

          {/* Desktop Nav - Clean links, NO dropdown, includes Blog & O nas */}
          <div className="hidden md:flex items-center gap-6">
            {NAV_ITEMS.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="text-sm font-medium transition-colors duration-300 hover:opacity-100 opacity-90"
                style={{ color: textSecondary }}
              >
                {item.label}
              </Link>
            ))}
            <Link
              href="/login"
              className="text-sm font-semibold transition-colors duration-300"
              style={{ color: loginColor, padding: "9px 14px" }}
            >
              Zaloguj
            </Link>
            <Link
              href={ctaHref}
              className="text-sm font-semibold text-white px-[18px] py-[10px] rounded-[8px] transition-all duration-300 hover:brightness-110"
              style={{
                background: isTransparent
                  ? "rgba(255,255,255,0.15)"
                  : "#3E7BD6",
                backdropFilter: isTransparent ? "blur(10px)" : undefined,
              }}
            >
              {ctaLabel}
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            aria-label={menuOpen ? "Zamknij menu" : "Otwórz menu"}
            className="md:hidden p-2"
            style={{ color: textSecondary }}
            onClick={() => setMenuOpen(!menuOpen)}
          >
            {menuOpen ? <X /> : <Menu />}
          </button>
        </div>
      </div>

      {/* Mobile Menu - Clean, includes Blog & O nas */}
      {menuOpen && (
        <div
          className="md:hidden border-t animate-slide-down"
          style={{ background: mobileBg, borderColor: isTransparent ? "rgba(255,255,255,0.08)" : "#EAF0F7" }}
        >
          <div className="px-4 py-4 space-y-3">
            {NAV_ITEMS.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setMenuOpen(false)}
                className="block py-2 text-sm font-medium"
                style={{ color: isTransparent ? "#FFF" : "#4A5A6E" }}
              >
                {item.label}
              </Link>
            ))}
            <Link
              href="/login"
              onClick={() => setMenuOpen(false)}
              className="block py-2 text-sm font-semibold"
              style={{ color: isTransparent ? "#FFF" : "#173A6A" }}
            >
              Zaloguj
            </Link>
            <Link
              href={ctaHref}
              onClick={() => setMenuOpen(false)}
              className="block text-center text-sm font-semibold text-white px-[18px] py-[10px] rounded-[8px]"
              style={{ background: "#3E7BD6" }}
            >
              {ctaLabel}
            </Link>
          </div>
        </div>
      )}
    </nav>
  );
}

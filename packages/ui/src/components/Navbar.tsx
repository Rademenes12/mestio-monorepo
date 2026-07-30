"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

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
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="flex items-center justify-between h-[60px] gap-4">
          {/* Logo */}
          <Link href={logoHref} className="flex items-center gap-2.5 shrink-0">
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

          {/* Clean Navigation Row - NO expandable menu, NO dropdowns, NO overlay panel */}
          <div className="flex items-center gap-3 sm:gap-6 overflow-x-auto no-scrollbar py-1">
            {NAV_ITEMS.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="text-xs sm:text-sm font-medium whitespace-nowrap transition-colors duration-300 hover:opacity-100 opacity-90"
                style={{ color: textSecondary }}
              >
                {item.label}
              </Link>
            ))}
          </div>

          {/* Actions */}
          <div className="flex items-center gap-2 sm:gap-3 shrink-0">
            <Link
              href="/login"
              className="text-xs sm:text-sm font-semibold whitespace-nowrap transition-colors duration-300"
              style={{ color: loginColor, padding: "8px 12px" }}
            >
              Zaloguj
            </Link>
            <Link
              href={ctaHref}
              className="text-xs sm:text-sm font-semibold text-white px-3 sm:px-[18px] py-2 sm:py-[10px] rounded-[8px] whitespace-nowrap transition-all duration-300 hover:brightness-110"
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
        </div>
      </div>
    </nav>
  );
}

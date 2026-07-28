"use client"

import { useState } from 'react'
import Link from 'next/link'
import { Menu, X, ChevronDown } from 'lucide-react'

export interface SubmenuItem {
  label: string
  href: string
}

const defaultSubmenuItems: SubmenuItem[] = [
  { label: 'Zarządzanie', href: '#features' },
  { label: 'Płatności', href: '#features' },
  { label: 'Zgłoszenia', href: '#features' },
  { label: 'Raporty', href: '#features' },
]

interface NavbarProps {
  logoHref?: string
  submenuItems?: SubmenuItem[]
  ctaLabel?: string
  ctaHref?: string
}

export function Navbar({
  logoHref = '/',
  submenuItems = defaultSubmenuItems,
  ctaLabel = 'Zamów Mestio',
  ctaHref = '/zamow',
}: NavbarProps) {
  const [menuOpen, setMenuOpen] = useState(false)
  const [dropdownOpen, setDropdownOpen] = useState(false)

  return (
    <nav className="sticky top-0 z-50" style={{ background: "rgba(246,248,251,.85)", backdropFilter: "blur(10px)", WebkitBackdropFilter: "blur(10px)", borderBottom: "1px solid #E2E9F2" }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href={logoHref} className="flex items-center gap-2.5">
            <div className="w-[34px] h-[34px] rounded-[10px] flex items-center justify-center" style={{ background: "linear-gradient(135deg,#3E7BD6,#173A6A)" }}>
              <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
              </svg>
            </div>
            <span className="text-xl font-bold tracking-tight" style={{ fontFamily: "'Space Grotesk',sans-serif", color: "#0E1A2B" }}>Mestio</span>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-6">
            {/* Funkcje with dropdown */}
            <div
              className="relative"
              onMouseEnter={() => setDropdownOpen(true)}
              onMouseLeave={() => setDropdownOpen(false)}
            >
              <button className="flex items-center gap-1 py-2 text-sm font-medium transition" style={{ color: "#3A4759" }}>
                Funkcje <ChevronDown className="w-3.5 h-3.5" />
              </button>
              {dropdownOpen && (
                <div className="absolute top-full left-0 mt-2 w-48 bg-white rounded-xl shadow-elevated border overflow-hidden animate-slide-down" style={{ borderColor: "#EAF0F7" }}>
                  {submenuItems.map((item) => (
                    <Link
                      key={item.label}
                      href={item.href}
                      className="block px-4 py-2.5 transition text-sm" style={{ color: "#4A5A6E" }}
                    >
                      {item.label}
                    </Link>
                  ))}
                </div>
              )}
            </div>

            <Link href="#pricing" className="text-sm font-medium transition" style={{ color: "#3A4759" }}>Cennik</Link>
            <Link href="/kontakt" className="text-sm font-medium transition" style={{ color: "#3A4759" }}>Kontakt</Link>
            <Link href="/login" className="text-sm font-semibold transition" style={{ color: "#173A6A", padding: "9px 14px" }}>Zaloguj</Link>
            <Link href={ctaHref} className="text-sm font-semibold text-white px-[18px] py-[10px] rounded-[11px] transition" style={{ background: "linear-gradient(135deg,#3E7BD6,#173A6A)", boxShadow: "0 6px 16px rgba(23,58,106,.25)" }}>
              {ctaLabel}
            </Link>
          </div>

          {/* Mobile menu button */}
          <button className="md:hidden" style={{ color: "#4A5A6E" }} onClick={() => setMenuOpen(!menuOpen)}>
            {menuOpen ? <X /> : <Menu />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <div className="md:hidden bg-white border-t animate-slide-down" style={{ borderColor: "#EAF0F7" }}>
          <div className="px-4 py-4 space-y-3">
            <Link href="#features" className="block py-2 text-sm" style={{ color: "#4A5A6E" }}>Funkcje</Link>
            <Link href="#pricing" className="block py-2 text-sm" style={{ color: "#4A5A6E" }}>Cennik</Link>
            <Link href="/kontakt" className="block py-2 text-sm" style={{ color: "#4A5A6E" }}>Kontakt</Link>
            <Link href="/login" className="block py-2 text-sm font-semibold" style={{ color: "#173A6A" }}>Zaloguj</Link>
            <Link href={ctaHref} className="block text-center text-sm font-semibold text-white px-[18px] py-[10px] rounded-[11px]" style={{ background: "linear-gradient(135deg,#3E7BD6,#173A6A)" }}>
              {ctaLabel}
            </Link>
          </div>
        </div>
      )}
    </nav>
  )
}

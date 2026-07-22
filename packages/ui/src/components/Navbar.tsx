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
  ctaLabel = 'Wypróbuj za darmo',
  ctaHref = '/register',
}: NavbarProps) {
  const [menuOpen, setMenuOpen] = useState(false)
  const [dropdownOpen, setDropdownOpen] = useState(false)

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 glass" style={{ backdropFilter: "blur(16px)" }}>
      {/* Animated Stars Background (Clip 3) */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {[...Array(20)].map((_, i) => (
          <div
            key={i}
            className="absolute w-[2px] h-[2px] bg-white rounded-full animate-twinkle"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 3}s`,
              animationDuration: `${2 + Math.random() * 3}s`,
              opacity: 0.3 + Math.random() * 0.7
            }}
          />
        ))}
      </div>

      {/* Mountain silhouette at bottom */}
      <div className="absolute bottom-0 left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-[#8864f0]/40 to-transparent" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link href={logoHref} className="flex items-center gap-2">
            <div className="w-8 h-8 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-lg" />
            <span className="text-xl font-bold">Mestio</span>
          </Link>

          {/* Desktop Nav with CSS submenu (Clip 3) */}
          <div className="hidden md:flex items-center gap-8">
            {/* Funkcje with dropdown */}
            <div
              className="relative"
              onMouseEnter={() => setDropdownOpen(true)}
              onMouseLeave={() => setDropdownOpen(false)}
            >
              <button className="flex items-center gap-1 text-white/70 hover:text-white transition py-2">
                Funkcje <ChevronDown className="w-3.5 h-3.5" />
              </button>
              {dropdownOpen && (
                <div className="absolute top-full left-0 mt-2 w-48 glass rounded-xl border border-white/10 overflow-hidden animate-slide-down shadow-2xl">
                  {submenuItems.map((item) => (
                    <Link
                      key={item.label}
                      href={item.href}
                      className="block px-4 py-2.5 text-white/70 hover:text-white hover:bg-white/5 transition text-sm"
                    >
                      {item.label}
                    </Link>
                  ))}
                </div>
              )}
            </div>

            <Link href="#pricing" className="text-white/70 hover:text-white transition">Cennik</Link>
            <Link href="/kontakt" className="text-white/70 hover:text-white transition">Kontakt</Link>
            <Link href="/login" className="px-4 py-2 text-white/80 hover:text-white transition">Zaloguj się</Link>
            <Link href={ctaHref} className="px-4 py-2 bg-[#8864f0] hover:bg-[#7854e0] rounded-lg transition">
              {ctaLabel}
            </Link>
          </div>

          {/* Mobile menu button */}
          <button className="md:hidden" onClick={() => setMenuOpen(!menuOpen)}>
            {menuOpen ? <X /> : <Menu />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <div className="md:hidden glass-strong border-t border-white/10 animate-slide-down">
          <div className="px-4 py-4 space-y-3">
            <Link href="#features" className="block text-white/70 hover:text-white py-2">Funkcje</Link>
            <Link href="#pricing" className="block text-white/70 hover:text-white py-2">Cennik</Link>
            <Link href="/kontakt" className="block text-white/70 hover:text-white py-2">Kontakt</Link>
            <Link href="/login" className="block text-white/80 py-2">Zaloguj się</Link>
            <Link href={ctaHref} className="block px-4 py-2 bg-[#8864f0] rounded-lg text-center">
              {ctaLabel}
            </Link>
          </div>
        </div>
      )}
    </nav>
  )
}

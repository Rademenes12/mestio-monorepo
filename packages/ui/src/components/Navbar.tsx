"use client"

import { useState, useEffect } from 'react'
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
  const [scrolled, setScrolled] = useState(false)

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 60)
    }
    handleScroll()
    window.addEventListener('scroll', handleScroll, { passive: true })
    return () => window.removeEventListener('scroll', handleScroll)
  }, [])

  const isTransparent = !scrolled

  const navBg = isTransparent
    ? 'rgba(10,22,40,0.45)'
    : 'rgba(255,255,255,0.92)'
  const navBlur = 'blur(16px)'
  const navBorder = isTransparent
    ? 'rgba(255,255,255,0.08)'
    : '#E2E9F2'
  const textColor = isTransparent ? 'rgba(255,255,255,0.85)' : '#0E1A2B'
  const textSecondary = isTransparent ? 'rgba(255,255,255,0.6)' : '#3A4759'
  const logoColor = isTransparent ? '#FFF' : '#0E1A2B'
  const loginColor = isTransparent ? 'rgba(255,255,255,0.85)' : '#173A6A'
  const mobileBg = isTransparent ? 'rgba(10,22,40,0.98)' : '#FFFFFF'

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
              style={{ background: isTransparent ? 'rgba(255,255,255,0.15)' : '#3E7BD6' }}
            >
              <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
              </svg>
            </div>
            <span
              className="text-xl font-bold tracking-tight transition-all duration-500"
              style={{ fontFamily: "'Space Grotesk',sans-serif", color: logoColor }}
            >
              Mestio
            </span>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-6">
            <div
              className="relative"
              onMouseEnter={() => setDropdownOpen(true)}
              onMouseLeave={() => setDropdownOpen(false)}
            >
              <button
                className="flex items-center gap-1 py-2 text-sm font-medium transition-colors duration-300"
                style={{ color: textSecondary }}
              >
                Funkcje <ChevronDown className="w-3.5 h-3.5" />
              </button>
              {dropdownOpen && (
                <div className="absolute top-full left-0 mt-2 w-48 rounded-xl shadow-elevated border overflow-hidden animate-slide-down"
                  style={{ background: 'rgba(255,255,255,0.98)', backdropFilter: 'blur(20px)', borderColor: '#EAF0F7' }}>
                  {submenuItems.map((item) => (
                    <Link
                      key={item.label}
                      href={item.href}
                      className="block px-4 py-2.5 transition text-sm"
                      style={{ color: '#4A5A6E' }}
                    >
                      {item.label}
                    </Link>
                  ))}
                </div>
              )}
            </div>

            <Link href="#cennik" className="text-sm font-medium transition-colors duration-300" style={{ color: textSecondary }}>Cennik</Link>
            <Link href="/kontakt" className="text-sm font-medium transition-colors duration-300" style={{ color: textSecondary }}>Kontakt</Link>
            <Link href="/login" className="text-sm font-semibold transition-colors duration-300" style={{ color: loginColor, padding: '9px 14px' }}>Zaloguj</Link>
            <Link
              href={ctaHref}
              className="text-sm font-semibold text-white px-[18px] py-[10px] rounded-[8px] transition-all duration-300 hover:brightness-110"
              style={{
                background: isTransparent
                  ? 'rgba(255,255,255,0.15)'
                  : '#3E7BD6',
                backdropFilter: isTransparent ? 'blur(10px)' : undefined,
              }}
            >
              {ctaLabel}
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            className="md:hidden p-2"
            style={{ color: textSecondary }}
            onClick={() => setMenuOpen(!menuOpen)}
          >
            {menuOpen ? <X /> : <Menu />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {menuOpen && (
        <div
          className="md:hidden border-t animate-slide-down"
          style={{ background: mobileBg, borderColor: isTransparent ? 'rgba(255,255,255,0.08)' : '#EAF0F7' }}
        >
          <div className="px-4 py-4 space-y-3">
            <Link href="#features" className="block py-2 text-sm" style={{ color: isTransparent ? '#FFF' : '#4A5A6E' }}>Funkcje</Link>
            <Link href="#cennik" className="block py-2 text-sm" style={{ color: isTransparent ? '#FFF' : '#4A5A6E' }}>Cennik</Link>
            <Link href="/kontakt" className="block py-2 text-sm" style={{ color: isTransparent ? '#FFF' : '#4A5A6E' }}>Kontakt</Link>
            <Link href="/login" className="block py-2 text-sm font-semibold" style={{ color: isTransparent ? '#FFF' : '#173A6A' }}>Zaloguj</Link>
            <Link href={ctaHref} className="block text-center text-sm font-semibold text-white px-[18px] py-[10px] rounded-[8px]" style={{ background: '#3E7BD6' }}>
              {ctaLabel}
            </Link>
          </div>
        </div>
      )}
    </nav>
  )
}

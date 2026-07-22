"use client"

import { useState } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import {
  LayoutDashboard, Building2, Users, Ticket,
  FileText, Settings, ChevronLeft, ChevronRight,
  Home, CreditCard, BarChart3, Mail
} from 'lucide-react'

export interface NavItem {
  icon: React.ComponentType<{ className?: string }>
  label: string
  href: string
}

const defaultNavItems: NavItem[] = [
  { icon: LayoutDashboard, label: 'Dashboard', href: '/dashboard' },
  { icon: Building2, label: 'Nieruchomości', href: '/nieruchomosci' },
  { icon: Users, label: 'Lokatorzy', href: '/lokatorzy' },
  { icon: Ticket, label: 'Zgłoszenia', href: '/zgloszenia' },
  { icon: CreditCard, label: 'Płatności', href: '/platnosci' },
  { icon: BarChart3, label: 'Raporty', href: '/raporty' },
  { icon: Mail, label: 'Wiadomości', href: '/wiadomosci' },
  { icon: FileText, label: 'Dokumenty', href: '/dokumenty' },
]

interface SidebarProps {
  items?: NavItem[]
  settingsHref?: string
}

export function Sidebar({ items = defaultNavItems, settingsHref = '/ustawienia' }: SidebarProps) {
  const [collapsed, setCollapsed] = useState(false)
  const pathname = usePathname()

  return (
    <aside className={`glass-strong border-r border-white/10 h-screen flex flex-col transition-all duration-300 ${collapsed ? 'w-16' : 'w-64'}`}
      style={{ backdropFilter: "blur(20px)" }}
    >
      {/* Night landscape gradient background (Clip 1) */}
      <div className="absolute inset-0 bg-gradient-to-b from-[#1a1535] via-[#0f0d1f] to-[#080615] pointer-events-none" />

      <div className="relative z-10 flex flex-col h-full">
        {/* Logo */}
        <div className="h-16 flex items-center justify-between px-4 border-b border-white/10">
          {!collapsed && (
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-lg" />
              <span className="text-lg font-bold">Mestio</span>
            </div>
          )}
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="p-1 hover:bg-white/5 rounded transition ml-auto"
          >
            {collapsed ? <ChevronRight className="w-4 h-4" /> : <ChevronLeft className="w-4 h-4" />}
          </button>
        </div>

        {/* Nav Items with animated active indicator (Clip 1) */}
        <nav className="flex-1 py-4 px-2 space-y-1">
          {items.map((item) => {
            const isActive = pathname === item.href
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`relative flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-300 group ${
                  isActive
                    ? 'bg-[#8864f0]/15 text-[#8864f0]'
                    : 'text-white/60 hover:bg-white/5 hover:text-white'
                }`}
              >
                {/* Animated active indicator dot (Clip 1) */}
                {isActive && (
                  <div className="absolute left-0 top-1/2 -translate-y-1/2 w-[3px] h-6 bg-gradient-to-b from-[#8864f0] to-[#4da3ff] rounded-r-full transition-all duration-300" />
                )}
                <item.icon className={`w-5 h-5 flex-shrink-0 transition-colors ${isActive ? 'text-[#8864f0]' : ''}`} />
                {!collapsed && <span className="text-sm truncate">{item.label}</span>}
              </Link>
            )
          })}
        </nav>

        {/* Settings */}
        <div className="p-2 border-t border-white/10">
          <Link
            href={settingsHref}
            className="relative flex items-center gap-3 px-3 py-2 rounded-lg text-white/60 hover:bg-white/5 hover:text-white transition"
          >
            <Settings className="w-5 h-5 flex-shrink-0" />
            {!collapsed && <span className="text-sm">Ustawienia</span>}
          </Link>
        </div>
      </div>
    </aside>
  )
}

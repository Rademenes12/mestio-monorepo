"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { ThemeToggle } from "@mestio/ui";

const NAV_ICONS: Record<string, string> = {
  dashboard: "M4 11.5 12 5l8 6.5M6 10v9h4v-5h4v5h4v-9",
  customers: "M9 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM4 20a5 5 0 0 1 10 0M15.5 5.3a3 3 0 0 1 0 5.4M16 13.6a5 5 0 0 1 4 6.4",
  tasks: "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2M9 5h6",
  pipeline: "M4 5h5v14H4zM10 5h5v9h-5zM16 5h4v6h-4z",
  mail: "M4 6h16v12H4zM4 6l8 7 8-7",
  invoices: "M9 7h6M9 11h6M9 15h4M5 3h14a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z",
  payments: "M12 2l3 7h7l-5.5 4.5L18 21l-6-4.5L6 21l1.5-7.5L2 9h7z",
  kpi: "M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z",
  team: "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
};

const NAV_ITEMS = [
  { label: "Pulpit", href: "/owner/dashboard", key: "dashboard" },
  { label: "Klienci", href: "/owner/customers", key: "customers" },
  { label: "Zadania", href: "/owner/tasks", key: "tasks" },
  { label: "Pipeline", href: "/owner/pipeline", key: "pipeline" },
  { label: "Poczta", href: "/owner/mail", key: "mail" },
  { label: "Faktury", href: "/owner/invoices", key: "invoices" },
  { label: "Płatności", href: "/owner/payments", key: "payments" },
  { label: "KPI", href: "/owner/kpi", key: "kpi" },
  { label: "Zespół", href: "/owner/team", key: "team" },
];

const ADVANCED_ITEMS = [
  { label: "Raporty", href: "/owner/reports", key: "reports", icon: "M4 19h16M7 19V9m5 10V5m5 14v-7" },
  { label: "Dokumenty", href: "/owner/documents", key: "documents", icon: "M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z" },
  { label: "Automatyzacje", href: "/owner/automations", key: "automations", icon: "M13 2 3 14h8l-1 8 10-12h-8z" },
  { label: "AI Asystent", href: "/owner/ai", key: "ai", icon: "M12 3c-1.2 0-2 1-2 2v1a4 4 0 0 0-4 4v1c0 2 1 3 2 4v2a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-2c1-1 2-2 2-4v-1a4 4 0 0 0-4-4V5c0-1-.8-2-2-2z" },
  { label: "Osiedla", href: "/owner/estates", key: "estates", icon: "M4 21V9l8-5 8 5v12M9 21v-6h6v6" },
  { label: "Ranking uchwał", href: "/owner/resolutions-ranking", key: "resolutions-ranking", icon: "M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0V4zM7 6H4a1 1 0 0 0-1 1 4 4 0 0 0 4 4M17 6h3a1 1 0 0 1 1 1 4 4 0 0 1-4 4" },
  { label: "Opinie i pomysły", href: "/owner/feedback", key: "feedback", icon: "M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" },
  { label: "Blog", href: "/owner/blog", key: "blog", icon: "M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z" },
  { label: "Newsletter", href: "/owner/newsletter", key: "newsletter", icon: "M20 4H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zM22 6l-10 7L2 6" },
  { label: "🚀 Automation Hub", href: "/owner/publishing-hub", key: "publishing-hub", icon: null },
  { label: "Ustawienia", href: "/owner/settings", key: "settings", icon: "M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM19.4 13a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-2.9 1.2V21a2 2 0 1 1-4 0v-.1A1.7 1.7 0 0 0 7 19.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0-1.2-2.9H3a2 2 0 1 1 0-4h.1A1.7 1.7 0 0 0 4.7 7l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1A1.7 1.7 0 0 0 9.5 3.8V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 2.9 1.2l.1-.1a2 2 0 1 1 2.8 2.8" },
];

const DIVIDER = { borderTop: "1px solid var(--color-dark-border)" } as const;
const BG = { background: "var(--color-dark-bg)" } as const;

function SidebarIcon({ d }: { d: string }) {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
      strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
      <path d={d} />
    </svg>
  );
}

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const supabase = createClient();

  const advancedActive = ADVANCED_ITEMS.some(
    (item) => pathname === item.href || pathname.startsWith(item.href + "/")
  );
  const [advancedOpen, setAdvancedOpen] = useState(advancedActive);

  useEffect(() => {
    if (advancedActive) setAdvancedOpen(true);
  }, [advancedActive]);

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/");
    router.refresh();
  };

  const isActive = (href: string) =>
    pathname === href || pathname.startsWith(href + "/");

  return (
    <aside className="fixed inset-y-0 left-0 z-50 flex w-[240px] flex-col overflow-hidden" style={BG}>
      {/* Logo */}
      <div className="flex items-center gap-3 px-4 h-16 shrink-0" style={DIVIDER}>
        <div className="w-8 h-8 rounded-[8px] shrink-0 flex items-center justify-center" style={{ background: "#3E7BD6" }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
            <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
          </svg>
        </div>
        <div>
          <div className="font-heading font-bold text-base leading-tight" style={{ color: "var(--color-dark-text)" }}>Mestio</div>
          <div className="mono text-[8px] tracking-[.6px]" style={{ color: "var(--color-dark-text-muted)" }}>ADMIN · CRM</div>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-3 px-3 space-y-0.5">
        {NAV_ITEMS.map((item) => {
          const active = isActive(item.href);
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`sidebar-link ${active ? "active" : ""}`}
            >
              <SidebarIcon d={NAV_ICONS[item.key] || NAV_ICONS.dashboard} />
              <span>{item.label}</span>
            </Link>
          );
        })}

        {/* Advanced toggle */}
        <button
          type="button"
          onClick={() => setAdvancedOpen((v) => !v)}
          className="sidebar-link-muted w-full mt-1"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
            <path d="M12 3l1.9 5.8H20l-4.9 3.6L17 18l-5-3.7L7 18l1.9-5.6L4 8.8h6.1z" />
          </svg>
          <span>Więcej</span>
          <svg
            width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
            className={`ml-auto transition-transform ${advancedOpen ? "rotate-180" : ""}`}
          >
            <path d="M6 9l6 6 6-6" />
          </svg>
        </button>

        {advancedOpen && (
          <div className="flex flex-col gap-0.5 ml-1" style={{ borderLeft: "2px solid rgba(255,255,255,.1)", paddingLeft: "8px" }}>
            {ADVANCED_ITEMS.map((item) => {
              const active = isActive(item.href);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`sidebar-link ${active ? "active" : ""}`}
                >
                  {item.icon ? (
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                      strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" className="shrink-0">
                      <path d={item.icon} />
                    </svg>
                  ) : (
                    <span className="w-4 h-4 shrink-0 flex items-center justify-center text-sm">{item.label.charAt(0)}</span>
                  )}
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </div>
        )}

        {/* Recent section */}
        <div className="mt-6 mb-2" style={{ borderTop: "1px solid rgba(255,255,255,.08)", paddingTop: "12px" }}>
          <div className="px-3 py-1.5">
            <span className="mono text-[9px] font-semibold uppercase tracking-[.6px]" style={{ color: "var(--color-dark-text-muted)" }}>Ostatnie</span>
          </div>
          <div className="flex items-center gap-3 px-3 py-2 rounded-lg text-sm" style={{ color: "var(--color-dark-text-muted)" }}>
            <div className="w-1.5 h-1.5 rounded-full shrink-0" style={{ background: "#3E7BD6" }} />
            <span className="truncate">Brak ostatnich aktywności</span>
          </div>
        </div>
      </nav>

      {/* Footer: Theme toggle + logout + user */}
      <div className="px-3 py-3 shrink-0" style={DIVIDER}>
        <ThemeToggle />
        <div className="mt-1 mb-2" style={{ borderTop: "1px solid rgba(255,255,255,.06)" }} />
        <button
          onClick={handleLogout}
          className="sidebar-link-muted w-full"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
          </svg>
          Wyloguj
        </button>
        <div className="flex items-center gap-2.5 mt-2 pt-2" style={{ borderTop: "1px solid rgba(255,255,255,.06)" }}>
          <div className="w-7 h-7 rounded-full shrink-0 flex items-center justify-center" style={{ background: "#3E7BD6" }}>
            <span className="font-heading font-bold text-[10px] text-white">AV</span>
          </div>
          <div className="min-w-0 flex-1">
            <div className="text-[12px] font-semibold truncate" style={{ color: "var(--color-dark-text)" }}>AIVOLUX</div>
            <div className="text-[10px]" style={{ color: "var(--color-dark-text-muted)" }}>Właściciel platformy</div>
          </div>
        </div>
      </div>
    </aside>
  );
}

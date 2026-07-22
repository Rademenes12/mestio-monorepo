"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

const NAV_ITEMS = [
  {
    label: "Pulpit",
    href: "/dashboard",
    key: "dashboard",
    icon: "M4 11.5 12 5l8 6.5M6 10v9h4v-5h4v5h4v-9",
    badge: null,
  },
  {
    label: "Klienci",
    href: "/customers",
    key: "customers",
    icon: "M9 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM4 20a5 5 0 0 1 10 0M15.5 5.3a3 3 0 0 1 0 5.4M16 13.6a5 5 0 0 1 4 6.4",
    badge: null,
  },
  {
    label: "Zadania",
    href: "/tasks",
    key: "tasks",
    icon: "M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2M9 5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2M9 5h6",
    badge: null,
  },
  {
    label: "Pipeline",
    href: "/pipeline",
    key: "pipeline",
    icon: "M4 5h5v14H4zM10 5h5v9h-5zM16 5h4v6h-4z",
    badge: null,
  },
  {
    label: "Poczta",
    href: "/mail",
    key: "mail",
    icon: "M4 6h16v12H4zM4 6l8 7 8-7",
    badge: null,
  },
  {
    label: "Faktury",
    href: "/invoices",
    key: "invoices",
    icon: "M9 7h6M9 11h6M9 15h4M5 3h14a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z",
    badge: null,
  },
  {
    label: "Płatności",
    href: "/payments",
    key: "payments",
    icon: "M12 2l3 7h7l-5.5 4.5L18 21l-6-4.5L6 21l1.5-7.5L2 9h7z",
    badge: null,
  },
  {
    label: "KPI",
    href: "/kpi",
    key: "kpi",
    icon: "M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z",
    badge: null,
  },
  {
    label: "Zespół",
    href: "/team",
    key: "team",
    icon: "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
    badge: null,
  },
];

const ADVANCED_ITEMS = [
  {
    label: "Raporty",
    href: "/reports",
    key: "reports",
    icon: "M4 19h16M7 19V9m5 10V5m5 14v-7",
  },
  {
    label: "Dokumenty",
    href: "/documents",
    key: "documents",
    icon: "M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z",
  },
  {
    label: "Automatyzacje",
    href: "/automations",
    key: "automations",
    icon: "M13 2 3 14h8l-1 8 10-12h-8z",
  },
  {
    label: "AI Asystent",
    href: "/ai",
    key: "ai",
    icon: "M12 3c-1.2 0-2 1-2 2v1a4 4 0 0 0-4 4v1c0 2 1 3 2 4v2a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-2c1-1 2-2 2-4v-1a4 4 0 0 0-4-4V5c0-1-.8-2-2-2z",
  },
  {
    label: "Osiedla",
    href: "/estates",
    key: "estates",
    icon: "M4 21V9l8-5 8 5v12M9 21v-6h6v6",
  },
  {
    label: "Ranking uchwał",
    href: "/resolutions-ranking",
    key: "resolutions-ranking",
    icon: "M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0V4zM7 6H4a1 1 0 0 0-1 1 4 4 0 0 0 4 4M17 6h3a1 1 0 0 1 1 1 4 4 0 0 1-4 4",
  },
  {
    label: "Opinie i pomysły",
    href: "/feedback",
    key: "feedback",
    icon: "M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z",
  },
  {
    label: "Blog",
    href: "/blog",
    key: "blog",
    icon: "M12 20h9M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z",
  },
   {
     label: "Newsletter",
     href: "/newsletter",
     key: "newsletter",
     icon: "M20 4H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2zM22 6l-10 7L2 6",
   },
   {
     label: "🚀 Automation Hub",
     href: "/publishing-hub",
     key: "publishing-hub",
     icon: "M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z",
   },
   {
     label: "Ustawienia",
     href: "/settings",
     key: "settings",
     icon: "M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM19.4 13a1.7 1.7 0 0 0 .3 1.9l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-2.9 1.2V21a2 2 0 1 1-4 0v-.1A1.7 1.7 0 0 0 7 19.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0-1.2-2.9H3a2 2 0 1 1 0-4h.1A1.7 1.7 0 0 0 4.7 7l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1A1.7 1.7 0 0 0 9.5 3.8V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 2.9 1.2l.1-.1a2 2 0 1 1 2.8 2.8",
   },
];

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

  return (
    <aside className="fixed inset-y-0 left-0 z-50 flex w-[220px] flex-col bg-ink text-white overflow-hidden">
      <div className="flex items-center gap-[9px] px-[14px] pt-[18px] pb-3">
        <div className="w-8 h-8 rounded-[9px] bg-gradient-to-br from-azure to-blueprint flex items-center justify-center shrink-0">
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
            <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
          </svg>
        </div>
        <div>
          <div className="font-[family-name:var(--font-heading)] font-bold text-[17px] text-white leading-tight">Mestio</div>
          <div className="font-[family-name:var(--font-mono)] text-[8px] text-[#7F96B5] tracking-[.6px]">ADMIN · CRM</div>
        </div>
      </div>

      <nav className="flex-1 flex flex-col gap-[3px] mt-5 px-[14px] overflow-y-auto">
        {NAV_ITEMS.map((item) => {
          const isActive =
            pathname === item.href || pathname.startsWith(item.href + "/");
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-[10px] px-[12px] py-[10px] rounded-[10px] text-[13px] font-medium transition-colors ${
                isActive
                  ? "bg-azure/20 text-white"
                  : "text-[#9FB2CC] hover:text-white hover:bg-white/5"
              }`}
            >
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d={item.icon} />
              </svg>
              <span>{item.label}</span>
              {item.badge && (
                <span className="ml-auto bg-amber text-[#3a2a00] font-[family-name:var(--font-mono)] text-[9px] font-semibold px-[6px] py-[1px] rounded-full">
                  {item.badge}
                </span>
              )}
            </Link>
          );
        })}

        <button
          onClick={() => setAdvancedOpen((v) => !v)}
          className="flex items-center gap-[10px] px-[12px] py-[10px] mt-1 rounded-[10px] text-[13px] font-medium text-[#9FB2CC] hover:text-white hover:bg-white/5 transition-colors w-full"
        >
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M12 3l1.9 5.8H20l-4.9 3.6L17 18l-5-3.7L7 18l1.9-5.6L4 8.8h6.1z" />
          </svg>
          <span>Zaawansowane</span>
          <svg
            width="15"
            height="15"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className={`ml-auto transition-transform ${advancedOpen ? "rotate-180" : ""}`}
          >
            <path d="M6 9l6 6 6-6" />
          </svg>
        </button>

        {advancedOpen && (
          <div className="flex flex-col gap-[2px] pl-[10px]">
            {ADVANCED_ITEMS.map((item) => {
              const isActive =
                pathname === item.href || pathname.startsWith(item.href + "/");
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-[10px] px-[12px] py-[9px] rounded-[9px] text-[12.5px] font-medium transition-colors ${
                    isActive
                      ? "bg-azure/20 text-white"
                      : "text-[#8DA0BC] hover:text-white hover:bg-white/5"
                  }`}
                >
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                    <path d={item.icon} />
                  </svg>
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </div>
        )}
      </nav>

      <div className="border-t border-white/[.08] px-[14px] pb-[18px] pt-2">
        <button
          onClick={handleLogout}
          className="flex items-center gap-[10px] px-[12px] py-[10px] rounded-[10px] text-[13px] font-medium text-[#9FB2CC] hover:text-white hover:bg-white/5 transition-colors w-full"
        >
          <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
          </svg>
          Wyloguj
        </button>

        <div className="flex items-center gap-[9px] mt-2 pt-3 border-t border-white/[.08]">
          <div className="w-[30px] h-[30px] rounded-full bg-gradient-to-br from-amber to-[#C98800] flex items-center justify-center shrink-0">
            <span className="font-[family-name:var(--font-heading)] font-bold text-[11px] text-white">AV</span>
          </div>
          <div className="min-w-0 flex-1">
            <div className="text-[11.5px] font-semibold text-white truncate">AIVOLUX</div>
            <div className="font-[family-name:var(--font-mono)] text-[8.5px] text-[#7F96B5]">Właściciel platformy</div>
          </div>
        </div>
      </div>
    </aside>
  );
}

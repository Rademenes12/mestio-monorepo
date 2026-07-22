"use client";

import { usePathname, useRouter } from "next/navigation";
import Sidebar from "@/components/Sidebar";

const PAGE_TITLES: Record<string, string> = {
  "/dashboard": "Pulpit",
  "/customers": "Klienci",
  "/tasks": "Zadania",
  "/pipeline": "Pipeline sprzedaży",
  "/kpi": "KPI Dashboard",
  "/team": "Zespół",
  "/mail": "Poczta",
  "/invoices": "Faktury",
  "/payments": "Płatności",
  "/reports": "Raporty",
  "/automations": "Automatyzacje",
  "/ai": "AI Asystent",
  "/estates": "Osiedla",
  "/documents": "Dokumenty i wzory",
  "/feedback": "Opinie i pomysły",
  "/blog": "Blog",
  "/newsletter": "Newsletter",
  "/publishing-hub": "🚀 Automation Hub",
  "/resolutions-ranking": "Ranking uchwał",
  "/settings": "Ustawienia",
};

const ADD_LABELS: Record<string, string> = {
  "/customers": "Nowy klient",
  "/pipeline": "Nowy lead",
  "/blog": "Nowy artykuł",
  "/feedback": "Dodaj pomysł",
};

const ADD_LINKS: Record<string, string> = {
  "/customers": "/customers/new",
  "/pipeline": "/customers/new",
  "/blog": "/blog?new=1",
  "/feedback": "/feedback?new=1",
};

function getPageTitle(pathname: string): string {
  const exact = PAGE_TITLES[pathname];
  if (exact) return exact;
  for (const [key, title] of Object.entries(PAGE_TITLES)) {
    if (pathname.startsWith(key + "/")) return title;
  }
  return "Mestio CRM";
}

function getAddLabel(pathname: string): string | null {
  return ADD_LABELS[pathname] ?? null;
}

function getAddLink(pathname: string): string | null {
  return ADD_LINKS[pathname] ?? null;
}

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const pageTitle = getPageTitle(pathname);
  const addLabel = getAddLabel(pathname);
  const addLink = getAddLink(pathname);
  const isDashboard = pathname === "/dashboard";

  return (
    <div className="flex min-h-screen bg-[#F6F8FB]">
      <Sidebar />

      <div className="flex-1 ml-[220px] flex flex-col min-w-0">
        <header className="h-[60px] shrink-0 bg-white shadow-[0_1px_4px_rgba(14,26,43,.06)] flex items-center justify-between px-6 z-10">
          <div className="flex items-center gap-3">
            {!isDashboard && (
              <button
                onClick={() => router.back()}
                className="flex items-center justify-center w-8 h-8 rounded-lg hover:bg-[#F4F7FB] text-ink/40 hover:text-ink transition-colors"
                title="Powrót"
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
              </button>
            )}
            <h1 className="font-[family-name:var(--font-heading)] font-bold text-[19px] tracking-[-.3px] text-ink">
              {pageTitle}
            </h1>
          </div>
          <div className="flex items-center gap-[10px]">
            <div className="flex items-center gap-[7px] bg-[#F4F7FB] rounded-[10px] px-3 py-2 w-[220px]">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#9AA7B8" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="7" />
                <path d="M21 21l-4-4" />
              </svg>
              <input
                placeholder="Szukaj…"
                className="flex-1 text-[12.5px] text-ink bg-transparent border-none outline-none placeholder-[#9AA7B8]"
              />
            </div>
            {addLabel && (
              <a
                href={addLink ?? "#"}
                className="flex items-center gap-[5px] bg-gradient-to-br from-azure to-blueprint text-white text-[12.5px] font-semibold px-[14px] py-2 rounded-[10px] hover:opacity-90 transition-opacity"
              >
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.6" strokeLinecap="round">
                  <path d="M12 6v12M6 12h12" />
                </svg>
                {addLabel}
              </a>
            )}
          </div>
        </header>

        <main className="flex-1 overflow-y-auto p-5 px-6">{children}</main>
      </div>
    </div>
  );
}

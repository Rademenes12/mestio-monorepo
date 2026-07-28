"use client";

import { usePathname, useRouter } from "next/navigation";
import Sidebar from "@/components/Sidebar";

const PAGE_TITLES: Record<string, string> = {
  "/owner/dashboard": "Pulpit",
  "/owner/customers": "Klienci",
  "/owner/tasks": "Zadania",
  "/owner/pipeline": "Pipeline sprzedaży",
  "/owner/kpi": "KPI Dashboard",
  "/owner/team": "Zespół",
  "/owner/mail": "Poczta",
  "/owner/invoices": "Faktury",
  "/owner/payments": "Płatności",
  "/owner/reports": "Raporty",
  "/owner/automations": "Automatyzacje",
  "/owner/ai": "AI Asystent",
  "/owner/estates": "Osiedla",
  "/owner/documents": "Dokumenty i wzory",
  "/owner/feedback": "Opinie i pomysły",
  "/owner/blog": "Blog",
  "/owner/newsletter": "Newsletter",
  "/owner/publishing-hub": "🚀 Automation Hub",
  "/owner/resolutions-ranking": "Ranking uchwał",
  "/owner/settings": "Ustawienia",
};

const ADD_LABELS: Record<string, string> = {
  "/owner/customers": "Nowy klient",
  "/owner/pipeline": "Nowy lead",
  "/owner/blog": "Nowy artykuł",
  "/owner/feedback": "Dodaj pomysł",
};

const ADD_LINKS: Record<string, string> = {
  "/owner/customers": "/customers/new",
  "/owner/pipeline": "/customers/new",
  "/owner/blog": "/blog?new=1",
  "/owner/feedback": "/feedback?new=1",
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
  const isDashboard = pathname === "/owner/dashboard";

  return (
    <div className="flex min-h-screen" style={{ background: "var(--color-page)" }}>
      <Sidebar />

      <div className="flex-1 ml-[240px] flex flex-col min-w-0">
        <header className="h-[60px] shrink-0 border-b flex items-center justify-between px-6 z-10 transition-colors duration-300" style={{ background: "var(--color-card)", borderColor: "var(--color-glass-border)" }}>
          <div className="flex items-center gap-3">
            {!isDashboard && (
              <button
                onClick={() => router.back()}
                className="flex items-center justify-center w-8 h-8 rounded-lg hover:bg-[#F1F3F6] text-[#94A3B8] hover:text-[#1A1A2E] transition-colors"
                title="Powrót"
              >
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M19 12H5M12 19l-7-7 7-7" />
                </svg>
              </button>
            )}
            <h1 className="font-heading font-bold text-[19px] tracking-[-.3px] text-[#1A1A2E]">
              {pageTitle}
            </h1>
          </div>
          <div className="flex items-center gap-[10px]">
            <div className="flex items-center gap-[7px] bg-[#F1F3F6] rounded-[10px] px-3 py-2 w-[220px]">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="11" cy="11" r="7" />
                <path d="M21 21l-4-4" />
              </svg>
              <input
                placeholder="Szukaj…"
                className="flex-1 text-[12.5px] text-[#1A1A2E] bg-transparent border-none outline-none placeholder-[#94A3B8]"
              />
            </div>
            {addLabel && (
              <a
                href={addLink ?? "#"}
                className="flex items-center gap-[5px] bg-blue-600 text-white text-[12.5px] font-semibold px-[14px] py-2 rounded-[10px] hover:bg-blue-700 transition-colors"
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

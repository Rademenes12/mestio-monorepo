"use client";

import { usePathname, useRouter } from "next/navigation";

const BREADCRUMB_LABELS: Record<string, string> = {
  "/dashboard": "Pulpit",
  "/tasks": "Zadania",
  "/pipeline": "Pipeline",
  "/pipeline/matrix": "Macierz",
  "/kpi": "KPI",
  "/team": "Zespół",
  "/customers": "Klienci",
  "/owner/customers/new": "Nowy klient",
  "/mail": "Poczta",
  "/invoices": "Faktury",
  "/payments": "Płatności",
  "/reports": "Raporty",
  "/automations": "Automatyzacje",
  "/ai": "AI Asystent",
  "/estates": "Osiedla",
  "/documents": "Dokumenty",
  "/feedback": "Opinie",
  "/blog": "Blog",
  "/resolutions-ranking": "Ranking uchwał",
  "/newsletter": "Newsletter",
  "/settings": "Ustawienia",
};

function getBreadcrumbs(pathname: string): { label: string; href: string }[] {
  const parts = pathname.split("/").filter(Boolean);
  const crumbs: { label: string; href: string }[] = [];
  let current = "";

  for (const part of parts) {
    current += "/" + part;
    const label = BREADCRUMB_LABELS[current] || part;
    crumbs.push({ label, href: current });
  }

  // Always start with Pulpit
  if (crumbs.length > 0 && crumbs[0].href !== "/dashboard") {
    crumbs.unshift({ label: "Pulpit", href: "/dashboard" });
  }

  return crumbs;
}

export default function Breadcrumb() {
  const pathname = usePathname();
  const router = useRouter();
  const crumbs = getBreadcrumbs(pathname);

  if (crumbs.length <= 1 && crumbs[0]?.href === "/dashboard") return null;

  return (
    <nav className="flex items-center gap-1.5 text-[12px] mb-4" aria-label="Breadcrumb">
      <button
        onClick={() => router.back()}
        className="flex items-center gap-1 text-[#8A98AB] hover:text-ink transition-colors mr-2"
        title="Wstecz"
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M19 12H5M12 19l-7-7 7-7" />
        </svg>
      </button>
      {crumbs.map((crumb, i) => (
        <span key={crumb.href} className="flex items-center gap-1.5">
          {i > 0 && <span className="text-[#CBD5E1]">/</span>}
          {i === crumbs.length - 1 ? (
            <span className="text-ink font-medium">{crumb.label}</span>
          ) : (
            <button
              onClick={() => router.push(crumb.href)}
              className="text-[#8A98AB] hover:text-ink transition-colors"
            >
              {crumb.label}
            </button>
          )}
        </span>
      ))}
    </nav>
  );
}

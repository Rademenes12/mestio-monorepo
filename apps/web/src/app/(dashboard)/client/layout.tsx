import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { EstateSwitcher } from "./estate-switcher";
import { SidebarNav, type NavItem } from "./sidebar-nav";
import { ThemeToggle } from "@mestio/ui";

import {
  LayoutDashboard,
  ClipboardList,
  Users,
  Phone,
  CheckSquare,
  Megaphone,
  Scale,
  Building2,
  FileText,
  Settings,
} from "lucide-react";

const NAV_ITEMS: Omit<NavItem, "badge">[] = [
  { href: "/client/", label: "Pulpit", icon: LayoutDashboard },
  { href: "/client/reports", label: "Tablica spraw", icon: ClipboardList },
  { href: "/client/contacts", label: "Kontakty", icon: Users },
  { href: "/client/phones", label: "Telefony", icon: Phone },
  { href: "/client/tasks", label: "Zadania", icon: CheckSquare },
  { href: "/client/announcements", label: "Komunikaty", icon: Megaphone },
  { href: "/client/resolutions", label: "Uchwały", icon: Scale },
  { href: "/client/estate", label: "Osiedle", icon: Building2 },
  { href: "/client/invoices", label: "Faktury", icon: FileText },
  { href: "/client/settings", label: "Ustawienia", icon: Settings },
];

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: memberships } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id, role")
    .eq("user_id", user.id);

  const adminMemberships = (memberships ?? []).filter(
    (m) => m.role === "admin" || m.role === "board" || m.role === "manager"
  );

  if (adminMemberships.length === 0) {
    redirect("/login?error=role");
  }

  const estateIds = adminMemberships.map((m) => m.estate_id);

  const { data: estates } = await supabase
    .from("fixflow_estates")
    .select("id, name")
    .in("id", estateIds)
    .eq("status", "active");

  const cookieStore = await cookies();
  const activeEstateId =
    cookieStore.get("active_estate_id")?.value ?? estates?.[0]?.id ?? null;

  let newReportsBadge = 0;
  let openTasksBadge = 0;
  if (activeEstateId) {
    const { count: newReportsCount } = await supabase
      .from("fixflow_reports")
      .select("*", { count: "exact", head: true })
      .eq("estate_id", activeEstateId)
      .eq("status", "Nowe");
    newReportsBadge = newReportsCount ?? 0;

    const { count: openTasksCount } = await supabase
      .from("fixflow_tasks")
      .select("*", { count: "exact", head: true })
      .eq("estate_id", activeEstateId)
      .neq("status", "Zrobione");
    openTasksBadge = openTasksCount ?? 0;
  }

  const navItems: NavItem[] = NAV_ITEMS.map((item) => ({
    ...item,
    badge:
      item.href === "/reports"
        ? newReportsBadge
        : item.href === "/tasks"
          ? openTasksBadge
          : undefined,
  }));

  const userInitials = user.email?.slice(0, 2).toUpperCase() ?? "UZ";

  return (
    <div className="flex min-h-screen" style={{ background: "var(--color-page)" }}>
      {/* ── Sidebar ── */}
      <aside
        className="fixed inset-y-0 left-0 z-50 flex w-[240px] flex-col overflow-hidden transition-colors duration-300"
        style={{ background: "var(--color-dark-bg)" }}
      >
        {/* Logo */}
        <div className="flex items-center gap-3 px-4 h-16 shrink-0" style={{ borderBottom: "1px solid var(--color-dark-border)" }}>
          <div className="w-8 h-8 rounded-[8px] shrink-0 flex items-center justify-center" style={{ background: "#3E7BD6" }}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
              <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
            </svg>
          </div>
          <div>
            <div className="font-heading font-bold text-base leading-tight" style={{ color: "var(--color-dark-text)" }}>Mestio</div>
            <div style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "9px", color: "var(--color-dark-text-muted)", letterSpacing: ".5px" }}>PANEL ZARZĄDU</div>
          </div>
        </div>

        {/* Estate switcher */}
        <div className="px-3 mt-3 mb-1">
          <EstateSwitcher
            estates={
              (estates ?? []).map((e) => ({ id: e.id, name: e.name })) as {
                id: string;
                name: string;
              }[]
            }
            activeId={activeEstateId}
          />
        </div>

        {/* Navigation */}
        <SidebarNav items={navItems} />

        {/* Theme toggle + user footer */}
        <div className="px-3 py-3 shrink-0" style={{ borderTop: "1px solid var(--color-dark-border)" }}>
          <ThemeToggle />
          <div className="my-2" style={{ borderTop: "1px solid rgba(255,255,255,.06)" }} />
          <div className="flex items-center gap-2.5">
            <div className="w-7 h-7 rounded-full shrink-0 flex items-center justify-center" style={{ background: "#3E7BD6" }}>
              <span className="font-heading font-bold text-[10px] text-white">{userInitials}</span>
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-[12px] font-semibold truncate" style={{ color: "var(--color-dark-text)" }}>{user.email?.split("@")[0] ?? "Użytkownik"}</div>
              <div style={{ fontSize: "10px", color: "var(--color-dark-text-muted)" }}>Zarząd osiedla</div>
            </div>
          </div>
        </div>
      </aside>

      {/* ── Main content ── */}
      <div className="flex-1 ml-[240px] flex flex-col min-w-0">
        <main className="flex-1 overflow-y-auto p-6">{children}</main>
      </div>
    </div>
  );
}

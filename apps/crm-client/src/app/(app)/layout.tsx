import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { EstateSwitcher } from "./estate-switcher";
import { SidebarNav, type NavItem } from "./sidebar-nav";

const NAV_ITEMS: Omit<NavItem, "badge">[] = [
  { href: "/", label: "Pulpit", icon: "◉" },
  { href: "/reports", label: "Tablica spraw", icon: "☰" },
  { href: "/contacts", label: "Kontakty", icon: "👤" },
  { href: "/phones", label: "Telefony", icon: "☎" },
  { href: "/tasks", label: "Zadania", icon: "✓" },
  { href: "/announcements", label: "Komunikaty", icon: "✉" },
  { href: "/resolutions", label: "Uchwały", icon: "⚖" },
  { href: "/estate", label: "Osiedle", icon: "⌂" },
  { href: "/invoices", label: "Faktury", icon: "📄" },
  { href: "/settings", label: "Ustawienia", icon: "⚙" },
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
    (m) => m.role === "admin" || m.role === "board"
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

  return (
    <div className="min-h-screen flex">
      <aside className="w-64 bg-ink text-white flex flex-col fixed inset-y-0 left-0 z-30">
        <div className="p-6">
          <h1 className="text-xl font-heading font-bold tracking-tight">
            Mestio
          </h1>
          <p className="text-xs text-white/50 mt-1">Panel Zarządu</p>
        </div>

        <SidebarNav items={navItems} />

        <div className="p-4 border-t border-white/10">
          <div className="text-xs text-white/40 truncate">{user.email}</div>
          <form action="/auth/signout" method="post" className="mt-2">
            <button className="text-[13px] text-white/60 hover:text-white transition-colors min-h-[36px] -ml-1 px-1">
              Wyloguj się
            </button>
          </form>
        </div>
      </aside>

      <div className="flex-1 ml-64">
        <header className="sticky top-0 z-20 bg-paper/80 backdrop-blur-sm border-b border-ink/5">
          <div className="flex items-center justify-between px-8 py-3">
            <div>
              <h2 className="text-sm font-medium text-ink/50">
                Aktywne osiedle
              </h2>
              <EstateSwitcher
                estates={estates ?? []}
                activeId={activeEstateId}
              />
            </div>
            <div className="flex items-center gap-3">
              <div className="h-9 w-9 rounded-full bg-azure flex items-center justify-center text-white text-sm font-semibold">
                {user.email?.[0].toUpperCase()}
              </div>
            </div>
          </div>
        </header>

        <main className="p-8">{children}</main>
      </div>
    </div>
  );
}

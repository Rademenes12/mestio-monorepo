import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import Link from "next/link";
import { ThemeToggle } from "@mestio/ui";
import { LogoutButton } from "@/components/LogoutButton";
import {
  LayoutDashboard,
  ClipboardList,
  Phone,
  Scale,
  Bell,
  type LucideIcon,
} from "lucide-react";

const NAV_ITEMS: { href: string; label: string; icon: LucideIcon }[] = [
  { href: "/resident/", label: "Pulpit", icon: LayoutDashboard },
  { href: "/resident/reports", label: "Zgłoszenia", icon: ClipboardList },
  { href: "/resident/resolutions", label: "Głosowania", icon: Scale },
  { href: "/resident/phones", label: "Numery alarmowe", icon: Phone },
  { href: "/resident/notifications", label: "Powiadomienia", icon: Bell },
];

export default async function ResidentLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createClient();
  const cookieStore = await cookies();
  const demoRole = cookieStore.get("mestio_demo_role")?.value;

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user && !demoRole) redirect("/login?redirect=/resident/");

  let profileName: string | null = null;
  if (user) {
    const { data: profile } = await supabase
      .from("fixflow_resident_profiles")
      .select("role, name")
      .eq("user_id", user.id)
      .maybeSingle();
    profileName = profile?.name ?? null;
  }

  const userInitials = profileName?.slice(0, 2).toUpperCase() ?? user?.email?.slice(0, 2).toUpperCase() ?? "MK";

  return (
    <div className="flex min-h-screen" style={{ background: "var(--color-page)" }}>
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
            <div style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "9px", color: "var(--color-dark-text-muted)", letterSpacing: ".5px" }}>PANEL MIESZKAŃCA</div>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 px-3 py-4 space-y-1">
          {NAV_ITEMS.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors"
              style={{ color: "var(--color-dark-text)" }}
            >
              <item.icon className="w-[17px] h-[17px] shrink-0" />
              <span>{item.label}</span>
            </Link>
          ))}
        </nav>

        {/* Theme toggle + logout + user */}
        <div className="px-3 py-3 shrink-0 space-y-2" style={{ borderTop: "1px solid var(--color-dark-border)" }}>
          <ThemeToggle />
          <LogoutButton />
          <div className="flex items-center gap-2.5 pt-2" style={{ borderTop: "1px solid rgba(255,255,255,.06)" }}>
            <div className="w-7 h-7 rounded-full shrink-0 flex items-center justify-center" style={{ background: "#3E7BD6" }}>
              <span className="font-heading font-bold text-[10px] text-white">{userInitials}</span>
            </div>
            <div className="min-w-0 flex-1">
              <div className="text-[12px] font-semibold truncate" style={{ color: "var(--color-dark-text)" }}>{profileName ?? "Mieszkaniec"}</div>
            </div>
          </div>
        </div>
      </aside>

      <div className="flex-1 ml-[240px] flex flex-col min-w-0">
        <main className="flex-1 overflow-y-auto p-6">{children}</main>
      </div>
    </div>
  );
}

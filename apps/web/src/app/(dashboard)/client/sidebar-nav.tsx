"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
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
  type LucideIcon,
} from "lucide-react";

export type NavItem = {
  href: string;
  label: string;
  iconName: string;
  badge?: number;
};

const ICON_MAP: Record<string, LucideIcon> = {
  dashboard: LayoutDashboard,
  reports: ClipboardList,
  contacts: Users,
  phones: Phone,
  tasks: CheckSquare,
  announcements: Megaphone,
  resolutions: Scale,
  estate: Building2,
  invoices: FileText,
  settings: Settings,
};

export function SidebarNav({ items }: { items: NavItem[] }) {
  const pathname = usePathname();

  return (
    <nav className="flex-1 px-3 py-2 space-y-0.5">
      {items.map((item) => {
        const active =
          item.href === "/client/"
            ? pathname === "/client/" || pathname === "/client"
            : pathname === item.href || pathname.startsWith(item.href + "/");

        const Icon = ICON_MAP[item.iconName] || LayoutDashboard;

        return (
          <Link
            key={item.href}
            href={item.href}
            className={`sidebar-link ${active ? "active" : ""}`}
          >
            <Icon className="w-[18px] h-[18px] shrink-0" />
            <span className="truncate">{item.label}</span>
            {!!item.badge && item.badge > 0 && (
              <span className="ml-auto text-[11px] font-semibold px-2 py-0.5 rounded-full" style={{ background: "rgba(242,169,0,.16)", color: "#F2A900" }}>
                {item.badge > 99 ? "99+" : item.badge}
              </span>
            )}
          </Link>
        );
      })}
    </nav>
  );
}

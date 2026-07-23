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
import { colors } from "@mestio/design-tokens";

export type NavItem = {
  href: string;
  label: string;
  icon: LucideIcon;
  badge?: number;
};

export function SidebarNav({ items }: { items: NavItem[] }) {
  const pathname = usePathname();

  return (
    <nav className="flex-1 px-3 py-2 space-y-0.5">
      {items.map((item) => {
        const active =
          item.href === "/"
            ? pathname === "/"
            : pathname === item.href || pathname.startsWith(item.href + "/");

        const Icon = item.icon;

        return (
          <Link
            key={item.href}
            href={item.href}
            className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all duration-150 min-h-[44px] ${
              active
                ? "text-white"
                : "text-white/60 hover:text-white hover:bg-white/5"
            }`}
            style={{
              background: active
                ? `${colors.accent}22`
                : "transparent",
            }}
          >
            <Icon
              className="w-4.5 h-4.5 shrink-0"
              style={{
                color: active ? colors.accent : undefined,
              }}
            />
            <span className="truncate">{item.label}</span>
            {!!item.badge && item.badge > 0 && (
              <span
                className="ml-auto text-[11px] font-semibold px-2 py-0.5 rounded-full"
                style={{
                  background: `${colors.warning}20`,
                  color: colors.warning,
                }}
              >
                {item.badge > 99 ? "99+" : item.badge}
              </span>
            )}
          </Link>
        );
      })}
    </nav>
  );
}

// Icon map for external use
export const NAV_ICONS: Record<string, LucideIcon> = {
  "/": LayoutDashboard,
  "/reports": ClipboardList,
  "/contacts": Users,
  "/phones": Phone,
  "/tasks": CheckSquare,
  "/announcements": Megaphone,
  "/resolutions": Scale,
  "/estate": Building2,
  "/invoices": FileText,
  "/settings": Settings,
};

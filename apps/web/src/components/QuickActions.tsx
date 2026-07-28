"use client";

import { useRouter } from "next/navigation";

interface QuickAction {
  label: string;
  icon: string;
  href: string;
  color: string;
  shortcut?: string;
}

const ACTIONS: QuickAction[] = [
  {
    label: "Nowy klient",
    icon: "M18 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0ZM3 19.235v-.11a6.375 6.375 0 0 1 12.75 0v.109A12.318 12.318 0 0 1 9.374 21c-2.331 0-4.512-.645-6.374-1.766Z",
    href: "/customers/new",
    color: "#3E7BD6",
    shortcut: "Ctrl+N",
  },
  {
    label: "Nowy lead",
    icon: "M12 4.5v15m7.5-7.5h-15",
    href: "/customers/new",
    color: "#2E9E6B",
    shortcut: "Ctrl+L",
  },
  {
    label: "Nowa faktura",
    icon: "M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v6m3-3H9m1.5-12H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z",
    href: "/invoices",
    color: "#8B5CF6",
    shortcut: "Ctrl+I",
  },
  {
    label: "Nowe zadanie",
    icon: "M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z",
    href: "/tasks",
    color: "#F2A900",
    shortcut: "Ctrl+T",
  },
  {
    label: "Raport",
    icon: "M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z",
    href: "/reports",
    color: "#173A6A",
  },
];

export default function QuickActions() {
  const router = useRouter();

  return (
    <div className="flex gap-2.5 flex-wrap">
      {ACTIONS.map((action) => (
        <button
          key={action.label}
          onClick={() => router.push(action.href)}
          className="group flex items-center gap-2 px-3.5 py-2.5 rounded-[10px] text-[12.5px] font-medium 
                     bg-white border border-[#E9EFF6] text-ink/70
                     hover:border-current hover:text-opacity-100 hover:shadow-sm
                     active:scale-[0.98] transition-all duration-150"
          style={{ color: action.color, borderColor: "transparent" }}
          title={action.shortcut}
        >
          <svg
            width="15"
            height="15"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="shrink-0"
          >
            <path d={action.icon} />
          </svg>
          <span>{action.label}</span>
          {action.shortcut && (
            <kbd className="hidden group-hover:inline-flex ml-auto text-[10px] px-1.5 py-0.5 rounded bg-[#F4F7FB] text-ink/40 font-mono">
              {action.shortcut}
            </kbd>
          )}
        </button>
      ))}
    </div>
  );
}

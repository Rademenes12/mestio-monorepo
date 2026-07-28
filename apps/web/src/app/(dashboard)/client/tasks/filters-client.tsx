"use client";

import Link from "next/link";

const FILTERS = [
  { key: "all", label: "Wszystkie" },
  { key: "open", label: "Otwarte" },
  { key: "today", label: "Dziś" },
  { key: "week", label: "Ten tydzień" },
  { key: "overdue", label: "Przeterminowane" },
  { key: "done", label: "Zrobione" },
];

export function TaskFilters({
  activeFilter,
  counts,
}: {
  activeFilter: string;
  counts: {
    all: number;
    open: number;
    today: number;
    week: number;
    overdue: number;
    done: number;
  };
}) {
  return (
    <div className="flex gap-2 flex-wrap">
      {FILTERS.map((f) => {
        const active = activeFilter === f.key;
        const danger = f.key === "overdue";
        const count = counts[f.key as keyof typeof counts] ?? 0;

        return (
          <Link
            key={f.key}
            href={f.key === "all" ? "/tasks" : `/tasks?filter=${f.key}`}
            className={`px-4 py-2.5 rounded-xl text-[13.5px] font-semibold transition-all min-h-[42px] flex items-center ${
              active
                ? danger
                  ? "bg-danger text-white"
                  : "bg-[#173A6A] text-white"
                : danger
                  ? "bg-white text-danger shadow-[0_1px_4px_rgba(14,26,43,.04)]"
                  : "bg-white text-ink/60 hover:bg-azure/5 shadow-[0_1px_4px_rgba(14,26,43,.04)]"
            }`}
          >
            {f.label}
            {count > 0 && (
              <span
                className={`ml-1.5 text-[12.5px] font-medium ${
                  active ? "text-white/70" : "text-ink/35"
                }`}
              >
                {count}
              </span>
            )}
          </Link>
        );
      })}
    </div>
  );
}

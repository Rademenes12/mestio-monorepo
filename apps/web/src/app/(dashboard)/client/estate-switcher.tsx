"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

export function EstateSwitcher({
  estates,
  activeId,
}: {
  estates: { id: string; name: string }[];
  activeId: string | null;
}) {
  const router = useRouter();
  const [selected, setSelected] = useState(activeId ?? "");

  if (estates.length <= 1) return null;

  return (
    <select
      value={selected}
      onChange={async (e) => {
        const id = e.target.value;
        setSelected(id);
        await fetch("/api/set-estate", {
          method: "POST",
          body: JSON.stringify({ estateId: id }),
          headers: { "Content-Type": "application/json" },
        });
        router.refresh();
      }}
      className="text-sm bg-transparent border border-white/20 rounded-lg px-3 py-2 text-white focus:outline-none focus:ring-2 focus:ring-azure/40 focus:border-azure cursor-pointer min-h-[36px]"
    >
      {estates.map((est) => (
        <option key={est.id} value={est.id} className="text-ink">
          {est.name}
        </option>
      ))}
    </select>
  );
}

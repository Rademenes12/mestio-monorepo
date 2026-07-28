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
      className="text-sm rounded-lg px-3 py-2 focus:outline-none focus:ring-2 cursor-pointer min-h-[36px] w-full"
      style={{
        background: "rgba(255,255,255,.08)",
        border: "1px solid rgba(255,255,255,.12)",
        color: "#D5DEEC",
      }}
    >
      {estates.map((est) => (
        <option key={est.id} value={est.id}>
          {est.name}
        </option>
      ))}
    </select>
  );
}

"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export function DeleteBuildingButton({ buildingId }: { buildingId: string }) {
  const router = useRouter();
  const [confirming, setConfirming] = useState(false);

  if (!confirming) {
    return (
      <button
        onClick={() => setConfirming(true)}
        className="text-xs text-red-400 hover:text-red-600 transition-colors ml-auto"
      >
        Usuń
      </button>
    );
  }

  return (
    <span className="ml-auto flex items-center gap-1 text-xs">
      <span className="text-red-500">Na pewno?</span>
      <button
        onClick={async () => {
          const supabase = createClient();
          const { error } = await supabase.from("fixflow_buildings").delete().eq("id", buildingId);
          if (!error) router.refresh();
        }}
        className="text-red-600 font-medium hover:underline"
      >
        Tak
      </button>
      <button
        onClick={() => setConfirming(false)}
        className="text-ink/40 hover:underline"
      >
        Nie
      </button>
    </span>
  );
}

export function DeleteStairwellButton({ stairwellId }: { stairwellId: string }) {
  const router = useRouter();
  const [confirming, setConfirming] = useState(false);

  if (!confirming) {
    return (
      <button
        onClick={() => setConfirming(true)}
        className="text-[10px] text-red-400 hover:text-red-600 transition-colors"
      >
        Usuń
      </button>
    );
  }

  return (
    <span className="flex items-center gap-1 text-[10px]">
      <span className="text-red-500">Na pewno?</span>
      <button
        onClick={async () => {
          const supabase = createClient();
          const { error } = await supabase.from("fixflow_stairwells").delete().eq("id", stairwellId);
          if (!error) router.refresh();
        }}
        className="text-red-600 font-medium hover:underline"
      >
        Tak
      </button>
      <button
        onClick={() => setConfirming(false)}
        className="text-ink/40 hover:underline"
      >
        Nie
      </button>
    </span>
  );
}

export function AddBuildingModal({ estateId }: { estateId: string }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [type, setType] = useState("residential");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_buildings").insert({
      estate_id: estateId,
      name,
      building_type: type,
    });
    setLoading(false);
    if (insertError) {
      setError(`Nie udało się dodać budynku: ${insertError.message}`);
      return;
    }
    setOpen(false);
    setName("");
    setType("residential");
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
      >
        + Dodaj budynek
      </button>
      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white rounded-[12px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-md mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-4">
              Nowy budynek
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Nazwa *
                </label>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Budynek A"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Typ
                </label>
                <select
                  value={type}
                  onChange={(e) => setType(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm bg-white focus:outline-none focus:border-azure"
                >
                  <option value="residential">Mieszkalny</option>
                  <option value="garage">Garaż</option>
                </select>
              </div>
              {error && <p className="text-[12.5px] text-danger">{error}</p>}
              <div className="flex gap-3 justify-end pt-2">
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  className="px-4 py-2 rounded-xl text-sm text-ink/60 hover:bg-paper transition-colors"
                >
                  Anuluj
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 disabled:opacity-50 transition-colors"
                >
                  {loading ? "Dodawanie..." : "Dodaj"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

export function AddStairwellModal({ buildingId }: { buildingId: string }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [floorMin, setFloorMin] = useState(0);
  const [floorMax, setFloorMax] = useState(4);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: insertError } = await supabase.from("fixflow_stairwells").insert({
      building_id: buildingId,
      name,
      floor_min: floorMin,
      floor_max: floorMax,
    });
    setLoading(false);
    if (insertError) {
      setError(`Nie udało się dodać klatki: ${insertError.message}`);
      return;
    }
    setOpen(false);
    setName("");
    router.refresh();
  };

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="text-xs px-3 py-1.5 rounded-lg border border-dashed border-ink/20 text-ink/50 hover:border-azure hover:text-azure transition-colors"
      >
        + Dodaj klatkę
      </button>
      {open && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-ink/30 backdrop-blur-sm"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white rounded-[12px] shadow-[0_8px_32px_rgba(14,26,43,.12)] p-6 w-full max-w-md mx-4"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-lg font-heading font-semibold text-ink mb-4">
              Nowa klatka
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-ink/50 mb-1">
                  Nazwa *
                </label>
                <input
                  type="text"
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  placeholder="Np. Klatka A"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-ink/50 mb-1">
                    Piętro min
                  </label>
                  <input
                    type="number"
                    value={floorMin}
                    onChange={(e) => setFloorMin(parseInt(e.target.value) || 0)}
                    className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-ink/50 mb-1">
                    Piętro max
                  </label>
                  <input
                    type="number"
                    value={floorMax}
                    onChange={(e) => setFloorMax(parseInt(e.target.value) || 0)}
                    className="w-full px-3 py-2 rounded-xl border border-ink/10 text-sm focus:outline-none focus:border-azure"
                  />
                </div>
              </div>
              {error && <p className="text-[12.5px] text-danger">{error}</p>}
              <div className="flex gap-3 justify-end pt-2">
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  className="px-4 py-2 rounded-xl text-sm text-ink/60 hover:bg-paper transition-colors"
                >
                  Anuluj
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="px-4 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 disabled:opacity-50 transition-colors"
                >
                  {loading ? "Dodawanie..." : "Dodaj"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function CloseResolutionButton({
  resolutionId,
}: {
  resolutionId: string;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleClose = async () => {
    setError(null);
    setLoading(true);
    const supabase = createClient();

    // Wynik ("passed"/"rejected", nie generyczne "closed") liczony wazonymi
    // udzialami jesli sa ustawione, inaczej po prostu liczba glosow.
    // Wstrzymujacy sie (abstain) nie licza sie do zadnej ze stron.
    const { data: votes, error: votesError } = await supabase
      .from("fixflow_resolution_votes")
      .select("choice, share_units")
      .eq("resolution_id", resolutionId);

    if (votesError) {
      setLoading(false);
      setError(`Nie udało się policzyć głosów: ${votesError.message}`);
      return;
    }

    const forWeight = (votes ?? [])
      .filter((v) => v.choice === "for")
      .reduce((a, v) => a + (v.share_units || 1), 0);
    const againstWeight = (votes ?? [])
      .filter((v) => v.choice === "against")
      .reduce((a, v) => a + (v.share_units || 1), 0);
    const outcome = forWeight > againstWeight ? "passed" : "rejected";

    const { error: updateError } = await supabase
      .from("fixflow_resolutions")
      .update({ status: outcome, closed_at: new Date().toISOString() })
      .eq("id", resolutionId);
    setLoading(false);
    if (updateError) {
      setError(`Nie udało się zamknąć głosowania: ${updateError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <>
      <button
        type="button"
        onClick={handleClose}
        disabled={loading}
        className="text-xs font-semibold text-[#6B7A90] hover:text-[#173A6A] transition-colors disabled:opacity-50"
      >
        {loading ? "Zamykanie…" : "Zamknij głosowanie ręcznie"}
      </button>
      {error && <p className="text-[11.5px] text-danger mt-1">{error}</p>}
    </>
  );
}

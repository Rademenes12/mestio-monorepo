"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function AnonymizeButton({
  residentId,
  isAdmin,
}: {
  residentId: string;
  isAdmin: boolean;
}) {
  const router = useRouter();
  const [confirming, setConfirming] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isAdmin) return null;

  if (!confirming) {
    return (
      <button
        type="button"
        onClick={() => setConfirming(true)}
        className="w-full text-left text-[12.5px] font-medium px-3 py-2.5 rounded-lg text-danger/70 hover:bg-danger/10 hover:text-danger transition-colors mt-2 min-h-[40px]"
      >
        Zanonimizuj dane (RODO)
      </button>
    );
  }

  const handleAnonymize = async () => {
    setError(null);
    setLoading(true);
    const supabase = createClient();
    const { error: rpcError } = await supabase.rpc(
      "anonymize_resident_profiles",
      { target_profile_id: residentId }
    );
    setLoading(false);
    if (rpcError) {
      setError(`Nie udało się zanonimizować: ${rpcError.message}`);
      return;
    }
    router.refresh();
  };

  return (
    <div className="mt-2 space-y-1.5">
      <p className="text-[12.5px] text-danger/80 font-medium">
        Na pewno? Tej akcji nie można cofnąć.
      </p>
      <div className="flex items-center gap-4 text-[12.5px]">
        <button
          type="button"
          onClick={handleAnonymize}
          disabled={loading}
          className="text-danger font-semibold hover:underline disabled:opacity-50 min-h-[36px]"
        >
          {loading ? "Anonimizowanie…" : "Tak, anonimizuj"}
        </button>
        <button
          type="button"
          onClick={() => setConfirming(false)}
          disabled={loading}
          className="text-ink/45 hover:underline min-h-[36px]"
        >
          Nie
        </button>
      </div>
      {error && <p className="text-[11.5px] text-danger">{error}</p>}
    </div>
  );
}

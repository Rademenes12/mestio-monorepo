"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export default function ResetPasswordPage() {
  const router = useRouter();
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (password.length < 8) {
      setError("Hasło musi mieć co najmniej 8 znaków.");
      return;
    }
    if (password !== confirm) {
      setError("Hasła nie są identyczne.");
      return;
    }

    setLoading(true);
    const supabase = createClient();
    const { error: updateError } = await supabase.auth.updateUser({ password });

    if (updateError) {
      console.error(updateError);
      setError(
        updateError.message.includes("session")
          ? "Link wygasł lub jest nieprawidłowy. Poproś o nowy reset hasła."
          : "Nie udało się zmienić hasła. Spróbuj ponownie."
      );
      setLoading(false);
      return;
    }

    setDone(true);
    setLoading(false);
    setTimeout(() => {
      router.replace("/");
      router.refresh();
    }, 1500);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-paper p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-10">
          <h1 className="text-3xl font-heading font-bold text-ink">Mestio</h1>
          <p className="mt-2 text-ink/60">Ustaw nowe hasło</p>
        </div>

        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8">
          {done ? (
            <div className="text-center space-y-2">
              <p className="text-ink font-medium">Hasło zostało zmienione</p>
              <p className="text-sm text-ink/50">Przekierowujemy do panelu…</p>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium text-ink/70 mb-1.5"
                >
                  Nowe hasło
                </label>
                <input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={8}
                  autoComplete="new-password"
                  className="w-full px-4 py-2.5 rounded-xl border border-ink/10 bg-white text-ink focus:outline-none focus:border-azure focus:ring-2 focus:ring-azure/20"
                />
              </div>
              <div>
                <label
                  htmlFor="confirm"
                  className="block text-sm font-medium text-ink/70 mb-1.5"
                >
                  Powtórz hasło
                </label>
                <input
                  id="confirm"
                  type="password"
                  value={confirm}
                  onChange={(e) => setConfirm(e.target.value)}
                  required
                  minLength={8}
                  autoComplete="new-password"
                  className="w-full px-4 py-2.5 rounded-xl border border-ink/10 bg-white text-ink focus:outline-none focus:border-azure focus:ring-2 focus:ring-azure/20"
                />
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-red-50 text-red-600 text-sm">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={loading}
                className="w-full py-2.5 rounded-xl bg-azure text-white font-medium hover:bg-azure/90 disabled:opacity-50 transition-all"
              >
                {loading ? "Zapisywanie…" : "Zapisz nowe hasło"}
              </button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}

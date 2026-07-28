"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function ResetPasswordPage() {
  const router = useRouter();
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);
  const supabase = createClient();

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
    const { error: updateError } = await supabase.auth.updateUser({
      password,
    });

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
    setTimeout(() => router.replace("/dashboard"), 1500);
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-ink">
      <div className="w-full max-w-md px-6">
        <div className="bg-white rounded-[var(--radius-card)] shadow-[var(--shadow-card)] p-10">
          <div className="text-center mb-8">
            <h1 className="text-2xl font-bold text-ink mb-1">Nowe hasło</h1>
            <p className="text-sm text-ink/50">Ustaw hasło do panelu właściciela</p>
          </div>

          {done ? (
            <div className="text-center space-y-3">
              <p className="text-ink font-medium">Hasło zostało zmienione</p>
              <p className="text-sm text-ink/50">Przekierowujemy do panelu…</p>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium text-ink mb-1.5"
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
                  className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure"
                />
              </div>
              <div>
                <label
                  htmlFor="confirm"
                  className="block text-sm font-medium text-ink mb-1.5"
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
                  className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure"
                />
              </div>

              {error && (
                <div className="bg-danger/5 text-danger text-sm px-4 py-2.5 rounded-[var(--radius-btn)] border border-danger/20">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={loading}
                className="w-full py-2.5 bg-azure text-white font-medium rounded-[var(--radius-btn)] hover:bg-azure-dark transition-colors disabled:opacity-50"
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

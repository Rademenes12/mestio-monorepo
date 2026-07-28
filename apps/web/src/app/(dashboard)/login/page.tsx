"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [resetSent, setResetSent] = useState(false);

  // Get redirect URL from query params
  const redirectTo = typeof window !== "undefined"
    ? new URLSearchParams(window.location.search).get("redirect") || "/"
    : "/";

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setError("Nieprawidłowy e-mail lub hasło.");
      setLoading(false);
      return;
    }

    // After login, determine redirect based on user role
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (user) {
      const { data: profile } = await supabase
        .from("fixflow_resident_profiles")
        .select("role")
        .eq("user_id", user.id)
        .maybeSingle();

      const role = profile?.role || "";

      if (role === "owner" || role === "admin") {
        router.push("/owner/dashboard");
      } else if (role === "manager" || role === "serwis" || role === "ochrona") {
        router.push("/client/");
      } else if (redirectTo !== "/") {
        router.push(redirectTo);
      } else {
        router.push("/client/");
      }
    } else {
      router.push(redirectTo);
    }
    router.refresh();
  };

  const handleForgotPassword = async () => {
    if (!email) {
      setError("Podaj adres e-mail, aby zresetować hasło.");
      return;
    }
    setError(null);
    setLoading(true);

    const supabase = createClient();
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/callback?next=/reset-password`,
    });

    if (error) {
      setError("Nie udało się wysłać linku. Spróbuj ponownie.");
      setLoading(false);
      return;
    }

    setResetSent(true);
    setLoading(false);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-paper p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-10">
          <h1 className="text-3xl font-heading font-bold text-text">Mestio</h1>
          <p className="mt-2 text-text-secondary">
            Panel Zarządu / Administratora
          </p>
        </div>

        <div className="bg-card border border-card-border rounded-[22px] shadow-card p-8">
          <h2 className="text-xl font-heading font-semibold text-text mb-6">
            Zaloguj się
          </h2>

          {resetSent ? (
            <div className="space-y-4 text-center">
              <p className="text-text font-medium">Sprawdź skrzynkę e-mail</p>
              <p className="text-sm text-text-secondary">
                Wysłaliśmy link do resetu hasła na <strong>{email}</strong>
              </p>
              <button
                type="button"
                onClick={() => setResetSent(false)}
                className="text-sm text-accent hover:text-accent-hover underline"
              >
                Wróć do logowania
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label
                  htmlFor="email"
                  className="block text-sm font-medium text-text-secondary mb-1.5"
                >
                  E-mail
                </label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  autoComplete="email"
                  placeholder="admin@osiedle.pl"
                  className="w-full px-4 py-2.5 rounded-xl border border-card-border bg-surface text-text placeholder:text-text-muted focus:outline-none focus:border-accent focus:ring-2 focus:ring-accent/20 transition-all"
                />
              </div>

              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium text-text-secondary mb-1.5"
                >
                  Hasło
                </label>
                <input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  autoComplete="current-password"
                  placeholder="••••••••"
                  className="w-full px-4 py-2.5 rounded-xl border border-card-border bg-surface text-text placeholder:text-text-muted focus:outline-none focus:border-accent focus:ring-2 focus:ring-accent/20 transition-all"
                />
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-error/10 text-error text-sm border border-error/20">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={loading}
                className="w-full py-2.5 rounded-xl bg-accent text-white font-medium hover:bg-accent-hover disabled:opacity-50 disabled:cursor-not-allowed transition-all"
              >
                {loading ? "Logowanie..." : "Zaloguj się"}
              </button>

              <button
                type="button"
                onClick={handleForgotPassword}
                disabled={loading}
                className="w-full text-sm text-text-muted hover:text-accent transition-colors disabled:opacity-50"
              >
                Nie pamiętasz hasła?
              </button>
            </form>
          )}
        </div>

        <p className="text-center text-sm text-text-muted mt-6">
          Mestio Home — dostęp tylko dla zarządu i administratorów
        </p>
      </div>
    </div>
  );
}

"use client";

import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sent, setSent] = useState(false);
  const [resetSent, setResetSent] = useState(false);
  const [checking, setChecking] = useState(true);
  const supabase = createClient();

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) {
        window.location.href = "/dashboard";
      } else {
        setChecking(false);
      }
    });
  }, []);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setError(error.message);
      setLoading(false);
    } else {
      window.location.href = "/dashboard";
    }
  };

  const handleSendLink = async () => {
    if (!email) {
      setError("Podaj adres e-mail");
      return;
    }
    setLoading(true);
    setError(null);

    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    });

    if (error) {
      setError(error.message);
    } else {
      setSent(true);
    }
    setLoading(false);
  };

  const handleForgotPassword = async () => {
    if (!email) {
      setError("Podaj adres e-mail, aby zresetować hasło");
      return;
    }
    setLoading(true);
    setError(null);

    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/callback?next=/reset-password`,
    });

    if (error) {
      setError(error.message);
    } else {
      setResetSent(true);
    }
    setLoading(false);
  };

  if (checking) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-ink">
        <div className="text-center">
          <div className="w-8 h-8 border-2 border-white/20 border-t-white rounded-full animate-spin mx-auto mb-4" />
          <p className="text-white/50 text-sm">Sprawdzanie sesji...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-ink">
      <div className="w-full max-w-md px-6">
        <div className="bg-white rounded-[var(--radius-card)] shadow-[var(--shadow-card)] p-10">
          <div className="text-center mb-8">
            <h1 className="text-2xl font-bold text-ink mb-1">Mestio CRM</h1>
            <p className="text-sm text-mist-foreground text-ink/50">
              Panel właściciela
            </p>
          </div>

          {sent || resetSent ? (
            <div className="text-center space-y-4">
              <div className="w-12 h-12 bg-azure/10 rounded-full flex items-center justify-center mx-auto">
                <svg
                  className="w-6 h-6 text-azure"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                  />
                </svg>
              </div>
              <p className="text-ink font-medium">Sprawdź swoją skrzynkę</p>
              <p className="text-sm text-ink/50">
                {resetSent
                  ? "Wysłaliśmy link do resetu hasła na "
                  : "Wysłaliśmy link logowania na "}
                <strong>{email}</strong>
              </p>
              <button
                onClick={() => {
                  setSent(false);
                  setResetSent(false);
                }}
                className="text-sm text-azure hover:text-azure-dark transition-colors"
              >
                Wróć do logowania
              </button>
            </div>
          ) : (
            <>
              <form onSubmit={handleLogin} className="space-y-4">
                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-medium text-ink mb-1.5"
                  >
                    E-mail
                  </label>
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="twoj@email.com"
                    required
                    className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
                  />
                </div>

                <div>
                  <label
                    htmlFor="password"
                    className="block text-sm font-medium text-ink mb-1.5"
                  >
                    Hasło
                  </label>
                  <input
                    id="password"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="Twoje hasło"
                    required
                    className="w-full px-4 py-2.5 border border-mist rounded-[var(--radius-btn)] text-ink placeholder-ink/30 focus:outline-none focus:ring-2 focus:ring-azure/30 focus:border-azure transition-all"
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
                  className="w-full py-2.5 bg-azure text-white font-medium rounded-[var(--radius-btn)] hover:bg-azure-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? "Logowanie..." : "Zaloguj się"}
                </button>
              </form>

              <div className="mt-6 flex flex-col items-center gap-2">
                <button
                  type="button"
                  onClick={handleForgotPassword}
                  disabled={loading}
                  className="text-sm text-ink/50 hover:text-azure transition-colors disabled:opacity-50"
                >
                  Nie pamiętasz hasła?
                </button>
                <button
                  type="button"
                  onClick={handleSendLink}
                  disabled={loading}
                  className="text-sm text-ink/50 hover:text-azure transition-colors disabled:opacity-50"
                >
                  Wyślij link logowania na e-mail
                </button>
              </div>
            </>
          )}
        </div>

        <p className="text-center text-xs text-white/30 mt-6">
          Mestio &copy; {new Date().getFullYear()}
        </p>
      </div>
    </div>
  );
}

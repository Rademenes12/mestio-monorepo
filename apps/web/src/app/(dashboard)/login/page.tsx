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

  const redirectTo =
    typeof window !== "undefined"
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

      if (role === "owner") {
        router.push("/owner/dashboard");
      } else if (
        role === "admin" ||
        role === "manager" ||
        role === "serwis" ||
        role === "ochrona"
      ) {
        router.push("/client/");
      } else if (role === "resident") {
        router.push("/resident/");
      } else if (redirectTo !== "/") {
        router.push(redirectTo);
      } else {
        router.push("/resident/");
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
    <div
      className="min-h-screen w-full flex items-center justify-center p-4"
      style={{ background: "#F6F8FB" }}
    >
      <div className="w-full max-w-[420px] mx-auto">
        {/* Logo + nagłówek */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-12 h-12 rounded-[14px] mb-4 shadow-[0_4px_12px_rgba(62,123,214,0.3)]"
            style={{ background: "#3E7BD6" }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff"
              strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
              <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
            </svg>
          </div>
          <h1 className="text-2xl font-heading font-bold" style={{ color: "#0E1A2B" }}>
            Zaloguj się do Mestio
          </h1>
          <p className="text-sm mt-1.5" style={{ color: "#7C8AA0" }}>
            Panel zarządu, administracji i mieszkańców
          </p>
        </div>

        {/* Formularz */}
        <div
          className="bg-white rounded-[20px] p-8 shadow-[0_4px_24px_rgba(14,26,43,0.06)]"
          style={{
            border: "1px solid #E9EEF5",
          }}
        >
          {resetSent ? (
            <div className="space-y-4 text-center py-4">
              <div
                className="w-12 h-12 rounded-full flex items-center justify-center mx-auto"
                style={{ background: "rgba(46,158,107,.12)" }}
              >
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                  stroke="#2E9E6B" strokeWidth="2.2" strokeLinecap="round"
                  strokeLinejoin="round">
                  <path d="M22 12a10 10 0 1 1-10-10" />
                  <path d="M22 4 12 14.01 9 11" />
                </svg>
              </div>
              <p className="font-medium" style={{ color: "#0E1A2B" }}>
                Sprawdź skrzynkę e-mail
              </p>
              <p className="text-sm" style={{ color: "#7C8AA0" }}>
                Wysłaliśmy link do resetu hasła na <strong>{email}</strong>
              </p>
              <button
                type="button"
                onClick={() => setResetSent(false)}
                className="text-sm underline"
                style={{ color: "#3E7BD6" }}
              >
                Wróć do logowania
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label
                  htmlFor="email"
                  className="block text-sm font-medium mb-1.5"
                  style={{ color: "#4A5A6E" }}
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
                  placeholder="twoj@email.pl"
                  className="w-full px-4 py-2.5 rounded-[8px] text-sm transition-all"
                  style={{
                    background: "#F8F9FB",
                    border: "1px solid #E9EEF5",
                    color: "#0E1A2B",
                  }}
                  onFocus={(e) => {
                    e.target.style.borderColor = "#3E7BD6";
                    e.target.style.boxShadow = "0 0 0 3px rgba(62,123,214,.15)";
                  }}
                  onBlur={(e) => {
                    e.target.style.borderColor = "#E9EEF5";
                    e.target.style.boxShadow = "none";
                  }}
                />
              </div>

              <div>
                <label
                  htmlFor="password"
                  className="block text-sm font-medium mb-1.5"
                  style={{ color: "#4A5A6E" }}
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
                  className="w-full px-4 py-2.5 rounded-[8px] text-sm transition-all"
                  style={{
                    background: "#F8F9FB",
                    border: "1px solid #E9EEF5",
                    color: "#0E1A2B",
                  }}
                  onFocus={(e) => {
                    e.target.style.borderColor = "#3E7BD6";
                    e.target.style.boxShadow = "0 0 0 3px rgba(62,123,214,.15)";
                  }}
                  onBlur={(e) => {
                    e.target.style.borderColor = "#E9EEF5";
                    e.target.style.boxShadow = "none";
                  }}
                />
              </div>

              {error && (
                <div
                  className="p-3 rounded-[8px] text-sm"
                  style={{
                    background: "rgba(239,68,68,.1)",
                    color: "#EF4444",
                    border: "1px solid rgba(239,68,68,.2)",
                  }}
                >
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={loading}
                className="w-full py-2.5 rounded-[8px] text-sm font-semibold text-white transition-all disabled:opacity-50 hover:brightness-110"
                style={{
                  background: "#3E7BD6",
                }}
              >
                {loading ? "Logowanie..." : "Zaloguj się"}
              </button>

              <button
                type="button"
                onClick={handleForgotPassword}
                disabled={loading}
                className="w-full text-sm transition-colors disabled:opacity-50"
                style={{ color: "#7C8AA0" }}
                onMouseEnter={(e) => { e.currentTarget.style.color = "#3E7BD6" }}
                onMouseLeave={(e) => { e.currentTarget.style.color = "#7C8AA0" }}
              >
                Nie pamiętasz hasła?
              </button>
            </form>
          )}
        </div>

        {/* Stopka */}
        <p className="text-center text-xs mt-6" style={{ color: "#9AA7B8" }}>
          Mestio — system dla osiedli, zarządców i mieszkańców
        </p>
      </div>
    </div>
  );
}

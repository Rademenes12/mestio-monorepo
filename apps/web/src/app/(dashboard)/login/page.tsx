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
        // Fallback: jeśli brak profilu, idź na dashboard owner (pierwsze logowanie)
        router.push("/owner/dashboard");
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
    <div className="flex min-h-screen">
      {/* ── Left panel: Branding ── */}
      <div
        className="hidden lg:flex w-[480px] lg:w-[42%] flex-col justify-between p-10 lg:p-14 relative overflow-hidden"
        style={{
          background: "linear-gradient(160deg, #173A6A 0%, #0E1A2B 100%)",
        }}
      >
        {/* Subtle radial glow */}
        <div
          className="absolute top-[-20%] right-[-10%] w-[400px] h-[400px] rounded-full opacity-20"
          style={{
            background: "radial-gradient(circle, rgba(62,123,214,0.5) 0%, transparent 70%)",
          }}
        />

        <div className="relative z-10">
          {/* Logo */}
          <div className="flex items-center gap-3 mb-12">
            <div
              className="w-10 h-10 rounded-[10px] flex items-center justify-center shrink-0"
              style={{ background: "#3E7BD6" }}
            >
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#fff"
                strokeWidth="2.1"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z" />
              </svg>
            </div>
            <span
              className="text-white font-heading font-bold text-xl tracking-tight"
            >
              Mestio
            </span>
          </div>

          {/* Value prop */}
          <h2
            className="text-white font-heading font-bold text-3xl lg:text-4xl leading-tight mb-5"
          >
            Zarządzanie osiedlem
            <br />
            wreszcie pod kontrolą
          </h2>
          <p className="text-base leading-relaxed" style={{ color: "rgba(255,255,255,0.65)" }}>
            Zgłoszenia usterek, komunikacja z mieszkańcami, ślad audytowy —
            wszystko w jednym miejscu. Bez chaosu, bez telefonów, bez grupy na
            Facebooku.
          </p>

          {/* Feature list */}
          <div className="mt-10 space-y-4">
            {[
              {
                icon: "M22 12a10 10 0 1 1-10-10M22 4 12 14.01 9 11",
                text: "Zgłoszenia ze statusem i SLA",
              },
              {
                icon: "M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z",
                text: "5 ról: mieszkaniec, zarząd, zarządca, serwis, ochrona",
              },
              {
                icon: "M12 2l3 7h7l-5.5 4.5L18 21l-6-4.5L6 21l1.5-7.5L2 9h7z",
                text: "Powiadomienia push i ślad audytowy",
              },
              {
                icon: "M4 21V9l8-5 8 5v12M9 21v-6h6v6",
                text: "Struktura osiedla: budynki, klatki, piętra",
              },
            ].map((feature, i) => (
              <div key={i} className="flex items-start gap-3">
                <div
                  className="w-8 h-8 rounded-lg flex items-center justify-center shrink-0 mt-0.5"
                  style={{ background: "rgba(255,255,255,0.08)" }}
                >
                  <svg
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="rgba(255,255,255,0.7)"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <path d={feature.icon} />
                  </svg>
                </div>
                <span className="text-sm" style={{ color: "rgba(255,255,255,0.7)" }}>
                  {feature.text}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <p className="relative z-10 text-xs" style={{ color: "rgba(255,255,255,0.3)" }}>
          © {new Date().getFullYear()} Mestio. System dla osiedli i wspólnot.
        </p>
      </div>

      {/* ── Right panel: Login form ── */}
      <div
        className="flex-1 flex items-center justify-center p-6 lg:p-14"
        style={{ background: "var(--color-page, #F9FAFB)" }}
      >
        <div className="w-full" style={{ maxWidth: "440px" }}>
          {/* Mobile logo (visible only on small screens) */}
          <div className="lg:hidden text-center mb-8">
            <div
              className="inline-flex items-center justify-center w-12 h-12 rounded-[10px] mb-4"
              style={{ background: "#3E7BD6" }}
            >
              <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#fff"
                strokeWidth="2.1"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z" />
              </svg>
            </div>
            <h1 className="text-2xl font-heading font-bold" style={{ color: "#0E1A2B" }}>
              Mestio
            </h1>
          </div>

          {/* Form header */}
          <div className="mb-8">
            <h1
              className="text-[28px] font-heading font-bold tracking-tight mb-2"
              style={{ color: "#0E1A2B" }}
            >
              Zaloguj się
            </h1>
            <p className="text-[15px] leading-relaxed" style={{ color: "#7C8AA0" }}>
              Wprowadź swoje dane, aby przejść do panelu zarządzania osiedlem.
            </p>
          </div>

          {resetSent ? (
            <div
              className="rounded-[16px] p-8 text-center"
              style={{
                background: "#fff",
                border: "1px solid var(--color-glass-border, #EBEFF4)",
                boxShadow: "0 1px 3px rgba(14,26,43,.04)",
              }}
            >
              <div
                className="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-5"
                style={{ background: "rgba(34,197,94,.12)" }}
              >
                <svg
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#22C55E"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M22 12a10 10 0 1 1-10-10" />
                  <path d="M22 4 12 14.01 9 11" />
                </svg>
              </div>
              <p className="text-lg font-semibold mb-1.5" style={{ color: "#0E1A2B" }}>
                Sprawdź skrzynkę e-mail
              </p>
              <p className="text-sm mb-6" style={{ color: "#7C8AA0" }}>
                Wysłaliśmy link do resetu hasła na{" "}
                <strong style={{ color: "#0E1A2B" }}>{email}</strong>
              </p>
              <button
                type="button"
                onClick={() => setResetSent(false)}
                className="text-sm font-medium transition-colors"
                style={{ color: "#3E7BD6" }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.color = "#2A5FA8";
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.color = "#3E7BD6";
                }}
              >
                ← Wróć do logowania
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit}>
              <div
                className="rounded-[16px] p-8"
                style={{
                  background: "#fff",
                  border: "1px solid var(--color-glass-border, #EBEFF4)",
                  boxShadow: "0 1px 3px rgba(14,26,43,.04)",
                }}
              >
                <div className="space-y-5">
                  {/* Email */}
                  <div>
                    <label
                      htmlFor="email"
                      className="block text-[13px] font-semibold mb-2"
                      style={{ color: "#4A5A6E" }}
                    >
                      Adres e-mail
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none">
                        <svg
                          width="18"
                          height="18"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="#9AA7B8"
                          strokeWidth="1.8"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <rect width="20" height="16" x="2" y="4" rx="2" />
                          <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
                        </svg>
                      </div>
                      <input
                        id="email"
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                        autoComplete="email"
                        placeholder="twoj@email.pl"
                        className="w-full pl-11 pr-4 py-3 rounded-[12px] text-[15px] transition-all outline-none"
                        style={{
                          background: "#F9FAFB",
                          border: "1px solid var(--color-glass-border, #EBEFF4)",
                          color: "#0E1A2B",
                        }}
                        onFocus={(e) => {
                          e.currentTarget.style.borderColor = "#3E7BD6";
                          e.currentTarget.style.boxShadow =
                            "0 0 0 3px rgba(62,123,214,.12)";
                          e.currentTarget.style.background = "#fff";
                        }}
                        onBlur={(e) => {
                          e.currentTarget.style.borderColor =
                            "var(--color-glass-border, #EBEFF4)";
                          e.currentTarget.style.boxShadow = "none";
                          e.currentTarget.style.background = "#F9FAFB";
                        }}
                      />
                    </div>
                  </div>

                  {/* Password */}
                  <div>
                    <label
                      htmlFor="password"
                      className="block text-[13px] font-semibold mb-2"
                      style={{ color: "#4A5A6E" }}
                    >
                      Hasło
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none">
                        <svg
                          width="18"
                          height="18"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="#9AA7B8"
                          strokeWidth="1.8"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                          <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                        </svg>
                      </div>
                      <input
                        id="password"
                        type="password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        required
                        autoComplete="current-password"
                        placeholder="••••••••"
                        className="w-full pl-11 pr-4 py-3 rounded-[12px] text-[15px] transition-all outline-none"
                        style={{
                          background: "#F9FAFB",
                          border: "1px solid var(--color-glass-border, #EBEFF4)",
                          color: "#0E1A2B",
                        }}
                        onFocus={(e) => {
                          e.currentTarget.style.borderColor = "#3E7BD6";
                          e.currentTarget.style.boxShadow =
                            "0 0 0 3px rgba(62,123,214,.12)";
                          e.currentTarget.style.background = "#fff";
                        }}
                        onBlur={(e) => {
                          e.currentTarget.style.borderColor =
                            "var(--color-glass-border, #EBEFF4)";
                          e.currentTarget.style.boxShadow = "none";
                          e.currentTarget.style.background = "#F9FAFB";
                        }}
                      />
                    </div>
                  </div>

                  {error && (
                    <div
                      className="p-3.5 rounded-[12px] text-[13px] font-medium"
                      style={{
                        background: "rgba(239,68,68,.08)",
                        color: "#EF4444",
                        border: "1px solid rgba(239,68,68,.15)",
                      }}
                    >
                      {error}
                    </div>
                  )}

                  <button
                    type="submit"
                    disabled={loading}
                    className="w-full py-3 rounded-[12px] text-[15px] font-semibold text-white transition-all disabled:opacity-50 flex items-center justify-center gap-2"
                    style={{
                      background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                      boxShadow: "0 2px 8px rgba(62,123,214,.25)",
                    }}
                    onMouseEnter={(e) => {
                      e.currentTarget.style.transform = "translateY(-1px)";
                      e.currentTarget.style.boxShadow =
                        "0 4px 14px rgba(62,123,214,.35)";
                    }}
                    onMouseLeave={(e) => {
                      e.currentTarget.style.transform = "translateY(0)";
                      e.currentTarget.style.boxShadow =
                        "0 2px 8px rgba(62,123,214,.25)";
                    }}
                  >
                    {loading ? "Logowanie..." : "Zaloguj się"}
                    {!loading && (
                      <svg
                        width="16"
                        height="16"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2.2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M5 12h14M12 5l7 7-7 7" />
                      </svg>
                    )}
                  </button>
                </div>
              </div>

              {/* Forgot password */}
              <div className="mt-6 text-center">
                <button
                  type="button"
                  onClick={handleForgotPassword}
                  disabled={loading}
                  className="text-[13px] font-medium transition-colors disabled:opacity-50"
                  style={{ color: "#7C8AA0" }}
                  onMouseEnter={(e) => {
                    e.currentTarget.style.color = "#3E7BD6";
                  }}
                  onMouseLeave={(e) => {
                    e.currentTarget.style.color = "#7C8AA0";
                  }}
                >
                  Nie pamiętasz hasła?
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}

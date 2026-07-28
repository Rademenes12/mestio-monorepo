"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";
import Link from "next/link";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [resetSent, setResetSent] = useState(false);
  const [activeTab, setActiveTab] = useState<"client" | "owner" | "resident">("client");

  const redirectTo =
    typeof window !== "undefined"
      ? new URLSearchParams(window.location.search).get("redirect") || "/"
      : "/";

  const handleTabSelect = (tab: "client" | "owner" | "resident") => {
    setActiveTab(tab);
    setError(null);
    if (tab === "owner") {
      setEmail("twoj@mestio.pl");
      setPassword("Test1234!");
    } else if (tab === "client") {
      setEmail("test-admin@fixflow.app");
      setPassword("Test1234!");
    } else {
      setEmail("test-mieszkaniec@fixflow.app");
      setPassword("Test1234!");
    }
  };

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
      className="min-h-screen w-full flex items-center justify-center p-4 sm:p-6"
      style={{ background: "#F5F7FA", minHeight: "100vh", width: "100%" }}
    >
      <div
        className="w-full max-w-[430px] mx-auto"
        style={{ width: "100%", maxWidth: "430px", margin: "0 auto", boxSizing: "border-box" }}
      >
        {/* Top Branding Header */}
        <div className="flex flex-col items-center text-center mb-6">
          <div
            className="flex items-center justify-center w-12 h-12 rounded-[16px] mb-3 shadow-[0_6px_16px_rgba(62,123,214,0.25)] transition-transform hover:scale-105"
            style={{ background: "linear-gradient(135deg, #3E7BD6 0%, #2A5FA8 100%)" }}
          >
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff"
              strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
            </svg>
          </div>
          <span className="text-2xl font-bold font-heading tracking-tight" style={{ color: "#0E1A2B" }}>
            Mestio
          </span>
          <h1 className="text-base font-semibold mt-2" style={{ color: "#1A202C" }}>
            Zaloguj się
          </h1>
          <p className="text-xs mt-0.5" style={{ color: "#718096" }}>
            Wybierz swój profil i uzyskaj dostęp do panelu
          </p>
        </div>

        {/* Form Card */}
        <div
          className="bg-white rounded-[24px] p-6 sm:p-8 shadow-[0_10px_30px_rgba(0,0,0,0.04)]"
          style={{
            border: "1px solid #E2E8F0",
            width: "100%",
            boxSizing: "border-box",
          }}
        >
          {/* ProTracker Style Role Selector Pills */}
          <div className="grid grid-cols-3 gap-2 mb-6 p-1 rounded-[14px]" style={{ background: "#F7FAFC", border: "1px solid #EDF2F7" }}>
            <button
              type="button"
              onClick={() => handleTabSelect("client")}
              className={`py-2 px-1 text-xs font-semibold rounded-[10px] transition-all flex flex-col items-center justify-center gap-1 ${
                activeTab === "client"
                  ? "bg-white shadow-[0_2px_8px_rgba(0,0,0,0.06)] text-[#3E7BD6]"
                  : "text-[#718096] hover:text-[#2D3748]"
              }`}
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <rect x="2" y="7" width="20" height="14" rx="2" ry="2"/>
                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
              </svg>
              Zarządca
            </button>
            
            <button
              type="button"
              onClick={() => handleTabSelect("owner")}
              className={`py-2 px-1 text-xs font-semibold rounded-[10px] transition-all flex flex-col items-center justify-center gap-1 ${
                activeTab === "owner"
                  ? "bg-white shadow-[0_2px_8px_rgba(0,0,0,0.06)] text-[#3E7BD6]"
                  : "text-[#718096] hover:text-[#2D3748]"
              }`}
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
              </svg>
              Owner
            </button>

            <button
              type="button"
              onClick={() => handleTabSelect("resident")}
              className={`py-2 px-1 text-xs font-semibold rounded-[10px] transition-all flex flex-col items-center justify-center gap-1 ${
                activeTab === "resident"
                  ? "bg-white shadow-[0_2px_8px_rgba(0,0,0,0.06)] text-[#3E7BD6]"
                  : "text-[#718096] hover:text-[#2D3748]"
              }`}
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
              </svg>
              Mieszkaniec
            </button>
          </div>

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
                className="text-xs underline font-semibold"
                style={{ color: "#3E7BD6" }}
              >
                Wróć do logowania
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4" style={{ width: "100%" }}>
              {/* E-mail Input with Left Icon */}
              <div>
                <label
                  htmlFor="email"
                  className="block text-xs font-semibold mb-1"
                  style={{ color: "#4A5568" }}
                >
                  Email:
                </label>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none" style={{ color: "#A0AEC0" }}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                      <polyline points="22,6 12,13 2,6"/>
                    </svg>
                  </span>
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    autoComplete="email"
                    placeholder="Wprowadź adres email"
                    className="w-full pl-10 pr-4 py-2.5 rounded-[12px] text-xs transition-all outline-none"
                    style={{
                      width: "100%",
                      boxSizing: "border-box",
                      background: "#F7FAFC",
                      border: "1px solid #E2E8F0",
                      color: "#1A202C",
                    }}
                    onFocus={(e) => {
                      e.target.style.borderColor = "#3E7BD6";
                      e.target.style.background = "#FFFFFF";
                      e.target.style.boxShadow = "0 0 0 3px rgba(62,123,214,.12)";
                    }}
                    onBlur={(e) => {
                      e.target.style.borderColor = "#E2E8F0";
                      e.target.style.background = "#F7FAFC";
                      e.target.style.boxShadow = "none";
                    }}
                  />
                </div>
              </div>

              {/* Password Input with Left Icon & Right Forgot Link */}
              <div>
                <div className="flex items-center justify-between mb-1">
                  <label
                    htmlFor="password"
                    className="block text-xs font-semibold"
                    style={{ color: "#4A5568" }}
                  >
                    Hasło:
                  </label>
                  <button
                    type="button"
                    onClick={handleForgotPassword}
                    disabled={loading}
                    className="text-[11px] font-semibold transition-colors disabled:opacity-50"
                    style={{ color: "#3E7BD6" }}
                  >
                    Nie pamiętasz hasła?
                  </button>
                </div>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none" style={{ color: "#A0AEC0" }}>
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                      <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                  </span>
                  <input
                    id="password"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    autoComplete="current-password"
                    placeholder="Wprowadź hasło"
                    className="w-full pl-10 pr-4 py-2.5 rounded-[12px] text-xs transition-all outline-none"
                    style={{
                      width: "100%",
                      boxSizing: "border-box",
                      background: "#F7FAFC",
                      border: "1px solid #E2E8F0",
                      color: "#1A202C",
                    }}
                    onFocus={(e) => {
                      e.target.style.borderColor = "#3E7BD6";
                      e.target.style.background = "#FFFFFF";
                      e.target.style.boxShadow = "0 0 0 3px rgba(62,123,214,.12)";
                    }}
                    onBlur={(e) => {
                      e.target.style.borderColor = "#E2E8F0";
                      e.target.style.background = "#F7FAFC";
                      e.target.style.boxShadow = "none";
                    }}
                  />
                </div>
              </div>

              {error && (
                <div
                  className="p-3 rounded-[12px] text-xs flex items-center gap-2"
                  style={{
                    background: "rgba(239,68,68,.08)",
                    color: "#E53E3E",
                    border: "1px solid rgba(239,68,68,.2)",
                  }}
                >
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                  </svg>
                  {error}
                </div>
              )}

              {/* Full Pill Action Button */}
              <div className="pt-2">
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full py-3 rounded-full text-xs font-bold text-white shadow-[0_4px_14px_rgba(62,123,214,0.35)] transition-all active:scale-[0.99] disabled:opacity-50 hover:brightness-110 flex items-center justify-center gap-2"
                  style={{
                    background: "#3E7BD6",
                  }}
                >
                  {loading ? (
                    <>
                      <svg className="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      Logowanie...
                    </>
                  ) : (
                    "Zaloguj się"
                  )}
                </button>
              </div>
            </form>
          )}

          {/* Bottom Sign up section */}
          <div className="mt-6 pt-5 border-t border-[#EDF2F7] text-center">
            <p className="text-xs text-[#718096]">
              Nie masz jeszcze konta?
            </p>
            <div className="mt-2 flex items-center justify-center gap-3">
              <Link
                href="/zamow"
                className="inline-flex items-center gap-1.5 text-xs font-semibold text-[#3E7BD6] hover:underline"
              >
                <span>Zamów Mestio dla osiedla</span>
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <line x1="5" y1="12" x2="19" y2="12"/>
                  <polyline points="12 5 19 12 12 19"/>
                </svg>
              </Link>
            </div>
          </div>
        </div>

        {/* Footer */}
        <p className="text-center text-[11px] mt-6" style={{ color: "#A0AEC0" }}>
          Mestio — nowoczesny system dla osiedli i wspólnot
        </p>
      </div>
    </div>
  );
}

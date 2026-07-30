"use client";

import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { Crown, Building2, User, Sparkles, ArrowRight } from "lucide-react";

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

  const handleDemoAccess = (rolePath: string) => {
    window.location.href = rolePath;
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
          background: "linear-gradient(135deg, #0A1524 0%, #0E1A2B 50%, #173A6A 100%)",
        }}
      >
        <div className="relative z-10">
          <div className="flex items-center gap-3 mb-12">
            <div
              className="w-10 h-10 rounded-[10px] flex items-center justify-center"
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
            <span
              className="text-2xl font-bold tracking-tight text-white"
              style={{ fontFamily: "'Space Grotesk',sans-serif" }}
            >
              Mestio
            </span>
          </div>

          <h2
            className="text-[36px] font-heading font-bold text-white leading-tight tracking-tight mb-4"
          >
            Jeden ekosystem dla całego osiedla.
          </h2>
          <p className="text-[16px] leading-relaxed text-white/70 max-w-[360px]">
            Wygodne zarządzanie usterkami, uchwałami, e-podpisami i płatnościami z poziomu przeglądarki i aplikacji mobilnej.
          </p>
        </div>

        <p className="relative z-10 text-xs text-white/30">
          © {new Date().getFullYear()} Mestio. Wszystkie prawa zastrzeżone.
        </p>
      </div>

      {/* ── Right panel: Login & Quick Demo Access ── */}
      <div
        className="flex-1 flex items-center justify-center p-6 lg:p-14"
        style={{ background: "#F9FAFB" }}
      >
        <div className="w-full max-w-[480px] space-y-8">
          {/* Mobile logo */}
          <div className="lg:hidden text-center mb-6">
            <div
              className="inline-flex items-center justify-center w-12 h-12 rounded-[10px] mb-3"
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
            <h1 className="text-2xl font-heading font-bold text-ink">
              Mestio
            </h1>
          </div>

          {/* Form header */}
          <div>
            <h1 className="text-[28px] font-heading font-bold tracking-tight text-ink mb-2">
              Zaloguj się do Mestio
            </h1>
            <p className="text-[15px] text-ink/60 leading-relaxed">
              Przejdź do swojego panelu lub skorzystaj z natychmiastowego podglądu roli.
            </p>
          </div>

          {/* Quick Demo Launchers (Instantly test all 3 CRMs) */}
          <div className="bg-white rounded-[20px] p-5 shadow-[0_2px_12px_rgba(14,26,43,.06)] border border-[#EAF0F7] space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs font-mono font-semibold uppercase tracking-wider text-azure flex items-center gap-1.5">
                <Sparkles className="w-3.5 h-3.5 text-azure" />
                Szybki podgląd ról (Demo Mode)
              </span>
              <span className="text-[11px] font-medium text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-200">
                Włączone
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5 pt-1">
              <button
                type="button"
                onClick={() => handleDemoAccess("/owner/customers")}
                className="flex flex-col items-start p-3 rounded-[12px] bg-[#FAF9F6] border border-[#E0E6ED] hover:border-azure hover:bg-azure/5 transition-all text-left group"
              >
                <div className="w-7 h-7 rounded-lg bg-azure/10 text-azure flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
                  <Crown className="w-4 h-4" />
                </div>
                <span className="text-xs font-bold text-ink">CRM Owner</span>
                <span className="text-[10px] text-ink/50 mt-0.5">Właściciel platformy</span>
              </button>

              <button
                type="button"
                onClick={() => handleDemoAccess("/client/reports")}
                className="flex flex-col items-start p-3 rounded-[12px] bg-[#FAF9F6] border border-[#E0E6ED] hover:border-azure hover:bg-azure/5 transition-all text-left group"
              >
                <div className="w-7 h-7 rounded-lg bg-amber-500/10 text-amber-600 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
                  <Building2 className="w-4 h-4" />
                </div>
                <span className="text-xs font-bold text-ink">CRM Klienta</span>
                <span className="text-[10px] text-ink/50 mt-0.5">Zarządca / Admin</span>
              </button>

              <button
                type="button"
                onClick={() => handleDemoAccess("/resident/reports")}
                className="flex flex-col items-start p-3 rounded-[12px] bg-[#FAF9F6] border border-[#E0E6ED] hover:border-azure hover:bg-azure/5 transition-all text-left group"
              >
                <div className="w-7 h-7 rounded-lg bg-emerald-500/10 text-emerald-600 flex items-center justify-center mb-2 group-hover:scale-110 transition-transform">
                  <User className="w-4 h-4" />
                </div>
                <span className="text-xs font-bold text-ink">Mieszkaniec</span>
                <span className="text-[10px] text-ink/50 mt-0.5">Portal mieszkańca</span>
              </button>
            </div>
          </div>

          <div className="relative flex items-center justify-center">
            <div className="border-t border-[#EAF0F7] w-full" />
            <span className="bg-[#F9FAFB] px-3 text-xs text-ink/40 font-medium absolute">
              lub zaloguj się kontem Supabase
            </span>
          </div>

          {/* Standard Login Form */}
          {resetSent ? (
            <div className="bg-white rounded-[20px] p-6 text-center border border-[#EAF0F7] shadow-sm">
              <p className="text-base font-semibold text-ink mb-1">Sprawdź skrzynkę e-mail</p>
              <p className="text-xs text-ink/60 mb-4">Wysłaliśmy link resetujący na {email}</p>
              <button
                type="button"
                onClick={() => setResetSent(false)}
                className="text-xs font-semibold text-azure hover:underline"
              >
                ← Wróć do logowania
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-ink/70 mb-1.5">
                  Adres e-mail
                </label>
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="twoj@email.pl"
                  className="w-full px-4 py-2.5 rounded-xl border border-[#E0E6ED] bg-white text-sm text-ink outline-none focus:border-azure transition-all"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-ink/70 mb-1.5">
                  Hasło
                </label>
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  className="w-full px-4 py-2.5 rounded-xl border border-[#E0E6ED] bg-white text-sm text-ink outline-none focus:border-azure transition-all"
                />
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-xs text-red-600 font-medium">
                  {error}
                </div>
              )}

              <button
                type="submit"
                disabled={loading}
                className="w-full py-3 rounded-xl font-semibold text-sm text-white bg-gradient-to-r from-azure to-blueprint shadow-md hover:brightness-110 transition-all flex items-center justify-center gap-2"
              >
                {loading ? "Logowanie..." : "Zaloguj się"}
                <ArrowRight className="w-4 h-4" />
              </button>

              <div className="text-center pt-2">
                <button
                  type="button"
                  onClick={handleForgotPassword}
                  className="text-xs text-ink/50 hover:text-azure transition-colors"
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

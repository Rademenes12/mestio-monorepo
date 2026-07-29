"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import Link from "next/link";
import { contactSchema } from "@/lib/validations";
import { z } from "zod";

type ContactFormData = z.infer<typeof contactSchema>;

const CONTACT_INFO = [
  {
    icon: "M22 6l-10 7L2 6M2 6v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V6M2 6l2-2h16l2 2",
    k: "E-mail",
    v: "kontakt@mestio.pl",
  },
  {
    icon: "M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z",
    k: "Telefon",
    v: "+48 600 000 000",
  },
  {
    icon: "M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z M12 7a3 3 0 1 1 0 6 3 3 0 0 1 0-6z",
    k: "Adres",
    v: "ul. Przykładowa 1, 00-001 Warszawa",
  },
  {
    icon: "M3 3v18h18M7 17V9M12 17V5M17 17v-6",
    k: "NIP",
    v: "000-000-00-00",
  },
];

export default function KontaktPage() {
  const [sent, setSent] = useState(false);
  const [sending, setSending] = useState(false);
  const [serverError, setServerError] = useState("");

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ContactFormData>({
    resolver: zodResolver(contactSchema),
  });

  const onSubmit = async (data: ContactFormData) => {
    setServerError("");
    setSending(true);

    try {
      const res = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });

      if (!res.ok) {
        const json = await res.json();
        setServerError(json.error || "Wystąpił błąd. Spróbuj ponownie.");
        setSending(false);
        return;
      }

      setSent(true);
    } catch {
      setServerError("Nie można połączyć się z serwerem. Spróbuj ponownie.");
    } finally {
      setSending(false);
    }
  };

  return (
    <div className="flex min-h-screen">
      {/* Left panel: Branding */}
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
            <span className="text-white font-heading font-bold text-xl tracking-tight">
              Mestio
            </span>
          </div>

          {/* Value prop */}
          <h2 className="text-white font-heading font-bold text-3xl lg:text-4xl leading-tight mb-5">
            Porozmawiajmy o
            <br />
            Twoim osiedlu
          </h2>
          <p
            className="text-base leading-relaxed"
            style={{ color: "rgba(255,255,255,0.65)" }}
          >
            Masz pytanie o wdrożenie, demo lub wycenę? Napisz do nas —
            odpowiadamy w 1 dzień roboczy.
          </p>

          {/* Contact info list */}
          <div className="mt-10 space-y-5">
            {CONTACT_INFO.map((item, i) => (
              <div key={i} className="flex items-start gap-3">
                <div
                  className="w-9 h-9 rounded-lg flex items-center justify-center shrink-0"
                  style={{ background: "rgba(255,255,255,0.08)" }}
                >
                  <svg
                    width="17"
                    height="17"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="rgba(255,255,255,0.7)"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  >
                    <path d={item.icon} />
                  </svg>
                </div>
                <div className="pt-1">
                  <div
                    className="text-[11px] font-mono uppercase tracking-[0.5px] mb-0.5"
                    style={{ color: "rgba(255,255,255,0.4)" }}
                  >
                    {item.k}
                  </div>
                  <div
                    className="text-sm font-medium"
                    style={{ color: "rgba(255,255,255,0.85)" }}
                  >
                    {item.v}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <p
          className="relative z-10 text-xs"
          style={{ color: "rgba(255,255,255,0.3)" }}
        >
          © {new Date().getFullYear()} Mestio. System dla osiedli i wspólnot.
        </p>
      </div>

      {/* Right panel: Contact form */}
      <div
        className="flex-1 flex items-center justify-center p-6 lg:p-14"
        style={{ background: "#F9FAFB" }}
      >
        <div className="w-full" style={{ maxWidth: "480px" }}>
          {/* Mobile logo */}
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

          {/* Mobile contact info */}
          <div className="lg:hidden mb-8 grid grid-cols-2 gap-3">
            {CONTACT_INFO.map((item, i) => (
              <div
                key={i}
                className="rounded-xl p-3.5"
                style={{
                  background: "#fff",
                  border: "1px solid #EBEFF4",
                }}
              >
                <div
                  className="text-[10px] font-mono uppercase tracking-[0.4px] mb-1"
                  style={{ color: "#9AA7B8" }}
                >
                  {item.k}
                </div>
                <div className="text-[13px] font-medium" style={{ color: "#0E1A2B" }}>
                  {item.v}
                </div>
              </div>
            ))}
          </div>

          {/* Form header */}
          <div className="mb-8">
            <h1
              className="text-[28px] font-heading font-bold tracking-tight mb-2"
              style={{ color: "#0E1A2B" }}
            >
              Napisz do nas
            </h1>
            <p className="text-[15px] leading-relaxed" style={{ color: "#7C8AA0" }}>
              Odpowiadamy w ciągu 1 dnia roboczego.
            </p>
          </div>

          {sent ? (
            <div
              className="rounded-[16px] p-8 text-center"
              style={{
                background: "#fff",
                border: "1px solid #EBEFF4",
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
                Dziękujemy!
              </p>
              <p className="text-sm mb-6" style={{ color: "#7C8AA0" }}>
                Odezwiemy się w ciągu 1 dnia roboczego.
              </p>
              <button
                type="button"
                onClick={() => setSent(false)}
                className="text-sm font-medium transition-colors"
                style={{ color: "#3E7BD6" }}
                onMouseEnter={(e) => {
                  e.currentTarget.style.color = "#2A5FA8";
                }}
                onMouseLeave={(e) => {
                  e.currentTarget.style.color = "#3E7BD6";
                }}
              >
                ← Wyślij kolejną wiadomość
              </button>
            </div>
          ) : (
            <form onSubmit={handleSubmit(onSubmit)} noValidate>
              <div
                className="rounded-[16px] p-8"
                style={{
                  background: "#fff",
                  border: "1px solid #EBEFF4",
                  boxShadow: "0 1px 3px rgba(14,26,43,.04)",
                }}
              >
                <div className="space-y-5">
                  {/* Name + Email */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                    <div>
                      <label
                        htmlFor="kontakt-name"
                        className="block text-[13px] font-semibold mb-2"
                        style={{ color: "#4A5A6E" }}
                      >
                        Imię i nazwisko
                      </label>
                      <input
                        {...register("name")}
                        id="kontakt-name"
                        placeholder="Imię i nazwisko"
                        className="w-full px-4 py-3 rounded-[12px] text-[15px] transition-all outline-none"
                        style={{
                          background: "#F9FAFB",
                          border: errors.name
                            ? "1px solid #EF4444"
                            : "1px solid #EBEFF4",
                          color: "#0E1A2B",
                        }}
                        onFocus={(e) => {
                          e.currentTarget.style.borderColor = "#3E7BD6";
                          e.currentTarget.style.boxShadow =
                            "0 0 0 3px rgba(62,123,214,.12)";
                          e.currentTarget.style.background = "#fff";
                        }}
                        onBlur={(e) => {
                          e.currentTarget.style.borderColor = errors.name
                            ? "#EF4444"
                            : "#EBEFF4";
                          e.currentTarget.style.boxShadow = "none";
                          e.currentTarget.style.background = "#F9FAFB";
                        }}
                        aria-invalid={!!errors.name}
                      />
                      {errors.name && (
                        <p className="text-xs text-red-500 mt-1.5 font-medium" role="alert">
                          {errors.name.message}
                        </p>
                      )}
                    </div>
                    <div>
                      <label
                        htmlFor="kontakt-email"
                        className="block text-[13px] font-semibold mb-2"
                        style={{ color: "#4A5A6E" }}
                      >
                        Adres e-mail
                      </label>
                      <input
                        {...register("email")}
                        id="kontakt-email"
                        type="email"
                        placeholder="twój@email.pl"
                        className="w-full px-4 py-3 rounded-[12px] text-[15px] transition-all outline-none"
                        style={{
                          background: "#F9FAFB",
                          border: errors.email
                            ? "1px solid #EF4444"
                            : "1px solid #EBEFF4",
                          color: "#0E1A2B",
                        }}
                        onFocus={(e) => {
                          e.currentTarget.style.borderColor = "#3E7BD6";
                          e.currentTarget.style.boxShadow =
                            "0 0 0 3px rgba(62,123,214,.12)";
                          e.currentTarget.style.background = "#fff";
                        }}
                        onBlur={(e) => {
                          e.currentTarget.style.borderColor = errors.email
                            ? "#EF4444"
                            : "#EBEFF4";
                          e.currentTarget.style.boxShadow = "none";
                          e.currentTarget.style.background = "#F9FAFB";
                        }}
                        aria-invalid={!!errors.email}
                      />
                      {errors.email && (
                        <p className="text-xs text-red-500 mt-1.5 font-medium" role="alert">
                          {errors.email.message}
                        </p>
                      )}
                    </div>
                  </div>

                  {/* Message */}
                  <div>
                    <label
                      htmlFor="kontakt-message"
                      className="block text-[13px] font-semibold mb-2"
                      style={{ color: "#4A5A6E" }}
                    >
                      Wiadomość
                    </label>
                    <textarea
                      {...register("message")}
                      id="kontakt-message"
                      rows={5}
                      placeholder="Opisz swoje pytanie..."
                      className="w-full px-4 py-3 rounded-[12px] text-[15px] transition-all outline-none resize-none"
                      style={{
                        background: "#F9FAFB",
                        border: errors.message
                          ? "1px solid #EF4444"
                          : "1px solid #EBEFF4",
                        color: "#0E1A2B",
                      }}
                      onFocus={(e) => {
                        e.currentTarget.style.borderColor = "#3E7BD6";
                        e.currentTarget.style.boxShadow =
                          "0 0 0 3px rgba(62,123,214,.12)";
                        e.currentTarget.style.background = "#fff";
                      }}
                      onBlur={(e) => {
                        e.currentTarget.style.borderColor = errors.message
                          ? "#EF4444"
                          : "#EBEFF4";
                        e.currentTarget.style.boxShadow = "none";
                        e.currentTarget.style.background = "#F9FAFB";
                      }}
                      aria-invalid={!!errors.message}
                    />
                    {errors.message && (
                      <p className="text-xs text-red-500 mt-1.5 font-medium" role="alert">
                        {errors.message.message}
                      </p>
                    )}
                  </div>

                  {/* RODO */}
                  <div>
                    <label className="flex items-start gap-2.5 cursor-pointer">
                      <input
                        type="checkbox"
                        {...register("acceptRodo")}
                        className="mt-[3px] shrink-0 w-4 h-4 rounded accent-[#3E7BD6]"
                      />
                      <span
                        className="text-[12px] leading-relaxed"
                        style={{ color: "#5A6B80" }}
                      >
                        Wyrażam zgodę na przetwarzanie danych osobowych zgodnie z{" "}
                        <Link
                          href="/polityka"
                          target="_blank"
                          className="underline"
                          style={{ color: "#3E7BD6" }}
                        >
                          polityką prywatności
                        </Link>
                      </span>
                    </label>
                    {errors.acceptRodo && (
                      <p className="text-xs text-red-500 mt-1.5 font-medium" role="alert">
                        {errors.acceptRodo.message}
                      </p>
                    )}
                  </div>

                  {serverError && (
                    <div
                      className="p-3.5 rounded-[12px] text-[13px] font-medium"
                      style={{
                        background: "rgba(239,68,68,.08)",
                        color: "#EF4444",
                        border: "1px solid rgba(239,68,68,.15)",
                      }}
                    >
                      {serverError}
                    </div>
                  )}

                  {/* Submit */}
                  <button
                    type="submit"
                    disabled={sending}
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
                    {sending ? "Wysyłanie..." : "Wyślij wiadomość"}
                    {!sending && (
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
            </form>
          )}
        </div>
      </div>
    </div>
  );
}

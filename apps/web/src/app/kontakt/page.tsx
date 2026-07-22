"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import Link from "next/link";
import { contactSchema } from "@/lib/validations";
import { z } from "zod";

type ContactFormData = z.infer<typeof contactSchema>;

const labelClass =
  "font-mono text-[10px] tracking-[0.5px] uppercase text-[#8A98AB] mb-[6px]";
const inputClass =
  "w-full text-sm bg-[#F4F7FB] rounded-[11px] px-[13px] py-3 text-ink placeholder:text-[#B6C2D2] border border-transparent focus:border-azure/30 focus:bg-white transition-colors";
const errorClass = "text-xs text-red-500 mt-1 font-medium";

const CONTACT_INFO = [
  { k: "E-mail", v: "kontakt@mestio.pl" },
  { k: "Telefon", v: "xxxx" },
  { k: "Adres", v: "xxxx" },
  { k: "NIP", v: "xxxx" },
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
    <div className="max-w-[960px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
        Kontakt
      </h1>
      <p className="text-[15px] text-[#4A5A6E] mt-2">
        Masz pytanie o wdrożenie Mestio? Napisz — odpowiadamy w 1 dzień
        roboczy.
      </p>

      <div className="grid grid-cols-1 lg:grid-cols-[1.2fr_0.8fr] gap-[22px] mt-7 items-start">
        <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-6">
          {sent ? (
            <div className="text-center py-8">
              <div className="w-[56px] h-[56px] rounded-full bg-[rgba(46,158,107,.13)] flex items-center justify-center mx-auto">
                <svg
                  width="28"
                  height="28"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#2E9E6B"
                  strokeWidth="2.4"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M5 12l5 5 9-11" />
                </svg>
              </div>
              <p className="font-heading font-semibold text-lg mt-4 text-ink">
                Dziękujemy!
              </p>
              <p className="text-sm text-[#5A6B80] mt-2">
                Odezwiemy się w ciągu 1 dnia roboczego.
              </p>
            </div>
          ) : (
            <form onSubmit={handleSubmit(onSubmit)} noValidate>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-[14px]">
                <div>
                  <label htmlFor="kontakt-name" className={labelClass}>Imię i nazwisko</label>
                  <input
                    {...register("name")}
                    id="kontakt-name"
                    placeholder="Imię i nazwisko"
                    className={`${inputClass} ${errors.name ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                    aria-invalid={!!errors.name}
                    aria-describedby={errors.name ? "err-name" : undefined}
                  />
                  {errors.name && (
                    <p id="err-name" className={errorClass} role="alert">{errors.name.message}</p>
                  )}
                </div>
                <div>
                  <label htmlFor="kontakt-email" className={labelClass}>E-mail</label>
                  <input
                    {...register("email")}
                    id="kontakt-email"
                    type="email"
                    placeholder="twój@email.pl"
                    className={`${inputClass} ${errors.email ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                    aria-invalid={!!errors.email}
                    aria-describedby={errors.email ? "err-email" : undefined}
                  />
                  {errors.email && (
                    <p id="err-email" className={errorClass} role="alert">{errors.email.message}</p>
                  )}
                </div>
              </div>
              <div className="mt-[14px]">
                <label htmlFor="kontakt-message" className={labelClass}>Wiadomość</label>
                <textarea
                  {...register("message")}
                  id="kontakt-message"
                  className={`w-full min-h-[120px] resize-none text-sm bg-[#F4F7FB] rounded-[11px] px-[14px] py-[13px] text-ink border border-transparent focus:border-azure/30 focus:bg-white transition-colors ${errors.message ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                  placeholder="Opisz swoje pytanie..."
                  aria-invalid={!!errors.message}
                  aria-describedby={errors.message ? "err-message" : undefined}
                />
                {errors.message && (
                  <p id="err-message" className={errorClass} role="alert">{errors.message.message}</p>
                )}
              </div>

              <div className="mt-4 space-y-3">
                <label className="flex items-start gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    {...register("acceptRodo")}
                    className="mt-[3px] shrink-0 accent-azure"
                  />
                  <span className="text-[12px] text-[#5A6B80] leading-relaxed">
                    Wyrażam zgodę na przetwarzanie danych osobowych zgodnie z{" "}
                    <Link href="/polityka" target="_blank" className="text-azure underline">polityką prywatności</Link>
                  </span>
                </label>
                {errors.acceptRodo && (
                  <p id="err-acceptRodo" className={errorClass} role="alert">{errors.acceptRodo.message}</p>
                )}
              </div>

              {serverError && (
                <p className="mt-3 text-sm text-red-500 font-medium" role="alert">{serverError}</p>
              )}
              <button
                type="submit"
                disabled={sending}
                className="mt-4 inline-block bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[15px] px-[26px] py-[14px] rounded-[13px] cursor-pointer hover:brightness-110 transition-all disabled:opacity-50"
              >
                {sending ? "Wysyłanie..." : "Wyślij wiadomość"}
              </button>
            </form>
          )}
        </div>

        <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-6">
          <div className="flex flex-col gap-4">
            {CONTACT_INFO.map((item) => (
              <div key={item.k}>
                <div className={labelClass}>{item.k}</div>
                <div className="text-[14.5px] font-medium text-ink mt-1">
                  {item.v}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

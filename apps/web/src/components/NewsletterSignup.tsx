"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import Link from "next/link";
import { newsletterSchema } from "@/lib/validations";
import { z } from "zod";

type NewsletterFormData = z.infer<typeof newsletterSchema>;

export default function NewsletterSignup() {
  const [sent, setSent] = useState(false);
  const [sending, setSending] = useState(false);
  const [serverError, setServerError] = useState("");

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<NewsletterFormData>({
    resolver: zodResolver(newsletterSchema),
  });

  const onSubmit = async (data: NewsletterFormData) => {
    setServerError("");
    setSending(true);

    try {
      const res = await fetch("/api/newsletter", {
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
      setServerError("Nie można połączyć się z serwerem.");
    } finally {
      setSending(false);
    }
  };

  return (
    <div className="mt-[26px] bg-gradient-to-br from-blueprint to-ink rounded-[12px] p-[26px_28px]">
      <div className="flex items-center justify-between gap-5 flex-wrap">
        <div className="max-w-[520px]">
          <h2 className="font-heading font-bold text-[19px] text-white">
            Chcesz taki artykuł co tydzień?
          </h2>
          <p className="text-[13.5px] text-[#C7D2E0] mt-[6px] leading-relaxed">
            Zapisz się na newsletter dla zarządców — praktyczne poradniki prosto
            na skrzynkę.
          </p>
        </div>
        {sent ? (
          <div className="flex items-center gap-2 text-white font-semibold text-[13.5px]">
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#7FE0AE"
              strokeWidth="2.4"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="M20 6L9 17l-5-5" />
            </svg>
            Zapisano na newsletter!
          </div>
        ) : (
          <form className="flex items-start gap-2" onSubmit={handleSubmit(onSubmit)} noValidate>
            <div>
              <div className="flex gap-2">
                <label htmlFor="newsletter-email" className="sr-only">Adres e-mail do newslettera</label>
                <input
                  {...register("email")}
                  id="newsletter-email"
                  type="email"
                  placeholder="twój e-mail"
                  className={`w-[220px] text-[13.5px] bg-white/10 border rounded-[11px] px-[14px] py-[11px] text-white placeholder:text-white/40 ${errors.email || serverError ? "border-red-400" : "border-white/20"}`}
                  aria-invalid={!!(errors.email || serverError)}
                  aria-describedby={errors.email ? "newsletter-err-email" : serverError ? "newsletter-err" : undefined}
                />
                <button
                  type="submit"
                  disabled={sending}
                  className="bg-white text-blueprint font-semibold text-[13.5px] px-[18px] py-[11px] rounded-[11px] cursor-pointer whitespace-nowrap hover:brightness-95 transition-all disabled:opacity-50"
                >
                  {sending ? "..." : "Zapisz się"}
                </button>
              </div>
              {errors.email && (
                <p id="newsletter-err-email" className="text-xs text-red-400 mt-1" role="alert">{errors.email.message}</p>
              )}
              {serverError && (
                <p id="newsletter-err" className="text-xs text-red-400 mt-1" role="alert">{serverError}</p>
              )}
              <label className="flex items-start gap-2 cursor-pointer mt-2">
                <input
                  type="checkbox"
                  {...register("acceptRodo")}
                  className="mt-[3px] shrink-0 accent-azure"
                />
                <span className="text-[11px] text-[#C7D2E0] leading-relaxed">
                  Wyrażam zgodę na przetwarzanie danych zgodnie z{" "}
                  <Link href="/polityka" target="_blank" className="text-white underline">polityką prywatności</Link>
                </span>
              </label>
              {errors.acceptRodo && (
                <p className="text-xs text-red-400 mt-1" role="alert">{errors.acceptRodo.message}</p>
              )}
            </div>
          </form>
        )}
      </div>
    </div>
  );
}

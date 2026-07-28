"use client";

import { useState, useMemo, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { loadStripe } from "@stripe/stripe-js";
import {
  EmbeddedCheckoutProvider,
  EmbeddedCheckout,
} from "@stripe/react-stripe-js";
import { registrationSchema, RegistrationInput } from "@/lib/validations";
import Link from "next/link";

interface TransferData {
  paymentId: string;
  amount: number;
  transferTitle: string;
  dueDate: string;
  bankAccount: {
    bank: string;
    account: string;
    swift: string;
    owner: string;
  };
}

import { PLANS as PRICING_PLANS } from "@/lib/pricing";

const PLANS = PRICING_PLANS.map((p) => ({
  key: p.key,
  name: p.name,
  price: p.priceDisplay,
}));

const REG_BENEFITS = [
  "Panel zarządu w aplikacji (tryb biura)",
  "Kody zaproszeń dla mieszkańców",
  "Wszystkie funkcje wybranego planu",
  "Faktura VAT i wsparcie e-mail",
];

type FormData = RegistrationInput;

const labelClass =
  "font-mono text-[10px] tracking-[0.5px] uppercase text-[#8A98AB] mb-[6px]";
const inputClass =
  "w-full text-sm bg-[#F4F7FB] rounded-[11px] px-[13px] py-3 text-ink placeholder:text-[#B6C2D2] border border-transparent focus:border-azure/30 focus:bg-white transition-colors";
const errorClass = "text-xs text-red-500 mt-1 font-medium";

function ZamowContent() {
  const searchParams = useSearchParams();
  const defaultPlan = searchParams.get("plan") || "standard";
  const [plan, setPlan] = useState(defaultPlan);
  const [paymentMethod, setPaymentMethod] = useState<"card" | "blik" | "transfer">("card");
  const [submitting, setSubmitting] = useState(false);
  const [serverError, setServerError] = useState("");
  const [clientSecret, setClientSecret] = useState<string | null>(null);
  const [transferData, setTransferData] = useState<TransferData | null>(null);
  const [copied, setCopied] = useState(false);

  const stripePromise = useMemo(
    () => loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || ""),
    []
  );

  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(registrationSchema),
    defaultValues: {
      plan: (["start", "standard", "pro", "enterprise"].includes(defaultPlan)
        ? defaultPlan
        : "standard") as FormData["plan"],
    },
  });

  const onSubmit = async (data: FormData) => {
    setSubmitting(true);
    setServerError("");

    const endpoint =
      paymentMethod === "transfer"
        ? "/api/create-transfer"
        : paymentMethod === "blik"
        ? "/api/create-payment"
        : "/api/create-checkout";

    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email: data.email,
          password: data.password,
          companyName: data.companyName,
          nip: data.nip,
          contactName: data.contactName,
          phone: data.phone,
          estateName: data.estateName,
          plan,
          acceptRegulamin: data.acceptRegulamin,
          acceptRodo: data.acceptRodo,
          acceptNoWithdrawal: data.acceptNoWithdrawal,
        }),
      });

      const json = await res.json();

      if (!res.ok) {
        setServerError(json.error || "Wystąpił błąd. Spróbuj ponownie.");
        setSubmitting(false);
        return;
      }

      if (paymentMethod === "transfer") {
        setTransferData(json);
        setSubmitting(false);
      } else if (paymentMethod === "blik" && json.url) {
        // BLIK/P24 → przekierowanie na hosted Stripe Checkout
        window.location.href = json.url;
      } else if (json.clientSecret) {
        // Karta → embedded checkout
        setClientSecret(json.clientSecret);
        setSubmitting(false);
      } else {
        setSubmitting(false);
      }
    } catch {
      setServerError("Nie można połączyć się z serwerem. Spróbuj ponownie.");
      setSubmitting(false);
    }
  };

  if (transferData) {
    const planLabel = PLANS.find((p) => p.key === plan)?.price || "";
    return (
      <div className="max-w-[720px] mx-auto px-6 py-[50px] pb-[70px]">
        <div className="w-[56px] h-[56px] rounded-full bg-[rgba(242,169,0,.13)] flex items-center justify-center mx-auto">
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#F2A900"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <rect x="2" y="6" width="20" height="12" rx="2" />
            <path d="M6 12h4M14 12h4" />
          </svg>
        </div>
        <h1 className="font-heading font-bold text-[28px] tracking-[-0.5px] text-ink mt-5 text-center">
          Polecenie przelewu
        </h1>
        <p className="text-[15px] text-[#4A5A6E] mt-2 text-center leading-relaxed">
          Aby aktywować konto, wykonaj przelew na poniższe dane. Środki muszą
          wpłynąć w ciągu 7 dni.
        </p>

        <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-6 mt-6 space-y-4">
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Plan
            </span>
            <span className="text-[15px] font-semibold text-ink">
              {planLabel}
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Kwota
            </span>
            <span className="text-[20px] font-bold text-ink">
              {(transferData.amount / 100).toFixed(2).replace(".", ",")} PLN
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Termin płatności
            </span>
            <span className="text-[14px] font-semibold text-ink">
              {new Date(transferData.dueDate).toLocaleDateString("pl-PL")}
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Odbiorca
            </span>
            <span className="text-[14px] text-ink text-right">
              {transferData.bankAccount.owner}
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Bank
            </span>
            <span className="text-[14px] text-ink">
              {transferData.bankAccount.bank}
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              SWIFT
            </span>
            <span className="text-[14px] font-mono font-semibold text-ink">
              {transferData.bankAccount.swift}
            </span>
          </div>
          <div className="flex justify-between items-center pb-3 border-b border-[#E2E9F2]">
            <span className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB]">
              Tytuł przelewu
            </span>
            <span className="text-[14px] font-mono font-semibold text-blueprint">
              {transferData.transferTitle}
            </span>
          </div>
          <div>
            <div className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB] mb-2">
              Numer konta
            </div>
            <div className="flex items-center gap-2 bg-paper rounded-[11px] px-4 py-3 border border-[#E2E9F2]">
              <span className="font-mono font-semibold text-[15px] text-blueprint tracking-[1px]">
                {transferData.bankAccount.account}
              </span>
              <button
                type="button"
                onClick={() => {
                  navigator.clipboard.writeText(transferData.bankAccount.account);
                  setCopied(true);
                  setTimeout(() => setCopied(false), 2000);
                }}
                className="ml-auto shrink-0 flex items-center gap-[5px] px-3 py-[7px] rounded-[9px] bg-white text-blueprint text-[12px] font-semibold cursor-pointer hover:bg-[#EAF0F7] transition-colors border border-[#E2E9F2]"
              >
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#173A6A"
                  strokeWidth="1.9"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M9 9h10v10H9zM5 15V5h10" />
                </svg>
                {copied ? "Skopiowano!" : "Kopiuj"}
              </button>
            </div>
          </div>
        </div>

        <p className="text-[12.5px] text-[#8A98AB] mt-5 text-center leading-relaxed">
          Po zaksięgowaniu wpłaty na koncie (zwykle 1–2 dni robocze)
          otrzymasz e-mail z potwierdzeniem i kodem zaproszenia.
        </p>
        <Link
          href="/"
          className="block text-center mt-4 text-sm font-semibold text-azure hover:underline"
        >
          &larr; Wróć na stronę główną
        </Link>
      </div>
    );
  }

  if (clientSecret) {
    return (
      <div className="max-w-[720px] mx-auto px-6 py-[50px] pb-[70px]">
        <h1 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink mb-6">
          Dokończ płatność
        </h1>
        <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-6">
          <EmbeddedCheckoutProvider
            stripe={stripePromise}
            options={{ clientSecret }}
          >
            <EmbeddedCheckout />
          </EmbeddedCheckoutProvider>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-[960px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
        Zamów Mestio dla osiedla
      </h1>
      <p className="text-[15px] text-[#4A5A6E] mt-2">
        Rejestrujesz firmę / zarząd. Płatność odbywa się bezpiecznie przez
        Stripe — w aplikacji mieszkańca nie ma żadnych opłat.
      </p>

      <form
        onSubmit={handleSubmit(onSubmit)}
        className="grid grid-cols-1 lg:grid-cols-[1.3fr_0.9fr] gap-[22px] mt-7 items-start"
        noValidate
        aria-busy={submitting}
      >
        <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-6">
          <div className={labelClass}>Wybierz plan</div>

          <div className="flex gap-2 flex-wrap" role="radiogroup" aria-label="Wybierz plan subskrypcji">
            {PLANS.map((p) => (
              <button
                key={p.key}
                type="button"
                onClick={() => {
                  setPlan(p.key);
                  setValue("plan", p.key as FormData["plan"], { shouldValidate: true });
                }}
                role="radio"
                aria-checked={plan === p.key}
                className="px-[14px] py-[9px] rounded-[11px] text-[13px] font-semibold cursor-pointer transition-colors"
                style={{
                  background:
                    plan === p.key
                      ? "rgba(62,123,214,.13)"
                      : "#F4F7FB",
                  color: plan === p.key ? "#173A6A" : "#5A6B80",
                  border: `1px solid ${
                    plan === p.key ? "#3E7BD6" : "#E2E9F2"
                  }`,
                }}
              >
                {p.name} &middot; {p.price}
              </button>
            ))}
          </div>

          <div className="mt-4">
            <div className={labelClass}>Sposób płatności</div>
            <div className="flex gap-2 mt-1 flex-wrap">
              <button
                type="button"
                onClick={() => setPaymentMethod("card")}
                className={`px-4 py-2 rounded-[11px] text-[13px] font-semibold transition-colors ${
                  paymentMethod === "card"
                    ? "bg-azure/13 text-blueprint border border-azure"
                    : "bg-paper text-[#5A6B80] border border-transparent"
                }`}
              >
                💳 Karta (autopłatność)
              </button>
              <button
                type="button"
                onClick={() => setPaymentMethod("blik")}
                className={`px-4 py-2 rounded-[11px] text-[13px] font-semibold transition-colors ${
                  paymentMethod === "blik"
                    ? "bg-azure/13 text-blueprint border border-azure"
                    : "bg-paper text-[#5A6B80] border border-transparent"
                }`}
              >
                📱 BLIK / Przelewy24
              </button>
              <button
                type="button"
                onClick={() => setPaymentMethod("transfer")}
                className={`px-4 py-2 rounded-[11px] text-[13px] font-semibold transition-colors ${
                  paymentMethod === "transfer"
                    ? "bg-azure/13 text-blueprint border border-azure"
                    : "bg-paper text-[#5A6B80] border border-transparent"
                }`}
              >
                🏦 Przelew tradycyjny
              </button>
            </div>
            <p className="text-[11px] text-[#8A98AB] mt-2">
              {paymentMethod === "card" && "Płatność automatyczna co miesiąc (możesz anulować w każdej chwili)"}
              {paymentMethod === "blik" && "Pierwszy miesiąc teraz, kolejne - faktury e-mailem do ręcznej płatności"}
              {paymentMethod === "transfer" && "Otrzymasz dane do przelewu (płatność ręczna co miesiąc)"}
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-[14px] gap-y-4 mt-5">
            <div>
              <label htmlFor="companyName" className={labelClass}>Nazwa firmy / wspólnoty</label>
              <input
                {...register("companyName")}
                id="companyName"
                placeholder="np. Atlanti Sp. z o.o."
                className={`${inputClass} ${errors.companyName ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.companyName}
                aria-describedby={errors.companyName ? "err-companyName" : undefined}
              />
              {errors.companyName && (
                <p id="err-companyName" className={errorClass} role="alert">{errors.companyName.message}</p>
              )}
            </div>
            <div>
              <label htmlFor="nip" className={labelClass}>NIP</label>
              <input
                {...register("nip")}
                id="nip"
                placeholder="000-000-00-00"
                className={`${inputClass} ${errors.nip ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.nip}
                aria-describedby={errors.nip ? "err-nip" : undefined}
              />
              {errors.nip && (
                <p id="err-nip" className={errorClass} role="alert">{errors.nip.message}</p>
              )}
            </div>
            <div>
              <label htmlFor="contactName" className={labelClass}>Imię i nazwisko</label>
              <input
                {...register("contactName")}
                id="contactName"
                placeholder="Osoba kontaktowa"
                className={`${inputClass} ${errors.contactName ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.contactName}
                aria-describedby={errors.contactName ? "err-contactName" : undefined}
              />
              {errors.contactName && (
                <p id="err-contactName" className={errorClass} role="alert">{errors.contactName.message}</p>
              )}
            </div>
            <div>
              <label htmlFor="phone" className={labelClass}>Telefon</label>
              <input
                {...register("phone")}
                id="phone"
                placeholder="+48 600 000 000"
                className={`${inputClass} ${errors.phone ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.phone}
                aria-describedby={errors.phone ? "err-phone" : undefined}
              />
              {errors.phone && (
                <p id="err-phone" className={errorClass} role="alert">{errors.phone.message}</p>
              )}
            </div>
            <div className="sm:col-span-2">
              <label htmlFor="email" className={labelClass}>E-mail (logowanie do panelu)</label>
              <input
                {...register("email")}
                id="email"
                type="email"
                placeholder="biuro@firma.pl"
                className={`${inputClass} ${errors.email ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.email}
                aria-describedby={errors.email ? "err-email" : undefined}
              />
              {errors.email && (
                <p id="err-email" className={errorClass} role="alert">{errors.email.message}</p>
              )}
            </div>
            <div className="sm:col-span-2">
              <label htmlFor="password" className={labelClass}>Hasło</label>
              <input
                {...register("password")}
                id="password"
                type="password"
                placeholder="Min. 8 znaków"
                className={`${inputClass} ${errors.password ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.password}
                aria-describedby={errors.password ? "err-password" : undefined}
              />
              {errors.password && (
                <p id="err-password" className={errorClass} role="alert">{errors.password.message}</p>
              )}
            </div>
            <div className="sm:col-span-2">
              <label htmlFor="estateName" className={labelClass}>Nazwa osiedla</label>
              <input
                {...register("estateName")}
                id="estateName"
                placeholder="np. Osiedle Słoneczne Wzgórza"
                className={`${inputClass} ${errors.estateName ? "border-red-400 focus:border-red-400 bg-red-50/30" : ""}`}
                aria-invalid={!!errors.estateName}
                aria-describedby={errors.estateName ? "err-estateName" : undefined}
              />
              {errors.estateName && (
                <p id="err-estateName" className={errorClass} role="alert">{errors.estateName.message}</p>
              )}
            </div>
          </div>

          {serverError && (
            <p className="mt-4 text-sm text-red-500 font-medium text-center" role="alert">
              {serverError}
            </p>
          )}

          <div className="mt-4 space-y-3">
            <label className="flex items-start gap-2 cursor-pointer">
              <input
                type="checkbox"
                {...register("acceptRegulamin")}
                className="mt-[3px] shrink-0 accent-azure"
              />
              <span className="text-[12px] text-[#5A6B80] leading-relaxed">
                Akceptuję{" "}
                <Link href="/regulamin" target="_blank" className="text-azure underline">regulamin</Link>{" "}
                świadczenia usług Mestio
              </span>
            </label>
            {errors.acceptRegulamin && (
              <p id="err-acceptRegulamin" className={errorClass} role="alert">{errors.acceptRegulamin.message}</p>
            )}
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
            <label className="flex items-start gap-2 cursor-pointer">
              <input
                type="checkbox"
                {...register("acceptNoWithdrawal")}
                className="mt-[3px] shrink-0 accent-azure"
              />
              <span className="text-[12px] text-[#5A6B80] leading-relaxed">
                Potwierdzam, że znam i akceptuję fakt, iż{" "}
                <strong className="text-ink">nie przysługuje mi prawo odstąpienia od umowy</strong>{" "}
                (zgodnie z Art. 38 pkt 1 ustawy o prawach konsumenta) po rozpoczęciu świadczenia usługi cyfrowej
              </span>
            </label>
            {errors.acceptNoWithdrawal && (
              <p id="err-acceptNoWithdrawal" className={errorClass} role="alert">{errors.acceptNoWithdrawal.message}</p>
            )}
          </div>

          <button
            type="submit"
            disabled={submitting}
            aria-disabled={submitting}
            className="mt-[22px] w-full flex items-center justify-center gap-[9px] bg-[#635BFF] text-white font-semibold text-[15px] py-[15px] rounded-[13px] cursor-pointer hover:bg-[#5749E5] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {submitting ? (
              "Przetwarzanie..."
            ) : paymentMethod === "transfer" ? (
              <>
                Utwórz konto i wygeneruj przelew
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#fff"
                  strokeWidth="2.4"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M5 12h13M13 6l6 6-6 6" />
                </svg>
              </>
            ) : (
              <>
                Przejdź do bezpiecznej płatności
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#fff"
                  strokeWidth="2.4"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                >
                  <path d="M5 12h13M13 6l6 6-6 6" />
                </svg>
              </>
            )}
          </button>

          {paymentMethod === "transfer" ? (
            <div className="flex items-center justify-center gap-[6px] mt-3 text-xs text-[#9AA7B8]">
              <svg
                width="13"
                height="13"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#9AA7B8"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <rect x="2" y="6" width="20" height="12" rx="2" />
                <path d="M6 12h4M14 12h4" />
              </svg>
              Po utworzeniu konta zobaczysz dane do przelewu. Płatność sprawdzamy ręcznie.
            </div>
          ) : (
            <div className="flex items-center justify-center gap-[6px] mt-3 text-xs text-[#9AA7B8]">
              <svg
                width="13"
                height="13"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#9AA7B8"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M6 10V8a6 6 0 0 1 12 0v2M5 10h14v10H5z" />
              </svg>
              Płatność obsługuje Stripe. Nie przechowujemy danych karty.
            </div>
          )}
        </div>

        <div className="bg-ink rounded-[18px] p-6 text-white">
          <div
            className={labelClass}
            style={{ color: "#8FA6C4" }}
          >
            Co dostajesz
          </div>
          <div className="flex flex-col gap-3 mt-4">
            {REG_BENEFITS.map((benefit) => (
              <div key={benefit} className="flex gap-[9px] items-start">
                <svg
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#7FE0AE"
                  strokeWidth="2.4"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  className="shrink-0 mt-[1px]"
                >
                  <path d="M5 12l5 5 9-11" />
                </svg>
                <span className="text-[13.5px] text-[#D5DEEC] leading-relaxed">
                  {benefit}
                </span>
              </div>
            ))}
          </div>
          <div className="mt-5 pt-4 border-t border-white/[.12] text-[12.5px] text-[#9FB2CC] leading-relaxed">
            Po opłaceniu automatycznie utworzymy Twoje osiedle i wygenerujemy{" "}
            <b className="text-white">kody zaproszeń</b> dla mieszkańców.
          </div>
        </div>
      </form>
    </div>
  );
}

export default function ZamowPage() {
  return (
    <Suspense
      fallback={
        <div className="py-20 text-center text-[#8A98AB]">Ładowanie...</div>
      }
    >
      <ZamowContent />
    </Suspense>
  );
}

"use client";

import { useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";

const STEPS = [
  {
    title: "Witamy w Mestio",
    description:
      "Cieszymy się, że jesteś z nami! Właśnie zrobiłeś pierwszy krok do nowoczesnego zarządzania swoim osiedlem.",
    content: (
      <div className="space-y-4">
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          Twoje konto zostało pomyślnie utworzone. W ciągu kilku chwil
          otrzymasz kod zaproszenia, który pozwoli Ci zalogować się do panelu
          zarządcy.
        </p>
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          W kolejnych krokach pokażemy Ci, jak skonfigurować osiedle, zaprosić
          mieszkańców i w pełni wykorzystać możliwości Mestio.
        </p>
        <div className="bg-[rgba(62,123,214,.08)] rounded-[14px] p-4 border border-azure/20">
          <p className="text-[13px] text-blueprint font-semibold">
            Pierwsze 3 miesiące gratis
          </p>
          <p className="text-[12px] text-[#4A5A6E] mt-1">
            Pełen dostęp do wszystkich funkcji bez zobowiązań.
          </p>
        </div>
      </div>
    ),
  },
  {
    title: "Kody zaproszeń",
    description:
      "Udostępnij swoim mieszkańcom kody zaproszeń, aby mogli dołączyć do osiedla w aplikacji.",
    content: (
      <div className="space-y-4">
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          Po aktywacji konta na stronie potwierdzenia zobaczysz unikalny kod
          zaproszenia dla mieszkańców.
        </p>
        <div className="bg-[rgba(62,123,214,.08)] rounded-[14px] p-4 border border-azure/20">
          <div className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB] mb-2">
            Przykładowy kod
          </div>
          <div className="font-mono font-semibold text-[22px] tracking-[2px] text-blueprint">
            MEST-ABC123
          </div>
        </div>
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          Kod możesz wysłać mieszkańcom przez e-mail, SMS lub wydrukować i
          wywiesić na klatce schodowej. Każdy mieszkaniec potrzebuje kodu, aby
          zarejestrować się w aplikacji i zgłaszać usterki.
        </p>
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          W panelu zarządcy będziesz mógł wygenerować dodatkowe kody i
          zarządzać dostępem.
        </p>
      </div>
    ),
  },
  {
    title: "Aplikacja mieszkańca",
    description:
      "Twoi mieszkańcy korzystają z aplikacji mobilnej do zgłaszania usterek i śledzenia napraw.",
    content: (
      <div className="space-y-4">
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed">
          Aplikacja Mestio jest dostępna na urządzenia z systemem iOS oraz
          Android. Mieszkańcy mogą szybko zgłaszać usterki, dodawać zdjęcia i
          śledzić status napraw.
        </p>
        <div className="flex gap-3 justify-center flex-wrap mt-2">
          <button className="flex items-center gap-[9px] bg-ink text-white px-5 py-[13px] rounded-[13px] cursor-pointer hover:bg-ink/90 transition-colors">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="#fff">
              <path d="M16.4 12.6c0-2 1.6-2.9 1.7-3-1-1.4-2.4-1.6-2.9-1.6-1.2-.1-2.4.7-3 .7-.6 0-1.6-.7-2.6-.7-1.3 0-2.6.8-3.3 2-1.4 2.4-.4 6 1 8 .7 1 1.4 2 2.4 2 1 0 1.3-.6 2.5-.6s1.5.6 2.5.6 1.7-1 2.3-2c.7-1.1 1-2.2 1-2.3-.1 0-2-.8-2-3.1zM14.5 6.3c.5-.7.9-1.6.8-2.5-.8 0-1.7.5-2.3 1.2-.5.6-.9 1.5-.8 2.4.9.1 1.8-.4 2.3-1.1z" />
            </svg>
            <div className="text-left">
              <div className="text-[9px] opacity-80">Pobierz z</div>
              <div className="font-heading font-semibold text-sm">App Store</div>
            </div>
          </button>
          <button className="flex items-center gap-[9px] bg-ink text-white px-5 py-[13px] rounded-[13px] cursor-pointer hover:bg-ink/90 transition-colors">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M4 3l11 9-11 9z" fill="#3E7BD6" />
              <path d="M4 3l8 6-8 6z" fill="#2E9E6B" />
              <path d="M15 12l4-2.3v4.6z" fill="#F2A900" />
            </svg>
            <div className="text-left">
              <div className="text-[9px] opacity-80">Pobierz z</div>
              <div className="font-heading font-semibold text-sm">Google Play</div>
            </div>
          </button>
        </div>
        <p className="text-[13px] text-[#8A98AB] text-center">
          Linki do pobrania pojawią się po oficjalnym uruchomieniu.
        </p>
      </div>
    ),
  },
  {
    title: "Gotowe!",
    description:
      "Twoje konto jest gotowe. Możesz zalogować się do panelu i rozpocząć pracę.",
    content: (
      <div className="space-y-4">
        <div className="w-[56px] h-[56px] rounded-full bg-[rgba(46,158,107,.13)] flex items-center justify-center mx-auto">
          <svg
            width="30"
            height="30"
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
        <p className="text-[15px] text-[#4A5A6E] leading-relaxed text-center">
          Konfiguracja zakończona. Możesz teraz przejść do panelu zarządcy i
          w pełni zarządzać swoim osiedlem.
        </p>
        <div className="flex justify-center pt-2">
          <Link
              href="https://panel.mestio.pl"
              className="inline-flex items-center gap-2 bg-azure text-white font-semibold text-[15px] px-6 py-[13px] rounded-[13px] hover:bg-azure/90 transition-colors"
            >
              Przejdź do panelu
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
          </Link>
        </div>
      </div>
    ),
  },
];

function OnboardingContent() {
  const searchParams = useSearchParams();
  const stepParam = searchParams.get("step");
  const initialStep = stepParam ? Math.max(1, Math.min(4, parseInt(stepParam) || 1)) : 1;
  const [step, setStep] = useState(initialStep);

  const current = STEPS[step - 1];
  const total = STEPS.length;

  return (
    <div className="w-full max-w-[640px]">
      <div className="flex items-center gap-2 mb-8">
        {STEPS.map((_, i) => (
          <div key={i} className="flex-1 h-[3px] rounded-full transition-colors"
            style={{ backgroundColor: i < step ? "#3E7BD6" : "#E2E9F2" }}
          />
        ))}
      </div>

      <div className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] p-8">
        <div className="font-mono text-[10px] tracking-[0.6px] uppercase text-[#8A98AB] mb-2">
          Krok {step} z {total}
        </div>

        <h1 className="font-heading font-bold text-[28px] tracking-[-0.5px] text-ink">
          {current.title}
        </h1>

        <p className="text-[14px] text-[#5A6B80] mt-2 mb-6 leading-relaxed">
          {current.description}
        </p>

        {current.content}

        <div className="flex items-center justify-between mt-8 pt-6 border-t border-[#E2E9F2]">
          <button
            type="button"
            onClick={() => setStep((s) => Math.max(1, s - 1))}
            disabled={step === 1}
            className="px-4 py-2 text-[13px] font-semibold text-[#5A6B80] rounded-[11px] bg-paper hover:bg-[#EAF0F7] transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
          >
            &larr; Wstecz
          </button>

          <div className="flex gap-2">
            <span className="font-mono text-[11px] text-[#8A98AB] self-center">
              {step} / {total}
            </span>
          </div>

          {step < total ? (
            <button
              type="button"
              onClick={() => setStep((s) => Math.min(total, s + 1))}
              className="px-5 py-2 text-[13px] font-semibold text-white rounded-[11px] bg-azure hover:bg-azure/90 transition-colors"
            >
              Dalej &rarr;
            </button>
          ) : (
            <Link
              href="https://panel.mestio.pl"
              className="px-5 py-2 text-[13px] font-semibold text-white rounded-[11px] bg-azure hover:bg-azure/90 transition-colors inline-block"
            >
              Przejdź do panelu &rarr;
            </Link>
          )}
        </div>
      </div>
    </div>
  );
}

export default function OnboardingPage() {
  return (
    <Suspense
      fallback={
        <div className="py-20 text-center text-[#8A98AB]">Ładowanie...</div>
      }
    >
      <OnboardingContent />
    </Suspense>
  );
}

const PAIN_POINTS = [
  "Zgłoszenia giną w SMS-ach, telefonach i grupach na Facebooku",
  "Mieszkaniec nie wie, czy ktoś się zajął sprawą",
  "Zarząd nie ma historii ani dowodu, co i kiedy naprawiono",
  "Serwis dostaje niejasne opisy bez zdjęć i lokalizacji",
];

const GAIN_POINTS = [
  "Jeden strumień zgłoszeń ze statusem i historią",
  "Mieszkaniec widzi status i dostaje powiadomienia",
  "Pełny ślad audytowy — kto, co i kiedy zrobił",
  "Zdjęcia, PDF i dokładna lokalizacja w każdym zgłoszeniu",
];

export default function ProblemSolutionSection() {
  return (
    <section className="max-w-[1160px] mx-auto px-6 py-10">
      <div className="bg-ink rounded-[24px] p-11 grid grid-cols-1 md:grid-cols-2 gap-10"
        style={{
          backgroundImage:
            "radial-gradient(600px 300px at 90% 0%, rgba(62,123,214,.25), transparent 60%)",
        }}
      >
        <div>
          <div className="font-mono text-[11px] tracking-[0.6px] uppercase text-[#8FA6C4]">
            Bez Mestio
          </div>
          <div className="flex flex-col gap-[14px] mt-4">
            {PAIN_POINTS.map((point) => (
              <div key={point} className="flex gap-[10px] items-start">
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#6B7A90"
                  strokeWidth="2"
                  strokeLinecap="round"
                  className="shrink-0 mt-[1px]"
                >
                  <path d="M6 6l12 12M18 6L6 18" />
                </svg>
                <span className="text-[14.5px] text-[#C7D2E0] leading-relaxed">
                  {point}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div>
          <div className="font-mono text-[11px] tracking-[0.6px] uppercase text-[#7FE0AE]">
            Z Mestio
          </div>
          <div className="flex flex-col gap-[14px] mt-4">
            {GAIN_POINTS.map((point) => (
              <div key={point} className="flex gap-[10px] items-start">
                <svg
                  width="18"
                  height="18"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#2E9E6B"
                  strokeWidth="2.4"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  className="shrink-0 mt-[1px]"
                >
                  <path d="M5 12l5 5 9-11" />
                </svg>
                <span className="text-[14.5px] text-white leading-relaxed">
                  {point}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

"use client";

export default function OwnerError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex items-center justify-center min-h-[60vh]">
      <div
        className="rounded-[16px] p-8 max-w-md text-center"
        style={{
          background: "#fff",
          border: "1px solid var(--color-glass-border, #EBEFF4)",
          boxShadow: "0 1px 3px rgba(14,26,43,.04)",
        }}
      >
        <div
          className="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-5"
          style={{ background: "rgba(239,68,68,.1)" }}
        >
          <svg
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#EF4444"
            strokeWidth="1.8"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <circle cx="12" cy="12" r="10" />
            <path d="M12 8v4M12 16h.01" />
          </svg>
        </div>
        <h2
          className="text-lg font-heading font-bold mb-2"
          style={{ color: "#0E1A2B" }}
        >
          Coś poszło nie tak
        </h2>
        <p className="text-sm mb-6" style={{ color: "#7C8AA0" }}>
          Wystąpił nieoczekiwany błąd. Spróbuj odświeżyć stronę.
        </p>
        <div className="flex gap-3 justify-center">
          <button
            onClick={reset}
            className="px-5 py-2.5 rounded-[12px] text-sm font-semibold text-white transition-all"
            style={{
              background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
              boxShadow: "0 2px 8px rgba(62,123,214,.25)",
            }}
          >
            Spróbuj ponownie
          </button>
          <button
            onClick={() => (window.location.href = "/login")}
            className="px-5 py-2.5 rounded-[12px] text-sm font-semibold transition-all"
            style={{
              background: "#F1F4F8",
              color: "#4A5A6E",
              border: "1px solid #EBEFF4",
            }}
          >
            Wyloguj
          </button>
        </div>
        {error.digest && (
          <p
            className="text-[10px] mt-4 font-mono"
            style={{ color: "#9AA7B8" }}
          >
            ID: {error.digest}
          </p>
        )}
      </div>
    </div>
  );
}

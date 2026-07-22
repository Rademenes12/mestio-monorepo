"use client";

export default function AppError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex items-center justify-center min-h-[60vh]">
      <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 max-w-md text-center">
        <span className="text-4xl block mb-4">⚠️</span>
        <h2 className="text-lg font-heading font-bold text-ink mb-2">
          Wystąpił błąd
        </h2>
        <p className="text-sm text-ink/50 mb-6">
          Nie udało się załadować strony. Spróbuj ponownie.
        </p>
        <button
          onClick={reset}
          className="px-5 py-2 rounded-xl bg-azure text-white text-sm font-medium hover:bg-azure/90 transition-colors"
        >
          Spróbuj ponownie
        </button>
      </div>
    </div>
  );
}

type ClientDocument = {
  id: string;
  name: string;
  meta: string | null;
  status: string;
};

const STATUS_COLORS: Record<string, string> = {
  Podpisana: "#2E9E6B",
  Aktualna: "#3E7BD6",
};

export function ClientDocuments({ documents }: { documents: ClientDocument[] }) {
  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h2 className="font-heading font-semibold text-ink">
        Dokumenty i umowa od Mestio
      </h2>
      <p className="text-xs text-ink/40 mt-1 mb-4">
        Dokumenty przygotowane przez Mestio — tylko do odczytu.
      </p>

      {documents.length === 0 ? (
        <p className="text-sm text-ink/30">Brak dokumentów.</p>
      ) : (
        <div className="flex flex-col gap-2">
          {documents.map((d) => {
            const color = STATUS_COLORS[d.status] ?? "#6B7A90";
            return (
              <div
                key={d.id}
                className="flex items-center gap-3 px-3 py-2.5 rounded-xl bg-paper"
              >
                <svg
                  className="w-[17px] h-[17px] text-[#173A6A] shrink-0"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth={1.8}
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"
                  />
                  <path strokeLinecap="round" strokeLinejoin="round" d="M14 2v6h6" />
                </svg>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-ink">{d.name}</p>
                  {d.meta && (
                    <p className="text-[10px] font-mono text-ink/30 mt-0.5">
                      {d.meta}
                    </p>
                  )}
                </div>
                <span
                  className="text-[9.5px] font-semibold px-2 py-0.5 rounded-full shrink-0"
                  style={{ backgroundColor: color + "20", color }}
                >
                  {d.status}
                </span>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

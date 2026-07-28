type ClientInvoice = {
  id: string;
  invoice_number: string;
  period: string | null;
  amount: string | null;
  status: string;
  file_url: string | null;
};

const STATUS_COLORS: Record<string, string> = {
  Opłacona: "#2E9E6B",
  "Okres próbny": "#6B7A90",
  Wystawiona: "#F2A900",
};

export function ClientInvoices({ invoices }: { invoices: ClientInvoice[] }) {
  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h2 className="font-heading font-semibold text-ink mb-4">Moje faktury</h2>

      {invoices.length === 0 ? (
        <p className="text-sm text-ink/30">Brak faktur.</p>
      ) : (
        <div className="flex flex-col gap-2">
          {invoices.map((f) => {
            const color = STATUS_COLORS[f.status] ?? "#6B7A90";
            return (
              <div
                key={f.id}
                className="flex items-center gap-3 px-3 py-2.5 rounded-xl bg-paper"
              >
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-mono font-semibold text-[#173A6A]">
                    {f.invoice_number}
                  </p>
                  <p className="text-[11px] text-ink/40 mt-0.5">
                    {f.period ?? "—"} {f.amount ? `· ${f.amount}` : ""}
                  </p>
                </div>
                <span
                  className="text-[9.5px] font-semibold px-2 py-0.5 rounded-full shrink-0"
                  style={{ backgroundColor: color + "20", color }}
                >
                  {f.status}
                </span>
                {f.file_url ? (
                  <a
                    href={f.file_url}
                    target="_blank"
                    rel="noreferrer"
                    className="w-[30px] h-[30px] rounded-lg bg-azure/10 flex items-center justify-center shrink-0 hover:bg-azure/20 transition-colors"
                    title="Pobierz PDF"
                  >
                    <DownloadIcon />
                  </a>
                ) : (
                  <span
                    className="w-[30px] h-[30px] rounded-lg bg-ink/5 flex items-center justify-center shrink-0 opacity-40"
                    title="Brak pliku"
                  >
                    <DownloadIcon />
                  </span>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function DownloadIcon() {
  return (
    <svg
      className="w-[15px] h-[15px] text-[#173A6A]"
      fill="none"
      stroke="currentColor"
      strokeWidth={1.9}
      viewBox="0 0 24 24"
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 3v12m0 0l-4-4m4 4l4-4M4 21h16"
      />
    </svg>
  );
}

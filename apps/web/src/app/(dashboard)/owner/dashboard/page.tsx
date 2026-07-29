import Link from "next/link";

export default async function DashboardPage() {
  return (
    <div className="p-8 animate-fade-in">
      <div className="mb-6">
        <h1 className="font-heading font-bold text-xl mb-1" style={{ color: "#0E1A2B" }}>Pulpit</h1>
        <p className="text-sm" style={{ color: "#7C8AA0" }}>Witaj w panelu zarządzania Mestio.</p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        {[
          { label: "Aktywni klienci", value: "—", color: "#3E7BD6" },
          { label: "Leady w pipeline", value: "—", color: "#3E7BD6" },
          { label: "Zaległe faktury", value: "—", color: "#EF4444" },
          { label: "Otwarte zadania", value: "—", color: "#F2A900" },
        ].map((kpi) => (
          <div
            key={kpi.label}
            className="rounded-[12px] border p-5"
            style={{
              background: "#fff",
              borderColor: "#EBEFF4",
              boxShadow: "0 1px 2px rgba(14,26,43,.03)",
            }}
          >
            <div className="text-xs font-medium uppercase tracking-wider mb-3" style={{ color: "#4A5A6E" }}>
              {kpi.label}
            </div>
            <div className="text-2xl font-bold" style={{ color: "#0E1A2B" }}>{kpi.value}</div>
            <div className="mt-2 w-full h-1 rounded-full" style={{ background: "#F1F4F8" }}>
              <div className="h-full rounded-full" style={{ width: "0%", background: kpi.color }} />
            </div>
          </div>
        ))}
      </div>

      {/* Empty state */}
      <div className="rounded-[12px] border p-12 text-center" style={{ background: "#fff", borderColor: "#EBEFF4", boxShadow: "0 1px 2px rgba(14,26,43,.03)" }}>
        <div className="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-4" style={{ background: "rgba(62,123,214,.08)" }}>
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M13 2L3 14h8l-1 8 10-12h-8z"/>
          </svg>
        </div>
        <h3 className="font-heading font-semibold text-lg mb-2" style={{ color: "#0E1A2B" }}>Brak danych</h3>
        <p className="text-sm mb-6" style={{ color: "#7C8AA0" }}>
          Baza CRM jest pusta. Dodaj pierwszych klientów, aby zobaczyć dashboard w akcji.
        </p>
        <Link
          href="/owner/customers/new"
          className="inline-flex items-center gap-2 px-5 py-2.5 rounded-[12px] text-sm font-semibold text-white transition-all"
          style={{ background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)", boxShadow: "0 2px 8px rgba(62,123,214,.25)" }}
        >
          Dodaj pierwszego klienta
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M5 12h14M12 5l7 7-7 7"/>
          </svg>
        </Link>
      </div>
    </div>
  );
}

// app/(dashboard)/kpi/page.tsx
import { createClient } from "@/lib/supabase/server";

interface KPIData {
  current_cac: number | null;
  avg_ltv: number | null;
  current_churn: number | null;
  current_mrr: number | null;
  mrr_growth: number | null;
  ltv_to_cac_ratio: number | null;
  pending_leads: number;
  active_customers: number;
  overdue_tasks: number;
}

function formatPLN(value: number | null): string {
  if (value === null) return "—";
  return new Intl.NumberFormat("pl-PL", {
    style: "currency",
    currency: "PLN",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(value);
}

function formatPercent(value: number | null): string {
  if (value === null) return "—";
  const prefix = value > 0 ? "+" : "";
  return `${prefix}${value.toFixed(1)}%`;
}

function KPICard({
  title,
  value,
  subtitle,
  trend,
  color = "#3E7BD6",
  icon,
}: {
  title: string;
  value: string;
  subtitle?: string;
  trend?: number | null;
  color?: string;
  icon?: string;
}) {
  const isPositiveTrend = trend && trend > 0;
  const trendColor = isPositiveTrend ? "#10B981" : "#EF4444";

  return (
    <div className="bg-white/95 dark:bg-gray-800/95 backdrop-blur rounded-lg p-6 border border-gray-200 dark:border-gray-700">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm text-gray-600 dark:text-gray-400">{title}</p>
          <p className="text-3xl font-bold mt-2" style={{ color }}>
            {value}
          </p>
          {subtitle && (
            <p className="text-xs text-gray-500 dark:text-gray-500 mt-1">
              {subtitle}
            </p>
          )}
        </div>
        <div className="flex flex-col items-end">
          {icon && (
            <div
              className="p-2 rounded-lg"
              style={{ backgroundColor: `${color}20`, color }}
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={icon} />
              </svg>
            </div>
          )}
          {trend !== null && trend !== undefined && (
            <div className="flex items-center mt-2" style={{ color: trendColor }}>
              <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor">
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d={isPositiveTrend ? "M5 15l7-7 7 7" : "M19 9l-7 7-7-7"}
                />
              </svg>
              <span className="text-sm font-medium">{Math.abs(trend).toFixed(1)}%</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default async function KPIPage() {
  const supabase = await createClient();
  
  // Pobierz dane KPI
  const { data: kpiData, error } = await supabase
    .from("kpi_dashboard")
    .select("*")
    .single();

  if (error) {
    console.error("Błąd pobierania KPI:", error);
  }

  const kpi = (kpiData as KPIData) || {
    current_cac: null,
    avg_ltv: null,
    current_churn: null,
    current_mrr: null,
    mrr_growth: null,
    ltv_to_cac_ratio: null,
    pending_leads: 0,
    active_customers: 0,
    overdue_tasks: 0,
  };

  // Określ status LTV:CAC
  const ltv_cac_status = 
    kpi.ltv_to_cac_ratio === null ? "Brak danych" :
    kpi.ltv_to_cac_ratio >= 3 ? "Zdrowy biznes" :
    kpi.ltv_to_cac_ratio >= 1 ? "Do poprawy" :
    "Nieopłacalny!";

  const ltv_cac_color = 
    kpi.ltv_to_cac_ratio === null ? "#9CA3AF" :
    kpi.ltv_to_cac_ratio >= 3 ? "#10B981" :
    kpi.ltv_to_cac_ratio >= 1 ? "#F59E0B" :
    "#EF4444";

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">KPI Dashboard</h1>
        <p className="text-gray-600 dark:text-gray-400 mt-2">
          Kluczowe wskaźniki wydajności Twojego biznesu
        </p>
      </div>

      {/* Główne KPI */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <KPICard
          title="CAC - Koszt Pozyskania"
          value={formatPLN(kpi.current_cac)}
          subtitle="na jednego klienta"
          color="#3E7BD6"
          icon="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
        />
        
        <KPICard
          title="LTV - Wartość Klienta"
          value={formatPLN(kpi.avg_ltv)}
          subtitle="średni przychód życiowy"
          color="#10B981"
          icon="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
        />
        
        <KPICard
          title="Churn - Rezygnacje"
          value={formatPercent(kpi.current_churn)}
          subtitle="miesięczny wskaźnik"
          trend={kpi.current_churn}
          color="#EF4444"
          icon="M13 7a4 4 0 11-8 0 4 4 0 018 0zM9 14a6 6 0 00-6 6v1h12v-1a6 6 0 00-6-6zM21 12h-6"
        />
        
        <KPICard
          title="MRR - Przychód Miesięczny"
          value={formatPLN(kpi.current_mrr)}
          subtitle="recurring revenue"
          trend={kpi.mrr_growth}
          color="#8B5CF6"
          icon="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
        />
      </div>

      {/* Wskaźnik LTV:CAC */}
      <div className="bg-white/95 dark:bg-gray-800/95 backdrop-blur rounded-lg p-6 mb-8 border border-gray-200 dark:border-gray-700">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-xl font-bold mb-2">Wskaźnik LTV:CAC</h2>
            <p className="text-gray-600 dark:text-gray-400">
              Stosunek wartości klienta do kosztu pozyskania
            </p>
          </div>
          <div className="text-right">
            <p className="text-4xl font-bold" style={{ color: ltv_cac_color }}>
              {kpi.ltv_to_cac_ratio?.toFixed(2) || "—"}x
            </p>
            <p className="text-sm mt-1" style={{ color: ltv_cac_color }}>
              {ltv_cac_status}
            </p>
          </div>
        </div>
        <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-8 text-sm">
            <div>
              <span className="text-gray-500">Cel:</span>
              <span className="font-medium ml-2">≥3.0x</span>
            </div>
            <div>
              <span className="text-gray-500">Interpretacja:</span>
              <span className="ml-2">
                {kpi.ltv_to_cac_ratio && kpi.ltv_to_cac_ratio >= 3
                  ? "✅ Zarabiasz 3× więcej niż wydajesz na pozyskanie"
                  : kpi.ltv_to_cac_ratio && kpi.ltv_to_cac_ratio >= 1
                  ? "⚠️ Marża zbyt niska, optymalizuj koszty"
                  : "❌ Tracisz na każdym kliencie!"}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Status operacyjny */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-6 border border-blue-200 dark:border-blue-800">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-700 dark:text-blue-400 font-medium">Oczekujące leady</p>
              <p className="text-3xl font-bold text-blue-900 dark:text-blue-200 mt-2">
                {kpi.pending_leads}
              </p>
            </div>
            <a
              href="/pipeline"
              className="text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300"
            >
              Zobacz →
            </a>
          </div>
        </div>

        <div className="bg-green-50 dark:bg-green-900/20 rounded-lg p-6 border border-green-200 dark:border-green-800">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-700 dark:text-green-400 font-medium">Aktywni klienci</p>
              <p className="text-3xl font-bold text-green-900 dark:text-green-200 mt-2">
                {kpi.active_customers}
              </p>
            </div>
            <a
              href="/customers"
              className="text-green-600 hover:text-green-800 dark:text-green-400 dark:hover:text-green-300"
            >
              Zarządzaj →
            </a>
          </div>
        </div>

        <div className="bg-red-50 dark:bg-red-900/20 rounded-lg p-6 border border-red-200 dark:border-red-800">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-red-700 dark:text-red-400 font-medium">Zaległe zadania</p>
              <p className="text-3xl font-bold text-red-900 dark:text-red-200 mt-2">
                {kpi.overdue_tasks}
              </p>
            </div>
            <a
              href="/tasks"
              className="text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300"
            >
              Wykonaj →
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}
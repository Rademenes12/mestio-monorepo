// Skeleton pokazywany przez Next.js podczas ładowania danych Pulpitu (Server
// Component z kilkoma zapytaniami + silnikiem automatyzacji) - wcześniej ekran
// był pusty aż do zakończenia wszystkich zapytań.
export default function DashboardLoading() {
  return (
    <div className="max-w-7xl mx-auto space-y-5 animate-pulse">
      <div className="space-y-3">
        <div className="h-[22px] w-48 bg-[#E4EBF3] rounded-lg" />
        <div className="flex flex-col gap-[9px]">
          {[0, 1].map((i) => (
            <div key={i} className="h-[62px] bg-white rounded-2xl shadow-[var(--shadow-card)]" />
          ))}
        </div>
      </div>

      <div className="grid grid-cols-4 gap-[12px] mt-[22px]">
        {[0, 1, 2, 3].map((i) => (
          <div key={i} className="h-[74px] bg-white rounded-2xl shadow-[var(--shadow-card)]" />
        ))}
      </div>

      <div className="h-[180px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-[14px]">
        <div className="h-[180px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />
        <div className="h-[180px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />
      </div>
    </div>
  );
}

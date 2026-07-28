export default function AppLoading() {
  return (
    <div className="space-y-6 p-8 animate-pulse">
      <div className="h-8 w-48 bg-ink/5 rounded-lg" />
      <div className="h-4 w-64 bg-ink/5 rounded-lg mt-2" />

      <div className="grid grid-cols-5 gap-5">
        {Array.from({ length: 5 }).map((_, i) => (
          <div
            key={i}
            className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6"
          >
            <div className="h-3 w-20 bg-ink/5 rounded mb-3" />
            <div className="h-8 w-16 bg-ink/5 rounded" />
          </div>
        ))}
      </div>

      <div className="grid grid-cols-3 gap-5">
        <div className="col-span-2">
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <div className="h-5 w-40 bg-ink/5 rounded mb-5" />
            <div className="h-[180px] bg-ink/5 rounded" />
          </div>
        </div>
        <div>
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <div className="h-5 w-36 bg-ink/5 rounded mb-4" />
            <div className="space-y-3">
              {Array.from({ length: 4 }).map((_, i) => (
                <div key={i} className="h-10 bg-ink/5 rounded" />
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

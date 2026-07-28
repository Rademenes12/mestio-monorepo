type Stairwell = {
  id: string;
  floor_min: number;
  floor_max: number;
};

export function BuildingVisualization({
  buildingType,
  stairwells,
}: {
  buildingType: string;
  stairwells: Stairwell[];
}) {
  const isGarage = buildingType === "garage";

  if (isGarage) {
    // Dla garażu bierzemy najgłębszy poziom ujemny ze wszystkich "klatek"/sekcji
    const minFloor = stairwells.length
      ? Math.min(...stairwells.map((s) => s.floor_min))
      : -2;
    const levelsCount = Math.max(1, Math.abs(Math.min(0, minFloor)));
    const levels = Array.from({ length: levelsCount }).map((_, i) => `−${i + 1}`);

    return (
      <div className="bg-paper border border-ink/10 rounded-xl p-3 flex flex-col items-center justify-end">
        <div className="w-full h-[5px] bg-[#173A6A] rounded-t-[3px] mb-1" />
        <div className="flex flex-col gap-1 w-full">
          {levels.map((label) => (
            <div
              key={label}
              className="h-4 bg-[#DDE3EC] border border-[#C3CDDB] rounded-[2px] flex items-center justify-center text-[8px] font-mono text-[#5A6B80]"
            >
              {label}
            </div>
          ))}
        </div>
        <p className="text-[9px] font-mono text-ink/40 mt-1.5 text-center">
          garaż podziemny
        </p>
      </div>
    );
  }

  const stairFloors = stairwells.map((s) => Math.max(0, s.floor_max) + 1); // +parter
  const maxFloors = Math.max(1, ...stairFloors);

  const rows = [];
  for (let r = 0; r <= maxFloors; r++) {
    const floorNum = maxFloors - r;
    rows.push(
      stairFloors.map((f) => f >= floorNum)
    );
  }

  return (
    <div className="bg-paper border border-ink/10 rounded-xl p-3 flex flex-col items-center justify-end">
      <div className="flex flex-col gap-[3px] items-stretch w-full">
        {rows.map((row, i) => (
          <div key={i} className="flex gap-[3px] justify-center">
            {row.map((filled, j) => (
              <div
                key={j}
                className="flex-1 max-w-[26px] h-[15px] rounded-[2px]"
                style={
                  filled
                    ? { background: "#CFE0F5", border: "1px solid #A9C7EC" }
                    : { background: "transparent" }
                }
              />
            ))}
          </div>
        ))}
      </div>
      <div className="w-[70%] h-2 bg-[#173A6A] rounded-b-[3px] mt-[3px]" />
      <p className="text-[9px] font-mono text-ink/40 mt-1.5 text-center">
        {maxFloors + 1} kondygnacji (maks.) · {stairwells.length} klatki
      </p>
    </div>
  );
}

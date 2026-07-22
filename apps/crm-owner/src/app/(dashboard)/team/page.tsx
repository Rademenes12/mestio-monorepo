import { createClient } from "@/lib/supabase/server";

function tint(hex: string, alpha: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${alpha})`;
}

const TEAM_COLORS = ["#3E7BD6", "#2E9E6B", "#8B5CF6", "#F2A900", "#C98800"];

export default async function TeamPage() {
  const supabase = await createClient();

  // Równoległe zapytania
  const [tasksRes, leadsRes, usersRes] = await Promise.all([
    supabase.from("crm_tasks").select("*").order("due_date", { ascending: true }),
    supabase.from("crm_leads").select("id, company_name, stage"),
    supabase.auth.admin.listUsers(), // tylko admin/owner może wywołać
  ]);

  const allTasks = (tasksRes.data as any[]) ?? [];
  const allLeads = (leadsRes.data as any[]) ?? [];
  const users = usersRes.data?.users ?? [];

  // Mapa user_id → email
  const userEmailMap: Record<string, string> = {};
  for (const u of users) {
    userEmailMap[u.id] = u.email ?? u.id.slice(0, 8) + "...";
  }

  // Statystyki teamu
  const openTasks = allTasks.filter((t) => !t.done);
  const overdueTasks = openTasks.filter((t) => t.due_date && new Date(t.due_date) < new Date());
  const todayTasks = openTasks.filter(
    (t) => t.due_date && new Date(t.due_date).toDateString() === new Date().toDateString()
  );
  const doneThisWeek = allTasks.filter(
    (t) =>
      t.done &&
      t.updated_at &&
      (Date.now() - new Date(t.updated_at).getTime()) / (1000 * 60 * 60 * 24) < 7
  );

  // Grupuj po przypisanej osobie (lub "Nieprzypisane")
  const assignedMap: Record<string, { label: string; tasks: any[] }> = {};

  for (const task of openTasks) {
    const key = task.assigned_to || "unassigned";
    if (!assignedMap[key]) {
      assignedMap[key] = {
        label: key === "unassigned" ? "📋 Nieprzypisane" : userEmailMap[key] || `👤 ${key.slice(0, 8)}...`,
        tasks: [],
      };
    }
    assignedMap[key].tasks.push(task);
  }

  // Pipeline per osoba (symulacja — w realu zależałoby od owner_id)
  const leadStages = ["lead", "contact", "demo", "offer", "won"] as const;
  const STAGE_LABELS: Record<string, string> = {
    lead: "Lead", contact: "Kontakt", demo: "Demo", offer: "Oferta", won: "Wygrana",
  };

  return (
    <div className="space-y-6">
      {/* Team stats */}
      <div className="grid grid-cols-4 gap-4">
        <div className="bg-white rounded-[14px] p-4 border border-[#E9EFF6]">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Otwarte zadania</p>
          <p className="text-2xl font-bold text-ink mt-1">{openTasks.length}</p>
        </div>
        <div className="bg-white rounded-[14px] p-4 border border-[#E9EFF6]">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Zaległe</p>
          <p className="text-2xl font-bold text-[#C0392B] mt-1">{overdueTasks.length}</p>
        </div>
        <div className="bg-white rounded-[14px] p-4 border border-[#E9EFF6]">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Na dziś</p>
          <p className="text-2xl font-bold text-[#3E7BD6] mt-1">{todayTasks.length}</p>
        </div>
        <div className="bg-white rounded-[14px] p-4 border border-[#E9EFF6]">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Zrobione w tym tygodniu</p>
          <p className="text-2xl font-bold text-[#2E9E6B] mt-1">{doneThisWeek.length}</p>
        </div>
      </div>

      {/* Team members grid */}
      <div>
        <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink mb-3">
          Zespół — podział zadań
        </h3>
        {Object.keys(assignedMap).length === 0 ? (
          <div className="bg-white rounded-[14px] p-8 text-center text-ink/30 border border-[#E9EFF6]">
            Brak zadań w systemie. Dodaj pierwsze zadanie przez pipeline.
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-4">
            {Object.entries(assignedMap).map(([key, member], idx) => {
              const color = TEAM_COLORS[idx % TEAM_COLORS.length];
              const done = member.tasks.filter((t) => t.done).length;
              const total = member.tasks.length;
              const rate = total > 0 ? Math.round((done / total) * 100) : 0;

              return (
                <div key={key} className="bg-white rounded-[14px] p-4 border border-[#E9EFF6]">
                  <div className="flex items-center justify-between mb-3">
                    <h4 className="text-[14px] font-semibold text-ink">{member.label}</h4>
                    <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold"
                      style={{ background: tint(color, 0.1), color }}
                    >
                      {total} zadań
                    </span>
                  </div>

                  {/* Progress bar */}
                  <div className="mb-3">
                    <div className="flex justify-between text-[10px] mb-1">
                      <span className="text-[#8A98AB]">Postęp</span>
                      <span className="font-semibold text-ink">{rate}%</span>
                    </div>
                    <div className="h-1.5 bg-[#E9EFF6] rounded-full overflow-hidden">
                      <div
                        className="h-full rounded-full transition-all duration-500"
                        style={{
                          width: `${rate}%`,
                          background: rate >= 80 ? "#2E9E6B" : rate >= 40 ? "#F2A900" : "#C0392B",
                        }}
                      />
                    </div>
                  </div>

                  {/* Tasks list */}
                  <div className="space-y-1.5">
                    {member.tasks.slice(0, 5).map((task) => {
                      const overdue = task.due_date && new Date(task.due_date) < new Date();
                      return (
                        <div
                          key={task.id}
                          className={`flex items-center gap-2 py-1 px-2 rounded-[6px] text-[12px] ${
                            task.done ? "line-through text-[#CBD5E1]" : "text-ink"
                          }`}
                        >
                          <div
                            className={`w-1.5 h-1.5 rounded-full shrink-0 ${
                              task.done ? "bg-[#CBD5E1]" :
                              overdue ? "bg-[#C0392B]" :
                              task.priority === "high" ? "bg-[#C0392B]" :
                              task.priority === "medium" ? "bg-[#F2A900]" : "bg-[#6B7A90]"
                            }`}
                          />
                          <span className="truncate flex-1">{task.title}</span>
                          {task.due_date && !task.done && (
                            <span className="text-[9px] shrink-0" style={{ color: overdue ? "#C0392B" : "#8A98AB" }}>
                              {new Date(task.due_date).toLocaleDateString("pl-PL")}
                            </span>
                          )}
                        </div>
                      );
                    })}
                    {member.tasks.length > 5 && (
                      <p className="text-[10px] text-[#8A98AB] pl-4">+{member.tasks.length - 5} więcej</p>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Pipeline per stage summary */}
      <div className="bg-white rounded-[14px] p-5 border border-[#E9EFF6]">
        <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink mb-3">
          Pipeline — podsumowanie
        </h3>
        <div className="flex gap-2">
          {leadStages.map((stage, i) => {
            const count = allLeads.filter((l) => l.stage === stage).length;
            const color = TEAM_COLORS[i % TEAM_COLORS.length];
            return (
              <div
                key={stage}
                className="flex-1 rounded-[10px] p-3 text-center"
                style={{ background: tint(color, 0.06) }}
              >
                <p className="text-[10px] font-semibold text-ink/50">{STAGE_LABELS[stage]}</p>
                <p className="text-xl font-bold mt-1" style={{ color }}>{count}</p>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

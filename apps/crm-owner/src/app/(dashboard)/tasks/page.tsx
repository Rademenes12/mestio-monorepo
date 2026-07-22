import { createClient } from "@/lib/supabase/server";
import { CrmTask } from "@/lib/types";

function tint(hex: string, alpha: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${alpha})`;
}

export default async function TasksPage() {
  const supabase = await createClient();

  const { data: tasksData } = await supabase
    .from("crm_tasks")
    .select("*, crm_leads(company_name)")
    .order("due_date", { ascending: true });

  const tasks = (tasksData as (CrmTask & { crm_leads: { company_name: string } | null })[]) ?? [];

  const openTasks = tasks.filter((t) => !t.done);
  const doneTasks = tasks.filter((t) => t.done);
  const overdueTasks = openTasks.filter(
    (t) => t.due_date && new Date(t.due_date) < new Date()
  );

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-bold text-ink">Zadania</h2>
          <p className="text-[13px] text-ink/50 mt-1">
            {openTasks.length} otwartych, {doneTasks.length} zrobionych, {overdueTasks.length} po terminie
          </p>
        </div>
      </div>

      {tasks.length === 0 ? (
        <div className="bg-white rounded-[14px] p-12 text-center border border-[#E9EFF6]">
          <p className="text-ink/30 text-[14px]">Brak zadań</p>
          <p className="text-ink/20 text-[12px] mt-1">Zadania pojawią się automatycznie z pipeline i automatyzacji</p>
        </div>
      ) : (
        <div className="space-y-2">
          {tasks.map((task) => {
            const overdue = task.due_date && new Date(task.due_date) < new Date() && !task.done;
            const isToday =
              task.due_date &&
              new Date(task.due_date).toDateString() === new Date().toDateString();

            return (
              <div
                key={task.id}
                className={`flex items-center gap-4 py-3 px-4 rounded-[12px] bg-white border transition-all ${
                  task.done
                    ? "border-[#E9EFF6] opacity-50"
                    : overdue
                      ? "border-red-200"
                      : "border-[#E9EFF6]"
                }`}
              >
                <div
                  className={`w-3 h-3 rounded-full shrink-0 ${
                    task.done
                      ? "bg-[#2E9E6B]"
                      : overdue
                        ? "bg-[#C0392B]"
                        : task.priority === "high"
                          ? "bg-[#C0392B]"
                          : task.priority === "medium"
                            ? "bg-[#F2A900]"
                            : "bg-[#6B7A90]"
                  }`}
                />
                <div className="flex-1 min-w-0">
                  <p className={`text-[14px] ${task.done ? "line-through text-[#CBD5E1]" : "text-ink"}`}>
                    {task.title}
                  </p>
                  <p className="text-[11px] text-[#8A98AB]">
                    {task.crm_leads?.company_name ?? "—"}
                  </p>
                </div>
                <div className="flex items-center gap-3 shrink-0">
                  {task.due_date && (
                    <span
                      className={`text-[11px] font-medium px-2 py-0.5 rounded-full ${
                        task.done
                          ? "text-[#CBD5E1]"
                          : overdue
                            ? "text-[#C0392B] bg-red-50"
                            : isToday
                              ? "text-[#3E7BD6] bg-blue-50"
                              : "text-[#8A98AB]"
                      }`}
                    >
                      {overdue ? "PO TERMINIE" : isToday ? "DZIŚ" : new Date(task.due_date).toLocaleDateString("pl-PL")}
                    </span>
                  )}
                  <span
                    className={`text-[10px] px-2 py-0.5 rounded-full font-semibold ${
                      task.priority === "high"
                        ? "bg-red-50 text-[#C0392B]"
                        : task.priority === "medium"
                          ? "bg-amber-50 text-[#F2A900]"
                          : "bg-gray-100 text-[#6B7A90]"
                    }`}
                  >
                    {task.priority}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

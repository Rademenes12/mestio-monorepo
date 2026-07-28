import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import { TaskFilters } from "./filters-client";
import { CreateTaskModal } from "./create-modal";
import TaskCheck from "./task-check";
import InternalTaskCard, { type InternalTask } from "./internal-task-card";
import type { DbTask } from "@/lib/types";

export default async function TasksPage({
  searchParams,
}: {
  searchParams: Promise<{ filter?: string }>;
}) {
  const { filter } = await searchParams;
  const activeFilter = filter ?? "all";

  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  const now = new Date();
  const nowIso = now.toISOString();
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 999);
  const weekEnd = new Date();
  weekEnd.setDate(weekEnd.getDate() + 7);
  weekEnd.setHours(23, 59, 59, 999);

  // Przed migracją 0056 kolumna 'kind' nie istnieje — zapytania z filterem
  // .or("kind.eq...") zwrócą błąd. Detekcja: próbujemy z kind-em, jeśli
  // błąd to spowodowany brakiem kolumny — powtarzamy bez filtra i wyświetlamy
  // ostrzeżenie.
  async function tryQuery(useKindFilter: boolean) {
    const q = supabase
      .from("fixflow_tasks")
      .select("*", { count: "exact" })
      .eq("estate_id", estateId);

    const filtered = useKindFilter
      ? q.or("kind.eq.resident,kind.is.null")
      : q;

    let finalQ = filtered;
    switch (activeFilter) {
      case "open":
        finalQ = finalQ.eq("status", "Otwarte"); break;
      case "today":
        finalQ = finalQ
          .eq("status", "Otwarte")
          .gte("deadline", todayStart.toISOString())
          .lte("deadline", todayEnd.toISOString()); break;
      case "week":
        finalQ = finalQ
          .eq("status", "Otwarte")
          .gte("deadline", todayStart.toISOString())
          .lte("deadline", weekEnd.toISOString()); break;
      case "overdue":
        finalQ = finalQ.eq("status", "Otwarte").lt("deadline", nowIso); break;
      case "done":
        finalQ = finalQ.eq("status", "Zrobione"); break;
    }
    return finalQ.order("created_at", { ascending: false }).limit(100);
  }

  let withKindResult = await tryQuery(true);
  let needsMigration = false;

  if (withKindResult.error) {
    // Sprawdz czy blad jest zwiazany z kolumna 'kind'
    const msg = withKindResult.error.message ?? "";
    if (msg.includes("kind") || withKindResult.error.code === "42703") {
      needsMigration = true;
      withKindResult = await tryQuery(false);
    }
  }

  const tasks = withKindResult.data;
  const count = withKindResult.count;
  const isTableReady = !withKindResult.error;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const anySupabase = supabase as any;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const countAll = ((await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")
  )).count ?? 0);

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rOpen = await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    (needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")).eq("status", "Otwarte"));
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rToday = await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    (needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")).eq("status", "Otwarte").gte("deadline", todayStart.toISOString()).lte("deadline", todayEnd.toISOString()));
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rWeek = await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    (needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")).eq("status", "Otwarte").gte("deadline", todayStart.toISOString()).lte("deadline", weekEnd.toISOString()));
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rOverdue = await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    (needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")).eq("status", "Otwarte").lt("deadline", nowIso));
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rDone = await anySupabase.from("fixflow_tasks").select("*", { count: "exact", head: true }).then((q: any) =>
    (needsMigration ? q.eq("estate_id", estateId) : q.eq("estate_id", estateId).or("kind.eq.resident,kind.is.null")).eq("status", "Zrobione"));

  const openCount = rOpen.count ?? 0;
  const todayCount = rToday.count ?? 0;
  const weekCount = rWeek.count ?? 0;
  const overdueCount = rOverdue.count ?? 0;
  const doneCount = rDone.count ?? 0;

  const { data: taskEstateMembers } = await supabase
    .from("fixflow_user_estates")
    .select("user_id")
    .eq("estate_id", estateId);

  const taskResidentIds = [
    ...new Set((taskEstateMembers ?? []).map((m) => m.user_id)),
  ];

  const { data: residents } =
    taskResidentIds.length > 0
      ? await supabase
          .from("fixflow_resident_profiles")
          .select("id, name")
          .in("id", taskResidentIds)
          .limit(200)
      : { data: [] };

  // ZADANIA WEWNĘTRZNE CYKLICZNE (kind='internal') + dyskusja
  const { data: internalTasksRaw } = isTableReady
    ? await supabase
        .from("fixflow_tasks")
        .select("*")
        .eq("estate_id", estateId)
        .eq("kind", "internal")
        .order("created_at", { ascending: false })
    : { data: [] };

  const internalIds = (internalTasksRaw ?? []).map((t) => t.id);
  const { data: internalComments } =
    internalIds.length > 0
      ? await supabase
          .from("fixflow_task_comments")
          .select("*")
          .in("task_id", internalIds)
          .order("created_at", { ascending: true })
      : { data: [] };

  const internalTasks: InternalTask[] = (internalTasksRaw ?? []).map((t) => ({
    id: t.id,
    title: t.title,
    description: t.description,
    recurrence_interval: t.recurrence_interval,
    recurrence_unit: t.recurrence_unit,
    assigned_group: t.assigned_group,
    created_at: t.created_at,
    comments: (internalComments ?? [])
      .filter((c) => c.task_id === t.id)
      .map((c) => ({
        id: c.id,
        body: c.body,
        author_name: c.author_name,
        created_at: c.created_at,
      })),
  }));

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-heading font-bold text-ink">Zadania</h1>
          <p className="text-sm text-ink/50 mt-1">{count ?? 0} zadań</p>
        </div>
        {isTableReady && (
          <CreateTaskModal
            residents={residents ?? []}
            estateId={estateId}
            userId={user.id}
          />
        )}
      </div>

      <TaskFilters
        activeFilter={activeFilter}
        counts={{
          all: countAll,
          open: openCount,
          today: todayCount,
          week: weekCount,
          overdue: overdueCount,
          done: doneCount,
        }}
      />

      {needsMigration && isTableReady && (
        <div className="bg-amber-50 border border-amber-300 rounded-xl px-4 py-3 text-[12.5px] text-amber-800 leading-relaxed">
          Kolumna <code className="font-mono bg-amber-100 px-1 rounded">kind</code> nie istnieje — widoczność wszystkich zadań (bez podziału na typy). Uruchom migrację{" "}
          <code className="font-mono bg-amber-100 px-1 rounded">0056_mockup_features.sql</code> w SQL Editor, aby włączyć zadania wewnętrzne cykliczne i typy.
        </div>
      )}

      {!isTableReady ? (
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
          <p className="text-ink/50 text-sm mb-2">
            Tabela zadań nie istnieje jeszcze w bazie
          </p>
          <p className="text-ink/30 text-xs">
            Uruchom migrację{" "}
            <code className="font-mono text-azure">
              supabase/migrations/0052_create_tasks.sql
            </code>{" "}
            w SQL Editor Supabase
          </p>
        </div>
      ) : tasks && tasks.length === 0 ? (
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
          <p className="text-ink/50 text-sm">Brak zadań w tej kategorii</p>
          <p className="text-ink/35 text-[12.5px] mt-1">
            Kliknij „Nowe zadanie”, aby dodać pierwsze
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] overflow-hidden">
          <div className="divide-y divide-ink/5">
            {(tasks as DbTask[])?.map((t) => {
              const isOverdue =
                t.status === "Otwarte" &&
                t.deadline &&
                new Date(t.deadline) < new Date();
              const done = t.status === "Zrobione";

              return (
                <div key={t.id} className="flex items-center gap-4 px-6 py-4 min-h-[64px]">
                  <TaskCheck taskId={t.id} done={done} />
                  <div className="flex-1 min-w-0">
                    <p
                      className={`text-[14px] ${
                        done ? "text-ink/40 line-through" : "text-ink/80"
                      }`}
                    >
                      {t.title}
                    </p>
                    {t.description && (
                      <p className="text-[12.5px] text-ink/45 truncate mt-0.5">
                        {t.description}
                      </p>
                    )}
                  </div>
                  {t.deadline && (
                    <span
                      className={`text-[12px] font-mono shrink-0 px-2.5 py-1 rounded-full ${
                        isOverdue
                          ? "text-danger bg-danger/10 font-semibold"
                          : "text-ink/45 bg-paper"
                      }`}
                    >
                      {new Date(t.deadline).toLocaleDateString("pl-PL")}
                    </span>
                  )}
                  <span
                    className={`w-2.5 h-2.5 rounded-full shrink-0 ${
                      t.priority === "critical"
                        ? "bg-danger"
                        : t.priority === "high"
                          ? "bg-status-progress"
                          : t.priority === "low"
                            ? "bg-ink/15"
                            : "bg-azure/40"
                    }`}
                    title={`Priorytet: ${t.priority}`}
                  />
                </div>
              );
            })}
          </div>
        </div>
      )}

      <div>
        <h2 className="text-[11.5px] font-semibold uppercase tracking-wide text-ink/45 mt-8 mb-3">
          Zadania wewnętrzne cykliczne
        </h2>
        {internalTasks.length === 0 ? (
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-8 text-center">
            <p className="text-ink/45 text-[12.5px]">
              Brak zadań wewnętrznych. Dodaj np. coroczną polisę OC budynku.
            </p>
          </div>
        ) : (
          <div className="flex flex-col gap-3">
            {internalTasks.map((t) => (
              <InternalTaskCard
                key={t.id}
                estateId={estateId}
                task={t}
                authorName={user.email ?? "Zarząd"}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

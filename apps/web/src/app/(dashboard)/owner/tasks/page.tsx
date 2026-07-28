"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

interface Task {
  id: string;
  title: string;
  description: string | null;
  priority: string;
  status: string;
  due_date: string | null;
  completed_at: string | null;
  created_at: string;
  crm_leads?: { company_name: string } | null;
}

const PRIORITY_COLORS: Record<string, string> = {
  low: "#6B7A90",
  medium: "#3E7BD6",
  high: "#F2A900",
  urgent: "#E53E3E",
};

const PRIORITY_LABELS: Record<string, string> = {
  low: "Niski",
  medium: "Średni",
  high: "Wysoki",
  urgent: "Pilny",
};

export default function TasksPage() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [title, setTitle] = useState("");
  const [priority, setPriority] = useState("medium");
  const [adding, setAdding] = useState(false);
  const [filter, setFilter] = useState<"all" | "pending" | "done">("pending");
  const supabase = createClient();

  const fetchTasks = async () => {
    setLoading(true);
    const query = supabase
      .from("crm_tasks")
      .select("*, crm_leads(company_name)")
      .order("created_at", { ascending: false });
    if (filter !== "all") {
      if (filter === "done") {
        query.eq("status", "done");
      } else {
        query.or("status.eq.pending,status.eq.in_progress");
      }
    }
    const { data } = await query;
    setTasks((data as Task[]) ?? []);
    setLoading(false);
  };

  useEffect(() => { fetchTasks(); }, [filter]); // eslint-disable-line react-hooks/exhaustive-deps,react-hooks/set-state-in-effect

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;
    setAdding(true);
    await supabase.from("crm_tasks").insert({ title: title.trim(), priority });
    setTitle("");
    setPriority("medium");
    setAdding(false);
    fetchTasks();
  };

  const handleStatus = async (id: string, status: string) => {
    const completed_at = status === "done" ? new Date().toISOString() : null;
    await supabase.from("crm_tasks").update({ status, completed_at }).eq("id", id);
    fetchTasks();
  };

  const handleDelete = async (id: string) => {
    await supabase.from("crm_tasks").delete().eq("id", id);
    fetchTasks();
  };

  const pending = tasks.filter((t) => t.status !== "done");
  const done = tasks.filter((t) => t.status === "done");

  return (
    <div className="max-w-4xl mx-auto space-y-5">
      {/* ── Add task form ── */}
      <form
        onSubmit={handleAdd}
        className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-5 flex gap-3 items-end"
      >
        <div className="flex-1">
          <label className="text-[10px] font-semibold uppercase tracking-[.5px] text-[#8A98AB] mb-1.5 block">
            Nowe zadanie
          </label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Co trzeba zrobić?"
            className="w-full text-[13.5px] bg-[#F4F7FB] rounded-xl px-4 py-2.5 text-ink outline-none focus:ring-2 focus:ring-azure/30"
          />
        </div>
        <div>
          <label className="text-[10px] font-semibold uppercase tracking-[.5px] text-[#8A98AB] mb-1.5 block">
            Priorytet
          </label>
          <select
            value={priority}
            onChange={(e) => setPriority(e.target.value)}
            className="text-[13.5px] bg-[#F4F7FB] rounded-xl px-4 py-2.5 text-ink outline-none focus:ring-2 focus:ring-azure/30"
          >
            {Object.entries(PRIORITY_LABELS).map(([k, v]) => (
              <option key={k} value={k}>{v}</option>
            ))}
          </select>
        </div>
        <button
          type="submit"
          disabled={adding || !title.trim()}
          className="px-5 py-2.5 rounded-xl bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13px] hover:opacity-90 transition-opacity disabled:opacity-50"
        >
          {adding ? "..." : "Dodaj"}
        </button>
      </form>

      {/* ── Filter tabs ── */}
      <div className="flex items-center justify-between">
        <div className="flex gap-2">
          {(["pending", "done", "all"] as const).map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`px-4 py-2 rounded-xl text-[12.5px] font-semibold transition-colors ${
                filter === f
                  ? "bg-azure text-white"
                  : "bg-[#F4F7FB] text-[#5A6B80] hover:bg-[#E9EFF6]"
              }`}
            >
              {f === "pending"
                ? `Do zrobienia (${pending.length})`
                : f === "done"
                  ? `Zrobione (${done.length})`
                  : `Wszystkie (${tasks.length})`}
            </button>
          ))}
        </div>
        <p className="text-[12px] text-[#9AA7B8]">
          {pending.filter((t) => t.due_date && new Date(t.due_date) < new Date()).length} po terminie
        </p>
      </div>

      {/* ── Task list ── */}
      {loading ? (
        <div className="space-y-2 animate-pulse">
          {[0, 1, 2, 3].map((i) => (
            <div key={i} className="h-16 bg-white rounded-2xl shadow-[var(--shadow-card)]" />
          ))}
        </div>
      ) : tasks.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-[var(--shadow-card)] p-10 text-center">
          <p className="text-[#9AA7B8] text-[14px]">Brak zadań</p>
          <p className="text-[#CBD5E1] text-[12px] mt-1">
            {filter === "pending"
              ? "Dodaj pierwsze zadanie powyżej"
              : "Żadne zadanie nie pasuje do tego filtra"}
          </p>
        </div>
      ) : (
        <div className="space-y-1.5">
          {tasks.map((t) => {
            const overdue = t.due_date && new Date(t.due_date) < new Date() && t.status !== "done";
            const isToday = t.due_date && new Date(t.due_date).toDateString() === new Date().toDateString();
            return (
              <div
                key={t.id}
                className={`bg-white rounded-2xl shadow-[var(--shadow-card)] px-4 py-3 flex items-center gap-3 transition-all ${
                  t.status === "done" ? "opacity-55" : ""
                }`}
              >
                {/* Toggle done */}
                <button
                  onClick={() => handleStatus(t.id, t.status === "done" ? "pending" : "done")}
                  className={`w-5 h-5 rounded-full border-2 shrink-0 flex items-center justify-center transition-colors ${
                    t.status === "done"
                      ? "bg-success border-success"
                      : "border-[#D0D5DD] hover:border-success"
                  }`}
                >
                  {t.status === "done" && (
                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M5 12l5 5 9-11" />
                    </svg>
                  )}
                </button>

                {/* Content */}
                <div className="flex-1 min-w-0">
                  <div className={`text-[14px] font-medium flex items-center gap-2 ${
                    t.status === "done" ? "line-through text-[#8A98AB]" : "text-ink"
                  }`}>
                    {t.title}
                    {t.crm_leads?.company_name && (
                      <span className="text-[11px] font-normal text-[#9AA7B8]">
                        — {t.crm_leads.company_name}
                      </span>
                    )}
                  </div>
                  {t.description && (
                    <div className="text-[12px] text-[#7C8AA0] mt-0.5">{t.description}</div>
                  )}
                </div>

                {/* Due date */}
                {t.due_date && (
                  <span
                    className={`text-[11px] font-medium px-2 py-0.5 rounded-full shrink-0 ${
                      t.status === "done"
                        ? "text-[#CBD5E1]"
                        : overdue
                          ? "text-[#C0392B] bg-red-50"
                          : isToday
                            ? "text-azure bg-blue-50"
                            : "text-[#8A98AB]"
                    }`}
                  >
                    {overdue ? "PO TERMINIE" : isToday ? "DZIŚ" : new Date(t.due_date).toLocaleDateString("pl-PL")}
                  </span>
                )}

                {/* Priority badge */}
                <span
                  className="text-[10px] font-semibold px-2 py-0.5 rounded-full shrink-0"
                  style={{ background: `${PRIORITY_COLORS[t.priority]}15`, color: PRIORITY_COLORS[t.priority] }}
                >
                  {PRIORITY_LABELS[t.priority]}
                </span>

                {/* Delete */}
                <button
                  onClick={() => handleDelete(t.id)}
                  className="text-[#D0D5DD] hover:text-danger transition-colors shrink-0 p-0.5"
                >
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                    <path d="M3 6h18M8 6V4a1 1 0 011-1h6a1 1 0 011 1v2M19 6l-1 14a1 1 0 01-1 1H7a1 1 0 01-1-1L5 6" />
                  </svg>
                </button>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

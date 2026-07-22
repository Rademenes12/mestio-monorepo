import { createClient } from "@/lib/supabase/server";
import { CrmLead, CrmTask } from "@/lib/types";
import { runAutomations } from "@/lib/automations";
import QuickActions from "@/components/QuickActions";
import ClientFlowWidget from "@/components/ClientFlowWidget";

function tint(hex: string, alpha: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n>>16)&255},${(n>>8)&255},${n&255},${alpha})`;
}

export default async function DashboardPage() {
  const supabase = await createClient();
  await supabase.auth.getUser();

  // Silnik automatyzacji
  await runAutomations(supabase).catch(() => 0);

  // Równoległe zapytania (Promise.all) zamiast sekwencyjnych
  const [leadsRes, tasksRes, invoicesRes] = await Promise.all([
    supabase.from("crm_leads").select("*"),
    supabase
      .from("crm_tasks")
      .select("*, crm_leads(company_name)")
      .eq("done", false)
      .order("due_date", { ascending: true })
      .limit(8),
    supabase.from("crm_invoices").select("status, amount").eq("status", "overdue"),
  ]);

  const leads = (leadsRes.data as CrmLead[]) ?? [];
  const openTasks =
    (tasksRes.data as (CrmTask & { crm_leads: { company_name: string } | null })[]) ?? [];
  const overdueInvoices =
    (invoicesRes.data as { status: string; amount: number }[]) ?? [];

  const activeLeads = leads.filter((l) => l.stage === "active");
  const trialLeads = leads.filter((l) => ["onboarding", "won"].includes(l.stage));
  const mrr = activeLeads.reduce((sum, l) => sum + (l.mrr || 0), 0);

  const leads_pending = leads.filter((l) => l.stage === "lead");
  const leads_in_progress = leads.filter((l) =>
    ["contact", "demo", "offer"].includes(l.stage)
  );

  // Pipeline summary
  const pipelineStages = [
    { stage: "lead", label: "Lead", count: leads.filter((l) => l.stage === "lead").length, color: "#3E7BD6" },
    { stage: "contact", label: "Kontakt", count: leads.filter((l) => l.stage === "contact").length, color: "#173A6A" },
    { stage: "demo", label: "Demo", count: leads.filter((l) => l.stage === "demo").length, color: "#F2A900" },
    { stage: "offer", label: "Oferta", count: leads.filter((l) => l.stage === "offer").length, color: "#C98800" },
    { stage: "won", label: "Wygrana", count: leads.filter((l) => l.stage === "won").length, color: "#2E9E6B" },
  ];

  const actionQueue: {
    title: string; subtitle: string; tag: string; color: string;
    icon: string; iconBg: string; iconColor: string;
    tagBg: string; tagColor: string; cta: string; link: string;
  }[] = [];

  if (leads_pending.length) {
    const color = "#3E7BD6";
    actionQueue.push({
      title: `${leads_pending.length} ${leads_pending.length === 1 ? "nowy lead czeka" : "nowych leadów czeka"} na kontakt`,
      subtitle: leads_pending.map((l) => l.company_name).join(", "),
      tag: "Lead", color,
      icon: "M12 6v12M6 12h12",
      iconBg: tint(color, 0.12), iconColor: color,
      tagBg: tint(color, 0.13), tagColor: color,
      cta: "Zadzwoń dziś", link: "/pipeline",
    });
  }

  if (leads_in_progress.length) {
    const color = "#173A6A";
    actionQueue.push({
      title: `${leads_in_progress.length} rozmów w toku wymaga follow-upu`,
      subtitle: leads_in_progress.map((l) => l.company_name).join(", "),
      tag: "W toku", color,
      icon: "M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.4-4 8-9 8a10 10 0 01-4-.8L3 20l1.1-3.3A7.9 7.9 0 013 12c0-4.4 4-9 9-9s9 3.6 9 9z",
      iconBg: tint(color, 0.1), iconColor: color,
      tagBg: tint(color, 0.1), tagColor: color,
      cta: "Kontynuuj", link: "/pipeline",
    });
  }

  if (trialLeads.length) {
    const color = "#F2A900";
    actionQueue.push({
      title: `${trialLeads.length} ${trialLeads.length === 1 ? "próba kończy się" : "próby kończą się"} wkrótce`,
      subtitle: trialLeads.map((l) => l.company_name).join(", "),
      tag: "Próba", color,
      icon: "M12 8v4l3 2M12 3a9 9 0 100 18 9 9 0 000-18z",
      iconBg: tint(color, 0.14), iconColor: color,
      tagBg: tint(color, 0.12), tagColor: color,
      cta: "Przedłuż", link: "/customers",
    });
  }

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      {/* Quick Actions Bar */}
      <QuickActions />

      {/* Rapid stats */}
      <div className="grid grid-cols-4 gap-4">
        <a href="/customers" className="bg-white rounded-[14px] p-4 border border-[#E9EFF6] hover:shadow-sm transition-shadow">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Aktywni klienci</p>
          <p className="text-2xl font-bold text-ink mt-1">{activeLeads.length}</p>
          <p className="text-[11px] text-[#8A98AB] mt-0.5">MRR: {mrr.toLocaleString("pl-PL")} zł</p>
        </a>
        <a href="/pipeline/matrix" className="bg-white rounded-[14px] p-4 border border-[#E9EFF6] hover:shadow-sm transition-shadow">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Leady w pipeline</p>
          <p className="text-2xl font-bold text-ink mt-1">{leads_pending.length + leads_in_progress.length}</p>
          <p className="text-[11px] text-[#8A98AB] mt-0.5">{leads_pending.length} nowych, {leads_in_progress.length} w toku</p>
          <p className="text-[10px] text-azure mt-1">Macierz →</p>
        </a>
        <a href="/invoices" className="bg-white rounded-[14px] p-4 border border-[#E9EFF6] hover:shadow-sm transition-shadow">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Zaległe faktury</p>
          <p className="text-2xl font-bold text-[#C0392B] mt-1">{overdueInvoices.length}</p>
          <p className="text-[11px] text-[#8A98AB] mt-0.5">
            {overdueInvoices.reduce((s, i) => s + i.amount, 0).toLocaleString("pl-PL")} zł
          </p>
        </a>
        <a href="/kpi" className="bg-white rounded-[14px] p-4 border border-[#E9EFF6] hover:shadow-sm transition-shadow">
          <p className="text-[11px] font-medium text-[#8A98AB] uppercase tracking-wide">Otwarte zadania</p>
          <p className="text-2xl font-bold text-ink mt-1">{openTasks.length}</p>
          <p className="text-[11px] text-[#8A98AB] mt-0.5">
            {openTasks.filter((t) => t.due_date && new Date(t.due_date) < new Date()).length} po terminie
          </p>
          <p className="text-[10px] text-azure mt-1">KPI →</p>
        </a>
      </div>

      {/* Pipeline + Action cards */}
      <div className="grid grid-cols-3 gap-4">
        <div className="col-span-2 bg-white rounded-[14px] p-5 border border-[#E9EFF6]">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink">Pipeline</h3>
            <a href="/pipeline" className="text-[12px] text-azure hover:text-blueprint font-medium">Otwórz pipeline →</a>
          </div>
          <div className="flex gap-2">
            {pipelineStages.map((s) => (
              <a key={s.stage} href="/pipeline" className="flex-1 rounded-[10px] p-3 text-center hover:opacity-90 transition-opacity"
                style={{ background: tint(s.color, 0.08) }}>
                <div className="w-2 h-2 rounded-full mx-auto mb-1.5" style={{ background: s.color }} />
                <p className="text-[10px] font-semibold text-ink/60">{s.label}</p>
                <p className="text-lg font-bold text-ink mt-0.5">{s.count}</p>
              </a>
            ))}
          </div>
        </div>

        <div className="space-y-3">
          {actionQueue.map((card, i) => (
            <a key={i} href={card.link}
              className="block bg-white rounded-[14px] p-4 border border-[#E9EFF6] hover:shadow-sm transition-shadow">
              <div className="flex items-start gap-3">
                <div className="w-9 h-9 rounded-[10px] flex items-center justify-center shrink-0" style={{ background: card.iconBg }}>
                  <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke={card.iconColor} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d={card.icon} />
                  </svg>
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-[13px] font-semibold text-ink leading-snug">{card.title}</p>
                  <p className="text-[11px] text-[#8A98AB] mt-0.5 truncate">{card.subtitle}</p>
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold" style={{ background: card.tagBg, color: card.tagColor }}>{card.tag}</span>
                    <span className="text-[11px] font-medium text-azure">{card.cta} →</span>
                  </div>
                </div>
              </div>
            </a>
          ))}
          {actionQueue.length === 0 && (
            <div className="bg-white rounded-[14px] p-4 border border-[#E9EFF6] text-center text-ink/30 text-[13px]">Wszystko pod kontrolą 🎉</div>
          )}
        </div>
      </div>

      {/* Client → Project → Payment Flow */}
      <ClientFlowWidget />

      {/* Tasks + Recent Activity */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white rounded-[14px] p-5 border border-[#E9EFF6]">
          <div className="flex items-center justify-between mb-3">
            <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink">Zadania</h3>
            <a href="/team" className="text-[12px] text-azure hover:text-blueprint font-medium">Zespół →</a>
          </div>
          {openTasks.length === 0 ? (
            <p className="text-[13px] text-ink/30 text-center py-6">Brak otwartych zadań</p>
          ) : (
            <div className="space-y-2">
              {openTasks.slice(0, 5).map((task) => {
                const overdue = task.due_date && new Date(task.due_date) < new Date();
                return (
                  <div key={task.id} className="flex items-center gap-3 py-2 px-3 rounded-[10px] hover:bg-[#F4F7FB] transition-colors">
                    <div className={`w-2.5 h-2.5 rounded-full shrink-0 ${
                      task.priority === "high" ? "bg-[#C0392B]" :
                      task.priority === "medium" ? "bg-[#F2A900]" : "bg-[#6B7A90]"
                    }`} />
                    <span className="text-[13px] text-ink flex-1">{task.title}</span>
                    <span className="text-[11px] text-ink/40 shrink-0">{task.crm_leads?.company_name ?? "—"}</span>
                    {overdue && (
                      <span className="text-[10px] px-2 py-0.5 rounded-full bg-[#FFF0F0] text-[#C0392B] font-semibold">PO TERMINIE</span>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>

        <div className="bg-white rounded-[14px] p-5 border border-[#E9EFF6]">
          <h3 className="font-[family-name:var(--font-heading)] font-bold text-[15px] text-ink mb-3">Pipeline — podsumowanie</h3>
          <div className="space-y-3">
            {[
              { label: "Nowe leady", count: leads_pending.length, color: "#3E7BD6", href: "/pipeline" },
              { label: "W toku", count: leads_in_progress.length, color: "#173A6A", href: "/pipeline" },
              { label: "Aktywni klienci", count: activeLeads.length, color: "#2E9E6B", href: "/customers" },
              { label: "Zaległe faktury", count: overdueInvoices.length, color: "#C0392B", href: "/invoices" },
            ].map((item) => (
              <a key={item.label} href={item.href}
                className="flex items-center justify-between py-2.5 px-3 rounded-[10px] hover:bg-[#F4F7FB] transition-colors">
                <div className="flex items-center gap-2.5">
                  <div className="w-2.5 h-2.5 rounded-full" style={{ background: item.color }} />
                  <span className="text-[13px] text-ink">{item.label}</span>
                </div>
                <span className="text-[13px] font-bold text-ink">{item.count}</span>
              </a>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

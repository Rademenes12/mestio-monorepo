import type { SupabaseClient } from "@supabase/supabase-js";
import { CrmLead } from "./types";

export interface Automation {
  id: string;
  name: string;
  trigger_type: "new_lead" | "contract_expiring" | "invoice_overdue" | "inactive_client";
  trigger_days: number;
  segment: { stages?: string[]; plans?: string[]; sources?: string[] };
  action_type: "create_task" | "email_draft";
  action_config: { title?: string; subject?: string; body?: string };
  enabled: boolean;
}

interface Candidate {
  lead: CrmLead;
  runKey: string;
  vars: Record<string, string>; // {{firma}}, {{data}}, {{numer}}, {{kwota}}
}

function fill(template: string, vars: Record<string, string>): string {
  return template.replace(/\{\{(\w+)\}\}/g, (_, k) => vars[k] ?? "");
}

function matchesSegment(lead: CrmLead, seg: Automation["segment"]): boolean {
  if (seg.stages?.length && !seg.stages.includes(lead.stage)) return false;
  if (seg.plans?.length && !seg.plans.includes((lead.plan ?? "").toLowerCase())) return false;
  if (seg.sources?.length && !seg.sources.includes(lead.source)) return false;
  return true;
}

/**
 * Silnik automatyzacji (wzorzec HubSpot Workflows, uproszczony):
 * uruchamiany przy wejściu na Pulpit. Dla każdej włączonej reguły znajduje
 * kandydatów wg wyzwalacza, filtruje segmentem i wykonuje akcję dokładnie raz
 * (deduplikacja przez crm_automation_runs.run_key).
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function runAutomations(supabase: SupabaseClient<any>): Promise<number> {
  // Auto-status faktur: wystawione po terminie -> zaległe. Wykonywane tutaj
  // (nie tylko na stronie /invoices), bo silnik automatyzacji jest wołany na
  // Pulpicie - właściciel może nigdy nie odwiedzić Faktur, a status i tak musi
  // się przełączyć, inaczej reguła "invoice_overdue" nigdy nie znajdzie kandydatów
  // (audyt bezpieczeństwa 09.07: KPI i automatyzacja były od tego zależne w cichy sposób).
  await supabase
    .from("crm_invoices")
    .update({ status: "overdue" })
    .eq("status", "issued")
    .lt("due_date", new Date().toISOString().slice(0, 10));

  const { data: autos } = await supabase
    .from("crm_automations")
    .select("*")
    .eq("enabled", true);
  if (!autos?.length) return 0;

  const { data: leadsData } = await supabase.from("crm_leads").select("*");
  const leads = (leadsData as CrmLead[]) ?? [];
  if (!leads.length) return 0;

  const now = new Date();
  const dayMs = 86400000;
  let executed = 0;

  for (const auto of autos as Automation[]) {
    const candidates: Candidate[] = [];

    if (auto.trigger_type === "new_lead") {
      // leady utworzone w ciągu ostatnich trigger_days dni
      for (const lead of leads) {
        if (lead.stage !== "lead") continue;
        const ageDays = (now.getTime() - new Date(lead.created_at).getTime()) / dayMs;
        if (ageDays > Math.max(auto.trigger_days, 7)) continue; // nie budź starych leadów
        candidates.push({
          lead,
          runKey: lead.id,
          vars: { firma: lead.company_name },
        });
      }
    }

    if (auto.trigger_type === "contract_expiring") {
      for (const lead of leads) {
        if (!lead.contract_end) continue;
        const end = new Date(lead.contract_end);
        const daysLeft = (end.getTime() - now.getTime()) / dayMs;
        if (daysLeft < 0 || daysLeft > auto.trigger_days) continue;
        candidates.push({
          lead,
          runKey: `${lead.id}:${lead.contract_end}`,
          vars: {
            firma: lead.company_name,
            data: end.toLocaleDateString("pl-PL"),
          },
        });
      }
    }

    if (auto.trigger_type === "invoice_overdue") {
      const cutoff = new Date(now.getTime() - auto.trigger_days * dayMs)
        .toISOString()
        .slice(0, 10);
      const { data: overdue } = await supabase
        .from("crm_invoices")
        .select("id, number, amount, due_date, lead_id")
        .eq("status", "overdue")
        .lt("due_date", cutoff);
      for (const inv of overdue ?? []) {
        const lead = leads.find((l) => l.id === inv.lead_id);
        if (!lead) continue;
        candidates.push({
          lead,
          runKey: inv.id,
          vars: {
            firma: lead.company_name,
            numer: inv.number,
            kwota: String(inv.amount),
            data: inv.due_date ? new Date(inv.due_date).toLocaleDateString("pl-PL") : "—",
          },
        });
      }
    }

    if (auto.trigger_type === "inactive_client") {
      const monthKey = `${now.getFullYear()}-${now.getMonth() + 1}`;
      for (const lead of leads) {
        if (lead.stage !== "active" && lead.stage !== "risk") continue;
        const idleDays = (now.getTime() - new Date(lead.updated_at).getTime()) / dayMs;
        if (idleDays < auto.trigger_days) continue;
        // max 1 check-in per klient per miesiąc
        candidates.push({
          lead,
          runKey: `${lead.id}:${monthKey}`,
          vars: { firma: lead.company_name },
        });
      }
    }

    for (const c of candidates.filter((c) => matchesSegment(c.lead, auto.segment ?? {}))) {
      // deduplikacja: INSERT z unikalnym kluczem; konflikt (23505) = już wykonano.
      const { error: runError } = await supabase
        .from("crm_automation_runs")
        .insert({ automation_id: auto.id, run_key: c.runKey });
      if (runError) {
        if (runError.code === "23505") continue; // rzeczywisty duplikat — pomiń
        // Inny błąd (RLS/sieć/timeout) - nie zakładamy że wykonano, po prostu
        // spróbujemy przy następnym uruchomieniu. Wcześniej każdy błąd traktowano
        // jak duplikat, co mogło ciszyć trwałe błędy (audyt bezpieczeństwa 09.07).
        console.error(`[automations] insert run_key failed (${auto.name}):`, runError.message);
        continue;
      }

      if (auto.action_type === "create_task") {
        const { error } = await supabase.from("crm_tasks").insert({
          lead_id: c.lead.id,
          title: fill(auto.action_config.title ?? auto.name, c.vars),
          due_date: now.toISOString().slice(0, 10),
          priority: "Normalny",
        });
        if (error) {
          // Rollback rezerwacji run_key - inaczej akcja przepadnie na zawsze
          // mimo że zadanie nigdy nie powstało.
          await supabase.from("crm_automation_runs").delete().eq("automation_id", auto.id).eq("run_key", c.runKey);
          console.error(`[automations] create_task failed (${auto.name}):`, error.message);
          continue;
        }
        executed++;
      }

      if (auto.action_type === "email_draft") {
        if (!c.lead.contact_email) {
          await supabase.from("crm_automation_runs").delete().eq("automation_id", auto.id).eq("run_key", c.runKey);
          continue;
        }
        const { error } = await supabase.from("crm_emails").insert({
          lead_id: c.lead.id,
          to_email: c.lead.contact_email,
          subject: fill(auto.action_config.subject ?? auto.name, c.vars),
          body: fill(auto.action_config.body ?? "", c.vars),
          status: "draft",
        });
        if (error) {
          await supabase.from("crm_automation_runs").delete().eq("automation_id", auto.id).eq("run_key", c.runKey);
          console.error(`[automations] email_draft failed (${auto.name}):`, error.message);
          continue;
        }
        executed++;
      }
    }
  }

  return executed;
}

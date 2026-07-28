import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";
import Link from "next/link";
import {
  ClipboardList,
  Scale,
  Phone,
  Bell,
  ChevronRight,
} from "lucide-react";

export default async function ResidentDashboard() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/");
  const { supabase, estateId, profile } = ctx;

  if (!estateId) {
    return (
      <div className="max-w-2xl mx-auto py-12 space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">Witaj w panelu mieszkańca</h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz jeszcze przypisanego osiedla.</p>
          <p className="text-ink/30 text-sm mt-2">Skontaktuj się z administratorem, aby otrzymać zaproszenie.</p>
        </div>
      </div>
    );
  }

  const { data: reports } = await supabase
    .from("fixflow_reports")
    .select("id, title, status, category, created_at")
    .eq("estate_id", estateId)
    .eq("reporter_user_id", ctx.user.id)
    .order("created_at", { ascending: false })
    .limit(5);

  const { data: activeResolutions } = await supabase
    .from("fixflow_resolutions")
    .select("id, title, deadline")
    .eq("estate_id", estateId)
    .eq("status", "open")
    .order("created_at", { ascending: false })
    .limit(5);

  const { data: contacts } = await supabase
    .from("fixflow_emergency_contacts")
    .select("id, name, role, phone")
    .eq("estate_id", estateId)
    .eq("is_active", true)
    .eq("category", "emergency")
    .order("display_order")
    .limit(3);

  const myReportsCount = reports?.length ?? 0;
  const openReportsCount = reports?.filter((r) => r.status === "Nowe" || r.status === "W realizacji").length ?? 0;
  const activeResolutionsCount = activeResolutions?.length ?? 0;

  const QUICK_LINKS = [
    { href: "/resident/reports", label: "Moje zgłoszenia", icon: ClipboardList, desc: `${myReportsCount} zgłoszeń · ${openReportsCount} otwartych`, color: "#3E7BD6" },
    { href: "/resident/resolutions", label: "Głosowania", icon: Scale, desc: `${activeResolutionsCount} aktywnych`, color: "#2E9E6B" },
    { href: "/resident/phones", label: "Numery alarmowe", icon: Phone, desc: "Kontakty alarmowe", color: "#C0392B" },
    { href: "/resident/notifications", label: "Powiadomienia", icon: Bell, desc: "Historia powiadomień", color: "#F2A900" },
  ];

  return (
    <div className="max-w-4xl mx-auto space-y-8">
      {/* Welcome */}
      <div>
        <h1 className="text-2xl font-heading font-bold text-ink">
          {profile?.name ? `Witaj, ${profile.name}` : "Panel mieszkańca"}
        </h1>
        <p className="text-sm text-ink/50 mt-1">
          {profile?.building && profile?.apartment
            ? `${profile.building}, mieszkanie ${profile.apartment}`
            : "Przeglądaj zgłoszenia i głosuj"}
        </p>
      </div>

      {/* Quick links grid */}
      <div className="grid grid-cols-2 gap-4">
        {QUICK_LINKS.map((link) => (
          <Link
            key={link.href}
            href={link.href}
            className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5 hover:shadow-[0_4px_16px_rgba(14,26,43,.1)] transition-shadow"
          >
            <div
              className="w-10 h-10 rounded-xl flex items-center justify-center mb-3"
              style={{ backgroundColor: link.color + "15" }}
            >
              <link.icon className="w-5 h-5" style={{ color: link.color }} />
            </div>
            <h3 className="font-heading font-semibold text-[15px] text-ink">{link.label}</h3>
            <p className="text-[12px] text-ink/40 mt-0.5">{link.desc}</p>
          </Link>
        ))}
      </div>

      {/* Latest reports */}
      <section>
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-heading font-bold text-ink">Ostatnie zgłoszenia</h2>
          <Link
            href="/resident/reports"
            className="text-xs text-azure hover:underline flex items-center gap-1"
          >
            Zobacz wszystkie <ChevronRight className="w-3 h-3" />
          </Link>
        </div>
        {!reports || reports.length === 0 ? (
          <div className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-8 text-center">
            <p className="text-ink/40 text-sm">Nie masz jeszcze żadnych zgłoszeń.</p>
          </div>
        ) : (
          <div className="space-y-2">
            {reports.map((r) => (
              <div
                key={r.id}
                className="bg-white rounded-[12px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-4 flex items-center justify-between"
              >
                <div className="min-w-0 flex-1">
                  <p className="text-[13.5px] font-medium text-ink truncate">{r.title}</p>
                  <p className="text-[11px] text-ink/40 mt-0.5">
                    {r.category ?? "Bez kategorii"} · {new Date(r.created_at).toLocaleDateString("pl-PL")}
                  </p>
                </div>
                <span className="text-[11px] font-semibold px-2.5 py-0.5 rounded-full shrink-0 ml-3 text-[#3E7BD6]" style={{ backgroundColor: "#3E7BD615" }}>
                  {r.status}
                </span>
              </div>
            ))}
          </div>
        )}
      </section>

      {/* Active resolutions & Emergency contacts */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <section>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-heading font-bold text-ink">Aktywne głosowania</h2>
            <Link
              href="/resident/resolutions"
              className="text-xs text-azure hover:underline flex items-center gap-1"
            >
              Zobacz wszystkie <ChevronRight className="w-3 h-3" />
            </Link>
          </div>
          {activeResolutionsCount === 0 ? (
            <div className="bg-white rounded-[14px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-6 text-center">
              <p className="text-ink/40 text-sm">Brak aktywnych głosowań.</p>
            </div>
          ) : (
            <div className="space-y-2">
              {activeResolutions?.slice(0, 3).map((r) => (
                <div key={r.id} className="bg-white rounded-[12px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-4">
                  <p className="text-[13px] font-medium text-ink truncate">{r.title}</p>
                  {r.deadline && (
                    <p className="text-[11px] text-ink/40 mt-1">
                      Do: {new Date(r.deadline).toLocaleDateString("pl-PL")}
                    </p>
                  )}
                </div>
              ))}
            </div>
          )}
        </section>

        <section>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-heading font-bold text-ink">Numery alarmowe</h2>
            <Link
              href="/resident/phones"
              className="text-xs text-azure hover:underline flex items-center gap-1"
            >
              Zobacz wszystkie <ChevronRight className="w-3 h-3" />
            </Link>
          </div>
          {!contacts || contacts.length === 0 ? (
            <div className="bg-white rounded-[14px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-6 text-center">
              <p className="text-ink/40 text-sm">Brak zapisanych kontaktów.</p>
            </div>
          ) : (
            <div className="space-y-2">
              {contacts.map((c) => (
                <div key={c.id} className="bg-white rounded-[12px] shadow-[0_2px_8px_rgba(14,26,43,.04)] p-4 flex items-center justify-between">
                  <div>
                    <p className="text-[13px] font-medium text-ink">{c.name}</p>
                    <p className="text-[11px] text-ink/40">{c.role}</p>
                  </div>
                  <a
                    href={`tel:${c.phone}`}
                    className="text-[13px] font-mono text-azure hover:underline"
                  >
                    {c.phone}
                  </a>
                </div>
              ))}
            </div>
          )}
        </section>
      </div>
    </div>
  );
}

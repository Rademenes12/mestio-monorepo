import { getResidentContext } from "@/lib/resident-context";
import { redirect } from "next/navigation";
import { Bell } from "lucide-react";

export default async function ResidentNotificationsPage() {
  const ctx = await getResidentContext();
  if (!ctx) redirect("/login?redirect=/resident/notifications");
  const { supabase, estateId } = ctx;

  if (!estateId) {
    return (
      <div className="space-y-6">
        <h1 className="text-2xl font-heading font-bold text-ink">Powiadomienia</h1>
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Nie masz przypisanego osiedla.</p>
        </div>
      </div>
    );
  }

  // Try to get announcements as notifications for now
  const { data: announcements } = await supabase
    .from("fixflow_announcements")
    .select("id, title, content, created_at")
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false })
    .limit(20);

  const alist = announcements ?? [];

  return (
    <div className="max-w-3xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-heading font-bold text-ink">Powiadomienia</h1>
        <p className="text-sm text-ink/50 mt-1">
          Ogłoszenia i aktualności z osiedla
        </p>
      </div>

      {alist.length === 0 ? (
        <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <Bell className="w-8 h-8 mx-auto text-ink/20 mb-3" />
          <p className="text-ink/50">Brak powiadomień.</p>
          <p className="text-ink/30 text-sm mt-1">Nowe ogłoszenia pojawią się tutaj.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {alist.map((a) => (
            <div
              key={a.id}
              className="bg-white rounded-[16px] shadow-[0_2px_10px_rgba(14,26,43,.05)] p-5"
            >
              <div className="flex items-start gap-3">
                <div className="w-8 h-8 rounded-full bg-[#3E7BD615] flex items-center justify-center shrink-0 mt-0.5">
                  <Bell className="w-4 h-4 text-[#3E7BD6]" />
                </div>
                <div className="min-w-0 flex-1">
                  <h3 className="text-[14px] font-medium text-ink">{a.title}</h3>
                  {a.content && (
                    <p className="text-[12.5px] text-ink/60 mt-1 leading-relaxed">{a.content}</p>
                  )}
                  <p className="text-[11px] font-mono text-ink/30 mt-2">
                    {new Date(a.created_at).toLocaleDateString("pl-PL", {
                      day: "numeric",
                      month: "long",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

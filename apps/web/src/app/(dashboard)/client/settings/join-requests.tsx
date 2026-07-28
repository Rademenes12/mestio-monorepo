import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { DbJoinRequest } from "@/lib/types";

export function JoinRequests({
  requests,
  estateIds,
}: {
  requests: DbJoinRequest[];
  estateIds: string[];
}) {
  return (
    <div className="bg-white rounded-[12px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <h2 className="font-heading font-semibold text-ink mb-4">
        Prośby o dołączenie
      </h2>
      {requests.length === 0 ? (
        <p className="text-sm text-ink/30">Brak oczekujących próśb</p>
      ) : (
        <div className="space-y-2">
          {requests.map((r) => (
            <div
              key={r.id}
              className="flex items-center gap-3 px-3 py-2 rounded-xl bg-paper/50"
            >
              <span className="text-sm font-mono text-ink/70">
                {r.user_id.slice(0, 8)}
              </span>
              <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-azure/10 text-azure">
                {roleLabel(r.role)}
              </span>
              <span
                className={`text-[10px] px-1.5 py-0.5 rounded-full ${
                  r.status === "pending"
                    ? "bg-amber-50 text-amber-600"
                    : r.status === "approved"
                      ? "bg-green-50 text-green-600"
                      : "bg-red-50 text-red-600"
                }`}
              >
                {r.status === "pending"
                  ? "Oczekuje"
                  : r.status === "approved"
                    ? "Zaakceptowano"
                    : "Odrzucono"}
              </span>
              {r.status === "pending" && (
                <div className="ml-auto flex gap-1">
                  <form
                    action={async () => {
                      "use server";
                      if (!estateIds.includes(r.estate_id)) return;
                      const supabase = await createClient();
                      // RPC creates fixflow_user_estates + verifies profile
                      const { error } = await supabase.rpc(
                        "fixflow_approve_join_request",
                        { p_request_id: r.id }
                      );
                      if (error) {
                        console.error(error);
                        return;
                      }
                      revalidatePath("/settings");
                    }}
                  >
                    <button className="px-2 py-1 rounded-lg bg-status-closed/10 text-status-closed text-[10px] font-medium hover:bg-status-closed/20 transition-colors">
                      Akceptuj
                    </button>
                  </form>
                  <form
                    action={async () => {
                      "use server";
                      if (!estateIds.includes(r.estate_id)) return;
                      const supabase = await createClient();
                      const { error } = await supabase.rpc(
                        "fixflow_reject_join_request",
                        { p_request_id: r.id }
                      );
                      if (error) {
                        console.error(error);
                        return;
                      }
                      revalidatePath("/settings");
                    }}
                  >
                    <button className="px-2 py-1 rounded-lg bg-red-50 text-red-600 text-[10px] font-medium hover:bg-red-100 transition-colors">
                      Odrzuć
                    </button>
                  </form>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function roleLabel(role: string): string {
  const labels: Record<string, string> = {
    resident: "Mieszkaniec",
    technician: "Serwisant",
    security: "Ochrona",
    admin: "Administrator",
    board: "Zarząd",
  };
  return labels[role] ?? role;
}

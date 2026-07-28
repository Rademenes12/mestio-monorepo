import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { DbInviteCode } from "@/lib/types";
import { CopyCodeButton } from "./copy-code-button";

export function InviteCodes({
  codes,
  estateIds,
  isAdmin,
}: {
  codes: DbInviteCode[];
  estateIds: string[];
  isAdmin: boolean;
}) {
  return (
    <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-heading font-semibold text-ink">Kody zaproszeń</h2>
        <form
          action={async (formData: FormData) => {
            "use server";
            const role = formData.get("role") as string;
            const estateId = formData.get("estate_id") as string;

            const supabase = await createClient();
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) return;

            const { data: userMembership } = await supabase
              .from("fixflow_user_estates")
              .select("role")
              .eq("user_id", user.id)
              .eq("estate_id", estateId)
              .maybeSingle();

            if (!userMembership) return;

            const isCallerAdmin = userMembership.role === "admin";
            if (["admin", "board"].includes(role) && !isCallerAdmin) return;

            const autoJoin = role === "resident";
            const code = generateCode();
            const { error } = await supabase.from("fixflow_invitation_codes").insert({
              estate_id: estateId,
              code,
              role,
              auto_join: autoJoin,
              is_active: true,
              max_uses: 1,
              current_uses: 0,
            });
            if (error) return;
            revalidatePath("/settings");
          }}
          className="flex gap-2"
        >
          <input type="hidden" name="estate_id" value={estateIds[0] ?? ""} />
          <select
            name="role"
            className="px-3 py-1.5 rounded-xl border border-ink/10 text-xs bg-white focus:outline-none focus:border-azure"
          >
            <option value="resident">Mieszkaniec</option>
            <option value="technician">Serwisant</option>
            <option value="security">Ochrona</option>
            {isAdmin && (
              <>
                <option value="admin">Administrator</option>
                <option value="board">Zarząd</option>
              </>
            )}
          </select>
          <button className="px-3 py-1.5 rounded-xl bg-azure text-white text-xs font-medium hover:bg-azure/90 transition-colors">
            Generuj kod
          </button>
        </form>
      </div>

      {codes.length === 0 ? (
        <p className="text-sm text-ink/30">Brak kodów zaproszeń</p>
      ) : (
        <div className="space-y-2">
          {codes.map((c) => (
            <div
              key={c.id}
              className="flex items-center gap-3 px-3 py-2 rounded-xl bg-paper/50"
            >
              <span className="text-sm font-mono text-ink/70">{c.code}</span>
              <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-azure/10 text-azure">
                {roleLabel(c.role)}
              </span>
              {c.auto_join && (
                <span className="text-[10px] text-status-closed">
                  auto-dołączenie
                </span>
              )}
              <CopyCodeButton code={c.code} />
              <span className="text-[10px] text-ink/30">
                {c.is_active ? "Aktywny" : "Nieaktywny"}
              </span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function generateCode(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let code = "";
  for (let i = 0; i < 12; i++) {
    code += chars[Math.floor(Math.random() * chars.length)];
    if ((i + 1) % 4 === 0 && i < 11) code += "-";
  }
  return code;
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

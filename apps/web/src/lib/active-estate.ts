import { cookies } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import type { SupabaseClient, User } from "@supabase/supabase-js";

export type ActiveEstateContext = {
  supabase: SupabaseClient;
  user: User;
  /** Aktywne osiedle wybrane w nagłówku (cookie `active_estate_id`) */
  estateId: string | null;
  /** Wszystkie osiedla, w których user ma rolę admin/board */
  estateIds: string[];
  /** Rola usera w aktywnym osiedlu */
  role: "admin" | "board" | null;
};

/**
 * Jedyne źródło prawdy o aktywnym osiedlu dla stron server-side.
 * KAŻDA strona filtruje dane po `estateId` (zasada z AGENTS.md).
 */
export async function getActiveEstate(): Promise<ActiveEstateContext | null> {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: memberships } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id, role")
    .eq("user_id", user.id)
    .in("role", ["admin", "board"]);

  const estateIds = (memberships ?? []).map((m) => m.estate_id as string);
  if (estateIds.length === 0) {
    return { supabase, user, estateId: null, estateIds: [], role: null };
  }

  const cookieStore = await cookies();
  const cookieId = cookieStore.get("active_estate_id")?.value;
  const estateId =
    cookieId && estateIds.includes(cookieId) ? cookieId : estateIds[0];

  const role =
    ((memberships ?? []).find((m) => m.estate_id === estateId)?.role as
      | "admin"
      | "board"
      | undefined) ?? null;

  return { supabase, user, estateId, estateIds, role };
}

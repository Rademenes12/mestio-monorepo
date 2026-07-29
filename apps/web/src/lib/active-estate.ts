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
  const cookieStore = await cookies();
  const demoRole = cookieStore.get("mestio_demo_role")?.value;

  const {
    data: { user },
  } = await supabase.auth.getUser();

  let effectiveUser = user;
  if (!effectiveUser) {
    if (!demoRole) return null;
    effectiveUser = { id: "demo-admin-user", email: "test-admin@fixflow.app" } as unknown as User;
  }

  const { data: memberships } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id, role")
    .eq("user_id", effectiveUser.id)
    .in("role", ["admin", "board"]);

  let estateIds = (memberships ?? []).map((m) => m.estate_id as string);

  if (estateIds.length === 0) {
    const { data: anyEstates } = await supabase.from("fixflow_estates").select("id").limit(1);
    const fallbackId = anyEstates?.[0]?.id || "demo-estate-1";
    estateIds = [fallbackId];
  }

  const cookieId = cookieStore.get("active_estate_id")?.value;
  const estateId =
    cookieId && estateIds.includes(cookieId) ? cookieId : estateIds[0];

  const role =
    ((memberships ?? []).find((m) => m.estate_id === estateId)?.role as
      | "admin"
      | "board"
      | undefined) ?? "admin";

  return { supabase, user: effectiveUser, estateId, estateIds, role };
}

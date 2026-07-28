import { cookies } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import type { SupabaseClient, User } from "@supabase/supabase-js";

export type ResidentContext = {
  supabase: SupabaseClient;
  user: User;
  estateId: string | null;
  profile: {
    id: string;
    name: string | null;
    building: string | null;
    apartment: string | null;
  } | null;
};

export async function getResidentContext(): Promise<ResidentContext | null> {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: profile } = await supabase
    .from("fixflow_resident_profiles")
    .select("id, name, building, apartment")
    .eq("user_id", user.id)
    .maybeSingle();

  const { data: memberships } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id")
    .eq("user_id", user.id)
    .eq("role", "resident");

  const estateIds = (memberships ?? []).map((m) => m.estate_id as string);

  const cookieStore = await cookies();
  const cookieId = cookieStore.get("active_estate_id")?.value;
  const estateId =
    cookieId && estateIds.includes(cookieId) ? cookieId : estateIds[0] ?? null;

  return {
    supabase,
    user,
    estateId,
    profile: profile ?? null,
  };
}

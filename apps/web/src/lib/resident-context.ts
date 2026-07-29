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
  const cookieStore = await cookies();
  const demoRole = cookieStore.get("mestio_demo_role")?.value;

  const {
    data: { user },
  } = await supabase.auth.getUser();

  let effectiveUser = user;
  if (!effectiveUser) {
    if (!demoRole) return null;
    effectiveUser = { id: "demo-resident-user", email: "test-mieszkaniec@fixflow.app" } as unknown as User;
  }

  const { data: profile } = await supabase
    .from("fixflow_resident_profiles")
    .select("id, name, building, apartment")
    .eq("user_id", effectiveUser.id)
    .maybeSingle();

  const { data: memberships } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id")
    .eq("user_id", effectiveUser.id)
    .eq("role", "resident");

  let estateIds = (memberships ?? []).map((m) => m.estate_id as string);

  if (estateIds.length === 0) {
    const { data: anyEstates } = await supabase.from("fixflow_estates").select("id").limit(1);
    const fallbackId = anyEstates?.[0]?.id || "demo-estate-1";
    estateIds = [fallbackId];
  }

  const cookieId = cookieStore.get("active_estate_id")?.value;
  const estateId =
    cookieId && estateIds.includes(cookieId) ? cookieId : estateIds[0];

  return {
    supabase,
    user: effectiveUser,
    estateId,
    profile: profile ?? { id: "demo-profile", name: "Jan Kowalski", building: "A", apartment: "12" },
  };
}

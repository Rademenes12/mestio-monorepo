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
  const isDemo = cookieStore.get("mestio_demo")?.value === "true";

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    if (isDemo) {
      return {
        supabase,
        user: {
          id: "demo-resident-id",
          email: "mieszkaniec@mestio.pl",
          app_metadata: {},
          user_metadata: { name: "Mieszkaniec (Demo)" },
          aud: "authenticated",
          created_at: new Date().toISOString(),
        } as User,
        estateId: "demo-estate-id",
        profile: {
          id: "demo-profile-id",
          name: "Jan Kowalski",
          building: "Budynek A",
          apartment: "m. 14",
        },
      };
    }
    return null;
  }

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

  const cookieId = cookieStore.get("active_estate_id")?.value;
  const estateId =
    cookieId && estateIds.includes(cookieId) ? cookieId : estateIds[0] ?? (isDemo ? "demo-estate-id" : null);

  return {
    supabase,
    user,
    estateId,
    profile: profile ?? (isDemo ? { id: "demo", name: "Jan Kowalski", building: "Budynek A", apartment: "m. 14" } : null),
  };
}

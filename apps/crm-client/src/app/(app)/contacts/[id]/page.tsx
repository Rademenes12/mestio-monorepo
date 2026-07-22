import { createClient } from "@/lib/supabase/server";
import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";
import ShareEditor from "./share-editor";
import SpacesEditor from "./spaces-editor";
import ContactNotes from "./contact-notes";
import ContactTasks from "./contact-tasks";
import AnonymizeButton from "./anonymize-button";

export default async function ContactDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, role, estateId } = ctx;
  if (!estateId) redirect("/login?error=role");

  // Mieszkaniec musi należeć do AKTYWNEGO osiedla (zasada: filtruj wszystko
  // po active_estate_id) — inaczej traktujemy jak "nie znaleziono".
  const { data: targetMembership } = await supabase
    .from("fixflow_user_estates")
    .select("estate_id")
    .eq("user_id", id)
    .eq("estate_id", estateId)
    .maybeSingle();

  if (!targetMembership) {
    return (
      <div className="space-y-6">
        <Link href="/contacts" className="text-sm text-azure hover:underline">
          ← Wróć do kontaktów
        </Link>
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Mieszkaniec nie został znaleziony</p>
        </div>
      </div>
    );
  }

  const residentEstateId = targetMembership.estate_id;
  const isAdmin = role === "admin";

  const { data: profile } = await supabase
    .from("fixflow_resident_profiles")
    .select("*")
    .eq("id", id)
    .single();

  if (!profile) {
    return (
      <div className="space-y-6">
        <Link href="/contacts" className="text-sm text-azure hover:underline">
          ← Wróć do kontaktów
        </Link>
        <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-12 text-center">
          <p className="text-ink/50">Mieszkaniec nie został znaleziony</p>
        </div>
      </div>
    );
  }

  const { data: estate } = await supabase
    .from("fixflow_estates")
    .select("hide_resident_contacts, total_shares")
    .eq("id", residentEstateId)
    .single();

  const rodoActive = !isAdmin && estate?.hide_resident_contacts === true;

  const { data: spaces } = await supabase
    .from("fixflow_resident_spaces")
    .select("id, space_type, label")
    .eq("resident_id", id)
    .order("created_at", { ascending: false });

  const { data: notes } = await supabase
    .from("fixflow_contact_notes")
    .select("id, body, created_at")
    .eq("resident_id", id)
    .order("created_at", { ascending: false });

  const { data: tasks } = await supabase
    .from("fixflow_tasks")
    .select("id, title, status")
    .eq("related_resident_id", id)
    .order("created_at", { ascending: false });

  const maskContact = (value: string | null) => {
    if (!value) return "—";
    if (rodoActive) return "ukryte (RODO)";
    return value;
  };

  return (
    <div className="space-y-6">
      <Link href="/contacts" className="text-sm text-azure hover:underline">
        ← Wróć do kontaktów
      </Link>

      <div className="flex gap-6 items-start">
        <div className="flex-1 space-y-6">
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <div className="flex items-center gap-4 mb-6">
              <div className="w-14 h-14 rounded-full bg-azure/10 flex items-center justify-center">
                <span className="text-xl font-heading font-bold text-azure">
                  {(profile.name ?? "?")[0].toUpperCase()}
                </span>
              </div>
              <div>
                <h1 className="text-xl font-heading font-semibold text-ink">
                  {profile.name ?? "Bez nazwy"}
                </h1>
                <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-paper text-ink/50 mt-1 inline-block">
                  {profile.role}
                </span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <ContactField
                label="E-mail"
                value={maskContact(profile.email)}
                rodoActive={rodoActive}
              />
              <ContactField
                label="Telefon"
                value={maskContact(profile.phone)}
                rodoActive={rodoActive}
              />
              <ContactField
                label="Budynek"
                value={profile.building}
                rodoActive={false}
              />
              <ContactField
                label="Klatka"
                value={profile.footbridge}
                rodoActive={false}
              />
              <ContactField
                label="Piętro"
                value={profile.floor}
                rodoActive={false}
              />
              <ContactField
                label="Mieszkanie"
                value={profile.apartment}
                rodoActive={false}
              />
              <ContactField
                label="Powierzchnia"
                value={
                  (profile as Record<string, unknown>).apartment_area != null
                    ? `${(profile as Record<string, unknown>).apartment_area} m²`
                    : "—"
                }
                rodoActive={false}
              />
            </div>
          </div>

          <ShareEditor
            residentId={id}
            estateId={residentEstateId}
            initialShareUnits={
              ((profile as Record<string, unknown>).share_units as number) ?? null
            }
            initialTotalShares={estate?.total_shares ?? 1000}
          />

          <SpacesEditor
            estateId={residentEstateId}
            residentId={id}
            spaces={spaces ?? []}
          />

          <div className="grid grid-cols-2 gap-6">
            <ContactNotes
              estateId={residentEstateId}
              residentId={id}
              notes={notes ?? []}
            />
            <ContactTasks
              estateId={residentEstateId}
              residentId={id}
              tasks={tasks ?? []}
            />
          </div>

          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
            <h3 className="text-[13px] font-semibold text-ink/60 mb-3">Zgłoszenia</h3>
            <ReportList userId={id} estateId={residentEstateId} />
          </div>
        </div>

        <div className="w-72 shrink-0 space-y-4 sticky top-24">
          <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-5">
            <h3 className="text-[13px] font-semibold text-ink/60 mb-3">
              Informacje
            </h3>
            <div className="space-y-3 text-[12.5px]">
              <div className="flex justify-between items-center">
                <span className="text-ink/45">Zweryfikowany</span>
                <span
                  className={`font-semibold ${
                    profile.is_verified ? "text-status-closed" : "text-amber"
                  }`}
                >
                  {profile.is_verified ? "Tak" : "Nie"}
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-ink/45">RODO</span>
                <span
                  className={`font-semibold ${rodoActive ? "text-amber" : "text-status-closed"}`}
                >
                  {rodoActive ? "Dane ukryte" : "Wyłączone"}
                </span>
              </div>
              <AnonymizeButton residentId={profile.id} isAdmin={isAdmin} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function ContactField({
  label,
  value,
  rodoActive,
}: {
  label: string;
  value: string;
  rodoActive: boolean;
}) {
  return (
    <div>
      <div className="flex items-center gap-2 mb-0.5">
        <span className="text-[12px] text-ink/45">{label}</span>
        {rodoActive && (
          <span className="text-[10.5px] px-1.5 py-0.5 rounded bg-amber-50 text-amber-600 font-semibold">
            RODO
          </span>
        )}
      </div>
      <p
        className={`text-[14px] mt-0.5 ${rodoActive ? "text-ink/35 italic" : "text-ink/80"}`}
      >
        {value}
      </p>
    </div>
  );
}

async function ReportList({
  userId,
  estateId,
}: {
  userId: string;
  estateId: string;
}) {
  const supabase = await createClient();
  const { data: reports } = await supabase
    .from("fixflow_reports")
    .select("id, display_id, title, status, created_at")
    .eq("reporter_user_id", userId)
    .eq("estate_id", estateId)
    .order("created_at", { ascending: false })
    .limit(10);

  if (!reports || reports.length === 0) {
    return <p className="text-sm text-ink/40">Brak zgłoszeń od tego mieszkańca</p>;
  }

  return (
    <div className="space-y-1.5">
      {reports.map((r) => (
        <Link
          key={r.id}
          href={`/reports/${r.id}`}
          className="flex items-center gap-3 px-3 py-2.5 rounded-xl hover:bg-paper transition-colors min-h-[44px]"
        >
          <span className="text-[11.5px] font-mono text-ink/35 w-16 shrink-0">
            {r.display_id ?? r.id.slice(0, 8)}
          </span>
          <span className="text-sm text-ink/80 truncate flex-1">{r.title}</span>
          <span className="text-[11.5px] text-ink/45 shrink-0">{r.status}</span>
        </Link>
      ))}
    </div>
  );
}

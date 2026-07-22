import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

async function provisionEstate(
  admin: ReturnType<typeof createAdminClient>,
  userId: string,
  estateName: string,
  plan: string,
) {
  const { data: rpcResult, error: rpcError } = await admin.rpc("fixflow_provision_subscription", {
    p_user_id: userId,
    p_estate_name: estateName,
    p_plan: plan,
  });

  if (!rpcError) return rpcResult;

  // RPC nie istnieje lub nie działa — robimy provisioning ręcznie
  const { data: estate, error: estateError } = await admin
    .from("fixflow_estates")
    .insert({ name: estateName, plan })
    .select("id")
    .single();

  if (estateError || !estate) {
    throw new Error("Failed to create estate: " + (estateError?.message ?? "unknown"));
  }

  const { error: userEstateError } = await admin
    .from("fixflow_user_estates")
    .insert({ user_id: userId, estate_id: estate.id, role: "admin" });

  if (userEstateError) {
    throw new Error("Failed to add admin: " + userEstateError.message);
  }

  const CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const genCode = () => {
    let c = "";
    for (let i = 0; i < 12; i++) c += CODE_CHARS[Math.floor(Math.random() * CODE_CHARS.length)];
    return `${c.slice(0, 4)}-${c.slice(4, 8)}-${c.slice(8, 12)}`;
  };
  const validUntil = new Date(Date.now() + 30 * 86400000).toISOString();

  const codeRoles = [
    { role: "resident", auto_join: true, max_uses: null as number | null },
    { role: "technician", auto_join: false, max_uses: 100 },
    { role: "security", auto_join: false, max_uses: 100 },
    { role: "admin", auto_join: false, max_uses: 100 },
  ];
  for (const cr of codeRoles) {
    await admin.from("fixflow_invitation_codes").insert({
      code: genCode(),
      estate_id: estate.id,
      role: cr.role,
      auto_join: cr.auto_join,
      max_uses: cr.max_uses,
      current_uses: 0,
      valid_until: validUntil,
      is_active: true,
    });
  }

  const startDate = new Date().toISOString();
  const endDate = new Date(Date.now() + 365 * 86400000).toISOString();
  const { error: subError } = await admin.from("fixflow_subscriptions").insert({
    estate_id: estate.id,
    plan,
    status: "active",
    start_date: startDate,
    end_date: endDate,
  });

  if (subError) {
    throw new Error("Failed to create subscription: " + subError.message);
  }

  return { estate_id: estate.id };
}

export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { paymentId } = await req.json();
  if (!paymentId) {
    return NextResponse.json({ error: "Missing paymentId" }, { status: 400 });
  }

  const admin = createAdminClient();

  const { data: payment, error: fetchError } = await admin
    .from("fixflow_transfer_payments")
    .select("*")
    .eq("id", paymentId)
    .single();

  if (fetchError || !payment) {
    return NextResponse.json({ error: "Payment not found", details: fetchError?.message }, { status: 404 });
  }

  if (payment.status !== "pending") {
    return NextResponse.json({ error: "Payment already processed" }, { status: 409 });
  }

  let provisionResult;
  try {
    provisionResult = await provisionEstate(admin, payment.user_id, payment.estate_name, payment.plan);
  } catch (err) {
    return NextResponse.json({
      error: "Provisioning failed",
      details: err instanceof Error ? err.message : "unknown error",
    }, { status: 500 });
  }

  const amountPln = Math.round(payment.amount / 100);

  const { data: crmEstate } = await admin
    .from("estates")
    .insert({ name: payment.estate_name })
    .select("id")
    .single();

  const { data: existingLead } = await admin
    .from("crm_leads")
    .select("id")
    .eq("company_name", payment.estate_name)
    .maybeSingle();

  if (!existingLead) {
    const { data: newLead } = await admin.from("crm_leads").insert({
      company_name: payment.estate_name,
      source: "website",
      stage: "won",
      plan: payment.plan,
      mrr: amountPln,
      estate_id: crmEstate?.id || null,
    }).select("id").single();

    if (newLead) {
      await admin.from("crm_interactions").insert({
        lead_id: newLead.id,
        type: "auto",
        summary: `💳 Przelew potwierdzony — plan ${payment.plan}, ${amountPln} PLN/mc`,
      });
    }
  }

  const { error: updateError } = await admin
    .from("fixflow_transfer_payments")
    .update({ status: "confirmed" })
    .eq("id", paymentId);

  if (updateError) {
    return NextResponse.json({ error: "Payment confirmed but status update failed", details: updateError.message }, { status: 500 });
  }

  // Send confirmation email with admin invitation code
  try {
    const { data: userData } = await admin.auth.admin.getUserById(payment.user_id);
    const email = userData?.user?.email;
    if (email) {
      const { data: adminCode } = await admin
        .from("fixflow_invitation_codes")
        .select("code")
        .eq("estate_id", provisionResult.estate_id || provisionResult?.estate_id)
        .eq("role", "admin")
        .single();

      const resendKey = process.env.RESEND_API_KEY;
      if (resendKey) {
        await fetch("https://api.resend.com/emails", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${resendKey}`,
          },
          body: JSON.stringify({
            from: process.env.EMAIL_FROM || "Mestio <powiadomienia@mestio.pl>",
            to: email,
            subject: `Płatność za Mestio potwierdzona — Twój kod zaproszenia`,
            html: [
              `<h1 style="color:#0E1A2B">Płatność potwierdzona!</h1>`,
              `<p>Twoja subskrypcja Mestio (<strong>${payment.plan}</strong>) jest już aktywna. Osiedle: <strong>${payment.estate_name}</strong>.</p>`,
              adminCode?.code
                ? `<div style="background:#fff8e6;border-left:4px solid #F2A900;padding:16px;margin:16px 0"><p style="margin:0"><strong>Kod zaproszenia zarządcy:</strong></p><p style="font-size:24px;color:#3E7BD6;font-family:monospace;margin:8px 0 0">${adminCode.code}</p></div>`
                : "",
              `<p>Zaloguj się w aplikacji Mestio lub na <a href="https://panel.mestio.pl">panel.mestio.pl</a> i użyj kodu.</p>`,
              `<p style="color:#556677;font-size:14px">— Zespół Mestio</p>`,
            ].join(""),
          }),
        });
      }
    }
  } catch (emailError) {
    console.error("Failed to send transfer confirmation email:", emailError);
  }

  return NextResponse.json({ success: true, payment, provisioned: provisionResult });
}

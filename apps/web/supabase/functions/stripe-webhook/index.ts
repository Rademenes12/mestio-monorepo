import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import Stripe from "https://esm.sh/stripe@17.7.0?target=deno";

const CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

const PLAN_PRICES: Record<string, number> = {
  start: 7900,
  standard: 17900,
  pro: 34900,
  enterprise: 0,
};

const VAT_RATE = 23;

function generateCode(): string {
  let code = "";
  for (let i = 0; i < 12; i++) {
    code += CODE_CHARS[Math.floor(Math.random() * CODE_CHARS.length)];
  }
  return `${code.slice(0, 4)}-${code.slice(4, 8)}-${code.slice(8, 12)}`;
}

async function sendPaymentConfirmationEmail(params: {
  email: string;
  companyName: string;
  estateName: string;
  plan: string;
  invitationCode: string;
}) {
  const resendApiKey = Deno.env.get("RESEND_API_KEY");
  if (!resendApiKey) {
    console.warn("RESEND_API_KEY not set, skipping email");
    return;
  }

  const planLabels: Record<string, string> = {
    start: "Start — 79 zł/mc",
    standard: "Standard — 179 zł/mc",
    pro: "Pro — 349 zł/mc",
    enterprise: "Enterprise — wycena indywidualna",
  };

  const BRAND = {
    ink: "#0E1A2B",
    blueprint: "#173A6A",
    azure: "#3E7BD6",
    amber: "#F2A900",
    paper: "#F6F8FB",
  };

  const body = `
    <h1 style="font-family:'Space Grotesk',Arial,sans-serif;font-size:24px;font-weight:700;color:${BRAND.ink};margin:0 0 8px;">Płatność potwierdzona!</h1>
    <p style="font-size:18px;color:${BRAND.blueprint};margin:0 0 24px;font-weight:600;">Twoja subskrypcja Mestio jest już aktywna</p>

    <div style="background-color:${BRAND.paper};border-radius:8px;padding:24px;margin:0 0 24px;">
      <p style="margin:0 0 8px;font-size:14px;color:#556677;">Szczegóły subskrypcji:</p>
      <p style="margin:0;font-size:18px;font-weight:700;color:${BRAND.ink};">${planLabels[params.plan] || params.plan}</p>
      <p style="margin:8px 0 0;font-size:14px;color:#556677;">Osiedle: <strong>${params.estateName}</strong></p>
    </div>

    <p style="margin:0 0 16px;">Gratulujemy, <strong>${params.companyName}</strong>! Płatność została pomyślnie przetworzona. Twoje konto jest w pełni aktywne.</p>

    <div style="background-color:#fff8e6;border-left:4px solid ${BRAND.amber};padding:16px;margin:0 0 24px;">
      <p style="margin:0 0 8px;font-weight:600;color:${BRAND.ink};">Twój kod zaproszenia dla zarządcy:</p>
      <p style="margin:0;font-size:24px;font-weight:700;color:${BRAND.azure};letter-spacing:2px;font-family:monospace;">${params.invitationCode}</p>
      <p style="margin:8px 0 0;font-size:13px;color:#666;">Użyj tego kodu podczas pierwszego logowania w aplikacji zarządcy.</p>
    </div>

    <p style="margin:0 0 16px;font-weight:600;color:${BRAND.ink};">Co teraz?</p>

    <table role="presentation" cellpadding="12" cellspacing="0" style="margin:0 0 24px;width:100%;">
      <tr>
        <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">1.</td>
        <td style="vertical-align:top;">
          <strong style="color:${BRAND.ink};">Pobierz aplikację zarządcy</strong><br />
          <span style="font-size:14px;color:#556677;">
            <a href="#" style="color:${BRAND.azure};text-decoration:underline;">App Store</a> &bull; <a href="#" style="color:${BRAND.azure};text-decoration:underline;">Google Play</a>
          </span>
        </td>
      </tr>
      <tr>
        <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">2.</td>
        <td style="vertical-align:top;">
          <strong style="color:${BRAND.ink};">Zaloguj się kodem</strong><br />
          <span style="font-size:14px;color:#556677;">Wprowadź swój email i powyższy kod zaproszenia.</span>
        </td>
      </tr>
      <tr>
        <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">3.</td>
        <td style="vertical-align:top;">
          <strong style="color:${BRAND.ink};">Zacznij zarządzać</strong><br />
          <span style="font-size:14px;color:#556677;">Dodaj mieszkańców, zarządzaj zgłoszeniami, komunikuj się z osiedlem.</span>
        </td>
      </tr>
    </table>

    <p style="margin:0 0 16px;">Faktura VAT zostanie wysłana w oddzielnej wiadomości.</p>
    <p style="margin:0 0 16px;">Dziękujemy za zaufanie. Jesteśmy tu, aby pomóc!</p>
    <p style="margin:0;color:#556677;font-size:14px;">— Zespół Mestio</p>
  `;

  const html = `<!DOCTYPE html>
<html lang="pl">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet" />
</head>
<body style="margin:0;padding:0;background-color:${BRAND.paper};font-family:'IBM Plex Sans',Arial,sans-serif;font-size:16px;line-height:1.6;color:${BRAND.ink};">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:${BRAND.paper};padding:32px 0;">
    <tr>
      <td align="center">
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="background-color:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.06);">
          <tr>
            <td style="background-color:${BRAND.blueprint};padding:32px 40px;text-align:center;">
              <div style="font-family:'Space Grotesk',Arial,sans-serif;font-size:28px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Mestio</div>
            </td>
          </tr>
          <tr>
            <td style="padding:40px;">
              ${body}
            </td>
          </tr>
          <tr>
            <td style="background-color:${BRAND.ink};padding:24px 40px;text-align:center;">
              <p style="margin:0;font-size:14px;color:#8899aa;">
                &copy; ${new Date().getFullYear()} Mestio. Wszelkie prawa zastrzeżone.
              </p>
              <p style="margin:8px 0 0;font-size:13px;color:#667788;">
                Mestio sp. z o.o. &bull; ul. Przykładowa 1, 00-001 Warszawa
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;

  try {
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${resendApiKey}`,
      },
      body: JSON.stringify({
        from: "Mestio <powiadomienia@mestio.pl>",
        to: params.email,
        subject: "Płatność za Mestio potwierdzona — Twój kod zaproszenia",
        html,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error("Resend error:", errorText);
    }
  } catch (error) {
    console.error("Failed to send email:", error);
  }
}

async function generateInvoice(params: {
  supabaseAdmin: any;
  userId: string;
  estateId: string;
  subscriptionId: string;
  planName: string;
  buyerCompany: string;
  buyerNip: string;
  paymentIntentId?: string;
}) {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;

  // Get next invoice sequence number
  const prefix = `FV/${year}/${String(month).padStart(2, "0")}/`;
  const { data: existing } = await params.supabaseAdmin
    .from("fixflow_invoices")
    .select("invoice_number")
    .like("invoice_number", `${prefix}%`)
    .order("invoice_number", { ascending: false })
    .limit(1);

  const seq = existing && existing.length > 0
    ? parseInt(existing[0].invoice_number.split("/").pop() || "0", 10) + 1
    : 1;

  const invoiceNumber = `${prefix}${String(seq).padStart(3, "0")}`;

  const planKey = params.planName.toLowerCase();
  const amountNet = PLAN_PRICES[planKey] ?? 0;
  const amountVat = Math.round((amountNet * VAT_RATE) / 100);
  const amountGross = amountNet + amountVat;

  // Period: current month
  const periodStart = new Date(year, month - 1, 1).toLocaleDateString("pl-PL");
  const periodEnd = new Date(year, month, 0).toLocaleDateString("pl-PL");

  const { data, error } = await params.supabaseAdmin
    .from("fixflow_invoices")
    .insert({
      invoice_number: invoiceNumber,
      user_id: params.userId,
      estate_id: params.estateId,
      subscription_id: params.subscriptionId,
      plan_name: params.planName,
      period_start: periodStart,
      period_end: periodEnd,
      amount_net: amountNet,
      vat_rate: VAT_RATE,
      amount_vat: amountVat,
      amount_gross: amountGross,
      currency: "PLN",
      buyer_company: params.buyerCompany,
      buyer_nip: params.buyerNip,
      status: "paid",
      html_content: `Faktura ${invoiceNumber} - ${params.planName} - ${amountGross / 100} PLN`,
      ...(params.paymentIntentId ? { stripe_payment_intent_id: params.paymentIntentId } : {}),
    })
    .select()
    .single();

  if (error) {
    console.error("Invoice creation error:", error);
    throw error;
  }

  return data;
}

export default {
  fetch: withSupabase({ auth: "none", cors: false }, async (req, ctx) => {
    const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
      apiVersion: "2026-06-24.dahlia",
    });

    const body = await req.text();
    const signature = req.headers.get("stripe-signature") || "";

    try {
      const event = await stripe.webhooks.constructEventAsync(
        body,
        signature,
        Deno.env.get("STRIPE_WEBHOOK_SECRET")!
      );

      if (event.type === "checkout.session.completed") {
        const session = event.data.object;
        const userId = session.client_reference_id;
        const estateName = session.metadata?.estate_name || "Nowe osiedle";
        const plan = session.metadata?.plan || "standard";
        const stripePriceId = session.metadata?.stripe_price_id || "";
        const customerId =
          typeof session.customer === "string"
            ? session.customer
            : `guest_${userId || session.id}`;
        // Subscription checkout has subscription id; one-time BLIK/P24
        // (mode=payment) does not — use a stable unique key for idempotency.
        const subscriptionId =
          typeof session.subscription === "string"
            ? session.subscription
            : `onetime_${session.id}`;
        const isOneTimePayment =
          session.mode === "payment" ||
          typeof session.subscription !== "string";
        const paymentIntentId =
          typeof session.payment_intent === "string" ? session.payment_intent : "";

        if (!userId) {
          return Response.json(
            { error: "Missing client_reference_id (userId)" },
            { status: 400 }
          );
        }

        const { data: existingSub } = await ctx.supabaseAdmin
          .from("fixflow_subscriptions")
          .select("id")
          .eq("stripe_subscription_id", subscriptionId)
          .maybeSingle();

        if (existingSub) {
          return Response.json({ received: true, deduplicated: true });
        }

        if (isOneTimePayment && paymentIntentId) {
          const { data: existingPayment } = await ctx.supabaseAdmin
            .from("fixflow_invoices")
            .select("id")
            .eq("stripe_payment_intent_id", paymentIntentId)
            .maybeSingle();

          if (existingPayment) {
            return Response.json({ received: true, deduplicated: true });
          }
        }

        // Check if user already has an estate from a previous partial processing
        const { data: existingUserEstate } = await ctx.supabaseAdmin
          .from("fixflow_user_estates")
          .select("estate_id")
          .eq("user_id", userId)
          .eq("role", "admin")
          .maybeSingle();

        let estateId: string;

        if (existingUserEstate?.estate_id) {
          estateId = existingUserEstate.estate_id;
        } else {
          const { data: estate, error: estateError } = await ctx.supabaseAdmin
            .from("fixflow_estates")
            .insert({ name: estateName, created_by: userId })
            .select("id")
            .single();

          if (estateError) {
            console.error("Estate creation error:", estateError);
            return Response.json(
              { error: "Failed to create estate" },
              { status: 500 }
            );
          }

          estateId = estate.id;

          const { error: userEstateError } = await ctx.supabaseAdmin
            .from("fixflow_user_estates")
            .insert({
              user_id: userId,
              estate_id: estateId,
              role: "admin",
            });

          if (userEstateError) {
            console.error("User estate creation error:", userEstateError);
            return Response.json(
              { error: "Failed to link user to estate" },
              { status: 500 }
            );
          }
        }

        // Generate invitation codes (skip if codes already exist for this estate)
        const { count: existingCodes } = await ctx.supabaseAdmin
          .from("fixflow_invitation_codes")
          .select("*", { count: "exact", head: true })
          .eq("estate_id", estateId);

        if (!existingCodes || existingCodes === 0) {
          const validUntil = new Date();
          validUntil.setDate(validUntil.getDate() + 30);

          const codes = [
            { role: "resident", auto_join: true, max_uses: null as number | null },
            { role: "technician", auto_join: false, max_uses: 100 },
            { role: "security", auto_join: false, max_uses: 100 },
            { role: "admin", auto_join: false, max_uses: 100 },
          ];

          for (const c of codes) {
            const { error: codeError } = await ctx.supabaseAdmin
              .from("fixflow_invitation_codes")
              .insert({
                code: generateCode(),
                estate_id: estateId,
                role: c.role,
                auto_join: c.auto_join,
                max_uses: c.max_uses,
                current_uses: 0,
                valid_until: validUntil.toISOString(),
                is_active: true,
              });

            if (codeError) {
              console.error("Invitation code error:", codeError);
            }
          }
        }

        const { data: subData, error: subError } = await ctx.supabaseAdmin
          .from("fixflow_subscriptions")
          .insert({
            user_id: userId,
            estate_id: estateId,
            status: "active",
            metadata_json: {
              plan,
              payment_mode: isOneTimePayment ? "one_time" : "subscription",
              payment_type: session.metadata?.payment_type || null,
              checkout_session_id: session.id,
            },
            stripe_price_id: stripePriceId,
            stripe_customer_id: customerId,
            stripe_subscription_id: subscriptionId,
            current_period_end: new Date(
              Date.now() + 30 * 24 * 60 * 60 * 1000
            ).toISOString(),
            updated_at: new Date().toISOString(),
          })
          .select()
          .single();

        if (subError) {
          console.error("Subscription creation error:", subError);
          return Response.json(
            { error: "Failed to create subscription" },
            { status: 500 }
          );
        }

        // Get user data for invoice and email
        const { data: userData } = await ctx.supabaseAdmin.auth.admin.getUserById(userId);
        const userMetadata = userData?.user?.user_metadata || {};
        const email = userData?.user?.email || "";
        const companyName = userMetadata.company_name || "Firma";
        const buyerNip = userMetadata.nip || "";

        // Generate invoice
        try {
          await generateInvoice({
            supabaseAdmin: ctx.supabaseAdmin,
            userId,
            estateId,
            subscriptionId: subData.id,
            planName: plan,
            buyerCompany: companyName,
            buyerNip,
            paymentIntentId: isOneTimePayment ? paymentIntentId : undefined,
          });
        } catch (invoiceError) {
          console.error("Failed to generate invoice:", invoiceError);
          // Continue even if invoice fails
        }

        // ─── CRM Owner: utwórz lead + osiedle w panelu admina ───
        const mrrPln = (PLAN_PRICES[plan.toLowerCase()] ?? 0) / 100;

        const { data: crmEstate } = await ctx.supabaseAdmin
          .from("estates")
          .insert({ name: estateName })
          .select("id")
          .single();

        const { data: existingLead } = await ctx.supabaseAdmin
          .from("crm_leads")
          .select("id")
          .eq("company_name", estateName)
          .maybeSingle();

        if (!existingLead) {
          const { data: newLead, error: leadError } = await ctx.supabaseAdmin
            .from("crm_leads")
            .insert({
              company_name: estateName,
              contact_name: userMetadata.contact_name || null,
              contact_email: email || null,
              contact_phone: userMetadata.phone || null,
              nip: userMetadata.nip || null,
              source: "website",
              stage: "won",
              plan: plan,
              mrr: mrrPln,
              estate_id: crmEstate?.id || null,
            })
            .select("id")
            .single();

          if (leadError) {
            console.error("CRM Owner lead creation error:", leadError);
          } else if (newLead) {
            await ctx.supabaseAdmin.from("crm_interactions").insert({
              lead_id: newLead.id,
              type: "auto",
              summary: `💳 Płatność Stripe — plan ${plan}, ${mrrPln} PLN/mc`,
            });
            console.log("CRM Owner lead created:", estateName);
          }
        }

        // Get admin invitation code for this estate
        const { data: adminCode } = await ctx.supabaseAdmin
          .from("fixflow_invitation_codes")
          .select("code")
          .eq("estate_id", estateId)
          .eq("role", "admin")
          .single();

        // Send payment confirmation email with invitation code
        try {
          await sendPaymentConfirmationEmail({
            email,
            companyName,
            estateName,
            plan,
            invitationCode: adminCode?.code || "Kod dostępny w panelu",
          });
        } catch (emailError) {
          console.error("Failed to send email:", emailError);
          // Continue even if email fails
        }
      }

      if (event.type === "customer.subscription.updated") {
        const subscription = event.data.object;
        const { error: updateError } = await ctx.supabaseAdmin
          .from("fixflow_subscriptions")
          .update({
            status: subscription.status,
            current_period_end: subscription.current_period_end
              ? new Date(subscription.current_period_end * 1000).toISOString()
              : undefined,
            updated_at: new Date().toISOString(),
          })
          .eq("stripe_subscription_id", subscription.id);

        if (updateError) {
          console.error("Subscription update error:", updateError);
        }
      }

      if (event.type === "customer.subscription.deleted") {
        const subscription = event.data.object;
        const { error: deleteError } = await ctx.supabaseAdmin
          .from("fixflow_subscriptions")
          .update({
            status: "canceled",
            updated_at: new Date().toISOString(),
          })
          .eq("stripe_subscription_id", subscription.id);

        if (deleteError) {
          console.error("Subscription delete error:", deleteError);
        }
      }

      return Response.json({ received: true });
    } catch (error) {
      console.error("Webhook error:", error);
      return Response.json(
        { error: "Webhook processing error" },
        { status: 400 }
      );
    }
  }),
};

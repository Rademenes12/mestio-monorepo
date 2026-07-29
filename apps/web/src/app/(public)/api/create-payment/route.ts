import { NextRequest, NextResponse } from "next/server";
import { getStripe, PLANS } from "@/lib/stripe";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { registrationSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";
import { sendWelcomeEmail } from "@/lib/email";
import { createLeadFromOrder } from "@/lib/create-lead-from-order";
import { PLAN_AMOUNTS_MAP } from "@/lib/pricing";

export async function POST(request: NextRequest) {
  if (!rateLimitByIp(request, 5)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }
  try {
    const body = await request.json();

    const parsed = registrationSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          error: "Błędne dane formularza",
          details: parsed.error.flatten().fieldErrors,
        },
        { status: 400 }
      );
    }

    const {
      email,
      password,
      companyName,
      nip,
      contactName,
      phone,
      estateName,
      plan,
    } = parsed.data;

    const planConfig = PLANS[plan];
    if (!planConfig || planConfig.price === 0) {
      return NextResponse.json(
        { error: `Nieprawidłowy plan: ${plan}` },
        { status: 400 }
      );
    }

    const adminClient = supabaseAdmin();

    const { data: userData, error: signUpError } =
      await adminClient.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
          company_name: companyName,
          nip,
          contact_name: contactName,
          phone,
          estate_name: estateName,
        },
      });

    if (signUpError) {
      if (
        signUpError.message?.includes("already") ||
        signUpError.status === 422
      ) {
        return NextResponse.json(
          { error: "Konto z tym adresem e-mail już istnieje" },
          { status: 409 }
        );
      }
      console.error("User creation error:", signUpError);
      return NextResponse.json(
        { error: "Wystąpił błąd podczas rejestracji. Spróbuj ponownie." },
        { status: 500 }
      );
    }

    const userId = userData.user.id;

    // ── Utwórz leada w CRM Owner ──
    await createLeadFromOrder({
      companyName,
      contactName,
      email,
      phone,
      nip,
      plan,
      amountGrosze: PLAN_AMOUNTS_MAP[plan] ?? 0,
      paymentMethod: "blik",
      estateName,
    });

    sendWelcomeEmail({
      email,
      companyName,
      estateName,
    });

    const baseUrl =
      process.env.NEXT_PUBLIC_URL ||
      request.headers.get("origin") ||
      "http://localhost:3000";

    // Customer is required so the webhook can link Stripe ↔ user.
    const customer = await getStripe().customers.create({
      email,
      name: companyName,
      metadata: { user_id: userId, estate_name: estateName, plan },
    });

    // One-time payment (BLIK / P24 / card). Webhook provisions estate
    // using onetime_{session.id} as stripe_subscription_id for idempotency.
    const session = await getStripe().checkout.sessions.create({
      mode: "payment",
      customer: customer.id,
      payment_method_types: ["card", "blik", "p24"],
      line_items: [
        {
          price_data: {
            currency: "pln",
            product_data: {
              name: `Mestio - Plan ${plan.charAt(0).toUpperCase() + plan.slice(1)} (pierwszy miesiąc)`,
              description: `Dostęp do Mestio dla osiedla: ${estateName}. Kolejne miesiące płatne ręcznie przelewem.`,
            },
            unit_amount: planConfig.price,
          },
          quantity: 1,
        },
      ],
      client_reference_id: userId,
      metadata: {
        estate_name: estateName,
        plan,
        payment_type: "manual_recurring",
      },
      success_url: `${baseUrl}/sukces?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${baseUrl}/zamow?plan=${plan}`,
    });

    return NextResponse.json({ url: session.url });
  } catch (error: unknown) {
    console.error("create-payment error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

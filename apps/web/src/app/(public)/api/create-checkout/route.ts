import { NextRequest, NextResponse } from "next/server";
import { getStripe, PLANS } from "@/lib/stripe";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { registrationSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";
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
      acceptRegulamin,
      acceptRodo,
    } = parsed.data;

    const planConfig = PLANS[plan];
    if (!planConfig || !planConfig.priceId) {
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
      paymentMethod: "card",
      estateName,
    });

    // Welcome email will be sent by webhook AFTER successful payment

    const baseUrl =
      process.env.NEXT_PUBLIC_URL ||
      request.headers.get("origin") ||
      "http://localhost:3000";

    const session = await getStripe().checkout.sessions.create({
      mode: "subscription",
      ui_mode: "embedded_page",
      payment_method_types: ["card"],
      line_items: [{ price: planConfig.priceId, quantity: 1 }],
      client_reference_id: userId,
      metadata: {
        estate_name: estateName,
        plan,
        stripe_price_id: planConfig.priceId,
      },
      return_url: `${baseUrl}/sukces?session_id={CHECKOUT_SESSION_ID}`,
    });

    return NextResponse.json({ clientSecret: session.client_secret });
  } catch (error: unknown) {
    console.error("create-checkout error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

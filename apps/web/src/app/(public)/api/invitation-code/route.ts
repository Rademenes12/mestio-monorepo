import { NextRequest, NextResponse } from "next/server";
import { getStripe } from "@/lib/stripe";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const sessionId = searchParams.get("session_id");

  if (!sessionId) {
    return NextResponse.json({ error: "Brak session_id" }, { status: 400 });
  }

  try {
    // Auth check: user must be logged in
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json(
        { error: "Nie jesteś zalogowany" },
        { status: 401 }
      );
    }

    const session = await getStripe().checkout.sessions.retrieve(sessionId);

    if (session.payment_status !== "paid") {
      return NextResponse.json(
        { error: "Płatność nie została zakończona" },
        { status: 400 }
      );
    }

    const stripeUserId = session.client_reference_id;
    if (!stripeUserId) {
      return NextResponse.json({ error: "Brak user_id" }, { status: 400 });
    }

    // Verify the authenticated user matches the Stripe session owner
    if (user.id !== stripeUserId) {
      return NextResponse.json(
        { error: "Brak dostępu do tego kodu" },
        { status: 403 }
      );
    }

    const adminClient = supabaseAdmin();

    const { data: userEstate } = await adminClient
      .from("fixflow_user_estates")
      .select("estate_id")
      .eq("user_id", user.id)
      .eq("role", "admin")
      .single();

    if (!userEstate) {
      return NextResponse.json(
        { error: "Nie znaleziono osiedla" },
        { status: 404 }
      );
    }

    const { data: code } = await adminClient
      .from("fixflow_invitation_codes")
      .select("code, max_uses, current_uses, valid_until")
      .eq("estate_id", userEstate.estate_id)
      .eq("role", "resident")
      .eq("is_active", true)
      .single();

    if (!code) {
      return NextResponse.json(
        { error: "Nie znaleziono kodu zaproszenia" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      code: code.code,
      usesLeft:
        code.max_uses === null ? null : code.max_uses - code.current_uses,
      validUntil: code.valid_until,
    });
  } catch (error) {
    console.error("invitation-code error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

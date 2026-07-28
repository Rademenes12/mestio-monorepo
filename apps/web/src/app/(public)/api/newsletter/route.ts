import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { newsletterSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";

export async function POST(request: NextRequest) {
  if (!rateLimitByIp(request, 3)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }
  try {
    const body = await request.json();
    const parsed = newsletterSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: "Nieprawidłowy adres e-mail" },
        { status: 400 }
      );
    }

    const { email, acceptRodo } = parsed.data;

    const { data: existing } = await supabaseAdmin()
      .from("newsletter_subscribers")
      .select("id")
      .eq("email", email)
      .maybeSingle();

    if (existing) {
      return NextResponse.json({ ok: true });
    }

    const { error } = await supabaseAdmin()
      .from("newsletter_subscribers")
      .insert({ email });

    if (error) {
      console.error("Newsletter insert error:", error);
      return NextResponse.json(
        { error: "Wystąpił błąd. Spróbuj ponownie." },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true });
  } catch (error) {
    console.error("Newsletter API error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

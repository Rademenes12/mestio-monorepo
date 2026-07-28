import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { contactSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";

export async function POST(request: NextRequest) {
  if (!rateLimitByIp(request, 3)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }
  try {
    const body = await request.json();
    const parsed = contactSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: "Błędne dane formularza" },
        { status: 400 }
      );
    }

    const { name, email, message, acceptRodo } = parsed.data;

    const { error } = await supabaseAdmin()
      .from("contact_messages")
      .insert({
        name,
        email,
        message,
      });

    if (error) {
      console.error("Contact insert error:", error);
      return NextResponse.json(
        { error: "Wystąpił błąd. Spróbuj ponownie." },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true });
  } catch (error) {
    console.error("Contact API error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

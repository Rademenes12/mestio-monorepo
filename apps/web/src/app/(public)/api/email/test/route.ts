import { NextRequest, NextResponse } from "next/server";
import { Resend } from "resend";

// Debug endpoint do weryfikacji konfiguracji Resend/DNS domeny - bez tego
// guarda byl to publiczny, niezabezpieczony relay e-mail (audyt bezpieczenstwa
// 2026-07-14). Wymaga tego samego sekretu co /api/crm/blog - bez nowej
// zmiennej srodowiskowej, sekret juz jest skonfigurowany w Vercel.
function isAuthorized(request: NextRequest): boolean {
  const key = request.headers.get("x-api-key");
  const expected = process.env.CRM_BLOG_API_KEY;
  return !!expected && key === expected;
}

export async function GET(request: NextRequest) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const to = request.nextUrl.searchParams.get("to");

  if (!to) {
    return NextResponse.json(
      { error: "Missing query parameter: ?to=email@example.com" },
      { status: 400 }
    );
  }

  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    return NextResponse.json(
      { error: "RESEND_API_KEY not configured" },
      { status: 500 }
    );
  }

  try {
    const resend = new Resend(apiKey);
    const { data, error } = await resend.emails.send({
      from: process.env.EMAIL_FROM || "Mestio <powiadomienia@mestio.pl>",
      to,
      subject: "Test – Mestio Email",
      html: "<h1>Test</h1><p>To jest testowa wiadomość z Mestio.</p>",
    });

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, id: data?.id });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

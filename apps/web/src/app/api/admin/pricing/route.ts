import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { rateLimitByIp } from "@/lib/rate-limit";

/**
 * GET  /api/admin/pricing  — odczyt cen (dla CRM Owner)
 * PUT  /api/admin/pricing  — aktualizacja cen (auth przez x-api-key)
 *
 * Body PUT: { plan_key: string, amount_grosze: number, price_display: string }
 */
export async function GET(request: NextRequest) {
  if (!rateLimitByIp(request, 30)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }
  try {
    const adminClient = supabaseAdmin();
    const { data, error } = await adminClient
      .from("pricing_config")
      .select("*")
      .order("plan_key");

    if (error) {
      return NextResponse.json({ error: "Failed to read pricing" }, { status: 500 });
    }

    return NextResponse.json(data || []);
  } catch {
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  const apiKey = request.headers.get("x-api-key");
  if (!apiKey || apiKey !== process.env.CRM_BLOG_API_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();

    if (!body.plan_key || typeof body.amount_grosze !== "number" || !body.price_display) {
      return NextResponse.json(
        { error: "plan_key, amount_grosze, and price_display are required" },
        { status: 400 }
      );
    }

    const validKeys = ["start", "standard", "pro", "enterprise"];
    if (!validKeys.includes(body.plan_key)) {
      return NextResponse.json(
        { error: `plan_key must be one of: ${validKeys.join(", ")}` },
        { status: 400 }
      );
    }

    const adminClient = supabaseAdmin();
    const { error } = await adminClient
      .from("pricing_config")
      .upsert({
        plan_key: body.plan_key,
        amount_grosze: body.amount_grosze,
        price_display: body.price_display,
        updated_at: new Date().toISOString(),
      });

    if (error) {
      return NextResponse.json({ error: "Failed to update pricing" }, { status: 500 });
    }

    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}

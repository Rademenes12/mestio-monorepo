import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { rateLimitByIp } from "@/lib/rate-limit";

export async function POST(request: NextRequest) {
  if (!rateLimitByIp(request, 5)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }

  try {
    const body = await request.json();
    const { documentId } = body;

    if (!documentId) {
      return NextResponse.json({ error: "documentId is required" }, { status: 400 });
    }

    const autentiEdgeFn = process.env.SUPABASE_AUTENTI_SEND_URL;
    if (!autentiEdgeFn) {
      const { data: lead, error: leadErr } = await supabaseAdmin()
        .from("client_documents")
        .select("lead_id")
        .eq("id", documentId)
        .single();

      await supabaseAdmin()
        .from("client_documents")
        .update({ status: "sent" })
        .eq("id", documentId);

      if (!leadErr && lead?.lead_id) {
        await supabaseAdmin().from("crm_interactions").insert({
          lead_id: lead.lead_id,
          type: "auto",
          summary: "Umowa oznaczona jako wysłana (Autenti nieaktywne — skonfiguruj klucz API w Ustawieniach)",
        });
      }

      return NextResponse.json({
        success: true,
        fallback: true,
        message: "Dokument oznaczony jako wysłany. Skonfiguruj SUPABASE_AUTENTI_SEND_URL aby wysyłać przez Autenti.",
      });
    }

    const res = await fetch(autentiEdgeFn, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": process.env.CRM_API_KEY ?? "",
      },
      body: JSON.stringify({ documentId }),
    });

    if (!res.ok) {
      const err = await res.json().catch(() => ({ error: "Autenti send failed" }));
      return NextResponse.json({ error: err.error ?? "Autenti send failed" }, { status: res.status });
    }

    const result = await res.json();

    return NextResponse.json(result);
  } catch (error: unknown) {
    console.error("[send-to-autenti] Error:", error);
    const message = error instanceof Error ? error.message : "Unknown error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}

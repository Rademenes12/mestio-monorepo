import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";

/**
 * Autenti Webhook — status dokumentów
 *
 * Odbiera powiadomienia z Autenti o zmianie statusu dokumentu:
 *   PENDING → COMPLETED (wszyscy podpisali)
 *   PENDING → DECLINED (ktoś odrzucił)
 *   PENDING → EXPIRED (link wygasł)
 *
 * Format payloadu (zgodny ze specyfikacją Autenti REST API):
 * {
 *   "document_id": "uuid",
 *   "status": "PENDING" | "COMPLETED" | "DECLINED" | "EXPIRED" | "CANCELLED",
 *   "recipients": [{ "email": "...", "status": "SIGNED" | "PENDING" | "DECLINED" }],
 *   "event": "status_changed" | "recipient_signed" | "document_completed"
 * }
 */

const AUTENTI_SANDBOX_BASE = "https://api.sandbox.autenti.com/api/v1";
const AUTENTI_LIVE_BASE = "https://api.autenti.com/api/v1";

interface WebhookRecipient {
  email: string;
  name?: string;
  status: string;
}

interface AutentiWebhookPayload {
  document_id: string;
  status: string;
  event?: string;
  recipients?: WebhookRecipient[];
}

async function downloadAndStorePdf(
  supabaseAdmin: any,
  autentiDocId: string,
  docId: string,
  leadId: string,
): Promise<string | null> {
  try {
    const apiKey = Deno.env.get("AUTENTI_API_KEY") ?? "";
    const mode = (Deno.env.get("AUTENTI_MODE") ?? "sandbox") as "sandbox" | "live";
    const baseUrl = mode === "sandbox" ? AUTENTI_SANDBOX_BASE : AUTENTI_LIVE_BASE;

    if (!apiKey) return null;

    const res = await fetch(`${baseUrl}/documents/${autentiDocId}/file`, {
      headers: { Authorization: `Bearer ${apiKey}` },
    });

    if (res.status === 404 || !res.ok) return null;

    const pdfBytes = await res.arrayBuffer();
    const path = `documents/${leadId}/${docId}.pdf`;

    const { error } = await supabaseAdmin.storage.from("documents").upload(path, pdfBytes, {
      contentType: "application/pdf",
      upsert: true,
    });

    if (error) {
      console.warn("[autenti-webhook] Storage upload failed:", error.message);
      return null;
    }

    const { data: urlData } = await supabaseAdmin.storage
      .from("documents")
      .createSignedUrl(path, 3600);

    return urlData?.signedUrl ?? path;
  } catch (err) {
    console.warn("[autenti-webhook] PDF download failed:", err);
    return null;
  }
}

Deno.serve(
  withSupabase({ auth: "none", cors: false }, async (req, ctx) => {
    try {
      if (req.method !== "POST") {
        return Response.json({ error: "Method not allowed" }, { status: 405 });
      }

      const body: AutentiWebhookPayload = await req.json();
      const autentiDocId = body.document_id;
      const rawStatus = (body.status ?? body.event ?? "").toUpperCase();

      if (!autentiDocId) {
        return Response.json({ error: "Missing document_id" }, { status: 400 });
      }

      const STATUS_MAP: Record<string, { autentiStatus: string; docStatus: string }> = {
        PENDING:    { autentiStatus: "pending",   docStatus: "sent" },
        COMPLETED:  { autentiStatus: "completed", docStatus: "signed" },
        SIGNED:     { autentiStatus: "completed", docStatus: "signed" },
        DECLINED:   { autentiStatus: "declined",  docStatus: "draft" },
        REJECTED:   { autentiStatus: "declined",  docStatus: "draft" },
        EXPIRED:    { autentiStatus: "expired",   docStatus: "draft" },
        CANCELLED:  { autentiStatus: "cancelled", docStatus: "draft" },
        SENT:       { autentiStatus: "sent",      docStatus: "sent" },
      };

      const mapping = STATUS_MAP[rawStatus] ?? { autentiStatus: rawStatus.toLowerCase(), docStatus: "sent" };

      const { data: doc, error: docError } = await ctx.supabaseAdmin
        .from("client_documents")
        .select("id, lead_id")
        .eq("autenti_external_id", autentiDocId)
        .maybeSingle();

      if (docError || !doc) {
        console.warn("[autenti-webhook] Unknown document:", autentiDocId);
        return Response.json({ received: true, warning: "Document not found" });
      }

      let storagePath: string | null = null;
      if (mapping.docStatus === "signed") {
        storagePath = await downloadAndStorePdf(ctx.supabaseAdmin, autentiDocId, doc.id, doc.lead_id);
      }

      await ctx.supabaseAdmin
        .from("client_documents")
        .update({
          autenti_status: mapping.autentiStatus,
          status: mapping.docStatus,
          signed_at: mapping.docStatus === "signed" ? new Date().toISOString() : null,
          storage_path: storagePath ?? undefined,
        })
        .eq("id", doc.id);

      if (mapping.docStatus === "signed" && doc.lead_id) {
        const { data: lead } = await ctx.supabaseAdmin
          .from("crm_leads")
          .select("payment_received, contract_signed, onboarding_complete, stage")
          .eq("id", doc.lead_id)
          .single();

        const wasSigned = lead?.contract_signed ?? false;

        await ctx.supabaseAdmin
          .from("crm_leads")
          .update({ contract_signed: true, updated_at: new Date().toISOString() })
          .eq("id", doc.lead_id);

        const recipientsSummary = body.recipients
          ? body.recipients.map((r) => `${r.email}: ${r.status}`).join(", ")
          : "";

        await ctx.supabaseAdmin.from("crm_interactions").insert({
          lead_id: doc.lead_id,
          type: "auto",
          summary: `Umowa podpisana (Autenti e-podpis)${recipientsSummary ? ` – ${recipientsSummary}` : ""}${storagePath ? " – PDF zapisany" : ""}`,
        });

        if (!wasSigned) {
          const allDone = lead?.payment_received && true && lead?.onboarding_complete;
          if (allDone) {
            console.log(`[autenti-webhook] Checklist complete for lead ${doc.lead_id} — auto-progressing`);
          }
        }
      } else if (mapping.docStatus === "draft" && doc.lead_id) {
        await ctx.supabaseAdmin.from("crm_interactions").insert({
          lead_id: doc.lead_id,
          type: "auto",
          summary: `Dokument Autenti: ${rawStatus.toLowerCase()} (umowa niepodpisana)`,
        });
      }

      return Response.json({ received: true });
    } catch (err: unknown) {
      console.error("[autenti-webhook]", err);
      const message = err instanceof Error ? err.message : "Unknown error";
      return Response.json({ error: message }, { status: 500 });
    }
  }),
);

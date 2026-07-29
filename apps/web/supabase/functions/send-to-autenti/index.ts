import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";

const AUTENTI_SANDBOX_BASE = "https://api.sandbox.autenti.com/api/v1";
const AUTENTI_LIVE_BASE = "https://api.autenti.com/api/v1";

function getAutentiConfig() {
  const apiKey = Deno.env.get("AUTENTI_API_KEY") ?? "";
  const mode = (Deno.env.get("AUTENTI_MODE") ?? "sandbox") as "sandbox" | "live";
  if (!apiKey) throw new Error("AUTENTI_API_KEY is not set. Skonfiguruj klucz API w Supabase Edge Function secrets.");
  return {
    apiKey,
    mode,
    baseUrl: mode === "sandbox" ? AUTENTI_SANDBOX_BASE : AUTENTI_LIVE_BASE,
  };
}

const WEBHOOK_URL = (() => {
  const projectRef = Deno.env.get("SUPABASE_PROJECT_REF") ?? "";
  return projectRef
    ? `https://${projectRef}.supabase.co/functions/v1/autenti-webhook`
    : "";
})();

const SIGN_TYPE_MAP: Record<string, string> = {
  standard: "standard",
  qualified: "qualified",
};

interface AutentiRecipient {
  email: string;
  name: string;
  role: "SIGNER" | "APPROVER" | "VIEWER";
  signingOrder?: number;
}

interface AutentiFile {
  name: string;
  content: string;
  content_type: string;
}

interface AutentiCreatePayload {
  title: string;
  description?: string;
  recipients: AutentiRecipient[];
  files: AutentiFile[];
  callback_url: string;
  sign_type: "standard" | "qualified";
  language?: string;
}

interface AutentiCreateResponse {
  id: string;
  status: string;
  recipients: Array<{
    id: string;
    email: string;
    name: string;
    status: string;
  }>;
  links: Array<{ href: string; rel: string; method: string }>;
  created_at: string;
}

async function createDocument(
  baseUrl: string,
  apiKey: string,
  payload: AutentiCreatePayload,
): Promise<AutentiCreateResponse> {
  const res = await fetch(`${baseUrl}/documents`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      Accept: "application/json",
    },
    body: JSON.stringify(payload),
  });

  if (!res.ok) {
    const errBody = await res.text();
    let errMsg = `HTTP ${res.status}`;
    try {
      const errJson = JSON.parse(errBody);
      errMsg = errJson.message ?? errJson.error ?? errMsg;
    } catch {
      errMsg = errBody.slice(0, 500);
    }
    throw new Error(`Autenti API error: ${errMsg}`);
  }

  return res.json();
}

async function downloadSignedPdf(
  baseUrl: string,
  apiKey: string,
  documentId: string,
): Promise<Uint8Array | null> {
  const res = await fetch(`${baseUrl}/documents/${documentId}/file`, {
    headers: { Authorization: `Bearer ${apiKey}` },
  });

  if (res.status === 404) return null;
  if (!res.ok) {
    console.warn(`[autenti] Cannot download signed PDF: HTTP ${res.status}`);
    return null;
  }

  return new Uint8Array(await res.arrayBuffer());
}

interface RepInfo {
  name: string;
  email: string;
  position?: string;
}

async function fetchReps(supabaseAdmin: any, leadId: string): Promise<RepInfo[]> {
  const { data } = await supabaseAdmin
    .from("crm_settings")
    .select("value")
    .eq("key", `client_meta:${leadId}`)
    .maybeSingle();

  const meta = (data?.value ?? {}) as { reps?: RepInfo[] };
  return meta.reps?.filter((r) => r.email?.trim()) ?? [];
}

function textToBase64Pdf(text: string): string {
  const escaped = text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");

  const html = `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<style>
  body{font-family:DejaVu Sans,sans-serif;font-size:11.5px;line-height:1.65;padding:56px 64px;color:#1f2937}
  pre{white-space:pre-wrap;font-family:DejaVu Sans Mono,monospace;font-size:10.5px;margin:0}
  h1{font-size:16px;font-weight:700;margin:0 0 20px}
</style>
</head>
<body>
<h1>Umowa Mestio</h1>
<pre>${escaped}</pre>
</body>
</html>`;

  return btoa(unescape(encodeURIComponent(html)));
}

Deno.serve(
  withSupabase({ auth: "none", cors: true }, async (req, ctx) => {
    try {
      if (req.method === "OPTIONS") {
        return new Response(null, {
          headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type, Authorization, x-api-key",
          },
        });
      }

      if (req.method !== "POST") {
        return Response.json({ error: "Method not allowed" }, { status: 405 });
      }

      const crmKey = req.headers.get("x-api-key") ?? "";
      if (crmKey !== Deno.env.get("CRM_API_KEY")) {
        return Response.json({ error: "Unauthorized" }, { status: 401 });
      }

      const body = await req.json();
      const { documentId, signType } = body as { documentId: string; signType?: string };
      if (!documentId) {
        return Response.json({ error: "documentId is required" }, { status: 400 });
      }

      const { data: doc, error: docError } = await ctx.supabaseAdmin
        .from("client_documents")
        .select("id, lead_id, title, body, type, autenti_external_id, autenti_status")
        .eq("id", documentId)
        .single();

      if (docError || !doc) {
        return Response.json({ error: "Document not found" }, { status: 404 });
      }

      if (doc.autenti_external_id && doc.autenti_status === "completed") {
        return Response.json({
          success: true,
          alreadySent: true,
          autentiDocumentId: doc.autenti_external_id,
          message: "Dokument został już wysłany i podpisany",
        });
      }

      if (doc.autenti_external_id && doc.autenti_status === "sent") {
        return Response.json({
          success: true,
          alreadySent: true,
          autentiDocumentId: doc.autenti_external_id,
          message: "Dokument został już wysłany — oczekuje na podpis",
        });
      }

      const { data: lead, error: leadError } = await ctx.supabaseAdmin
        .from("crm_leads")
        .select("contact_email, contact_name")
        .eq("id", doc.lead_id)
        .single();

      if (leadError || !lead?.contact_email) {
        return Response.json({ error: "Lead or contact email not found" }, { status: 400 });
      }

      const config = getAutentiConfig();
      const effectiveSignType = SIGN_TYPE_MAP[signType ?? "standard"] ?? "standard";
      const pdfBase64 = textToBase64Pdf(doc.body);

      const reps = await fetchReps(ctx.supabaseAdmin, doc.lead_id);

      const recipients: AutentiRecipient[] = [{ email: lead.contact_email, name: lead.contact_name ?? "Klient", role: "SIGNER", signingOrder: 1 }];

      for (const rep of reps) {
        if (rep.email !== lead.contact_email) {
          recipients.push({ email: rep.email, name: rep.name, role: "SIGNER", signingOrder: 1 });
        }
      }

      const payload: AutentiCreatePayload = {
        title: doc.title,
        description: `Umowa Mestio — ${doc.title} (plan ${doc.type})`,
        recipients,
        files: [{ name: `${doc.title.replace(/\s+/g, "_")}.pdf`, content: pdfBase64, content_type: "application/pdf" }],
        callback_url: WEBHOOK_URL,
        sign_type: effectiveSignType,
        language: "pl",
      };

      const result = await createDocument(config.baseUrl, config.apiKey, payload);

      const signingLink = result.links?.find((l) => l.rel === "signing" || l.rel === "self")?.href ?? `https://app.autenti.com/documents/${result.id}`;

      await ctx.supabaseAdmin
        .from("client_documents")
        .update({
          autenti_external_id: result.id,
          autenti_link: signingLink,
          autenti_status: "sent",
          status: "sent",
        })
        .eq("id", documentId);

      await ctx.supabaseAdmin.from("crm_interactions").insert({
        lead_id: doc.lead_id,
        type: "auto",
        summary: `Umowa "${doc.title}" wysłana do podpisu przez Autenti (${recipients.length} odbiorców, tryb: ${config.mode})`,
      });

      return Response.json({
        success: true,
        autentiDocumentId: result.id,
        signingLink,
        mode: config.mode,
      });
    } catch (err: unknown) {
      console.error("[send-to-autenti]", err);
      const message = err instanceof Error ? err.message : "Unknown error";
      return Response.json({ error: message }, { status: 500 });
    }
  }),
);

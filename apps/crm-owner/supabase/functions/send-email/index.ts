// send-email: wysylka pojedynczego maila przez Resend, uzywana przez:
// - CRM Owner /mail (kompozytor + zatwierdzanie szkicow AI)
// - kolejke onboardingowa (crm_email_queue + pg_cron), patrz migracja 0013
//
// Autoryzacja: verify_jwt=true (domyslne) - wymaga waznego naglowka
// Authorization z anon/service_role/user JWT. Nie jest to publiczny endpoint.

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const EMAIL_FROM = Deno.env.get("EMAIL_FROM") || "Mestio <powiadomienia@mestio.pl>";

interface SendEmailPayload {
  to: string;
  subject: string;
  body: string; // plain text lub prosty HTML - opakowywane w wspolny szablon
  html?: boolean; // jesli true, `body` jest juz gotowym HTML (bez opakowania)
}

function wrapHtml(subject: string, bodyText: string): string {
  const safeBody = bodyText
    .split("\n")
    .map((line) => `<p style="margin:0 0 12px;">${line || "&nbsp;"}</p>`)
    .join("");
  return `<!DOCTYPE html>
<html>
  <body style="margin:0;padding:0;background:#F6F8FB;font-family:'IBM Plex Sans',Arial,sans-serif;">
    <div style="max-width:560px;margin:0 auto;padding:32px 24px;">
      <div style="font-family:'Space Grotesk',Arial,sans-serif;font-weight:700;font-size:20px;color:#0E1A2B;margin-bottom:20px;">
        Mestio
      </div>
      <div style="background:#fff;border-radius:16px;padding:28px;box-shadow:0 2px 12px rgba(14,26,43,.06);color:#1f2937;font-size:14.5px;line-height:1.6;">
        ${safeBody}
      </div>
      <div style="text-align:center;margin-top:20px;font-size:11.5px;color:#9AA7B8;">
        Mestio — zarządzanie zgłoszeniami dla wspólnot i spółdzielni · mestio.pl
      </div>
    </div>
  </body>
</html>`;
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return Response.json({ error: "Method not allowed" }, { status: 405 });
  }

  if (!RESEND_API_KEY) {
    console.error("send-email: RESEND_API_KEY not configured");
    return Response.json(
      { error: "Email delivery not configured (missing RESEND_API_KEY)" },
      { status: 500 }
    );
  }

  let payload: SendEmailPayload;
  try {
    payload = await req.json();
  } catch {
    return Response.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const { to, subject, body, html } = payload;
  if (!to || !subject || !body) {
    return Response.json(
      { error: "Missing required fields: to, subject, body" },
      { status: 400 }
    );
  }

  try {
    const resendRes = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: EMAIL_FROM,
        to,
        subject,
        html: html ? body : wrapHtml(subject, body),
      }),
    });

    if (!resendRes.ok) {
      const errorText = await resendRes.text();
      console.error("Resend API error:", errorText);
      return Response.json(
        { error: "Resend delivery failed", details: errorText },
        { status: 502 }
      );
    }

    const data = await resendRes.json();
    return Response.json({ success: true, id: data.id });
  } catch (error) {
    console.error("send-email failed:", error);
    return Response.json(
      { error: error instanceof Error ? error.message : "Unknown error" },
      { status: 500 }
    );
  }
});

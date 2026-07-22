import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { performSecurityCheck } from "@/lib/security-check";

const RESEND_KEY = process.env.RESEND_API_KEY;
const FROM_EMAIL = process.env.EMAIL_FROM || "Mestio <powiadomienia@mestio.pl>";
const MAX_DAILY_SENDS = 2000; // Resend free tier limit

export async function POST(req: NextRequest) {
  if (!RESEND_KEY) {
    return NextResponse.json({ error: "RESEND_API_KEY nie skonfigurowany" }, { status: 500 });
  }

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { subject, html, draft_id, require_approval } = await req.json();
  if (!subject || !html) {
    return NextResponse.json({ error: "Brak tematu lub treści HTML" }, { status: 400 });
  }

  // ===== SECURITY CHECKS =====

  // 1. Check if draft exists and has approval (if required)
  if (draft_id) {
    const { data: draft } = await supabase
      .from("newsletter_drafts")
      .select("status, plagiarism_score, phishing_risk_level")
      .eq("id", draft_id)
      .eq("user_id", user.id)
      .single();

    if (draft && require_approval) {
      // Require approval workflow
      if (draft.status !== "approved") {
        return NextResponse.json(
          { error: "Newsletter must be approved before sending. Current status: " + draft.status },
          { status: 400 }
        );
      }

      // Double-check plagiarism score
      if (draft.plagiarism_score > 60) {
        return NextResponse.json(
          { error: `Cannot send: Plagiarism score ${draft.plagiarism_score}% exceeds 60% threshold` },
          { status: 400 }
        );
      }

      // Double-check phishing risk
      if (draft.phishing_risk_level === "high") {
        return NextResponse.json(
          { error: "Cannot send: High phishing risk detected" },
          { status: 400 }
        );
      }
    }
  }

  // 2. Perform security check on content
  const securityCheck = performSecurityCheck(subject, html);
  if (!securityCheck.safe_to_send) {
    return NextResponse.json(
      {
        error: "Newsletter failed security checks",
        security: securityCheck,
      },
      { status: 400 }
    );
  }

  // 3. Check daily send limit
  const today = new Date().toISOString().split("T")[0];
  const { data: statsData } = await supabase
    .from("newsletter_send_stats")
    .select("emails_sent")
    .eq("user_id", user.id)
    .eq("send_date", today)
    .single();

  const emailsSentToday = statsData?.emails_sent || 0;

  // Pobierz aktywnych subskrybentów
  const { data: subscribers, error: subError } = await supabase
    .from("newsletter_subscribers")
    .select("email")
    .eq("unsubscribed", false);

  if (subError) {
    return NextResponse.json({ error: subError.message }, { status: 500 });
  }

  if (!subscribers || subscribers.length === 0) {
    return NextResponse.json({ error: "Brak aktywnych subskrybentów" }, { status: 400 });
  }

  // 4. Check daily limit
  if (emailsSentToday + subscribers.length > MAX_DAILY_SENDS) {
    return NextResponse.json(
      {
        error: `Daily send limit (${MAX_DAILY_SENDS}) would be exceeded. Sent today: ${emailsSentToday}/${MAX_DAILY_SENDS}`,
      },
      { status: 429 }
    );
  }

  const results: { email: string; status: string; error?: string }[] = [];
  let sent = 0;
  let failed = 0;

  // Wysyłka pojedynczych maili (Resend nie ma batch API dla różnych odbiorców)
  for (const sub of subscribers) {
    try {
      const res = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${RESEND_KEY}`,
        },
        body: JSON.stringify({
          from: FROM_EMAIL,
          to: [sub.email],
          subject,
          html,
          reply_to: "support@mestio.pl",
        }),
      });

      if (res.ok) {
        sent++;
        results.push({ email: sub.email, status: "sent" });
      } else {
        const err = await res.json().catch(() => ({}));
        failed++;
        results.push({ email: sub.email, status: "failed", error: (err as { message?: string })?.message ?? `HTTP ${res.status}` });
      }
    } catch (e) {
      failed++;
      results.push({ email: sub.email, status: "failed", error: e instanceof Error ? e.message : "nieznany błąd" });
    }

    // Małe opóźnienie żeby nie przekroczyć rate limitu
    if (subscribers.indexOf(sub) < subscribers.length - 1) {
      await new Promise((r) => setTimeout(r, 200));
    }
  }

  // Update send stats
  const { error: statsError } = await supabase
    .from("newsletter_send_stats")
    .upsert(
      {
        user_id: user.id,
        send_date: today,
        emails_sent: emailsSentToday + sent,
        emails_failed: failed,
      },
      { onConflict: "user_id,send_date" }
    );

  if (statsError) {
    console.error("Error updating stats:", statsError);
  }

  // Update draft status to "sent"
  if (draft_id) {
    await supabase
      .from("newsletter_drafts")
      .update({
        status: "sent",
        sent_at: new Date().toISOString(),
        sent_to_count: sent,
        failed_count: failed,
      })
      .eq("id", draft_id);

    // Log send action
    await supabase.from("approval_logs").insert({
      draft_id,
      user_id: user.id,
      action: "sent",
      review_notes: `Sent to ${sent} recipients, ${failed} failed`,
    });
  }

  return NextResponse.json({
    total: subscribers.length,
    sent,
    failed,
    sent_today: emailsSentToday + sent,
    daily_limit: MAX_DAILY_SENDS,
    results: results.filter((r) => r.status === "failed"),
    security: securityCheck,
  });
}

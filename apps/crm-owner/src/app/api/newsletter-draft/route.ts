import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";
import { checkPlagiarism } from "@/lib/plagiarism-check";
import { replaceImagePlaceholders } from "@/lib/unsplash-api";
import { performSecurityCheck } from "@/lib/security-check";

export async function POST(request: Request) {
  try {
    const { subject, html_content, ai_topic, action, draft_id, status, review_notes } = await request.json();

    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // === ACTION: save-draft ===
    if (action === "save-draft") {
      // Validate input
      if (!subject?.trim() || !html_content?.trim()) {
        return NextResponse.json(
          { error: "Subject and HTML required" },
          { status: 400 }
        );
      }

      // Process images
      let processedHtml = html_content;
      try {
        processedHtml = await replaceImagePlaceholders(html_content);
      } catch (err) {
        console.error("Image processing error:", err);
        // Continue without image processing
      }

      // Check plagiarism
      const plagiarismReport = await checkPlagiarism(subject + " " + html_content);

      // Check security (phishing, spam, malicious links)
      const securityCheck = performSecurityCheck(subject, html_content);

      // Save to drafts table
      const { data, error } = await supabase
        .from("newsletter_drafts")
        .insert({
          user_id: user.id,
          subject: subject.trim(),
          html_content: processedHtml,
          ai_topic: ai_topic?.trim() || null,
          status: "draft",
          plagiarism_score: plagiarismReport.score,
          plagiarism_report: plagiarismReport,
          ai_generated_probability: plagiarismReport.ai_generated_probability,
          phishing_risk_level: securityCheck.phishing_risk_level,
        })
        .select()
        .single();

      if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
      }

      return NextResponse.json({
        success: true,
        draft: data,
        plagiarism: plagiarismReport,
        security: securityCheck,
      });
    }

    // === ACTION: submit-for-review ===
    if (action === "submit-for-review") {
      if (!draft_id) {
        return NextResponse.json({ error: "draft_id required" }, { status: 400 });
      }

      // Update draft status
      const { data: draft, error: updateError } = await supabase
        .from("newsletter_drafts")
        .update({ status: "pending_review", updated_at: new Date().toISOString() })
        .eq("id", draft_id)
        .eq("user_id", user.id)
        .select()
        .single();

      if (updateError) {
        return NextResponse.json({ error: updateError.message }, { status: 500 });
      }

      // Log approval action
      await supabase.from("approval_logs").insert({
        draft_id,
        user_id: user.id,
        action: "submitted_for_review",
        review_notes: review_notes || "User submitted for review",
      });

      return NextResponse.json({ success: true, draft });
    }

    // === ACTION: approve ===
    if (action === "approve") {
      if (!draft_id) {
        return NextResponse.json({ error: "draft_id required" }, { status: 400 });
      }

      // Verify plagiarism check
      const { data: draft } = await supabase
        .from("newsletter_drafts")
        .select("*")
        .eq("id", draft_id)
        .eq("user_id", user.id)
        .single();

      if (!draft) {
        return NextResponse.json({ error: "Draft not found" }, { status: 404 });
      }

      // Block if plagiarism > 60%
      if (draft.plagiarism_score > 60) {
        return NextResponse.json(
          { error: `Plagiarism score too high (${draft.plagiarism_score}%). Cannot approve.` },
          { status: 400 }
        );
      }

      // Block if high phishing risk
      if (draft.phishing_risk_level === "high") {
        return NextResponse.json(
          { error: "High phishing risk detected. Cannot approve." },
          { status: 400 }
        );
      }

      // Update draft status
      const { data: approved, error: updateError } = await supabase
        .from("newsletter_drafts")
        .update({
          status: "approved",
          reviewed_by: user.id,
          approved_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        })
        .eq("id", draft_id)
        .select()
        .single();

      if (updateError) {
        return NextResponse.json({ error: updateError.message }, { status: 500 });
      }

      // Log approval action
      await supabase.from("approval_logs").insert({
        draft_id,
        user_id: user.id,
        action: "reviewed_and_approved",
        review_notes: review_notes || "Approved for sending",
        plagiarism_checked: true,
        plagiarism_score: draft.plagiarism_score,
      });

      return NextResponse.json({ success: true, draft: approved });
    }

    // === ACTION: reject ===
    if (action === "reject") {
      if (!draft_id || !review_notes) {
        return NextResponse.json({ error: "draft_id and review_notes required" }, { status: 400 });
      }

      // Update draft status back to draft
      const { data: rejected, error: updateError } = await supabase
        .from("newsletter_drafts")
        .update({
          status: "draft",
          updated_at: new Date().toISOString(),
        })
        .eq("id", draft_id)
        .eq("user_id", user.id)
        .select()
        .single();

      if (updateError) {
        return NextResponse.json({ error: updateError.message }, { status: 500 });
      }

      // Log rejection
      await supabase.from("approval_logs").insert({
        draft_id,
        user_id: user.id,
        action: "reviewed_and_rejected",
        review_notes,
      });

      return NextResponse.json({ success: true, draft: rejected });
    }

    // === ACTION: soft-delete ===
    if (action === "soft-delete") {
      if (!draft_id) {
        return NextResponse.json({ error: "draft_id required" }, { status: 400 });
      }

      const { data: deleted, error: deleteError } = await supabase
        .from("newsletter_drafts")
        .update({
          soft_deleted: true,
          deleted_by: user.id,
          deleted_at: new Date().toISOString(),
        })
        .eq("id", draft_id)
        .eq("user_id", user.id)
        .select()
        .single();

      if (deleteError) {
        return NextResponse.json({ error: deleteError.message }, { status: 500 });
      }

      return NextResponse.json({ success: true, draft: deleted });
    }

    return NextResponse.json(
      { error: "Invalid action" },
      { status: 400 }
    );
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    console.error("[newsletter-draft]", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

// GET drafts list or specific draft with approval history
export async function GET(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const url = new URL(request.url);
    const draftId = url.searchParams.get("id");

    // Get specific draft with approval history
    if (draftId) {
      const { data: draft, error: draftError } = await supabase
        .from("newsletter_drafts")
        .select("*")
        .eq("id", draftId)
        .eq("user_id", user.id)
        .single();

      if (draftError) {
        return NextResponse.json({ error: "Draft not found" }, { status: 404 });
      }

      // Get approval history
      const { data: approvals } = await supabase
        .from("approval_logs")
        .select("*")
        .eq("draft_id", draftId)
        .order("created_at", { ascending: false });

      return NextResponse.json({ draft, approvals: approvals || [] });
    }

    // Get all drafts (excluding soft-deleted)
    const { data, error } = await supabase
      .from("newsletter_drafts")
      .select("*")
      .eq("user_id", user.id)
      .eq("soft_deleted", false)
      .order("created_at", { ascending: false });

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ drafts: data });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

// DELETE permanently remove a draft (admin only, or soft-delete)
export async function DELETE(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const url = new URL(request.url);
    const draftId = url.searchParams.get("id");

    if (!draftId) {
      return NextResponse.json({ error: "draft_id required" }, { status: 400 });
    }

    // Soft delete
    const { error } = await supabase
      .from("newsletter_drafts")
      .update({
        soft_deleted: true,
        deleted_by: user.id,
        deleted_at: new Date().toISOString(),
      })
      .eq("id", draftId)
      .eq("user_id", user.id);

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, message: "Draft soft-deleted" });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

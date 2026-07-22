/**
 * Email Preview API
 * Renders email in HTML format for desktop and mobile preview
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    const { html, viewtype } = await request.json();

    if (!html) {
      return NextResponse.json({ error: "HTML content required" }, { status: 400 });
    }

    // Create responsive preview wrapper
    const viewType = viewtype || "desktop"; // 'desktop', 'mobile', 'tablet'

    const preview = createPreviewHtml(html, viewType);

    return NextResponse.json({
      success: true,
      preview,
      viewtype: viewType,
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    console.error("[preview-email]", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

export async function GET(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const url = new URL(request.url);
    const draftId = url.searchParams.get("id");
    const viewType = url.searchParams.get("viewtype") || "desktop";

    if (!draftId) {
      return NextResponse.json({ error: "draft_id required" }, { status: 400 });
    }

    // Get draft
    const { data: draft, error } = await supabase
      .from("newsletter_drafts")
      .select("subject, html_content")
      .eq("id", draftId)
      .eq("user_id", user.id)
      .single();

    if (error || !draft) {
      return NextResponse.json({ error: "Draft not found" }, { status: 404 });
    }

    // Create preview
    const preview = createPreviewHtml(draft.html_content, viewType);

    return NextResponse.json({
      success: true,
      subject: draft.subject,
      preview,
      viewtype: viewType,
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    console.error("[preview-email]", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

/**
 * Create responsive preview HTML
 */
function createPreviewHtml(html: string, viewType: string): string {
  let width = "600px";
  let deviceLabel = "Desktop (600px)";

  if (viewType === "mobile") {
    width = "375px";
    deviceLabel = "Mobile (375px)";
  } else if (viewType === "tablet") {
    width = "480px";
    deviceLabel = "Tablet (480px)";
  }

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Email Preview</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 40px 20px;
      min-height: 100vh;
    }
    .preview-container {
      max-width: 800px;
      margin: 0 auto;
    }
    .device-label {
      color: white;
      font-size: 14px;
      margin-bottom: 15px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .device-info {
      font-weight: 600;
      letter-spacing: 0.5px;
    }
    .preview-frame {
      width: ${width};
      margin: 0 auto;
      background: white;
      border-radius: 12px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
    }
    .email-content {
      width: 100%;
      max-width: 100%;
      display: block;
    }
    .email-content img {
      max-width: 100%;
      height: auto;
    }
    .preview-warning {
      background: #fff3cd;
      border-left: 4px solid #ffc107;
      padding: 12px 15px;
      margin-bottom: 20px;
      border-radius: 4px;
      color: #856404;
      font-size: 13px;
      line-height: 1.5;
    }
    @media (max-width: 768px) {
      body {
        padding: 20px 10px;
      }
      .preview-frame {
        width: 100%;
        max-width: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="preview-container">
    <div class="device-label">
      <span class="device-info">${deviceLabel}</span>
    </div>
    
    <div class="preview-warning">
      ℹ️ This is a preview of how your email will appear to recipients. Always test before sending to ensure proper rendering across different email clients.
    </div>

    <div class="preview-frame">
      <div class="email-content">
        ${html}
      </div>
    </div>
  </div>
</body>
</html>
  `.trim();
}

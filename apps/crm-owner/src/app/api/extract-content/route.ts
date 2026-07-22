/**
 * Content Extraction API
 * Extract content from URLs and cache for newsletter generation
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { extractContentFromUrl, convertToNewsletterHtml } from "@/lib/content-extraction";

export async function POST(request: Request) {
  try {
    const { url } = await request.json();

    if (!url || typeof url !== "string") {
      return NextResponse.json({ error: "Valid URL required" }, { status: 400 });
    }

    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Check cache first
    const { data: cachedContent } = await supabase
      .from("content_extraction_cache")
      .select("*")
      .eq("user_id", user.id)
      .eq("source_url", url)
      .gt("expires_at", new Date().toISOString())
      .single();

    if (cachedContent) {
      return NextResponse.json({
        success: true,
        extracted: cachedContent,
        cached: true,
      });
    }

    // Extract content
    const extracted = await extractContentFromUrl(url);

    // Save to cache (upsert)
    await supabase
      .from("content_extraction_cache")
      .upsert({
        user_id: user.id,
        source_url: extracted.source_url,
        extracted_title: extracted.title,
        extracted_content: extracted.content,
        extracted_html: extracted.html,
        source_type: extracted.source_type,
        content_hash: extracted.content_hash,
      });

    // Get subscriber count for newsletter generation
    const { count: subscriberCount } = await supabase
      .from("newsletter_subscribers")
      .select("*", { count: "exact" })
      .eq("unsubscribed", false);

    // Convert to newsletter format
    const newsletter = convertToNewsletterHtml(extracted, subscriberCount || 0);

    return NextResponse.json({
      success: true,
      extracted,
      newsletter,
      cached: false,
    });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    console.error("[extract-content]", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

/**
 * GET - Clear cache for a URL
 */
export async function DELETE(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const url = new URL(request.url);
    const sourceUrl = url.searchParams.get("url");

    if (!sourceUrl) {
      return NextResponse.json({ error: "URL parameter required" }, { status: 400 });
    }

    const { error } = await supabase
      .from("content_extraction_cache")
      .delete()
      .eq("user_id", user.id)
      .eq("source_url", sourceUrl);

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, message: "Cache cleared" });
  } catch (e) {
    const msg = e instanceof Error ? e.message : "Unknown error";
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}

import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { rateLimitByIp } from "@/lib/rate-limit";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const apiKey = request.headers.get("x-api-key");
  if (!apiKey || apiKey !== process.env.CRM_BLOG_API_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (!rateLimitByIp(request, 10)) {
    return NextResponse.json(
      { error: "Too many requests — max 10 per minute" },
      { status: 429 }
    );
  }

  try {
    const { id } = await params;
    const adminClient = supabaseAdmin();

    const { error } = await adminClient
      .from("blog_posts")
      .delete()
      .eq("id", id);

    if (error) {
      console.error("blog post delete error:", error);
      return NextResponse.json(
        { error: "Błąd usuwania z bazy" },
        { status: 500 }
      );
    }

    return NextResponse.json({ deleted: true, id });
  } catch (error) {
    console.error("crm blog delete error:", error);
    return NextResponse.json(
      { error: "Wewnętrzny błąd serwera" },
      { status: 500 }
    );
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const apiKey = request.headers.get("x-api-key");
  if (!apiKey || apiKey !== process.env.CRM_BLOG_API_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (!rateLimitByIp(request, 10)) {
    return NextResponse.json(
      { error: "Too many requests — max 10 per minute" },
      { status: 429 }
    );
  }

  try {
    const { id } = await params;
    const body = await request.json();
    const adminClient = supabaseAdmin();

    const update: Record<string, unknown> = {};
    if (body.title !== undefined) update.title = body.title;
    if (body.content !== undefined) update.body = body.content;
    if (body.excerpt !== undefined) update.excerpt = body.excerpt;
    if (body.cover_image !== undefined) update.cover_url = body.cover_image || null;
    if (body.author_name !== undefined) update.author_name = body.author_name;
    if (body.tags !== undefined) update.tags = body.tags;
    if (body.status !== undefined) update.status = body.status;
    if (body.published_at !== undefined) {
      const d = new Date(body.published_at);
      if (!isNaN(d.getTime())) update.published_at = d.toISOString();
    }
    update.updated_at = new Date().toISOString();

    if (Object.keys(update).length <= 1) {
      return NextResponse.json(
        { error: "Brak pól do aktualizacji" },
        { status: 400 }
      );
    }

    const { data: post, error } = await adminClient
      .from("blog_posts")
      .update(update)
      .eq("id", id)
      .select()
      .single();

    if (error) {
      console.error("blog post update error:", error);
      return NextResponse.json(
        { error: "Błąd aktualizacji" },
        { status: 500 }
      );
    }

    return NextResponse.json(post);
  } catch (error) {
    console.error("crm blog update error:", error);
    return NextResponse.json(
      { error: "Wewnętrzny błąd serwera" },
      { status: 500 }
    );
  }
}

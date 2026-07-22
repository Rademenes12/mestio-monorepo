import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { crmBlogPostSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";

/**
 * Zamienia polskie znaki na ASCII i formatuje slug.
 * "Wspólnota mieszkaniowa" → "wspolnota-mieszkaniowa"
 */
function slugify(text: string): string {
  return text
    .toString()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80);
}

export async function POST(request: NextRequest) {
  const apiKey = request.headers.get("x-api-key");
  if (!apiKey || apiKey !== process.env.CRM_BLOG_API_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (!rateLimitByIp(request, 10)) {
    return NextResponse.json(
      { error: "Too many requests — max 10 per minute" },
      { status: 429 },
    );
  }

  try {
    const body = await request.json();
    const parsed = crmBlogPostSchema.safeParse(body);

    if (!parsed.success) {
      const flat = parsed.error.flatten();
      const fieldErrors: Record<string, string> = {};
      for (const [field, msgs] of Object.entries(flat.fieldErrors)) {
        fieldErrors[field] = (msgs as string[])[0] || "Nieprawidłowa wartość";
      }

      return NextResponse.json(
        {
          error: "Błąd walidacji",
          fields: fieldErrors,
          hint: "Sprawdź pola: slug (tylko a-z, 0-9 i myślniki), content (min. 50 znaków), excerpt (10–300 znaków)",
        },
        { status: 400 },
      );
    }

    const {
      title,
      slug: rawSlug,
      content,
      excerpt,
      cover_image,
      author_name,
      published_at,
      tags,
      status,
    } = parsed.data;

    // Automatycznie popraw slug jeśli zawiera polskie znaki
    const slug = slugify(rawSlug) || slugify(title);

    const adminClient = supabaseAdmin();

    const { data: existing } = await adminClient
      .from("blog_posts")
      .select("id")
      .eq("slug", slug)
      .maybeSingle();

    if (existing) {
      return NextResponse.json(
        { error: "Post o tym slugu już istnieje. Zmień tytuł lub slug." },
        { status: 409 },
      );
    }

    // Walidacja daty — jeśli nieprawidłowa, użyj aktualnej
    let publishDate = new Date().toISOString();
    if (published_at) {
      const d = new Date(published_at);
      if (!isNaN(d.getTime())) publishDate = d.toISOString();
    }

    const { data: post, error } = await adminClient
      .from("blog_posts")
      .insert({
        title,
        slug,
        content,
        excerpt,
        cover_image: cover_image ?? null,
        author_name,
        published_at: publishDate,
        tags: tags ?? [],
        status,
      })
      .select()
      .single();

    if (error) {
      console.error("blog post insert error:", error);
      return NextResponse.json(
        { error: "Błąd zapisu do bazy. Spróbuj ponownie." },
        { status: 500 },
      );
    }

    return NextResponse.json(post, { status: 201 });
  } catch (error) {
    console.error("crm blog error:", error);
    return NextResponse.json(
      { error: "Wewnętrzny błąd serwera" },
      { status: 500 },
    );
  }
}

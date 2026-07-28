import type { Metadata } from "next";
import { supabase } from "@/lib/supabase";
import Link from "next/link";
import { notFound } from "next/navigation";

interface BlogPostDetail {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  content: string;
  tag: string;
  read_time: string;
  created_at: string;
  cover_color: string;
}

async function getPost(slug: string): Promise<BlogPostDetail | null> {
  try {
    const { data, error } = await supabase
      .from("blog_posts")
      .select("*")
      .eq("slug", slug)
      .eq("status", "published")
      .single();

    if (error || !data) return null;

    const row = data as Record<string, unknown>;

    function extractTag(tags: unknown): string {
      if (Array.isArray(tags) && tags.length > 0) return String(tags[0]);
      if (typeof tags === "string") return tags;
      return "";
    }

    return {
      id: String(row.id ?? ""),
      title: String(row.title ?? ""),
      slug: String(row.slug ?? ""),
      excerpt: String(row.excerpt ?? ""),
      content: String(row.content ?? ""),
      tag: String(row.tag || extractTag(row.tags)),
      read_time: String(row.read_time || "5 min"),
      created_at: String(row.published_at ?? row.created_at ?? ""),
      cover_color: String(row.cover_color ?? ""),
    };
  } catch {
    return null;
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const slug = (await params).slug;
  const post = await getPost(slug);
  if (!post) return { title: "Nie znaleziono" };

  return {
    title: post.title,
    description: post.excerpt || post.title,
    openGraph: {
      title: `${post.title} — Blog Mestio`,
      description: post.excerpt || "",
      type: "article",
      publishedTime: post.created_at,
      tags: post.tag ? [post.tag] : undefined,
    },
    alternates: { canonical: `https://mestio.pl/blog/${slug}` },
  };
}

const COVERS = [
  "#3E7BD6",
  "linear-gradient(135deg, #F2A900, #C98800)",
  "linear-gradient(135deg, #2E9E6B, #173A6A)",
];

export default async function BlogPostPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const post = await getPost(slug);

  if (!post) notFound();

  const coverIdx = post.id.charCodeAt(post.id.length - 1) % COVERS.length;

  return (
    <div className="max-w-[820px] mx-auto px-6 py-[50px] pb-[70px]">
      <div
        className="h-[200px] rounded-[12px] mb-6"
        style={{
          background: post.cover_color || COVERS[coverIdx],
        }}
      />
      <div className="font-mono text-[10.5px] text-[#8A98AB] uppercase tracking-[0.4px] mb-2">
        {post.tag} &middot; {post.read_time}
      </div>
      <h1 className="font-heading font-bold text-[32px] tracking-[-0.6px] leading-tight text-ink">
        {post.title}
      </h1>
      <div className="text-[15px] text-[#5A6B80] mt-4 leading-relaxed">
        {post.content || post.excerpt}
      </div>
      <Link
        href="/blog"
        className="inline-block mt-10 text-sm font-semibold text-azure hover:underline"
      >
        &larr; Wszystkie artykuły
      </Link>
    </div>
  );
}

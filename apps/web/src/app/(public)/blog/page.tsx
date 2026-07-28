import type { Metadata } from "next";
import { supabase } from "@/lib/supabase";
import Link from "next/link";
import NewsletterSignup from "@/components/NewsletterSignup";

export const metadata: Metadata = {
  title: "Blog",
  description: "Baza wiedzy dla wspólnot mieszkaniowych i zarządców — poradniki, przepisy, dobre praktyki w zarządzaniu osiedlami. Artykuły pisane przez ekspertów Mestio.",
  openGraph: {
    title: "Blog — Baza wiedzy dla wspólnot i zarządców | Mestio",
    description: "Praktyczne poradniki dla zarządców nieruchomości, przepisy, dobre praktyki.",
    type: "website",
  },
  alternates: { canonical: "https://mestio.pl/blog" },
};

const COVERS = [
  "linear-gradient(135deg, #3E7BD6, #173A6A)",
  "linear-gradient(135deg, #F2A900, #C98800)",
  "linear-gradient(135deg, #2E9E6B, #173A6A)",
  "linear-gradient(135deg, #6B7A90, #173A6A)",
  "linear-gradient(135deg, #173A6A, #3E7BD6)",
  "linear-gradient(135deg, #3E7BD6, #2E9E6B)",
];

interface BlogPost {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  tag: string;
  read_time: string;
  created_at: string;
}

function extractTag(tags: unknown): string {
  if (Array.isArray(tags) && tags.length > 0) return String(tags[0]);
  if (typeof tags === "string") return tags;
  return "";
}

function estimateReadTime(content: string | null | undefined): string {
  if (!content) return "5 min";
  const words = content.split(/\s+/).length;
  if (words < 200) return "3 min";
  if (words < 500) return "5 min";
  if (words < 1000) return "8 min";
  return "12 min";
}

async function getPosts(): Promise<BlogPost[] | null> {
  try {
    const { data, error } = await supabase
      .from("blog_posts")
      .select("id, title, slug, excerpt, tags, content, published_at, status")
      .eq("status", "published")
      .order("published_at", { ascending: false });

    if (error) return null;

    return ((data || []) as Record<string, unknown>[]).map((row) => ({
      id: String(row.id ?? ""),
      title: String(row.title ?? ""),
      slug: String(row.slug ?? ""),
      excerpt: String(row.excerpt ?? ""),
      tag: extractTag(row.tags),
      read_time: String(row.read_time || estimateReadTime(row.content as string | null)),
      created_at: String(row.published_at ?? row.created_at ?? ""),
    }));
  } catch {
    return null;
  }
}

export default async function BlogPage() {
  const posts = await getPosts();

  return (
    <div className="max-w-[1000px] mx-auto px-6 py-[50px] pb-[70px]">
      <h1 className="font-heading font-bold text-[32px] tracking-[-0.6px] text-ink">
        Baza wiedzy dla wspólnot i zarządców
      </h1>
      <p className="text-[15px] text-[#4A5A6E] mt-2">
        Praktyczne poradniki: prawo, techniczne przeglądy, komunikacja z
        mieszkańcami.
      </p>

      {!posts ? (
        <div className="text-center py-20 text-[#8A98AB]">
          <p className="text-lg">
            Brak dostępnych artykułów — baza bloga nie jest jeszcze
            skonfigurowana.
          </p>
          <p className="text-sm mt-2">
            Artykuły pojawią się tutaj po opublikowaniu ich z panelu CRM Owner.
            Zajrzyj wkrótce!
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-[18px] mt-7">
          {posts.map((post, i) => (
            <Link
              key={post.id}
              href={`/blog/${post.slug}`}
              className="bg-white rounded-[22px] shadow-[0_2px_14px_rgba(14,26,43,.06)] overflow-hidden hover:shadow-[0_6px_20px_rgba(14,26,43,.10)] transition-shadow"
            >
              <div
                className="h-[140px]"
                style={{ background: COVERS[i % COVERS.length] }}
              />
              <div className="p-5">
                <div className="font-mono text-[10.5px] text-[#8A98AB] uppercase tracking-[0.4px]">
                  {post.tag} &middot; {post.read_time}
                </div>
                <h2 className="font-heading font-semibold text-lg mt-2 leading-tight text-ink">
                  {post.title}
                </h2>
                <p className="text-[13.5px] text-[#5A6B80] leading-relaxed mt-2">
                  {post.excerpt}
                </p>
                <span className="inline-block text-[13px] font-semibold text-azure mt-3">
                  Czytaj &rarr;
                </span>
              </div>
            </Link>
          ))}
        </div>
      )}

      <NewsletterSignup />
    </div>
  );
}

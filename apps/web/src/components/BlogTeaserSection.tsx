import { supabase } from "@/lib/supabase";
import Link from "next/link";

async function getLatestPosts(limit: number) {
  const { data } = await supabase
    .from("blog_posts")
    .select("id, title, excerpt, tags, slug")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .limit(limit);
  return (data || []).map((row: Record<string, unknown>) => ({
    ...row,
    tag: Array.isArray(row.tags) && row.tags.length > 0 ? String(row.tags[0]) : String(row.tag ?? ""),
  }));
}

const COVERS = [
  "linear-gradient(135deg, #3E7BD6, #173A6A)",
  "linear-gradient(135deg, #F2A900, #C98800)",
  "linear-gradient(135deg, #2E9E6B, #173A6A)",
  "linear-gradient(135deg, #7C3AED, #3E7BD6)",
  "linear-gradient(135deg, #173A6A, #0E1A2B)",
];

const FALLBACK_POSTS = [
  {
    tag: "Prawo",
    title: "Obowiązkowe przeglądy techniczne — kalendarz 2026",
    excerpt: "Kominiarski, gazowy, elektryczny, wind — kiedy, jak często i kto odpowiada.",
  },
  {
    tag: "Zarządzanie",
    title: "Jak skrócić czas naprawy usterek o połowę",
    excerpt: "Priorytety, SLA i jasny obieg zgłoszeń — praktyczny przewodnik dla zarządu.",
  },
  {
    tag: "Wspólnota",
    title: "Komunikacja z mieszkańcami bez chaosu",
    excerpt: "Dlaczego ogłoszenia z terminem wygaśnięcia działają lepiej niż posty na FB.",
  },
];

export default async function BlogTeaserSection() {
  const posts = await getLatestPosts(3);
  const hasPosts = posts.length > 0;
  const items = hasPosts ? posts : FALLBACK_POSTS;

  return (
    <section className="max-w-[1160px] mx-auto px-6 py-10">
      <div className="flex items-baseline justify-between">
        <h2 className="font-heading font-bold text-[26px] tracking-[-0.5px] text-ink">
          Baza wiedzy dla wspólnot
        </h2>
        <Link
          href="/blog"
          className="text-sm font-semibold text-azure hover:underline"
        >
          Zobacz wszystkie &rarr;
        </Link>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[18px] mt-[22px]">
        {items.map((item: Record<string, unknown>, i: number) => {
          const slug = (item as { slug?: string }).slug;
          const tagStr = String(item.tag || "");
          const titleStr = String(item.title || "");
          const excerptStr = String(item.excerpt || "");

          return (
            <Link
              key={slug || titleStr}
              href={slug ? `/blog/${slug}` : "/blog"}
              className="bg-white rounded-[22px] overflow-hidden shadow-[0_2px_14px_rgba(14,26,43,.06)] cursor-pointer hover:shadow-[0_6px_20px_rgba(14,26,43,.10)] transition-shadow"
            >
              <div
                className="h-[130px]"
                style={{ background: COVERS[i % COVERS.length] }}
              />
              <div className="p-[18px]">
                <div className="font-mono text-[10.5px] text-[#8A98AB] uppercase tracking-[0.4px]">
                  {tagStr}
                </div>
                <h3 className="font-heading font-semibold text-base mt-2 leading-tight text-ink">
                  {titleStr}
                </h3>
                <p className="text-[13px] text-[#5A6B80] leading-relaxed mt-[7px]">
                  {excerptStr}
                </p>
              </div>
            </Link>
          );
        })}
      </div>
    </section>
  );
}

import { colors } from "@mestio/design-tokens";
import { Sparkles } from "lucide-react";
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
  `linear-gradient(135deg, ${colors.accent}, ${colors.navy})`,
  `linear-gradient(135deg, ${colors.warning}, #C98800)`,
  `linear-gradient(135deg, ${colors.success}, ${colors.navy})`,
  `linear-gradient(135deg, #7C3AED, ${colors.accent})`,
  `linear-gradient(135deg, ${colors.navy}, #0E1A2B)`,
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
    <section id="blog" className="max-w-7xl mx-auto px-6 py-[60px]">
      <div className="text-center">
        <div
          className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-4"
          style={{
            background: `${colors.info}12`,
            color: colors.info,
            border: `1px solid ${colors.info}25`,
          }}
        >
          <Sparkles className="w-3.5 h-3.5" />
          Baza wiedzy
        </div>
        <h2
          className="font-heading font-bold text-[30px] tracking-[-0.6px]"
          style={{ color: colors.text }}
        >
          Baza wiedzy dla wspólnot
        </h2>
        <p
          className="text-sm mt-3 max-w-xl mx-auto"
          style={{ color: colors.textSecondary }}
        >
          Praktyczne artykuły o zarządzaniu nieruchomościami i zgłoszeniach.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[18px] mt-[26px]">
        {items.map((item: Record<string, unknown>, i: number) => {
          const slug = (item as { slug?: string }).slug;
          const tagStr = String(item.tag || "");
          const titleStr = String(item.title || "");
          const excerptStr = String(item.excerpt || "");

          return (
            <Link
              key={slug || titleStr}
              href={slug ? `/blog/${slug}` : "/blog"}
              className="glass-card overflow-hidden transition-all duration-300 hover:translate-y-[-4px]"
              style={{ borderColor: colors.cardBorder }}
            >
              <div
                className="h-[130px]"
                style={{ background: COVERS[i % COVERS.length] }}
              />
              <div className="p-[20px]">
                <div
                  className="font-mono text-[10.5px] uppercase tracking-[0.4px]"
                  style={{ color: colors.textMuted }}
                >
                  {tagStr}
                </div>
                <h3
                  className="font-heading font-semibold text-base mt-2 leading-tight"
                  style={{ color: colors.text }}
                >
                  {titleStr}
                </h3>
                <p
                  className="text-[13px] leading-relaxed mt-[7px]"
                  style={{ color: colors.textSecondary }}
                >
                  {excerptStr}
                </p>
              </div>
            </Link>
          );
        })}
      </div>

      <div className="text-center mt-8">
        <Link
          href="/blog"
          className="inline-flex items-center gap-2 text-sm font-semibold px-5 py-3 rounded-xl transition-all duration-200"
          style={{
            background: `${colors.accent}12`,
            color: colors.accent,
            border: `1px solid ${colors.accent}25`,
          }}
        >
          Zobacz wszystkie artykuły &rarr;
        </Link>
      </div>
    </section>
  );
}

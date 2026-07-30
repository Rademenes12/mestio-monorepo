import type { Metadata } from "next";
import { supabase } from "@/lib/supabase";
import Link from "next/link";
import NewsletterSignup from "@/components/NewsletterSignup";
import { Sparkles, Globe, Coins, Smartphone, ArrowRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Blog i Nowości — Mestio",
  description: "Baza wiedzy dla wspólnot mieszkaniowych, zarządców i mieszkańców. Aktualności, poradniki i nowe funkcje w systemie Mestio.",
  openGraph: {
    title: "Blog i Nowości | Mestio",
    description: "Praktyczne poradniki dla zarządców nieruchomości, aktualności i nowe funkcje.",
    type: "website",
  },
  alternates: { canonical: "https://mestio.pl/blog" },
};

export interface DisplayPost {
  id: string;
  title: string;
  slug: string;
  excerpt: string;
  tag: string;
  date: string;
  gradient: string;
  iconType?: "points" | "globe" | "app" | "plus";
}

const SAMPLE_POSTS: DisplayPost[] = [
  {
    id: "featured-1",
    title: "Plan Wspólnotowy zmienia się w Mestio Plus",
    slug: "plan-wspolnotowy-zmienia-sie-w-mestio-plus",
    excerpt:
      "Wprowadzamy kluczowe ulepszenia w platformie Mestio. Wszystkie najważniejsze funkcje zgłaszania usterek, audytu SLA i e-podpisu umów są teraz dostępne w jednym zintegrowanym pakiecie.",
    tag: "Mestio Team",
    date: "24 Czerwca 2025",
    gradient: "linear-gradient(135deg, #70E1FF 0%, #3E7BD6 50%, #173A6A 100%)",
    iconType: "plus",
  },
  {
    id: "story-1",
    title: "Punkty i Nagrody dla Aktywnych Mieszkańców",
    slug: "punkty-i-nagrody-dla-aktywnych-mieszkancow",
    excerpt:
      "Wprowadzamy prosty i przejrzysty system nagradzania mieszkańców za zgłaszanie usterek oraz udział w corocznych głosowaniach uchwał osiedlowych.",
    tag: "Mestio Team",
    date: "18 Kwietnia 2025",
    gradient: "linear-gradient(135deg, #FFE699 0%, #FFB338 50%, #E67300 100%)",
    iconType: "points",
  },
  {
    id: "story-2",
    title: "Nowy Standard Bezpieczeństwa RODO i Separacji Danych",
    slug: "nowy-standard-bezpieczenstwa-rodo-i-separacji-danych",
    excerpt:
      "Przedstawiamy dedykowany protokół separacji danych osiedli, który gwarantuje 100% prywatności i pełną zgodność z polskimi przepisami prawa.",
    tag: "Mestio Team",
    date: "3 Kwietnia 2025",
    gradient: "linear-gradient(135deg, #80E5FF 0%, #33B5E5 50%, #0077B6 100%)",
    iconType: "globe",
  },
  {
    id: "story-3",
    title: "Premiera Wersji Beta Aplikacji Mobilnej Mestio",
    slug: "premiera-wersji-beta-aplikacji-mobilnej-mestio",
    excerpt:
      "Startuje oficjalna wersja beta aplikacji mobilnej dla mieszkańców i zarządców osiedli. Zgłaszaj usterki w mniej niż 60 sekund ze zdjęciem z telefonu.",
    tag: "Mestio Team",
    date: "3 Stycznia 2025",
    gradient: "linear-gradient(135deg, #C2B3FF 0%, #8C66FF 50%, #5227CC 100%)",
    iconType: "app",
  },
];

async function getPostsFromDb(): Promise<DisplayPost[] | null> {
  try {
    const { data, error } = await supabase
      .from("blog_posts")
      .select("id, title, slug, excerpt, tags, published_at, cover_color")
      .eq("status", "published")
      .order("published_at", { ascending: false });

    if (error || !data || data.length === 0) return null;

    const gradients = [
      "linear-gradient(135deg, #70E1FF 0%, #3E7BD6 50%, #173A6A 100%)",
      "linear-gradient(135deg, #FFE699 0%, #FFB338 50%, #E67300 100%)",
      "linear-gradient(135deg, #80E5FF 0%, #33B5E5 50%, #0077B6 100%)",
      "linear-gradient(135deg, #C2B3FF 0%, #8C66FF 50%, #5227CC 100%)",
    ];

    return (data as Record<string, unknown>[]).map((row, idx) => ({
      id: String(row.id ?? ""),
      title: String(row.title ?? ""),
      slug: String(row.slug ?? ""),
      excerpt: String(row.excerpt ?? ""),
      tag: "Mestio Team",
      date: row.published_at
        ? new Date(String(row.published_at)).toLocaleDateString("pl-PL", {
            day: "numeric",
            month: "long",
            year: "numeric",
          })
        : "Niedawno",
      gradient: String(row.cover_color || gradients[idx % gradients.length]),
    }));
  } catch {
    return null;
  }
}

export default async function BlogPage() {
  const dbPosts = await getPostsFromDb();
  const allPosts = dbPosts && dbPosts.length > 0 ? dbPosts : SAMPLE_POSTS;

  const featured = allPosts[0];
  const stories = allPosts.slice(1, 4);

  return (
    <div className="min-h-screen bg-[#FAF9F6]">
      {/* Background Soft Glow (Portrait Style) */}
      <div className="relative max-w-7xl mx-auto px-6 pt-16 pb-24 overflow-hidden">
        <div
          className="absolute -top-40 -left-40 w-96 h-96 rounded-full pointer-events-none opacity-40 blur-3xl"
          style={{ background: "radial-gradient(circle, #FFE5EC 0%, #E8F0FE 60%, transparent 100%)" }}
        />

        {/* ── TOP HERO FEATURED SECTION ── */}
        <div className="grid grid-cols-1 lg:grid-cols-[1.05fr_0.95fr] gap-12 items-center mb-24 relative z-10">
          {/* Left Column: Big Headline & Info */}
          <div>
            <h1 className="font-heading font-bold text-[40px] sm:text-[52px] lg:text-[56px] text-ink leading-[1.08] tracking-[-1.8px]">
              {featured.title}
            </h1>
            <p className="text-[16px] sm:text-[18px] text-ink/60 leading-relaxed mt-6 max-w-xl">
              {featured.excerpt}
            </p>
            <div className="mt-8">
              <Link
                href={`/blog/${featured.slug}`}
                className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-white border border-[#E0E6ED] text-ink text-sm font-semibold shadow-sm hover:shadow-md hover:border-azure transition-all"
              >
                Czytaj artykuł
                <ArrowRight className="w-4 h-4 text-azure" />
              </Link>
            </div>
          </div>

          {/* Right Column: Featured Card (Portrait Hero Card) */}
          <Link
            href={`/blog/${featured.slug}`}
            className="group rounded-3xl border border-[#E9EEF5] bg-white shadow-sm overflow-hidden transition-all duration-300 hover:shadow-xl hover:-translate-y-1 block"
          >
            {/* Banner with Gradient */}
            <div
              className="h-64 sm:h-72 relative flex items-center justify-center p-8 overflow-hidden"
              style={{ background: featured.gradient }}
            >
              {/* Badge top-left */}
              <div className="absolute top-4 left-4 inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/90 backdrop-blur-md text-[11px] font-semibold text-ink shadow-sm">
                <span className="w-2 h-2 rounded-full bg-azure" />
                {featured.tag}
              </div>

              {/* Central Banner Graphic */}
              <div className="flex flex-col items-center justify-center text-white text-center">
                <div className="w-16 h-16 rounded-2xl bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center mb-3 shadow-lg">
                  <Sparkles className="w-8 h-8 text-white animate-pulse" />
                </div>
                <span className="font-heading font-bold text-3xl sm:text-4xl tracking-tight text-white drop-shadow-sm">
                  Plus
                </span>
              </div>
            </div>

            {/* Card Footer Info */}
            <div className="p-7 bg-white">
              <div className="text-xs text-ink/40 font-medium mb-2">{featured.date}</div>
              <h2 className="font-heading font-bold text-xl sm:text-22 text-ink group-hover:text-azure transition-colors leading-snug">
                {featured.title}
              </h2>
              <p className="text-sm text-ink/60 leading-relaxed mt-2.5 line-clamp-2">
                {featured.excerpt}
              </p>
            </div>
          </Link>
        </div>

        {/* ── MORE STORIES GRID SECTION (Portrait Grid) ── */}
        <div className="relative z-10">
          <h2 className="font-heading font-bold text-2xl sm:text-3xl text-ink mb-8 tracking-[-0.6px]">
            Więcej artykułów
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-7">
            {stories.map((story) => (
              <Link
                key={story.id}
                href={`/blog/${story.slug}`}
                className="group rounded-3xl border border-[#E9EEF5] bg-white shadow-sm overflow-hidden transition-all duration-300 hover:shadow-xl hover:-translate-y-1.5 flex flex-col justify-between"
              >
                <div>
                  {/* Top Graphic Card Header */}
                  <div
                    className="h-48 relative flex items-center justify-center p-6 overflow-hidden"
                    style={{ background: story.gradient }}
                  >
                    {/* Badge top-left */}
                    <div className="absolute top-4 left-4 inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/90 backdrop-blur-md text-[11px] font-semibold text-ink shadow-sm">
                      <span className="w-2 h-2 rounded-full bg-azure" />
                      {story.tag}
                    </div>

                    {/* Graphics / Icons depending on story */}
                    {story.iconType === "points" && (
                      <div className="flex flex-col items-center">
                        <div className="px-4 py-2 rounded-full bg-white/90 backdrop-blur-md border border-white/40 shadow-lg text-amber-600 font-mono text-xs font-bold flex items-center gap-2">
                          <Coins className="w-4 h-4" />
                          1 000 000 pkt
                        </div>
                      </div>
                    )}

                    {story.iconType === "globe" && (
                      <div className="w-14 h-14 rounded-full bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center text-white shadow-lg">
                        <Globe className="w-8 h-8" />
                      </div>
                    )}

                    {story.iconType === "app" && (
                      <div className="w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center text-white shadow-lg">
                        <Smartphone className="w-8 h-8" />
                      </div>
                    )}

                    {(!story.iconType || story.iconType === "plus") && (
                      <div className="w-12 h-12 rounded-xl bg-white/20 backdrop-blur-md flex items-center justify-center text-white">
                        <Sparkles className="w-6 h-6" />
                      </div>
                    )}
                  </div>

                  {/* Body Content */}
                  <div className="p-6 bg-white">
                    <div className="text-xs text-ink/40 font-medium mb-2">{story.date}</div>
                    <h3 className="font-heading font-bold text-lg text-ink group-hover:text-azure transition-colors leading-snug">
                      {story.title}
                    </h3>
                    <p className="text-sm text-ink/60 leading-relaxed mt-2.5 line-clamp-3">
                      {story.excerpt}
                    </p>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>

        {/* Newsletter Footer Section */}
        <div className="mt-20">
          <NewsletterSignup />
        </div>
      </div>
    </div>
  );
}

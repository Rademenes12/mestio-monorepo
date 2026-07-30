import type { Metadata } from "next";
import { supabase } from "@/lib/supabase";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Sparkles, ArrowLeft } from "lucide-react";

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

const SAMPLE_POSTS_DETAIL: Record<string, BlogPostDetail> = {
  "plan-wspolnotowy-zmienia-sie-w-mestio-plus": {
    id: "featured-1",
    title: "Plan Wspólnotowy zmienia się w Mestio Plus",
    slug: "plan-wspolnotowy-zmienia-sie-w-mestio-plus",
    excerpt:
      "Wprowadzamy kluczowe ulepszenia w platformie Mestio. Wszystkie najważniejsze funkcje zgłaszania usterek, audytu SLA i e-podpisu umów są teraz dostępne w jednym zintegrowanym pakiecie.",
    content: `
      Wprowadzamy kluczowe ulepszenia w systemie Mestio. Zdumiewająco proste zgłaszanie usterek, pełny ślad audytowy i cyfrowa obsługa umów zostały połączone w spójny pakiet Mestio Plus.
      
      ## Co nowego w Mestio Plus?
      - **Aplikacja Mobilna dla Mieszkańców**: Nowy interfejs ze zdjęciami na żywo, powiadomieniami push i statystykami.
      - **Ślad Audytowy SLA**: Każda zmiana statusu usterki (Nowe → W realizacji → Zamknięte) jest rejestrowana z dokładnością do sekundy.
      - **Integracja e-Podpisu Autenti**: Podpisuj umowy z zarządcami i dostawcami usług bez papieru i bez wychodzenia z domu.
      - **Zautomatyzowany Pipeline w CRM Owner**: Klient po zleceniu na www trafia automatycznie do pipeline'u z przygotowanym osiedlem.

      Nowy pakiet jest dostępny dla wszystkich dotychczasowych i nowych osiedli bez dodatkowych opłat aktywacyjnych.
    `,
    tag: "Mestio Team",
    read_time: "5 min czytania",
    created_at: "24 Czerwca 2025",
    cover_color: "linear-gradient(135deg, #70E1FF 0%, #3E7BD6 50%, #173A6A 100%)",
  },
  "punkty-i-nagrody-dla-aktywnych-mieszkancow": {
    id: "story-1",
    title: "Punkty i Nagrody dla Aktywnych Mieszkańców",
    slug: "punkty-i-nagrody-dla-aktywnych-mieszkancow",
    excerpt:
      "Wprowadzamy prosty i przejrzysty system nagradzania mieszkańców za zgłaszanie usterek oraz udział w corocznych głosowaniach uchwał osiedlowych.",
    content: `
      Zaangażowanie społeczności to klucz do zadbanego i bezpiecznego osiedla. System Punktów Mestio docenia mieszkańców, którzy aktywnie dbają o części wspólne.

      ## Jak działa system punktowy?
      1. **Zgłoszenie usterki**: Za każde zweryfikowane zgłoszenie awarii w częściach wspólnych otrzymujesz punkty.
      2. **Głosowanie nad uchwałą**: Oddanie głosu w głosowaniu elektronicznym premiowane jest dodatkowymi punktami.
      3. **Wymiana na korzyści**: Punkty można wymieniać na zniżki u partnerów osiedla lub dedykowane upominki.
    `,
    tag: "Mestio Team",
    read_time: "4 min czytania",
    created_at: "18 Kwietnia 2025",
    cover_color: "linear-gradient(135deg, #FFE699 0%, #FFB338 50%, #E67300 100%)",
  },
  "nowy-standard-bezpieczenstwa-rodo-i-separacji-danych": {
    id: "story-2",
    title: "Nowy Standard Bezpieczeństwa RODO i Separacji Danych",
    slug: "nowy-standard-bezpieczenstwa-rodo-i-separacji-danych",
    excerpt:
      "Przedstawiamy dedykowany protokół separacji danych osiedli, który gwarantuje 100% prywatności i pełną zgodność z polskimi przepisami prawa.",
    content: `
      Bezpieczeństwo danych mieszkańców i zarządców to nasz priorytet. Wraz z najnowszą aktualizacją wdrażamy architekturę pełnej separacji danych osiedlowych.

      ## Najważniejsze gwarancje bezpieczeństwa:
      - **Izolacja Bazy Danych**: Każda wspólnota i zarządca posiada odseparowany obieg danych.
      - **Szyfrowanie End-to-End**: Dane kontaktowe, zdjęcia usterek i dokumenty są szyfrowane kluczami AES-256.
      - **Prawo do zapomnienia (RODO art. 17)**: Jednym kliknięciem w panelu CRM anonimizujesz dane po zakończeniu współpracy, zachowując jedynie wymagane ustawowo dokumenty podatkowe.
    `,
    tag: "Mestio Team",
    read_time: "6 min czytania",
    created_at: "3 Kwietnia 2025",
    cover_color: "linear-gradient(135deg, #80E5FF 0%, #33B5E5 50%, #0077B6 100%)",
  },
  "premiera-wersji-beta-aplikacji-mobilnej-mestio": {
    id: "story-3",
    title: "Premiera Wersji Beta Aplikacji Mobilnej Mestio",
    slug: "premiera-wersji-beta-aplikacji-mobilnej-mestio",
    excerpt:
      "Startuje oficjalna wersja beta aplikacji mobilnej dla mieszkańców i zarządców osiedli. Zgłaszaj usterki w mniej niż 60 sekund ze zdjęciem z telefonu.",
    content: `
      Z radością ogłaszamy start testów beta nowej aplikacji mobilnej Mestio.

      ## Co zyskują mieszkańcy i zarządcy?
      - Zgłoszenie awarii w mniej niż 60 sekund (aparatu w telefonie, geolokalizacja klatki i piętra).
      - Powiadomienia PUSH w czasie rzeczywistym o zmianie statusu (np. "Serwisant przyjął usterkę do realizacji").
      - Bezpośredni kontakt z ochroną osiedla oraz wykaz telefonów alarmowych.
    `,
    tag: "Mestio Team",
    read_time: "3 min czytania",
    created_at: "3 Stycznia 2025",
    cover_color: "linear-gradient(135deg, #C2B3FF 0%, #8C66FF 50%, #5227CC 100%)",
  },
};

async function getPost(slug: string): Promise<BlogPostDetail | null> {
  try {
    const { data } = await supabase
      .from("blog_posts")
      .select("*")
      .eq("slug", slug)
      .eq("status", "published")
      .single();

    if (data) {
      const row = data as Record<string, unknown>;

      function extractTag(tags: unknown): string {
        if (Array.isArray(tags) && tags.length > 0) return String(tags[0]);
        if (typeof tags === "string") return tags;
        return "Mestio Team";
      }

      return {
        id: String(row.id ?? ""),
        title: String(row.title ?? ""),
        slug: String(row.slug ?? ""),
        excerpt: String(row.excerpt ?? ""),
        content: String(row.content ?? ""),
        tag: String(row.tag || extractTag(row.tags)),
        read_time: String(row.read_time || "5 min czytania"),
        created_at: row.published_at
          ? new Date(String(row.published_at)).toLocaleDateString("pl-PL", {
              day: "numeric",
              month: "long",
              year: "numeric",
            })
          : "Niedawno",
        cover_color: String(row.cover_color || "linear-gradient(135deg, #70E1FF 0%, #3E7BD6 50%, #173A6A 100%)"),
      };
    }
  } catch {}

  return SAMPLE_POSTS_DETAIL[slug] ?? null;
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const slug = (await params).slug;
  const post = await getPost(slug);
  if (!post) return { title: "Nie znaleziono artykułu — Mestio" };

  return {
    title: `${post.title} — Blog Mestio`,
    description: post.excerpt || post.title,
    openGraph: {
      title: `${post.title} — Blog Mestio`,
      description: post.excerpt || "",
      type: "article",
      publishedTime: post.created_at,
      tags: [post.tag],
    },
    alternates: { canonical: `https://mestio.pl/blog/${slug}` },
  };
}

export default async function BlogPostPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const post = await getPost(slug);

  if (!post) notFound();

  return (
    <div className="min-h-screen bg-[#FAF9F6] py-16 px-6">
      <div className="max-w-4xl mx-auto">
        <Link
          href="/blog"
          className="inline-flex items-center gap-2 text-sm font-semibold text-ink/60 hover:text-azure transition-colors mb-8"
        >
          <ArrowLeft className="w-4 h-4" />
          Wróć do wszystkich artykułów
        </Link>

        {/* Article Banner Header */}
        <div
          className="h-64 sm:h-80 rounded-3xl mb-8 relative flex items-center justify-center p-8 overflow-hidden shadow-sm border border-[#E9EEF5]"
          style={{ background: post.cover_color }}
        >
          <div className="absolute top-6 left-6 inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-full bg-white/90 backdrop-blur-md text-xs font-semibold text-ink shadow-sm">
            <span className="w-2 h-2 rounded-full bg-azure" />
            {post.tag}
          </div>
          <div className="w-20 h-20 rounded-2xl bg-white/20 backdrop-blur-md border border-white/30 flex items-center justify-center text-white shadow-xl">
            <Sparkles className="w-10 h-10 animate-pulse" />
          </div>
        </div>

        {/* Article Meta */}
        <div className="flex items-center gap-3 text-xs font-medium text-ink/40 mb-3">
          <span>{post.created_at}</span>
          <span>&middot;</span>
          <span>{post.read_time}</span>
        </div>

        {/* Article Title */}
        <h1 className="font-heading font-bold text-3xl sm:text-4xl lg:text-5xl text-ink tracking-[-1.2px] leading-tight mb-6">
          {post.title}
        </h1>

        {/* Excerpt Intro */}
        {post.excerpt && (
          <p className="text-lg text-ink/70 font-medium leading-relaxed mb-8 pb-8 border-b border-[#E0E6ED]">
            {post.excerpt}
          </p>
        )}

        {/* Article Body Content */}
        <div className="prose prose-lg max-w-none text-ink/80 leading-relaxed space-y-6">
          {post.content.split("\n\n").map((paragraph, idx) => {
            const trimmed = paragraph.trim();
            if (trimmed.startsWith("## ")) {
              return (
                <h2 key={idx} className="font-heading font-bold text-2xl text-ink mt-8 mb-4 tracking-tight">
                  {trimmed.replace("## ", "")}
                </h2>
              );
            }
            if (trimmed.startsWith("- ")) {
              const items = trimmed.split("\n- ").map((item) => item.replace("- ", ""));
              return (
                <ul key={idx} className="list-disc list-inside space-y-2 my-4 pl-2 text-ink/80">
                  {items.map((it, i) => (
                    <li key={i} dangerouslySetInnerHTML={{ __html: it.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>") }} />
                  ))}
                </ul>
              );
            }
            if (trimmed.startsWith("1. ")) {
              const items = trimmed.split(/\n\d+\.\s+/).filter(Boolean);
              return (
                <ol key={idx} className="list-decimal list-inside space-y-2 my-4 pl-2 text-ink/80">
                  {items.map((it, i) => (
                    <li key={i} dangerouslySetInnerHTML={{ __html: it.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>") }} />
                  ))}
                </ol>
              );
            }
            return (
              <p key={idx} className="text-base sm:text-lg leading-relaxed text-ink/80">
                {trimmed}
              </p>
            );
          })}
        </div>

        {/* Back Link Bottom */}
        <div className="mt-16 pt-8 border-t border-[#E0E6ED]">
          <Link
            href="/blog"
            className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-white border border-[#E0E6ED] text-ink text-sm font-semibold hover:border-azure transition-all shadow-sm"
          >
            <ArrowLeft className="w-4 h-4 text-azure" />
            Wróć do bazy wiedzy
          </Link>
        </div>
      </div>
    </div>
  );
}

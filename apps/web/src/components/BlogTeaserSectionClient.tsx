"use client";

import { useRef } from "react";
import { motion, useInView } from "framer-motion";
import Link from "next/link";
import { ArrowRight, Clock } from "lucide-react";

const COVERS = [
  "linear-gradient(135deg, #3E7BD6, #173A6A)",
  "linear-gradient(135deg, #F2A900, #C98800)",
  "linear-gradient(135deg, #22C55E, #173A6A)",
];

const FALLBACK_POSTS = [
  {
    tag: "Prawo",
    title: "Obowiązkowe przeglądy techniczne — kalendarz 2026",
    excerpt: "Kominiarski, gazowy, elektryczny, wind — kiedy, jak często i kto odpowiada.",
    readTime: "5 min",
  },
  {
    tag: "Zarządzanie",
    title: "Jak skrócić czas naprawy usterek o połowę",
    excerpt: "Priorytety, SLA i jasny obieg zgłoszeń — praktyczny przewodnik dla zarządu.",
    readTime: "7 min",
  },
  {
    tag: "Wspólnota",
    title: "Komunikacja z mieszkańcami bez chaosu",
    excerpt: "Dlaczego ogłoszenia z terminem wygaśnięcia działają lepiej niż posty na FB.",
    readTime: "4 min",
  },
];

export default function BlogTeaserSection({ posts }: { posts?: Array<Record<string, unknown>> }) {
  const ref = useRef<HTMLElement>(null);
  const isInView = useInView(ref, { once: true, margin: "-10%" });

  const hasPosts = posts && posts.length > 0;
  const items = hasPosts ? posts : FALLBACK_POSTS;

  return (
    <section ref={ref} id="blog" className="relative py-28" style={{ background: "#F9FAFB" }}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={isInView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="flex flex-col sm:flex-row items-start sm:items-end justify-between gap-6 mb-14"
        >
          <div>
            <p className="font-mono text-[11px] tracking-[0.6px] uppercase mb-4" style={{ color: "#7C8AA0" }}>
              Baza wiedzy
            </p>
            <h2
              className="font-heading font-bold text-[38px] sm:text-[46px] lg:text-[54px] tracking-[-1.2px] leading-[1.05]"
              style={{ color: "#0E1A2B" }}
            >
              Wiedza dla{" "}
              <span className="bg-gradient-to-r from-[#3E7BD6] to-[#173A6A] bg-clip-text text-transparent">
                wspólnot
              </span>
            </h2>
            <p className="text-[15px] mt-4 w-full max-w-md" style={{ color: "#4A5A6E" }}>
              Praktyczne artykuły o zarządzaniu nieruchomościami i zgłoszeniach.
            </p>
          </div>
          <Link
            href="/blog"
            className="inline-flex items-center gap-2 px-5 py-3 rounded-xl text-sm font-semibold transition-all hover:brightness-110 shrink-0"
            style={{
              background: "rgba(62,123,214,0.08)",
              color: "#3E7BD6",
              border: "1px solid rgba(62,123,214,0.2)",
            }}
          >
            Wszystkie artykuły
            <ArrowRight className="w-4 h-4" />
          </Link>
        </motion.div>

        {/* Magazine-style cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {items.slice(0, 3).map((item, i) => {
            const slug = (item as { slug?: string }).slug;
            const tagStr = String((item as { tag?: string }).tag || "");
            const titleStr = String((item as { title?: string }).title || "");
            const excerptStr = String((item as { excerpt?: string }).excerpt || "");
            const readTime = (item as { readTime?: string }).readTime || `${4 + i} min`;

            return (
              <motion.div
                key={slug || titleStr}
                initial={{ opacity: 0, y: 40 }}
                animate={isInView ? { opacity: 1, y: 0 } : {}}
                transition={{ duration: 0.6, delay: 0.15 + i * 0.1 }}
                className="group rounded-2xl overflow-hidden transition-all duration-300 hover:translate-y-[-6px]"
                style={{
                  background: "#FFFFFF",
                  border: "1px solid #EBEFF4",
                  boxShadow: "0 2px 10px rgba(14,26,43,0.04)",
                }}
              >
                {/* Cover */}
                <div className="h-[200px] relative overflow-hidden" style={{ background: COVERS[i % COVERS.length] }}>
                  {/* Pattern overlay */}
                  <div
                    className="absolute inset-0 opacity-20"
                    style={{
                      backgroundImage: "radial-gradient(circle at 30% 30%, white 1px, transparent 1px)",
                      backgroundSize: "24px 24px",
                    }}
                  />
                  {/* Tag pill */}
                  <div
                    className="absolute top-4 left-4 px-2.5 py-1 rounded-md text-[11px] font-semibold backdrop-blur-sm"
                    style={{ background: "rgba(255,255,255,0.2)", color: "#FFF" }}
                  >
                    {tagStr}
                  </div>
                  {/* Read time */}
                  <div
                    className="absolute bottom-4 right-4 inline-flex items-center gap-1 px-2 py-1 rounded-md text-[10px] font-mono"
                    style={{ background: "rgba(0,0,0,0.3)", color: "rgba(255,255,255,0.9)", backdropFilter: "blur(4px)" }}
                  >
                    <Clock className="w-3 h-3" />
                    {readTime}
                  </div>
                </div>

                {/* Content */}
                <div className="p-6">
                  <h3
                    className="font-heading font-semibold text-[17px] leading-[1.25] group-hover:text-[#3E7BD6] transition-colors"
                    style={{ color: "#0E1A2B" }}
                  >
                    {titleStr}
                  </h3>
                  <p className="text-[13.5px] leading-relaxed mt-3" style={{ color: "#4A5A6E" }}>
                    {excerptStr}
                  </p>
                  <Link
                    href={slug ? `/blog/${slug}` : "/blog"}
                    className="inline-flex items-center gap-1.5 mt-4 text-sm font-semibold transition-colors"
                    style={{ color: "#3E7BD6" }}
                  >
                    Czytaj
                    <ArrowRight className="w-3.5 h-3.5 transition-transform group-hover:translate-x-0.5" />
                  </Link>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

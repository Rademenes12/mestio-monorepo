import Link from "next/link";
import type { Metadata } from "next";

export const metadata: Metadata = { robots: { index: false, follow: false } };

export default function NotFound() {
  return (
    <html lang="pl">
      <body className="bg-[#F6F8FB] font-sans text-[#0E1A2B]" style={{ margin: 0 }}>
        <main
          style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            minHeight: "100vh",
            padding: "2rem",
            textAlign: "center",
          }}
        >
          <div
            style={{
              width: 72,
              height: 72,
              borderRadius: "50%",
              background: "rgba(62,123,214,.12)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              marginBottom: "1.5rem",
            }}
          >
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#3E7BD6" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <path d="M16 16s-1.5-2-4-2-4 2-4 2M9 9h.01M15 9h.01" />
            </svg>
          </div>
          <h1 style={{ fontFamily: "'Space Grotesk', sans-serif", fontSize: "2rem", fontWeight: 700, margin: "0 0 .5rem" }}>
            404 — Nie znaleziono
          </h1>
          <p style={{ color: "#4A5A6E", fontSize: "1rem", maxWidth: 400, margin: "0 0 2rem", lineHeight: 1.6 }}>
            Strona, której szukasz, nie istnieje lub została przeniesiona.
          </p>
          <Link
            href="/"
            style={{
              display: "inline-block",
              background: "#0E1A2B",
              color: "#fff",
              padding: ".75rem 1.75rem",
              borderRadius: 13,
              fontWeight: 600,
              fontSize: ".95rem",
              textDecoration: "none",
            }}
          >
            Wróć na stronę główną
          </Link>
        </main>
      </body>
    </html>
  );
}

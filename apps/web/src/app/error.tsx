"use client";

import { useEffect } from "react";

export default function ErrorPage({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Unhandled error:", error);
  }, [error]);

  return (
    <html lang="pl">
      <body className="bg-[#F6F8FB]" style={{ margin: 0, fontFamily: "'IBM Plex Sans', sans-serif", color: "#0E1A2B" }}>
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
              background: "rgba(242,169,0,.13)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              marginBottom: "1.5rem",
            }}
          >
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#F2A900" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
              <line x1="12" y1="9" x2="12" y2="13" />
              <line x1="12" y1="17" x2="12.01" y2="17" />
            </svg>
          </div>
          <h1 style={{ fontFamily: "'Space Grotesk', sans-serif", fontSize: "2rem", fontWeight: 700, margin: "0 0 .5rem" }}>
            Coś poszło nie tak
          </h1>
          <p style={{ color: "#4A5A6E", fontSize: "1rem", maxWidth: 400, margin: "0 0 2rem", lineHeight: 1.6 }}>
            Wystąpił nieoczekiwany błąd. Spróbuj odświeżyć stronę.
          </p>
          <button
            onClick={reset}
            style={{
              background: "#3E7BD6",
              color: "#fff",
              padding: ".75rem 1.75rem",
              borderRadius: 13,
              fontWeight: 600,
              fontSize: ".95rem",
              border: "none",
              cursor: "pointer",
              fontFamily: "inherit",
            }}
          >
            Spróbuj ponownie
          </button>
        </main>
      </body>
    </html>
  );
}

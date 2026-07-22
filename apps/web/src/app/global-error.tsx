"use client";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
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
              <circle cx="12" cy="12" r="10" />
              <line x1="12" y1="8" x2="12" y2="12" />
              <line x1="12" y1="16" x2="12.01" y2="16" />
            </svg>
          </div>
          <h1 style={{ fontFamily: "'Space Grotesk', sans-serif", fontSize: "2rem", fontWeight: 700, margin: "0 0 .5rem" }}>
            Błąd krytyczny
          </h1>
          <p style={{ color: "#4A5A6E", fontSize: "1rem", maxWidth: 400, margin: "0 0 2rem", lineHeight: 1.6 }}>
            Wystąpił błąd aplikacji. Nasz zespół został już powiadomiony.
          </p>
          <button
            onClick={reset}
            style={{
              background: "#0E1A2B",
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

import Link from 'next/link'

export function Footer() {
  return (
    <footer style={{ background: "#0E1A2B", color: "#fff", marginTop: "20px" }}>
      <div style={{ maxWidth: "1160px", margin: "0 auto", padding: "44px 24px 30px", display: "grid", gridTemplateColumns: "1.4fr 1fr 1fr 1fr", gap: "30px" }}>
        <div>
          <div style={{ display: "flex", alignItems: "center", gap: "9px", marginBottom: "12px" }}>
            <div style={{ width: "30px", height: "30px", borderRadius: "9px", background: "#3E7BD6", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round">
                <path d="M14 7a4 4 0 0 1-5.3 5.3L4 17l3 3 4.7-4.7A4 4 0 0 0 17 10l-2.2 2.2-2-2L15 8z"/>
              </svg>
            </div>
            <span style={{ fontFamily: "'Space Grotesk',sans-serif", fontWeight: 700, fontSize: "18px" }}>Mestio</span>
          </div>
          <div style={{ fontSize: "13px", color: "#9FB2CC", lineHeight: 1.6, maxWidth: "260px" }}>Zgłoszenia usterek na osiedlu — od „Nowe&quot; po „Zamknięte&quot;, pod pełną kontrolą.</div>
        </div>
        <div>
          <div style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "10.5px", letterSpacing: ".6px", textTransform: "uppercase", color: "#7F96B5", marginBottom: "12px" }}>Produkt</div>
          <div style={{ display: "flex", flexDirection: "column", gap: "9px" }}>
            <Link href="/" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Funkcje</Link>
            <Link href="#pricing" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Cennik</Link>
            <Link href="/zamow" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Zamów</Link>
          </div>
        </div>
        <div>
          <div style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "10.5px", letterSpacing: ".6px", textTransform: "uppercase", color: "#7F96B5", marginBottom: "12px" }}>Firma</div>
          <div style={{ display: "flex", flexDirection: "column", gap: "9px" }}>
            <Link href="/blog" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Blog</Link>
            <Link href="/kontakt" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Kontakt</Link>
          </div>
        </div>
        <div>
          <div style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "10.5px", letterSpacing: ".6px", textTransform: "uppercase", color: "#7F96B5", marginBottom: "12px" }}>Prawne</div>
          <div style={{ display: "flex", flexDirection: "column", gap: "9px" }}>
            <Link href="/polityka" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Polityka prywatności</Link>
            <Link href="/rodo" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>RODO</Link>
            <Link href="/regulamin" style={{ fontSize: "13.5px", color: "#C7D2E0" }}>Regulamin</Link>
          </div>
        </div>
      </div>
      <div style={{ borderTop: "1px solid rgba(255,255,255,.1)" }}>
        <div style={{ maxWidth: "1160px", margin: "0 auto", padding: "18px 24px", display: "flex", justifyContent: "space-between", flexWrap: "wrap", gap: "10px" }}>
          <span style={{ fontSize: "12px", color: "#7F94B0" }}>© 2026 Mestio · [Twoja firma] · NIP [000-000-00-00]</span>
          <span style={{ fontFamily: "'IBM Plex Mono',monospace", fontSize: "12px", color: "#7F94B0" }}>Zbudowano dla wspólnot mieszkaniowych</span>
        </div>
      </div>
    </footer>
  )
}

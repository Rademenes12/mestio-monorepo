import Link from 'next/link'

export function Footer() {
  return (
    <footer className="relative mt-32">
      {/* Floating Glassmorphism Card (Clip 5) */}
      <div className="relative -mt-16 mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
        <div className="relative glass rounded-[24px] p-8 md:p-12" style={{ backdropFilter: "blur(32px)" }}>
          {/* Glow border via pseudo-element — CSS via inline style */}
          <div
            className="absolute inset-0 rounded-[24px] pointer-events-none"
            style={{
              background: "linear-gradient(135deg, rgba(136,100,240,0.15), transparent 50%, rgba(77,163,255,0.1))",
              padding: "1px",
              mask: "linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0)",
              maskComposite: "exclude",
              WebkitMaskComposite: "xor"
            }}
          />

          <div className="relative z-10 flex flex-col md:flex-row items-center justify-between gap-8">
            {/* App Store Buttons */}
            <div className="flex flex-col sm:flex-row gap-4">
              {/* Google Play */}
              <a href="#" className="flex items-center gap-3 bg-white/5 border border-white/10 hover:bg-white/10 rounded-xl px-5 py-3 transition group">
                <svg className="w-7 h-7" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 0 1-.61-.92V2.734a1 1 0 0 1 .609-.92z" fill="#2196F3"/>
                  <path d="M14.5 12.7l2.3 2.3-11.6 6.6 9.3-8.9z" fill="#FFC107"/>
                  <path d="M20 12c0-.7-.4-1.3-1-1.6l-2.2-1.2-2.8 2.8 2.8 2.8L19 13.6c.6-.3 1-.9 1-1.6z" fill="#FFC107"/>
                </svg>
                <div>
                  <div className="text-[10px] text-white/50 leading-tight">POBIERZ Z</div>
                  <div className="text-sm font-semibold">Google Play</div>
                </div>
              </a>
              {/* Apple Store */}
              <a href="#" className="flex items-center gap-3 bg-white/5 border border-white/10 hover:bg-white/10 rounded-xl px-5 py-3 transition group">
                <svg className="w-7 h-7" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                </svg>
                <div>
                  <div className="text-[10px] text-white/50 leading-tight">POBIERZ Z</div>
                  <div className="text-sm font-semibold">App Store</div>
                </div>
              </a>
            </div>

            {/* Social Icons */}
            <div className="flex items-center gap-4">
              {[
                ["facebook", "M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"],
                ["twitter", "M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"],
                ["instagram", "M7.8 2h8.4C19.4 2 22 4.6 22 7.8v8.4a5.8 5.8 0 0 1-5.8 5.8H7.8C4.6 22 2 19.4 2 16.2V7.8A5.8 5.8 0 0 1 7.8 2m-.2 2A3.6 3.6 0 0 0 4 7.6v8.8C4 18.39 5.61 20 7.6 20h8.8a3.6 3.6 0 0 0 3.6-3.6V7.6C20 5.61 18.39 4 16.4 4H7.6m9.65 1.5a1.25 1.25 0 0 1 0 2.5 1.25 1.25 0 0 1 0-2.5M12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10m0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"],
                ["linkedin", "M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6zM2 9h4v12H2zM4 6a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"],
              ].map(([name, path]) => (
                <a key={name} href="#" className="w-9 h-9 flex items-center justify-center rounded-lg bg-white/5 hover:bg-[#8864f0]/20 transition group" aria-label={name}>
                  <svg className="w-4 h-4 text-white/60 group-hover:text-[#8864f0] transition" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d={path} />
                  </svg>
                </a>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Standard footer grid below */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <div className="flex items-center gap-2 mb-4">
              <div className="w-8 h-8 bg-gradient-to-br from-[#8864f0] to-[#4da3ff] rounded-lg" />
              <span className="text-xl font-bold">Mestio</span>
            </div>
            <p className="text-white/50 text-sm">Nowoczesny system zarządzania nieruchomościami.</p>
          </div>

          <div>
            <h3 className="font-semibold mb-3">Produkt</h3>
            <ul className="space-y-2 text-sm text-white/50">
              <li><Link href="#features" className="hover:text-white transition">Funkcje</Link></li>
              <li><Link href="#pricing" className="hover:text-white transition">Cennik</Link></li>
              <li><Link href="#" className="hover:text-white transition">API</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">Firma</h3>
            <ul className="space-y-2 text-sm text-white/50">
              <li><Link href="/o-nas" className="hover:text-white transition">O nas</Link></li>
              <li><Link href="/kontakt" className="hover:text-white transition">Kontakt</Link></li>
              <li><Link href="/kariera" className="hover:text-white transition">Kariera</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold mb-3">Prawne</h3>
            <ul className="space-y-2 text-sm text-white/50">
              <li><Link href="/polityka" className="hover:text-white transition">Polityka prywatności</Link></li>
              <li><Link href="/regulamin" className="hover:text-white transition">Regulamin</Link></li>
              <li><Link href="/rodo" className="hover:text-white transition">RODO</Link></li>
            </ul>
          </div>
        </div>

        <div className="border-t border-white/10 mt-8 pt-8 text-center text-sm text-white/40">
          © 2024 Mestio. Wszelkie prawa zastrzeżone.
        </div>
      </div>
    </footer>
  )
}

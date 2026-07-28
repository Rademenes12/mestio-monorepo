import type { Metadata, Viewport } from "next";
import { Space_Grotesk, IBM_Plex_Sans, IBM_Plex_Mono } from "next/font/google";
import CookieConsentWrapper from "@/components/CookieConsentWrapper";
import { Navbar } from "@mestio/ui";
import { Footer } from "@mestio/ui";
import "./globals.css";

const spaceGrotesk = Space_Grotesk({
  variable: "--font-space-grotesk",
  subsets: ["latin"],
  display: "swap",
  fallback: ["system-ui", "sans-serif"],
});

const ibmPlexSans = IBM_Plex_Sans({
  variable: "--font-ibm-plex-sans",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  display: "swap",
  fallback: ["system-ui", "sans-serif"],
});

const ibmPlexMono = IBM_Plex_Mono({
  variable: "--font-ibm-plex-mono",
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  display: "swap",
  fallback: ["ui-monospace", "monospace"],
});

const BASE_URL = "https://mestio.pl";

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  metadataBase: new URL(BASE_URL),
  title: {
    default: "Mestio — System zgłaszania usterek dla osiedli i wspólnot",
    template: "%s — Mestio",
  },
  description:
    "Nowoczesna platforma do zgłaszania i obsługi usterek w osiedlach i wspólnotach mieszkaniowych. Aplikacja mobilna dla mieszkańców, panel zarządu, pełna kontrola nad naprawami i konserwacją. Pierwsze 3 miesiące gratis.",
  keywords: [
    "zgłoszenia usterek",
    "osiedle",
    "wspólnota mieszkaniowa",
    "zarządca nieruchomości",
    "aplikacja dla mieszkańców",
    "naprawy",
    "konserwacja",
    "serwis",
    "Mestio",
    "panel zarządu",
    "system dla osiedli",
    "zarządzanie nieruchomościami",
    "zgłaszanie awarii",
  ],
  openGraph: {
    type: "website",
    siteName: "Mestio",
    locale: "pl_PL",
    title: "Mestio — System zgłaszania usterek dla osiedli i wspólnot",
    description:
      "Nowoczesna platforma do zgłaszania i obsługi usterek w osiedlach i wspólnotach. Aplikacja mobilna, panel zarządu, pełna kontrola. 3 miesiące gratis.",
    url: BASE_URL,
    images: [{ url: "/og-image.png", width: 1200, height: 630 }],
  },
  twitter: {
    card: "summary_large_image",
    title: "Mestio — System zgłaszania usterek dla osiedli",
    description:
      "Nowoczesna platforma do zgłaszania i obsługi usterek w osiedlach. 3 miesiące gratis.",
    images: ["/og-image.png"],
  },
  robots: { index: true, follow: true },
  alternates: { canonical: BASE_URL },
  icons: {
    icon: "/favicon.ico",
  },
  verification: {
    google: process.env.GOOGLE_VERIFICATION || "xxxx",
  },
  other: {
    "geo.region": "PL",
    "geo.placename": "Polska",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: "Mestio",
    url: BASE_URL,
    logo: `${BASE_URL}/og-image.png`,
    contactPoint: {
      "@type": "ContactPoint",
      email: "kontakt@mestio.pl",
      contactType: "customer support",
      availableLanguage: "Polish",
    },
    sameAs: [],
  };

  return (
    <html
      lang="pl"
      className={`${spaceGrotesk.variable} ${ibmPlexSans.variable} ${ibmPlexMono.variable} h-full antialiased`}
    >
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
        {process.env.NEXT_PUBLIC_GTM_ID && (
          <>
            <script
              dangerouslySetInnerHTML={{
                __html: `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${process.env.NEXT_PUBLIC_GTM_ID}');`,
              }}
            />
          </>
        )}
      </head>
      <body className="min-h-full flex flex-col bg-paper text-ink">
        <a
          href="#main-content"
          className="sr-only focus:not-sr-only focus:absolute focus:top-3 focus:left-3 focus:z-50 focus:bg-ink focus:text-white focus:px-4 focus:py-2 focus:rounded-[11px] focus:text-sm focus:font-semibold"
        >
          Przejdź do treści
        </a>
        {process.env.NEXT_PUBLIC_GTM_ID && (
          <noscript>
            <iframe
              src={`https://www.googletagmanager.com/ns.html?id=${process.env.NEXT_PUBLIC_GTM_ID}`}
              height="0"
              width="0"
              style={{ display: "none", visibility: "hidden" }}
            />
          </noscript>
        )}
        {children}
        <CookieConsentWrapper />
      </body>
    </html>
  );
}

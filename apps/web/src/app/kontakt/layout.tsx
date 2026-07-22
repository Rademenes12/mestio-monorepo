import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Kontakt",
  description: "Skontaktuj się z zespołem Mestio — wsparcie techniczne, sprzedaż, pytania o platformę dla osiedli.",
  openGraph: {
    title: "Kontakt — Mestio",
    description: "Skontaktuj się z zespołem Mestio — wsparcie techniczne, sprzedaż, pytania.",
  },
  robots: { index: true, follow: true },
  alternates: { canonical: "https://mestio.pl/kontakt" },
};

export default function KontaktLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}

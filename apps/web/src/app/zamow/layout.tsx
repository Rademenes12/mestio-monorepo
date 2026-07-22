import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Zamówienie",
  description: "Zamów Mestio dla swojego osiedla — rejestracja i bezpieczna płatność przez Stripe. Wybierz plan i zacznij już dziś.",
  openGraph: {
    title: "Zamów Mestio — rejestracja i płatność",
    description: "Wybierz plan (Start, Standard, Pro, Enterprise) i zamów Mestio dla swojego osiedla.",
  },
  robots: { index: true, follow: true },
  alternates: { canonical: "https://mestio.pl/zamow" },
};

export default function ZamowLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}

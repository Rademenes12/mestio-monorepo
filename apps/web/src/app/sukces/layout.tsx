import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Płatność zakończona",
  description: "Twoja płatność za Mestio została zakończona sukcesem. Skopiuj kod zaproszenia i zacznij korzystać z platformy.",
  robots: { index: false, follow: false },
  alternates: { canonical: "https://mestio.pl/sukces" },
};

export default function SukcesLayout({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}

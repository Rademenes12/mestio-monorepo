import { Navbar } from "@mestio/ui";
import { Footer } from "@mestio/ui";

export default function PublicLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <>
      <Navbar
        ctaLabel="Zamów Mestio"
        ctaHref="/zamow"
      />
      <main id="main-content" className="flex-1">
        {children}
      </main>
      <Footer />
    </>
  );
}

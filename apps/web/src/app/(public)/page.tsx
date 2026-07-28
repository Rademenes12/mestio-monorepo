import type { Metadata } from "next";
import HeroSection from "@/components/HeroSection";
import ProblemSolutionSection from "@/components/ProblemSolutionSection";
import FeaturesSection from "@/components/FeaturesSection";
import HowItWorksSection from "@/components/HowItWorksSection";
import TestimonialsSection from "@/components/TestimonialsSection";
import PricingSection from "@/components/PricingSection";
import ReferralSection from "@/components/ReferralSection";
import BlogTeaserSection from "@/components/BlogTeaserSection";
import RankingSection from "@/components/RankingSection";
import FaqSection from "@/components/FaqSection";
import CtaSection from "@/components/CtaSection";

export const metadata: Metadata = {
  alternates: { canonical: "https://mestio.pl" },
};

const FAQ_SCHEMA = {
  "@context": "https://schema.org",
  "@type": "FAQPage",
  mainEntity: [
    {
      "@type": "Question",
      name: "Czy mieszkańcy płacą za korzystanie z aplikacji?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "Nie. Aplikacja jest bezpłatna.",
      },
    },
    {
      "@type": "Question",
      name: "Jak wygląda płatność za system?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "Płatność subskrypcją miesięczną przez Stripe.",
      },
    },
    {
      "@type": "Question",
      name: "Czy mogę zrezygnować w każdej chwili?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "Tak. Subskrypcję można anulować w dowolnym momencie.",
      },
    },
    {
      "@type": "Question",
      name: "Czy aplikacja jest bezpieczna?",
      acceptedAnswer: {
        "@type": "Answer",
        text: "Tak. Dane każdego osiedla są od siebie odseparowane zgodnie z RODO.",
      },
    },
  ],
};

export default function Home() {
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(FAQ_SCHEMA) }}
      />
      <HeroSection />
      <ProblemSolutionSection />
      <FeaturesSection />
      <HowItWorksSection />
      <TestimonialsSection />
      <PricingSection />
      <ReferralSection />
      <BlogTeaserSection />
      <RankingSection />
      <FaqSection />
      <CtaSection />
    </>
  );
}

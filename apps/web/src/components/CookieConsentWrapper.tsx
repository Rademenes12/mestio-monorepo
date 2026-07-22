"use client";

import dynamic from "next/dynamic";

const CookieConsentInner = dynamic(
  () => import("@/components/CookieConsent"),
  { ssr: false }
);

export default function CookieConsentWrapper() {
  return <CookieConsentInner />;
}

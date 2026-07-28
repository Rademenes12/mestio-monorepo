"use client";

import { useEffect, useState } from "react";

export default function GtmLoader() {
  const gtmId = process.env.NEXT_PUBLIC_GTM_ID;
  const [consent, setConsent] = useState<string | null>(null);

  useEffect(() => {
    const stored = localStorage.getItem("cookie-consent");
    setConsent(stored);

    const handleConsentChange = () => {
      const updated = localStorage.getItem("cookie-consent");
      setConsent(updated);
    };

    window.addEventListener("cookie-consent-changed", handleConsentChange);
    return () => {
      window.removeEventListener("cookie-consent-changed", handleConsentChange);
    };
  }, []);

  useEffect(() => {
    if (!gtmId || consent !== "all") return;

    const gtmScript = document.createElement("script");
    gtmScript.innerHTML = `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${gtmId}');`;
    document.head.appendChild(gtmScript);

    const noscript = document.createElement("noscript");
    noscript.innerHTML = `<iframe src="https://www.googletagmanager.com/ns.html?id=${gtmId}" height="0" width="0" style="display:none;visibility:hidden"></iframe>`;
    document.body.insertBefore(noscript, document.body.firstChild);

    return () => {
      document.head.removeChild(gtmScript);
      document.body.removeChild(noscript);
    };
  }, [gtmId, consent]);

  return null;
}

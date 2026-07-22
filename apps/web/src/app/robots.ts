import type { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/api/", "/sukces", "/_next/"],
      },
    ],
    sitemap: "https://mestio.pl/sitemap.xml",
  };
}

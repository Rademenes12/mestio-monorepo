import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  poweredByHeader: false,
  allowedDevOrigins: ["10.0.0.20", "localhost"],

  /* ── Image Optimization ── */
  images: {
    formats: ["image/avif", "image/webp"],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  },

  /* ── Bundle Optimization ── */
  experimental: {
    optimizePackageImports: ["lucide-react", "@supabase/supabase-js"],
  },

  async headers() {
    return [
      /* Static asset caching (immutable with long max-age) */
      {
        source: "/_next/static/(.*)",
        headers: [
          {
            key: "Cache-Control",
            value: "public, max-age=31536000, immutable",
          },
        ],
      },
      {
        source: "/fonts/(.*)",
        headers: [
          {
            key: "Cache-Control",
            value: "public, max-age=31536000, immutable",
          },
        ],
      },
      {
        source: "/images/(.*)",
        headers: [
          {
            key: "Cache-Control",
            value: "public, max-age=86400, stale-while-revalidate=604800",
          },
        ],
      },
      /* Security headers */
      {
        source: "/(.*)",
        headers: [
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          {
            key: "X-Frame-Options",
            value: "DENY",
          },
          {
            key: "Referrer-Policy",
            value: "strict-origin-when-cross-origin",
          },
          {
            key: "Content-Security-Policy",
            value:
              "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://js.stripe.com https://www.googletagmanager.com https://*.google-analytics.com https://*.googletagmanager.com; style-src 'self' 'unsafe-inline' https://www.googletagmanager.com; frame-src https://js.stripe.com https://checkout.stripe.com https://www.googletagmanager.com; connect-src 'self' https://*.supabase.co https://*.stripe.com https://admin.mestio.pl https://www.google-analytics.com https://*.analytics.google.com https://*.google-analytics.com https://*.googletagmanager.com https://region1.google-analytics.com; img-src 'self' data: https://*.stripe.com https://www.google-analytics.com https://*.googletagmanager.com https://images.pexels.com; font-src 'self' https://www.googletagmanager.com; object-src 'none'; base-uri 'self'; form-action 'self' https://checkout.stripe.com;",
          },
          {
            key: "Permissions-Policy",
            value:
              "camera=(), microphone=(), geolocation=()",
          },
          {
            key: "Strict-Transport-Security",
            value: "max-age=63072000; includeSubDomains; preload",
          },
        ],
      },
    ];
  },
};

export default nextConfig;

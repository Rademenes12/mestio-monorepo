import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const API_RATE_LIMIT = new Map<string, { count: number; resetAt: number }>();

function getRateLimitKey(req: NextRequest): string {
  const forwarded = req.headers.get("x-forwarded-for");
  const ip = forwarded?.split(",")[0]?.trim() || "unknown";
  return `${ip}:${req.nextUrl.pathname}`;
}

function checkRateLimit(
  key: string,
  maxRequests: number,
  windowMs: number
): boolean {
  const now = Date.now();
  const entry = API_RATE_LIMIT.get(key);

  if (!entry || now > entry.resetAt) {
    API_RATE_LIMIT.set(key, { count: 1, resetAt: now + windowMs });
    return true;
  }

  if (entry.count >= maxRequests) return false;

  entry.count++;
  return true;
}

setInterval(() => {
  const now = Date.now();
  for (const [key, entry] of API_RATE_LIMIT) {
    if (now > entry.resetAt) API_RATE_LIMIT.delete(key);
  }
}, 60_000);

const RATE_LIMITS: Record<string, { max: number; windowMs: number }> = {
  "/api/create-checkout": { max: 5, windowMs: 60_000 },
  "/api/contact": { max: 3, windowMs: 60_000 },
  "/api/newsletter": { max: 5, windowMs: 60_000 },
  "/api/crm/blog": { max: 10, windowMs: 60_000 },
};

export function proxy(req: NextRequest) {
  const { pathname } = req.nextUrl;

  if (pathname.startsWith("/api/")) {
    const origin = req.headers.get("origin");
    const host = req.headers.get("host");
    const referer = req.headers.get("referer");

    if (req.method !== "GET" && req.method !== "HEAD") {
      if (origin && host) {
        const originHost = new URL(origin).host;
        if (originHost !== host && !host.endsWith(".vercel.app")) {
          return NextResponse.json(
            { error: "Forbidden" },
            { status: 403 }
          );
        }
      }
    }

    const limit = RATE_LIMITS[pathname];
    if (limit) {
      const key = getRateLimitKey(req);
      if (!checkRateLimit(key, limit.max, limit.windowMs)) {
        return NextResponse.json(
          { error: "Zbyt wiele zapytań. Spróbuj ponownie za minutę." },
          { status: 429 }
        );
      }
    }
  }

  const response = NextResponse.next();

  response.headers.set("X-Content-Type-Options", "nosniff");
  response.headers.set("X-Frame-Options", "DENY");
  response.headers.set("Referrer-Policy", "strict-origin-when-cross-origin");

  if (process.env.NODE_ENV === "production") {
    response.headers.set(
      "Strict-Transport-Security",
      "max-age=63072000; includeSubDomains; preload"
    );
  }

  return response;
}

export const config = {
  matcher: ["/api/:path*"],
};

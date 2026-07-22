/**
 * In-memory rate limiter for API routes.
 * Default: 100 requests per 15-minute window per IP.
 *
 * Returns a 429 response with Retry-After header when the limit is exceeded.
 */

import { NextRequest, NextResponse } from "next/server";

const DEFAULT_WINDOW_MS = 15 * 60 * 1000; // 15 minutes
const DEFAULT_MAX_REQUESTS = 100;

interface RateLimitEntry {
  count: number;
  resetAt: number;
}

const store = new Map<string, RateLimitEntry>();

// Periodically clean up expired entries to prevent memory leaks
const CLEANUP_INTERVAL = 60_000; // every 60 seconds
let lastCleanup = Date.now();

function cleanupStore(): void {
  const now = Date.now();
  store.forEach((entry, key) => {
    if (now > entry.resetAt) {
      store.delete(key);
    }
  });
  lastCleanup = now;
}

/** Extract the client IP from a NextRequest. */
export function getClientIp(request: NextRequest): string {
  return (
    request.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ||
    request.headers.get("x-real-ip") ||
    request.headers.get("cf-connecting-ip") || // Cloudflare
    "127.0.0.1"
  );
}

/**
 * Check rate limit for a given key.
 * @returns true if the request is allowed, false if rate-limited.
 */
export function rateLimit(
  key: string,
  max: number = DEFAULT_MAX_REQUESTS,
  windowMs: number = DEFAULT_WINDOW_MS
): boolean {
  const now = Date.now();

  // Periodic cleanup
  if (now - lastCleanup > CLEANUP_INTERVAL) {
    cleanupStore();
  }

  const entry = store.get(key);

  if (!entry || now >= entry.resetAt) {
    store.set(key, { count: 1, resetAt: now + windowMs });
    return true;
  }

  if (entry.count >= max) {
    return false;
  }

  entry.count++;
  return true;
}

/**
 * Rate limit by client IP.
 * @returns true if the request is allowed, false if rate-limited.
 */
export function rateLimitByIp(
  request: NextRequest,
  max: number = DEFAULT_MAX_REQUESTS,
  windowMs: number = DEFAULT_WINDOW_MS
): boolean {
  const ip = getClientIp(request);
  return rateLimit(`ip:${ip}`, max, windowMs);
}

/**
 * Rate limit API middleware.
 * Returns a 429 response with Retry-After header when the limit is exceeded,
 * or null if the request should proceed.
 *
 * Usage in an API route:
 *   const limit = rateLimitMiddleware(request, 100);
 *   if (limit) return limit;
 */
export function rateLimitMiddleware(
  request: NextRequest,
  max: number = DEFAULT_MAX_REQUESTS,
  windowMs: number = DEFAULT_WINDOW_MS
): NextResponse | null {
  const ip = getClientIp(request);
  const key = `ip:${ip}`;
  const now = Date.now();

  // Periodic cleanup
  if (now - lastCleanup > CLEANUP_INTERVAL) {
    cleanupStore();
  }

  const entry = store.get(key);

  if (!entry || now >= entry.resetAt) {
    store.set(key, { count: 1, resetAt: now + windowMs });
    return null; // allow
  }

  if (entry.count >= max) {
    const retryAfter = Math.ceil((entry.resetAt - now) / 1000);
    return NextResponse.json(
      { error: "Too many requests. Please try again later." },
      {
        status: 429,
        headers: {
          "Retry-After": String(retryAfter),
          "X-RateLimit-Limit": String(max),
          "X-RateLimit-Remaining": "0",
          "X-RateLimit-Reset": String(Math.ceil(entry.resetAt / 1000)),
        },
      }
    );
  }

  entry.count++;
  return null; // allow
}

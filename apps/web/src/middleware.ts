import { updateSession } from "@/lib/supabase/middleware";
import { type NextRequest, NextResponse } from "next/server";

const PUBLIC_PATHS = [
  "/",
  "/blog",
  "/kontakt",
  "/o-nas",
  "/polityka",
  "/regulamin",
  "/rodo",
  "/onboarding",
  "/zamow",
  "/sukces",
  "/login",
  "/auth",
  "/reset-password",
];

export async function middleware(request: NextRequest) {
  const { supabaseResponse, user } = await updateSession(request);

  const pathname = request.nextUrl.pathname;

  // Always allow public paths
  if (PUBLIC_PATHS.some((p) => pathname === p || pathname.startsWith(p + "/"))) {
    return supabaseResponse;
  }

  // /api routes are public (they handle their own auth)
  if (pathname.startsWith("/api/")) {
    return supabaseResponse;
  }

  // Protected routes: /owner/* and /client/* require login
  if (pathname.startsWith("/owner/") || pathname.startsWith("/client/")) {
    if (!user) {
      const loginUrl = new URL("/login", request.url);
      loginUrl.searchParams.set("redirect", pathname);
      return NextResponse.redirect(loginUrl);
    }
    // TODO: Check user role for /owner/* vs /client/* access
    return supabaseResponse;
  }

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

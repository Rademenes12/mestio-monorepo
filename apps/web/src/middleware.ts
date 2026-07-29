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
  const { supabaseResponse, user, supabase } = await updateSession(request);

  const pathname = request.nextUrl.pathname;

  // Always allow public paths
  if (PUBLIC_PATHS.some((p) => pathname === p || pathname.startsWith(p + "/"))) {
    return supabaseResponse;
  }

  // /api routes are public (they handle their own auth)
  if (pathname.startsWith("/api/")) {
    return supabaseResponse;
  }

  // Protected routes require login or demo mode
  if (
    pathname.startsWith("/owner/") ||
    pathname.startsWith("/client/") ||
    pathname.startsWith("/resident/")
  ) {
    const demoRole = request.cookies.get("mestio_demo_role")?.value;

    if (!user && !demoRole) {
      const loginUrl = new URL("/login", request.url);
      loginUrl.searchParams.set("redirect", pathname);
      return NextResponse.redirect(loginUrl);
    }

    // Determine role (demoRole cookie takes precedence for multi-role testing)
    const role = demoRole || "";

    // /owner/* — only owner/admin
    if (pathname.startsWith("/owner/")) {
      if (role && role !== "owner" && role !== "admin") {
        if (role === "resident") {
          return NextResponse.redirect(new URL("/resident/", request.url));
        }
        return NextResponse.redirect(new URL("/client/", request.url));
      }
    }

    // /client/* — allow admin, manager, serwis, ochrona, zarzad, or demo admin
    if (pathname.startsWith("/client/")) {
      if (role === "resident") {
        return NextResponse.redirect(new URL("/resident/", request.url));
      }
      if (role === "owner") {
        return NextResponse.redirect(new URL("/owner/dashboard", request.url));
      }
    }

    // /resident/* — allow resident or demo resident
    if (pathname.startsWith("/resident/")) {
      if (role === "owner") {
        return NextResponse.redirect(new URL("/owner/dashboard", request.url));
      }
      if (role === "admin" || role === "manager" || role === "serwis" || role === "ochrona") {
        return NextResponse.redirect(new URL("/client/", request.url));
      }
    }

    return supabaseResponse;
  }

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

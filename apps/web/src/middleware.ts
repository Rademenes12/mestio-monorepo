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
  // Demo preview paths — publicly accessible for sales demos
  "/client/reports",
  "/resident/reports",
  "/owner/customers",
];

export async function middleware(request: NextRequest) {
  const { supabaseResponse, user, supabase } = await updateSession(request);

  const pathname = request.nextUrl.pathname;

  // Always allow public paths (includes demo preview paths)
  if (PUBLIC_PATHS.some((p) => pathname === p || pathname.startsWith(p + "/"))) {
    return supabaseResponse;
  }

  // /api routes are public (they handle their own auth)
  if (pathname.startsWith("/api/")) {
    return supabaseResponse;
  }

  // Protected routes require login
  if (
    pathname.startsWith("/owner/") ||
    pathname.startsWith("/client/") ||
    pathname.startsWith("/resident/")
  ) {
    if (!user) {
      const loginUrl = new URL("/login", request.url);
      loginUrl.searchParams.set("redirect", pathname);
      return NextResponse.redirect(loginUrl);
    }

    // Check user role (non-blocking — errors default to allowing access)
    let role = "";
    try {
      const { data: profile } = await supabase
        .from("fixflow_resident_profiles")
        .select("role")
        .eq("user_id", user.id)
        .maybeSingle();
      role = profile?.role || "";
    } catch {
      // If DB query fails, allow access (login page handles role check)
    }

    // Role checks
    if (pathname.startsWith("/owner/") && role && role !== "owner" && role !== "admin") {
      return NextResponse.redirect(new URL("/client/", request.url));
    }
  }

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};

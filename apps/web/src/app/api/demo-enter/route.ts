import { cookies } from "next/headers";
import { NextResponse } from "next/server";

export async function GET(request: Request) {
  const url = new URL(request.url);
  const target = url.searchParams.get("target") || "/";

  const response = NextResponse.redirect(new URL(target, request.url));
  response.cookies.set("mestio_demo", "true", {
    path: "/",
    maxAge: 86400,
    httpOnly: false,
    sameSite: "lax",
  });

  return response;
}

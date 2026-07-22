import { cookies } from "next/headers";
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  const { estateId } = await request.json();
  const cookieStore = await cookies();
  cookieStore.set("active_estate_id", estateId, {
    path: "/",
    httpOnly: true,
    sameSite: "lax",
  });
  return NextResponse.json({ ok: true });
}

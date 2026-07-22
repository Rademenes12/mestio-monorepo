import { NextRequest, NextResponse } from "next/server";
import { supabaseAdmin } from "@/lib/supabase-admin";
import { registrationSchema } from "@/lib/validations";
import { rateLimitByIp } from "@/lib/rate-limit";
import crypto from "crypto";

import { PLAN_AMOUNTS_MAP } from "@/lib/pricing";


const PLAN_AMOUNTS: Record<string, number> = PLAN_AMOUNTS_MAP;

const BANK_ACCOUNT = {
  bank: "xxxx",
  account: "xxxx",
  swift: "xxxx",
  owner: "xxxx",
};

function generateTransferTitle(): string {
  const shortId = crypto.randomBytes(4).toString("hex").toUpperCase();
  return `MESTIO-${shortId}`;
}

export async function POST(request: NextRequest) {
  if (!rateLimitByIp(request, 5)) {
    return NextResponse.json({ error: "Too many requests" }, { status: 429 });
  }
  try {
    const body = await request.json();

    const parsed = registrationSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          error: "Błędne dane formularza",
          details: parsed.error.flatten().fieldErrors,
        },
        { status: 400 }
      );
    }

    const {
      email,
      password,
      companyName,
      nip,
      contactName,
      phone,
      estateName,
      plan,
      acceptRegulamin,
      acceptRodo,
    } = parsed.data;

    const amount = PLAN_AMOUNTS[plan];
    if (amount === undefined) {
      return NextResponse.json(
        { error: `Nieprawidłowy plan: ${plan}` },
        { status: 400 }
      );
    }

    const adminClient = supabaseAdmin();

    const { data: userData, error: signUpError } =
      await adminClient.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
          company_name: companyName,
          nip,
          contact_name: contactName,
          phone,
          estate_name: estateName,
        },
      });

    if (signUpError) {
      if (
        signUpError.message?.includes("already") ||
        signUpError.status === 422
      ) {
        return NextResponse.json(
          { error: "Konto z tym adresem e-mail już istnieje" },
          { status: 409 }
        );
      }
      console.error("User creation error:", signUpError);
      return NextResponse.json(
        { error: "Wystąpił błąd podczas rejestracji. Spróbuj ponownie." },
        { status: 500 }
      );
    }

    const userId = userData.user.id;
    const transferTitle = generateTransferTitle();
    const dueDate = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

    const { data: payment, error: insertError } = await adminClient
      .from("fixflow_transfer_payments")
      .insert({
        user_id: userId,
        estate_name: estateName,
        plan,
        amount,
        status: "pending",
        transfer_title: transferTitle,
        due_date: dueDate.toISOString(),
      })
      .select("id")
      .single();

    if (insertError) {
      console.error("Insert payment error:", insertError);
      return NextResponse.json(
        { error: "Wystąpił błąd przy tworzeniu płatności. Spróbuj ponownie." },
        { status: 500 }
      );
    }

    return NextResponse.json({
      paymentId: payment.id,
      amount,
      transferTitle,
      dueDate: dueDate.toISOString(),
      bankAccount: BANK_ACCOUNT,
    });
  } catch (error: unknown) {
    console.error("create-transfer error:", error);
    return NextResponse.json(
      { error: "Wystąpił błąd. Spróbuj ponownie." },
      { status: 500 }
    );
  }
}

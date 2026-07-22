import { Resend } from "resend";

function getResend() {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    console.warn("RESEND_API_KEY is not set — emails will not be sent");
    return null;
  }
  return new Resend(apiKey);
}

const FROM = process.env.EMAIL_FROM || "Mestio <powiadomienia@mestio.pl>";

const BRAND = {
  ink: "#0E1A2B",
  blueprint: "#173A6A",
  azure: "#3E7BD6",
  amber: "#F2A900",
  paper: "#F6F8FB",
};

function wrapHtml(body: string) {
  return `<!DOCTYPE html>
<html lang="pl">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600&family=Space+Grotesk:wght@500;700&display=swap" rel="stylesheet" />
</head>
<body style="margin:0;padding:0;background-color:${BRAND.paper};font-family:'IBM Plex Sans',Arial,sans-serif;font-size:16px;line-height:1.6;color:${BRAND.ink};">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:${BRAND.paper};padding:32px 0;">
    <tr>
      <td align="center">
        <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="background-color:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.06);">
          <tr>
            <td style="background-color:${BRAND.blueprint};padding:32px 40px;text-align:center;">
              <div style="font-family:'Space Grotesk',Arial,sans-serif;font-size:28px;font-weight:700;color:#ffffff;letter-spacing:-0.5px;">Mestio</div>
            </td>
          </tr>
          <tr>
            <td style="padding:40px;">
              ${body}
            </td>
          </tr>
          <tr>
            <td style="background-color:${BRAND.ink};padding:24px 40px;text-align:center;">
              <p style="margin:0;font-size:14px;color:#8899aa;">
                &copy; ${new Date().getFullYear()} Mestio. Wszelkie prawa zastrzeżone.
              </p>
              <p style="margin:8px 0 0;font-size:13px;color:#667788;">
                xxxx &bull; xxxx
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

export async function sendWelcomeEmail({
  email,
  companyName,
  estateName,
}: {
  email: string;
  companyName: string;
  estateName: string;
}) {
  try {
    const body = `
      <h1 style="font-family:'Space Grotesk',Arial,sans-serif;font-size:24px;font-weight:700;color:${BRAND.ink};margin:0 0 8px;">Witamy w Mestio!</h1>
      <p style="font-size:18px;color:${BRAND.blueprint};margin:0 0 24px;font-weight:600;">Potwierdzenie rejestracji</p>

      <p style="margin:0 0 16px;">Dziękujemy za rejestrację, <strong>${companyName}</strong>.</p>
      <p style="margin:0 0 16px;">Twoje osiedle <strong>${estateName}</strong> zostało pomyślnie dodane. Oto co dzieje się dalej:</p>

      <table role="presentation" cellpadding="12" cellspacing="0" style="margin:0 0 24px;width:100%;">
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">1.</td>
          <td style="vertical-align:top;"><strong style="color:${BRAND.ink};">Finalizacja płatności</strong><br /><span style="font-size:14px;color:#556677;">Dokończ konfigurację subskrypcji poprzez bezpieczny formularz Stripe.</span></td>
        </tr>
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">2.</td>
          <td style="vertical-align:top;"><strong style="color:${BRAND.ink};">Aktywacja konta</strong><br /><span style="font-size:14px;color:#556677;">Po potwierdzeniu płatności otrzymasz kod zaproszenia dla zarządcy osiedla.</span></td>
        </tr>
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">3.</td>
          <td style="vertical-align:top;"><strong style="color:${BRAND.ink};">Rozpoczęcie pracy</strong><br /><span style="font-size:14px;color:#556677;">Zaloguj się do panelu i zacznij zarządzać swoim osiedlem w jednym miejscu.</span></td>
        </tr>
      </table>

      <p style="margin:0 0 16px;">Masz pytania? Odpowiedzi znajdziesz w <a href="#" style="color:${BRAND.azure};text-decoration:underline;">Centrum Pomocy</a> lub odpowiadając na tę wiadomość.</p>

      <p style="margin:0;color:#556677;font-size:14px;">— Zespół Mestio</p>
    `;

    const resend = getResend();
    if (!resend) return;
    await resend.emails.send({
      from: FROM,
      to: email,
      subject: "Witamy w Mestio — potwierdzenie rejestracji",
      html: wrapHtml(body),
    });
  } catch (error) {
    console.error("Failed to send welcome email:", error);
  }
}

export async function sendPaymentConfirmationEmail({
  email,
  companyName,
  plan,
}: {
  email: string;
  companyName: string;
  plan: string;
}) {
  try {
    const planLabels: Record<string, string> = {
      start: "Start — 79 zł/mc",
      standard: "Standard — 179 zł/mc",
      pro: "Pro — 349 zł/mc",
      enterprise: "Enterprise — wycena indywidualna",
    };

    const body = `
      <h1 style="font-family:'Space Grotesk',Arial,sans-serif;font-size:24px;font-weight:700;color:${BRAND.ink};margin:0 0 8px;">Płatność potwierdzona!</h1>
      <p style="font-size:18px;color:${BRAND.blueprint};margin:0 0 24px;font-weight:600;">Twoja subskrypcja Mestio jest już aktywna</p>

      <div style="background-color:${BRAND.paper};border-radius:8px;padding:24px;margin:0 0 24px;">
        <p style="margin:0 0 8px;font-size:14px;color:#556677;">Szczegóły subskrypcji:</p>
        <p style="margin:0;font-size:18px;font-weight:700;color:${BRAND.ink};">${planLabels[plan] || plan}</p>
      </div>

      <p style="margin:0 0 16px;">Gratulujemy, <strong>${companyName}</strong>! Płatność została pomyślnie przetworzona. Twoje konto jest w pełni aktywne.</p>

      <p style="margin:0 0 16px;font-weight:600;color:${BRAND.ink};">Co teraz?</p>

      <table role="presentation" cellpadding="12" cellspacing="0" style="margin:0 0 24px;width:100%;">
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">&#10003;</td>
          <td style="vertical-align:top;">
            <strong style="color:${BRAND.ink};">Pobierz aplikacje</strong><br />
            <span style="font-size:14px;color:#556677;">
              Aplikacja zarządcy: <a href="#" style="color:${BRAND.azure};text-decoration:underline;">App Store</a> &bull; <a href="#" style="color:${BRAND.azure};text-decoration:underline;">Google Play</a><br />
              Aplikacja mieszkańca: <a href="#" style="color:${BRAND.azure};text-decoration:underline;">App Store</a> &bull; <a href="#" style="color:${BRAND.azure};text-decoration:underline;">Google Play</a>
            </span>
          </td>
        </tr>
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">&#10003;</td>
          <td style="vertical-align:top;">
            <strong style="color:${BRAND.ink};">Zaproszenie zarządcy</strong><br />
            <span style="font-size:14px;color:#556677;">Kod zaproszenia dla zarządcy osiedla został wysłany oddzielną wiadomością.</span>
          </td>
        </tr>
        <tr>
          <td style="width:36px;vertical-align:top;text-align:center;color:${BRAND.azure};font-weight:700;font-size:20px;">&#10003;</td>
          <td style="vertical-align:top;">
            <strong style="color:${BRAND.ink};">Panel administracyjny</strong><br />
            <span style="font-size:14px;color:#556677;">Zaloguj się na <a href="#" style="color:${BRAND.azure};text-decoration:underline;">app.mestio.pl</a> aby skonfigurować osiedle.</span>
          </td>
        </tr>
      </table>

      <p style="margin:0 0 16px;">Dziękujemy za zaufanie. Jesteśmy tu, aby pomóc!</p>
      <p style="margin:0;color:#556677;font-size:14px;">— Zespół Mestio</p>
    `;

    const resend = getResend();
    if (!resend) return;
    await resend.emails.send({
      from: FROM,
      to: email,
      subject: "Płatność za Mestio potwierdzona",
      html: wrapHtml(body),
    });
  } catch (error) {
    console.error("Failed to send payment confirmation email:", error);
  }
}

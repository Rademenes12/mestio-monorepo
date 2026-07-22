import { supabaseAdmin } from "./supabase-admin";

import { PLAN_AMOUNTS_MAP } from "./pricing";

const PLAN_PRICES: Record<string, number> = PLAN_AMOUNTS_MAP;

const SELLER = {
  company: "xxxx",
  address: "xxxx",
  nip: "xxxx",
  bank: "xxxx",
};

const VAT_RATE = 23;

function pad(n: number, width: number): string {
  return String(n).padStart(width, "0");
}

async function getNextSequence(year: number, month: number): Promise<number> {
  const adminClient = supabaseAdmin();
  const prefix = `FV/${year}/${pad(month, 2)}/`;

  const { data, error } = await adminClient
    .from("fixflow_invoices")
    .select("invoice_number")
    .like("invoice_number", `${prefix}%`)
    .order("invoice_number", { ascending: false })
    .limit(1);

  if (error) {
    console.error("getNextSequence error:", error);
    return 1;
  }

  if (!data || data.length === 0) return 1;

  const lastNum = parseInt(data[0].invoice_number.split("/").pop() || "0", 10);
  return lastNum + 1;
}

export interface InvoiceData {
  invoiceNumber: string;
  planName: string;
  periodStart: string;
  periodEnd: string;
  amountNet: number;
  vatRate: number;
  amountVat: number;
  amountGross: number;
  currency: string;
  buyerCompany: string;
  buyerNip: string;
  status: "issued" | "paid" | "cancelled";
  htmlContent: string;
}

export interface InvoiceRecord extends InvoiceData {
  id: string;
  userId: string;
  estateId: string;
  subscriptionId: string;
  createdAt: string;
}

function generateHtml(data: {
  invoiceNumber: string;
  seller: typeof SELLER;
  buyerCompany: string;
  buyerNip: string;
  planName: string;
  periodStart: string;
  periodEnd: string;
  amountNet: number;
  vatRate: number;
  amountVat: number;
  amountGross: number;
  currency: string;
  createdDate: string;
}): string {
  const fmtPrice = (grosze: number) =>
    (grosze / 100).toFixed(2).replace(".", ",") + " PLN";

  return `<!DOCTYPE html>
<html lang="pl">
<head>
<meta charset="UTF-8">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap');
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Space Grotesk', sans-serif; background: #F6F8FB; color: #0E1A2B; font-size: 12px; line-height: 1.5; padding: 40px; }
  .invoice-wrap { max-width: 800px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(14,26,43,0.08); overflow: hidden; }
  .header { background: #0E1A2B; padding: 32px 40px; display: flex; justify-content: space-between; align-items: flex-start; }
  .header-logo { color: #fff; font-size: 22px; font-weight: 700; letter-spacing: -0.5px; }
  .header-logo span { color: #F2A900; }
  .header-badge { background: #F2A900; color: #0E1A2B; font-size: 10px; font-weight: 600; padding: 4px 10px; border-radius: 4px; text-transform: uppercase; letter-spacing: 0.5px; }
  .body { padding: 40px; }
  .invoice-title { font-size: 24px; font-weight: 700; color: #173A6A; margin-bottom: 4px; }
  .invoice-sub { font-size: 11px; color: #666; margin-bottom: 32px; }
  .parties { display: flex; gap: 40px; margin-bottom: 32px; }
  .party { flex: 1; }
  .party-label { font-size: 9px; text-transform: uppercase; letter-spacing: 1px; color: #999; margin-bottom: 8px; font-weight: 600; }
  .party-name { font-size: 14px; font-weight: 600; color: #0E1A2B; margin-bottom: 4px; }
  .party-detail { font-size: 11px; color: #555; }
  .period { background: #F6F8FB; border-radius: 8px; padding: 16px 20px; margin-bottom: 24px; display: flex; justify-content: space-between; font-size: 12px; }
  .period-label { color: #888; }
  .period-value { font-weight: 600; color: #173A6A; }
  table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
  th { background: #173A6A; color: #fff; font-size: 10px; text-transform: uppercase; letter-spacing: 0.5px; padding: 10px 12px; text-align: left; }
  th:last-child { text-align: right; }
  td { padding: 10px 12px; border-bottom: 1px solid #E8ECF0; font-size: 12px; }
  td:last-child { text-align: right; font-weight: 600; }
  .totals { margin-left: auto; width: 280px; }
  .total-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 12px; }
  .total-row.total { border-top: 2px solid #0E1A2B; margin-top: 4px; padding-top: 10px; font-size: 16px; font-weight: 700; color: #173A6A; }
  .footer { background: #F6F8FB; padding: 24px 40px; display: flex; justify-content: space-between; align-items: center; margin-top: 8px; }
  .footer-bank { font-size: 10px; color: #666; }
  .footer-bank strong { color: #0E1A2B; }
  .nip { color: #999; font-size: 10px; }
</style>
</head>
<body>
<div class="invoice-wrap">
  <div class="header">
    <div class="header-logo">MESTIO<span>.</span></div>
    <div class="header-badge">Faktura VAT</div>
  </div>
  <div class="body">
    <div class="invoice-title">FAKTURA VAT</div>
    <div class="invoice-sub">Nr ${data.invoiceNumber} | ${data.createdDate}</div>

    <div class="parties">
      <div class="party">
        <div class="party-label">Sprzedawca</div>
        <div class="party-name">${data.seller.company}</div>
        <div class="party-detail">${data.seller.address}</div>
        <div class="party-detail">NIP: ${data.seller.nip}</div>
      </div>
      <div class="party">
        <div class="party-label">Nabywca</div>
        <div class="party-name">${data.buyerCompany}</div>
        <div class="party-detail nip">NIP: ${data.buyerNip}</div>
      </div>
    </div>

    <div class="period">
      <div><span class="period-label">Okres rozliczeniowy:</span> <span class="period-value">${data.periodStart} – ${data.periodEnd}</span></div>
    </div>

    <table>
      <thead>
        <tr><th>Usługa</th><th>Ilość</th><th>Cena netto</th><th>VAT</th><th>Wartość netto</th></tr>
      </thead>
      <tbody>
        <tr>
          <td>Abonament ${data.planName} – miesięczny</td>
          <td>1</td>
          <td>${fmtPrice(data.amountNet)}</td>
          <td>${data.vatRate}%</td>
          <td>${fmtPrice(data.amountNet)}</td>
        </tr>
      </tbody>
    </table>

    <div class="totals">
      <div class="total-row"><span>Netto:</span><span>${fmtPrice(data.amountNet)}</span></div>
      <div class="total-row"><span>VAT ${data.vatRate}%:</span><span>${fmtPrice(data.amountVat)}</span></div>
      <div class="total-row total"><span>Razem brutto:</span><span>${fmtPrice(data.amountGross)}</span></div>
    </div>
  </div>

  <div class="footer">
    <div class="footer-bank"><strong>${data.seller.bank}</strong></div>
    <div class="footer-bank">NIP ${data.seller.nip}</div>
  </div>
</div>
</body>
</html>`;
}

export async function generateInvoice(params: {
  userId: string;
  estateId: string;
  subscriptionId: string;
  planName: string;
  periodStart: string;
  periodEnd: string;
  buyerCompany: string;
  buyerNip: string;
}): Promise<InvoiceRecord> {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  const seq = await getNextSequence(year, month);

  const invoiceNumber = `FV/${year}/${pad(month, 2)}/${pad(seq, 3)}`;

  const planKey = params.planName.toLowerCase();
  const amountNet = PLAN_PRICES[planKey] ?? 0;

  if (amountNet === 0 && planKey !== "enterprise") {
    console.warn(`Unknown plan: ${params.planName}, using 0 net amount`);
  }

  const amountVat = Math.round((amountNet * VAT_RATE) / 100);
  const amountGross = amountNet + amountVat;

  const createdDate = now.toLocaleDateString("pl-PL", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });

  const htmlContent = generateHtml({
    invoiceNumber,
    seller: SELLER,
    buyerCompany: params.buyerCompany,
    buyerNip: params.buyerNip,
    planName: params.planName,
    periodStart: params.periodStart,
    periodEnd: params.periodEnd,
    amountNet,
    vatRate: VAT_RATE,
    amountVat,
    amountGross,
    currency: "PLN",
    createdDate,
  });

  const adminClient = supabaseAdmin();

  const { data, error } = await adminClient
    .from("fixflow_invoices")
    .insert({
      invoice_number: invoiceNumber,
      user_id: params.userId,
      estate_id: params.estateId,
      subscription_id: params.subscriptionId,
      plan_name: params.planName,
      period_start: params.periodStart,
      period_end: params.periodEnd,
      amount_net: amountNet,
      vat_rate: VAT_RATE,
      amount_vat: amountVat,
      amount_gross: amountGross,
      currency: "PLN",
      buyer_company: params.buyerCompany,
      buyer_nip: params.buyerNip,
      status: "issued",
      html_content: htmlContent,
    })
    .select()
    .single();

  if (error) {
    console.error("generateInvoice insert error:", error);
    throw new Error(`Failed to store invoice: ${error.message}`);
  }

  return {
    id: data.id,
    userId: data.user_id,
    estateId: data.estate_id,
    subscriptionId: data.subscription_id,
    invoiceNumber: data.invoice_number,
    planName: data.plan_name,
    periodStart: data.period_start,
    periodEnd: data.period_end,
    amountNet: data.amount_net,
    vatRate: data.vat_rate,
    amountVat: data.amount_vat,
    amountGross: data.amount_gross,
    currency: data.currency,
    buyerCompany: data.buyer_company,
    buyerNip: data.buyer_nip,
    status: data.status,
    htmlContent: data.html_content,
    createdAt: data.created_at,
  };
}

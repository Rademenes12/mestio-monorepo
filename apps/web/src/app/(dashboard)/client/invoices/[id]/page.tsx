import { getActiveEstate } from "@/lib/active-estate";
import { redirect } from "next/navigation";
import Link from "next/link";

export default async function InvoiceDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const ctx = await getActiveEstate();
  if (!ctx) redirect("/login");
  const { supabase, user } = ctx;

  const { data: invoice } = await supabase
    .from("fixflow_invoices")
    .select("*")
    .eq("id", id)
    .eq("user_id", user.id)
    .single();

  if (!invoice) {
    redirect("/invoices");
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <Link
          href="/invoices"
          className="text-sm text-ink/40 hover:text-ink/70 transition-colors"
        >
          ← Powrót do faktur
        </Link>
      </div>

      <div className="bg-white rounded-[22px] shadow-[0_2px_12px_rgba(14,26,43,.06)] p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-xl font-heading font-bold text-ink">
              {invoice.invoice_number}
            </h1>
            <p className="text-sm text-ink/50 mt-1">
              {invoice.plan_name}
            </p>
          </div>
          {invoice.html_content && (
            <a
              href={`data:text/html;charset=utf-8,${encodeURIComponent(invoice.html_content)}`}
              download={`${invoice.invoice_number}.html`}
              className="px-4 py-2 rounded-xl bg-azure/10 text-azure text-sm font-medium hover:bg-azure/20 transition-colors"
            >
              Pobierz HTML
            </a>
          )}
        </div>

        {invoice.html_content ? (
          <div className="border border-ink/10 rounded-xl overflow-hidden">
            <iframe
              srcDoc={invoice.html_content}
              className="w-full border-0"
              style={{ minHeight: "600px" }}
              title={invoice.invoice_number}
            />
          </div>
        ) : (
          <p className="text-sm text-ink/30 py-8 text-center">
            Brak treści faktury do wyświetlenia.
          </p>
        )}
      </div>
    </div>
  );
}

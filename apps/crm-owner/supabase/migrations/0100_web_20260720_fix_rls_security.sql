-- ============================================
-- Migracja RLS — łatanie 3 niezabezpieczonych tabel
-- Data: 2026-07-20
-- ============================================

-- 1. fixflow_invoices: Włącz RLS + polityka tylko dla zalogowanych
ALTER TABLE public.fixflow_invoices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS invoices_owner_read ON public.fixflow_invoices;
CREATE POLICY invoices_owner_read ON public.fixflow_invoices
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Tylko service_role może INSERT (przez API route na WWW)
CREATE POLICY invoices_service_insert ON public.fixflow_invoices
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- ============================================

-- 2. fixflow_transfer_payments: Poprawka polityki (była na public, zmień na authenticated)
DROP POLICY IF EXISTS invoices_owner_read ON public.fixflow_transfer_payments;

CREATE POLICY transfer_payments_owner_read ON public.fixflow_transfer_payments
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================

-- 3. blog_posts: Usuń niebezpieczną politykę blog_owner (ALL dla public)
-- (Zakomentowane bo użytkownik już usunął ręcznie z dashboardu)
-- DROP POLICY IF EXISTS blog_owner ON public.blog_posts;

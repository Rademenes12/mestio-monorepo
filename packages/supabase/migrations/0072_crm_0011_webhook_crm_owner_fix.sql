-- Naprawa provisioningu: webhook Stripe musi moc pisac do tabel CRM Owner
-- Wykonaj ten plik w Supabase SQL Editor (https://supabase.com → SQL Editor)

-- 1. Polityki dla estates (CRM Owner) — service_role bypass
DROP POLICY IF EXISTS estates_service_role_write ON public.estates;
CREATE POLICY estates_service_role_write ON public.estates
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS estates_service_role_update ON public.estates;
CREATE POLICY estates_service_role_update ON public.estates
  FOR UPDATE USING (true) WITH CHECK (true);

-- 2. Polityki dla crm_leads — service_role bypass
DROP POLICY IF EXISTS crm_leads_service_role_write ON public.crm_leads;
CREATE POLICY crm_leads_service_role_write ON public.crm_leads
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS crm_leads_service_role_update ON public.crm_leads;
CREATE POLICY crm_leads_service_role_update ON public.crm_leads
  FOR UPDATE USING (true) WITH CHECK (true);

-- 3. Polityki dla crm_interactions — potrzebne przy triggerach/auto-wpisach
DROP POLICY IF EXISTS crm_interactions_service_role ON public.crm_interactions;
CREATE POLICY crm_interactions_service_role ON public.crm_interactions
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS crm_tasks_service_role ON public.crm_tasks;
CREATE POLICY crm_tasks_service_role ON public.crm_tasks
  FOR INSERT WITH CHECK (true);

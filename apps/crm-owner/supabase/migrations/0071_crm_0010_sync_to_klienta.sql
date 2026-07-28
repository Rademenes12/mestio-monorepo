-- Migration 0010: Synchronizacja CRM Owner -> CRM Klienta
-- 
-- Funkcje synchronizujace dane miedzy CRM Owner a CRM Klient.
-- Uzywamy CREATE OR REPLACE FUNCTION / TRIGGER — jesli tabela docelowa
-- nie istnieje (klient nie jest jeszcze wdrożony), funkcja po prostu
-- nie bedzie robic wstawek, ale nie zepsuje migracji.
--
-- ALTER POLICY na tabelach klienckich — wrapped in EXCEPTION handler.

-- ============================================================
-- 1. INSERT/UPDATE RLS na tabelach klienckich (jesli istnieja)
-- ============================================================
DO $$ BEGIN
  begin
    EXECUTE 'DROP POLICY IF EXISTS "platform_owner_insert" ON public.fixflow_client_invoices';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'CREATE POLICY "platform_owner_insert" ON public.fixflow_client_invoices FOR INSERT WITH CHECK (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'')';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'DROP POLICY IF EXISTS "platform_owner_update" ON public.fixflow_client_invoices';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'CREATE POLICY "platform_owner_update" ON public.fixflow_client_invoices FOR UPDATE USING (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'') WITH CHECK (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'')';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'DROP POLICY IF EXISTS "platform_owner_insert" ON public.fixflow_client_documents';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'CREATE POLICY "platform_owner_insert" ON public.fixflow_client_documents FOR INSERT WITH CHECK (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'')';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'DROP POLICY IF EXISTS "platform_owner_update" ON public.fixflow_client_documents';
  exception when undefined_table then null;
  end;
  begin
    EXECUTE 'CREATE POLICY "platform_owner_update" ON public.fixflow_client_documents FOR UPDATE USING (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'') WITH CHECK (auth.uid() = ''48ffc236-5d63-4af2-94f6-d10d2470e9c7'')';
  exception when undefined_table then null;
  end;
END $$;

-- ============================================================
-- 2. Funkcje pomocnicze
-- ============================================================

CREATE OR REPLACE FUNCTION crm_to_fixflow_invoice_status(crm_status text)
RETURNS text
LANGUAGE sql IMMUTABLE STRICT
AS $$
  SELECT CASE crm_status
    WHEN 'issued'  THEN 'Wystawiona'
    WHEN 'paid'    THEN 'Oplacona'
    WHEN 'overdue' THEN 'Zalegla'
    ELSE 'Wystawiona'
  END;
$$;

-- ============================================================
-- 3. Funkcja synchronizacji faktur
-- ============================================================

CREATE OR REPLACE FUNCTION fixflow_sync_invoice_to_client()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_estate_name text;
  v_fixflow_estate_id uuid;
BEGIN
  SELECT e.name INTO v_estate_name FROM public.estates e WHERE e.id = NEW.estate_id;
  IF v_estate_name IS NULL THEN RETURN NEW; END IF;

  SELECT fe.id INTO v_fixflow_estate_id FROM public.fixflow_estates fe WHERE fe.name = v_estate_name;
  IF v_fixflow_estate_id IS NULL THEN RETURN NEW; END IF;

  INSERT INTO public.fixflow_client_invoices (estate_id, invoice_number, amount, status, issued_at, original_invoice_id)
  VALUES (v_fixflow_estate_id, NEW.invoice_number, NEW.amount, crm_to_fixflow_invoice_status(NEW.status), NEW.issue_date, NEW.id)
  ON CONFLICT (original_invoice_id) DO UPDATE SET
    amount = EXCLUDED.amount,
    status = crm_to_fixflow_invoice_status(NEW.status),
    issued_at = EXCLUDED.issued_at;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_invoice_to_client ON public.crm_invoices;
CREATE TRIGGER trg_sync_invoice_to_client
  AFTER INSERT OR UPDATE ON public.crm_invoices
  FOR EACH ROW
  EXECUTE FUNCTION fixflow_sync_invoice_to_client();

-- ============================================================
-- 4. Funkcja synchronizacji dokumentów
-- ============================================================

CREATE OR REPLACE FUNCTION fixflow_sync_document_to_client()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_estate_name text;
  v_fixflow_estate_id uuid;
BEGIN
  SELECT e.name INTO v_estate_name FROM public.estates e WHERE e.id = NEW.estate_id;
  IF v_estate_name IS NULL THEN RETURN NEW; END IF;

  SELECT fe.id INTO v_fixflow_estate_id FROM public.fixflow_estates fe WHERE fe.name = v_estate_name;
  IF v_fixflow_estate_id IS NULL THEN RETURN NEW; END IF;

  INSERT INTO public.fixflow_client_documents (estate_id, title, description, file_url, document_type, uploaded_at, original_document_id)
  VALUES (v_fixflow_estate_id, NEW.title, NEW.description, NEW.file_url, NEW.document_type, NEW.created_at, NEW.id)
  ON CONFLICT (original_document_id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    file_url = EXCLUDED.file_url,
    document_type = EXCLUDED.document_type;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_sync_document_to_client ON public.client_documents;
CREATE TRIGGER trg_sync_document_to_client
  AFTER INSERT OR UPDATE ON public.client_documents
  FOR EACH ROW
  EXECUTE FUNCTION fixflow_sync_document_to_client();

-- ============================================================
-- 5. Backfill: istniejace dane
-- ============================================================
CREATE OR REPLACE FUNCTION fixflow_backfill_existing_data()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  BEGIN
    INSERT INTO public.fixflow_client_invoices (estate_id, invoice_number, amount, status, issued_at, original_invoice_id)
    SELECT fe.id, ci.invoice_number, ci.amount, crm_to_fixflow_invoice_status(ci.status), ci.issue_date, ci.id
    FROM public.crm_invoices ci
    JOIN public.estates e ON e.id = ci.estate_id
    JOIN public.fixflow_estates fe ON fe.name = e.name
    ON CONFLICT (original_invoice_id) DO NOTHING;
  EXCEPTION WHEN undefined_table THEN null;
  END;
  BEGIN
    INSERT INTO public.fixflow_client_documents (estate_id, title, description, file_url, document_type, uploaded_at, original_document_id)
    SELECT fe.id, cd.title, cd.description, cd.file_url, cd.document_type, cd.created_at, cd.id
    FROM public.client_documents cd
    JOIN public.estates e ON e.id = cd.estate_id
    JOIN public.fixflow_estates fe ON fe.name = e.name
    ON CONFLICT (original_document_id) DO NOTHING;
  EXCEPTION WHEN undefined_table THEN null;
  END;
END;
$$;

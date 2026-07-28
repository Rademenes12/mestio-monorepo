-- Migration 0010: Synchronizacja CRM Owner -> CRM Klienta
-- Problem: CRM Owner zapisuje faktury do crm_invoices i dokumenty do
-- client_documents, ale CRM Klienta czyta z fixflow_client_invoices i
-- fixflow_client_documents. Te tabele sa rozne i Klient widzi puste dane.
--
-- Rozwiazanie: triggery AFTER INSERT/UPDATE na tabelach CRM Owner, ktore
-- automatycznie synchronizuja dane do tabel fixflow_*, mostem jest nazwa
-- osiedla (estates.name = fixflow_estates.name).

-- ============================================================
-- 1. INSERT/UPDATE RLS dla fixflow_client_invoices i fixflow_client_documents
--    (istniejace polityki maja tylko SELECT dla admin/board)
-- ============================================================
DROP POLICY IF EXISTS "platform_owner_insert" ON public.fixflow_client_invoices;
CREATE POLICY "platform_owner_insert" ON public.fixflow_client_invoices
  FOR INSERT
  WITH CHECK (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

DROP POLICY IF EXISTS "platform_owner_update" ON public.fixflow_client_invoices;
CREATE POLICY "platform_owner_update" ON public.fixflow_client_invoices
  FOR UPDATE
  USING (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  WITH CHECK (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

DROP POLICY IF EXISTS "platform_owner_insert" ON public.fixflow_client_documents;
CREATE POLICY "platform_owner_insert" ON public.fixflow_client_documents
  FOR INSERT
  WITH CHECK (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

DROP POLICY IF EXISTS "platform_owner_update" ON public.fixflow_client_documents;
CREATE POLICY "platform_owner_update" ON public.fixflow_client_documents
  FOR UPDATE
  USING (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
  WITH CHECK (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

-- ============================================================
-- 2. Funkcje pomocnicze
-- ============================================================

-- Mapowanie statusow faktury
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

-- Okres rozliczeniowy z polskimi nazwami miesiecy
CREATE OR REPLACE FUNCTION crm_invoice_period(issued_at date)
RETURNS text
LANGUAGE sql IMMUTABLE STRICT
AS $$
  SELECT CASE extract(month FROM issued_at)::int
    WHEN 1  THEN 'Styczen'
    WHEN 2  THEN 'Luty'
    WHEN 3  THEN 'Marzec'
    WHEN 4  THEN 'Kwiecien'
    WHEN 5  THEN 'Maj'
    WHEN 6  THEN 'Czerwiec'
    WHEN 7  THEN 'Lipiec'
    WHEN 8  THEN 'Sierpien'
    WHEN 9  THEN 'Wrzesien'
    WHEN 10 THEN 'Pazdziernik'
    WHEN 11 THEN 'Listopad'
    WHEN 12 THEN 'Grudzien'
  END || ' ' || extract(year FROM issued_at)::text;
$$;

-- ============================================================
-- 3. Funkcja sync: faktura CRM -> faktura Klienta
--    Most: crm_invoices -> crm_leads -> estates.name -> fixflow_estates.name
-- ============================================================
CREATE OR REPLACE FUNCTION sync_crm_invoice_to_fixflow(p_invoice_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invoice           record;
  v_estate_name        text;
  v_fixflow_estate_id  uuid;
  v_fixflow_invoice_id uuid;
BEGIN
  -- Auth check tylko gdy wywolywane jako RPC (nie z triggera)
  IF pg_trigger_depth() = 0
     AND auth.uid() IS DISTINCT FROM '48ffc236-5d63-4af2-94f6-d10d2470e9c7'
  THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  SELECT ci.*
  INTO v_invoice
  FROM crm_invoices ci
  JOIN crm_leads cl ON cl.id = ci.lead_id
  WHERE ci.id = p_invoice_id;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  -- Pobierz nazwe osiedla z estates (CRM Owner)
  SELECT e.name INTO v_estate_name
  FROM crm_leads cl
  JOIN estates e ON e.id = cl.estate_id
  WHERE cl.id = v_invoice.lead_id;

  IF v_estate_name IS NULL THEN
    RETURN NULL;
  END IF;

  -- Znajdz pasujacy fixflow_estates po nazwie
  SELECT id INTO v_fixflow_estate_id
  FROM fixflow_estates
  WHERE name = v_estate_name
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  -- Deduplikacja: sprawdz czy juz istnieje (invoice_number + estate_id)
  SELECT id INTO v_fixflow_invoice_id
  FROM fixflow_client_invoices
  WHERE estate_id = v_fixflow_estate_id
    AND invoice_number = v_invoice.number
  LIMIT 1;

  IF FOUND THEN
    UPDATE fixflow_client_invoices
    SET
      status = crm_to_fixflow_invoice_status(v_invoice.status),
      amount = round(v_invoice.amount, 0)::text || ' zl'
    WHERE id = v_fixflow_invoice_id;
    RETURN v_fixflow_invoice_id;
  END IF;

  INSERT INTO fixflow_client_invoices (
    estate_id, invoice_number, period, amount, status
  ) VALUES (
    v_fixflow_estate_id,
    v_invoice.number,
    crm_invoice_period(v_invoice.issued_at),
    round(v_invoice.amount, 0)::text || ' zl',
    crm_to_fixflow_invoice_status(v_invoice.status)
  )
  RETURNING id INTO v_fixflow_invoice_id;

  RETURN v_fixflow_invoice_id;
END;
$$;

COMMENT ON FUNCTION sync_crm_invoice_to_fixflow(uuid) IS
  'Synchronizuje fakture z crm_invoices do fixflow_client_invoices. Most: estates.name = fixflow_estates.name.';

-- ============================================================
-- 4. Funkcja sync: dokument CRM -> dokument Klienta
-- ============================================================
CREATE OR REPLACE FUNCTION sync_client_document_to_fixflow(p_document_id uuid)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_doc               record;
  v_estate_name        text;
  v_fixflow_estate_id  uuid;
  v_fixflow_doc_id     uuid;
  v_status             text;
BEGIN
  IF pg_trigger_depth() = 0
     AND auth.uid() IS DISTINCT FROM '48ffc236-5d63-4af2-94f6-d10d2470e9c7'
  THEN
    RAISE EXCEPTION 'FORBIDDEN';
  END IF;

  SELECT cd.*
  INTO v_doc
  FROM client_documents cd
  JOIN crm_leads cl ON cl.id = cd.lead_id
  WHERE cd.id = p_document_id;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT e.name INTO v_estate_name
  FROM crm_leads cl
  JOIN estates e ON e.id = cl.estate_id
  WHERE cl.id = v_doc.lead_id;

  IF v_estate_name IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT id INTO v_fixflow_estate_id
  FROM fixflow_estates
  WHERE name = v_estate_name
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  v_status := CASE v_doc.status
    WHEN 'signed' THEN 'Podpisana'
    ELSE 'Aktualna'
  END;

  -- Deduplikacja po name + estate_id
  SELECT id INTO v_fixflow_doc_id
  FROM fixflow_client_documents
  WHERE estate_id = v_fixflow_estate_id
    AND name = v_doc.title
  LIMIT 1;

  IF FOUND THEN
    UPDATE fixflow_client_documents
    SET
      meta   = v_doc.type,
      status = v_status
    WHERE id = v_fixflow_doc_id;
    RETURN v_fixflow_doc_id;
  END IF;

  INSERT INTO fixflow_client_documents (
    estate_id, name, meta, status
  ) VALUES (
    v_fixflow_estate_id,
    v_doc.title,
    v_doc.type,
    v_status
  )
  RETURNING id INTO v_fixflow_doc_id;

  RETURN v_fixflow_doc_id;
END;
$$;

COMMENT ON FUNCTION sync_client_document_to_fixflow(uuid) IS
  'Synchronizuje dokument z client_documents do fixflow_client_documents. Most: estates.name = fixflow_estates.name.';

-- ============================================================
-- 5. TRIGGERY: automatyczna synchronizacja
-- ============================================================

-- -- 5a. Faktury: INSERT
CREATE OR REPLACE FUNCTION trg_crm_invoice_sync()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM sync_crm_invoice_to_fixflow(NEW.id);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_crm_invoice_after_insert ON crm_invoices;
CREATE TRIGGER trg_crm_invoice_after_insert
  AFTER INSERT ON crm_invoices
  FOR EACH ROW
  EXECUTE FUNCTION trg_crm_invoice_sync();

-- -- 5b. Faktury: UPDATE (status/amount)
DROP TRIGGER IF EXISTS trg_crm_invoice_after_update ON crm_invoices;
CREATE TRIGGER trg_crm_invoice_after_update
  AFTER UPDATE ON crm_invoices
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status
     OR OLD.amount IS DISTINCT FROM NEW.amount
     OR OLD.number IS DISTINCT FROM NEW.number)
  EXECUTE FUNCTION trg_crm_invoice_sync();

-- -- 5c. Dokumenty: INSERT
CREATE OR REPLACE FUNCTION trg_client_document_sync()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM sync_client_document_to_fixflow(NEW.id);
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_client_document_after_insert ON client_documents;
CREATE TRIGGER trg_client_document_after_insert
  AFTER INSERT ON client_documents
  FOR EACH ROW
  EXECUTE FUNCTION trg_client_document_sync();

-- -- 5d. Dokumenty: UPDATE (status/title)
DROP TRIGGER IF EXISTS trg_client_document_after_update ON client_documents;
CREATE TRIGGER trg_client_document_after_update
  AFTER UPDATE ON client_documents
  FOR EACH ROW
  WHEN (OLD.status IS DISTINCT FROM NEW.status
     OR OLD.title IS DISTINCT FROM NEW.title
     OR OLD.type IS DISTINCT FROM NEW.type)
  EXECUTE FUNCTION trg_client_document_sync();

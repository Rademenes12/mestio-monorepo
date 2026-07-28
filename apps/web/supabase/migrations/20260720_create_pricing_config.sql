-- Tabela konfiguracji cen — edytowalna z CRM Owner
CREATE TABLE IF NOT EXISTS public.pricing_config (
  plan_key TEXT PRIMARY KEY,
  amount_grosze INTEGER NOT NULL DEFAULT 0,
  price_display TEXT NOT NULL DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.pricing_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read" ON public.pricing_config;
CREATE POLICY "Allow public read" ON public.pricing_config
  FOR SELECT USING (true);

-- Dane domyślne (zgodne z obecnym cennikiem)
INSERT INTO public.pricing_config (plan_key, amount_grosze, price_display)
VALUES
  ('start', 7900, '79 zł'),
  ('standard', 17900, '179 zł'),
  ('pro', 34900, '349 zł'),
  ('enterprise', 0, 'Wycena')
ON CONFLICT (plan_key) DO NOTHING;

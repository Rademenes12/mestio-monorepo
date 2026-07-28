-- ════════════════════════════════════════════════════════════════════════════
-- FixFlow Stripe Subscriptions — Migration 0024
-- Pipeline: Stripe webhook -> provision subscription -> create estate + admin
-- ════════════════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════════════════
-- 1. Tabela subscriptions
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS public.fixflow_subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  -- Stripe identifiers (unique constraint for idempotency)
  stripe_subscription_id text UNIQUE NOT NULL,
  stripe_customer_id text NOT NULL,
  stripe_price_id text,
  
  -- Link to estate (created during provisioning)
  estate_id uuid REFERENCES public.fixflow_estates(id) ON DELETE SET NULL,
  
  -- Link to user who purchased (from client_reference_id)
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  
  -- Subscription status
  status text NOT NULL DEFAULT 'active',
  -- 'active', 'past_due', 'canceled', 'unpaid', 'trialing', 'incomplete'
  
  -- Billing period
  current_period_start timestamptz,
  current_period_end timestamptz,
  cancel_at_period_end boolean DEFAULT false,
  
  -- Metadata from Stripe
  metadata_json jsonb DEFAULT '{}',
  
  -- Timestamps
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_fixflow_subscriptions_stripe_id 
  ON public.fixflow_subscriptions(stripe_subscription_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_subscriptions_customer 
  ON public.fixflow_subscriptions(stripe_customer_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_subscriptions_estate 
  ON public.fixflow_subscriptions(estate_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_subscriptions_user 
  ON public.fixflow_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_subscriptions_status 
  ON public.fixflow_subscriptions(status);

-- ════════════════════════════════════════════════════════════════════════════
-- 2. RLS: Tylko service_role może zapisywać, użytkownik może czytać własne
-- ════════════════════════════════════════════════════════════════════════════

ALTER TABLE public.fixflow_subscriptions ENABLE ROW LEVEL SECURITY;

-- Użytkownik może czytać tylko własne subskrypcje
DROP POLICY IF EXISTS "subscriptions_select_own" ON public.fixflow_subscriptions;
CREATE POLICY "subscriptions_select_own" ON public.fixflow_subscriptions
  FOR SELECT USING (user_id = auth.uid());

-- Admin osiedla może czytać subskrypcje swojego osiedla
DROP POLICY IF EXISTS "subscriptions_select_estate_admin" ON public.fixflow_subscriptions;
CREATE POLICY "subscriptions_select_estate_admin" ON public.fixflow_subscriptions
  FOR SELECT USING (
    estate_id IS NOT NULL 
    AND public.fixflow_is_estate_admin(estate_id)
  );

-- BRAK INSERT/UPDATE/DELETE dla authenticated - tylko service_role przez Edge Function!
-- To jest krytyczne dla bezpieczeństwa - klient NIE może manipulować subskrypcjami

-- Grant tylko SELECT dla authenticated
GRANT SELECT ON public.fixflow_subscriptions TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- 3. Funkcja provision_subscription (IDEMPOTENTNA)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_provision_subscription(
  p_stripe_subscription_id text,
  p_stripe_customer_id text,
  p_stripe_price_id text,
  p_user_id uuid,
  p_estate_name text,
  p_status text DEFAULT 'active',
  p_current_period_start timestamptz DEFAULT NULL,
  p_current_period_end timestamptz DEFAULT NULL,
  p_metadata jsonb DEFAULT '{}'
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_subscription_id uuid;
  v_estate_id uuid;
  v_invitation_code text;
  v_existing_sub public.fixflow_subscriptions%ROWTYPE;
BEGIN
  -- IDEMPOTENCY CHECK: Sprawdź czy subskrypcja już istnieje
  SELECT * INTO v_existing_sub
  FROM public.fixflow_subscriptions
  WHERE stripe_subscription_id = p_stripe_subscription_id;
  
  IF FOUND THEN
    -- Subskrypcja już istnieje - zwróć istniejące dane bez duplikacji
    RETURN jsonb_build_object(
      'success', true,
      'idempotent', true,
      'subscription_id', v_existing_sub.id,
      'estate_id', v_existing_sub.estate_id,
      'message', 'Subscription already provisioned'
    );
  END IF;
  
  -- KROK 1: Utwórz osiedle
  INSERT INTO public.fixflow_estates (name)
  VALUES (COALESCE(p_estate_name, 'Nowe Osiedle'))
  RETURNING id INTO v_estate_id;
  
  -- KROK 2: Dodaj użytkownika jako admina osiedla
  IF p_user_id IS NOT NULL THEN
    INSERT INTO public.fixflow_user_estates (user_id, estate_id, role)
    VALUES (p_user_id, v_estate_id, 'admin')
    ON CONFLICT (user_id, estate_id) DO UPDATE SET role = 'admin';
    
    -- Utwórz profil mieszkańca jeśli nie istnieje
    INSERT INTO public.fixflow_resident_profiles (id, role, is_verified)
    VALUES (p_user_id, 'Administrator', true)
    ON CONFLICT (id) DO UPDATE SET 
      role = 'Administrator',
      is_verified = true;
  END IF;
  
  -- KROK 3: Utwórz kod zaproszenia
  v_invitation_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 6));
  
  INSERT INTO public.fixflow_invitation_codes (estate_id, code, is_active)
  VALUES (v_estate_id, v_invitation_code, true);
  
  -- KROK 4: Utwórz rekord subskrypcji
  INSERT INTO public.fixflow_subscriptions (
    stripe_subscription_id,
    stripe_customer_id,
    stripe_price_id,
    estate_id,
    user_id,
    status,
    current_period_start,
    current_period_end,
    metadata_json
  )
  VALUES (
    p_stripe_subscription_id,
    p_stripe_customer_id,
    p_stripe_price_id,
    v_estate_id,
    p_user_id,
    p_status,
    p_current_period_start,
    p_current_period_end,
    p_metadata
  )
  RETURNING id INTO v_subscription_id;
  
  RETURN jsonb_build_object(
    'success', true,
    'idempotent', false,
    'subscription_id', v_subscription_id,
    'estate_id', v_estate_id,
    'invitation_code', v_invitation_code,
    'message', 'Subscription provisioned successfully'
  );
  
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(
    'success', false,
    'error', SQLERRM,
    'error_detail', SQLSTATE
  );
END;
$$;

-- ════════════════════════════════════════════════════════════════════════════
-- 4. Funkcja update_subscription_status
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION public.fixflow_update_subscription_status(
  p_stripe_subscription_id text,
  p_status text,
  p_current_period_start timestamptz DEFAULT NULL,
  p_current_period_end timestamptz DEFAULT NULL,
  p_cancel_at_period_end boolean DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_subscription public.fixflow_subscriptions%ROWTYPE;
BEGIN
  -- Znajdź subskrypcję
  SELECT * INTO v_subscription
  FROM public.fixflow_subscriptions
  WHERE stripe_subscription_id = p_stripe_subscription_id;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Subscription not found',
      'stripe_subscription_id', p_stripe_subscription_id
    );
  END IF;
  
  -- Zaktualizuj status
  UPDATE public.fixflow_subscriptions
  SET 
    status = p_status,
    current_period_start = COALESCE(p_current_period_start, current_period_start),
    current_period_end = COALESCE(p_current_period_end, current_period_end),
    cancel_at_period_end = COALESCE(p_cancel_at_period_end, cancel_at_period_end),
    updated_at = now()
  WHERE stripe_subscription_id = p_stripe_subscription_id;
  
  RETURN jsonb_build_object(
    'success', true,
    'subscription_id', v_subscription.id,
    'estate_id', v_subscription.estate_id,
    'old_status', v_subscription.status,
    'new_status', p_status
  );
END;
$$;

-- ════════════════════════════════════════════════════════════════════════════
-- 5. Widok dla statusu subskrypcji osiedla (z karencją)
-- ════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW public.v_fixflow_estate_subscription_status AS
SELECT 
  e.id AS estate_id,
  e.name AS estate_name,
  s.status AS subscription_status,
  s.current_period_end,
  s.cancel_at_period_end,
  -- Karencja: past_due przez max 7 dni nie blokuje dostępu
  CASE 
    WHEN s.status = 'active' THEN true
    WHEN s.status = 'trialing' THEN true
    WHEN s.status = 'past_due' AND s.current_period_end > (now() - interval '7 days') THEN true
    WHEN s.status IS NULL THEN true  -- Osiedla bez subskrypcji (legacy/test)
    ELSE false
  END AS is_access_allowed,
  -- Ostrzeżenie o zaległości
  CASE 
    WHEN s.status = 'past_due' THEN true
    WHEN s.cancel_at_period_end = true THEN true
    ELSE false
  END AS show_payment_warning
FROM public.fixflow_estates e
LEFT JOIN public.fixflow_subscriptions s ON s.estate_id = e.id;

-- Grant dla widoku
GRANT SELECT ON public.v_fixflow_estate_subscription_status TO authenticated;

-- ════════════════════════════════════════════════════════════════════════════
-- 6. Grants dla funkcji (tylko service_role może wywoływać provision)
-- ════════════════════════════════════════════════════════════════════════════

-- Funkcje provisioningu - TYLKO dla service_role (wywoływane przez Edge Function)
REVOKE EXECUTE ON FUNCTION public.fixflow_provision_subscription FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.fixflow_provision_subscription FROM authenticated;

REVOKE EXECUTE ON FUNCTION public.fixflow_update_subscription_status FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.fixflow_update_subscription_status FROM authenticated;

-- Service role ma dostęp przez domyślne uprawnienia superuser

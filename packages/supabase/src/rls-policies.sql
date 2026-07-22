-- ============================================================================
-- RLS Policies Audit & Recommendations for Mestio Monorepo
-- ============================================================================
-- This file documents recommended Row-Level Security (RLS) policies for the
-- Supabase database. Apply these via the Supabase SQL Editor or migrations.
--
-- ROLE HIERARCHY:
--   admin  — Full access to all rows (platform admin)
--   owner  — Owns properties, manages tenants and units
--   client — End-user (property owner customer) viewing their own data
--   tenant — Renter, views their own unit/tickets/payments
-- ============================================================================

-- 1. ENABLE RLS ON ALL TABLES ------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 2. PROFILES TABLE -----------------------------------------------------------
-- Users can only read/update their own profile.
-- Admins can read all profiles but cannot modify others' profiles directly.

CREATE POLICY "Users can read own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can read all profiles"
  ON public.profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Profiles are created via trigger on auth.users — no INSERT policy needed
-- from the client side (handled by handle_new_user trigger).

-- 3. PROPERTIES TABLE ---------------------------------------------------------
-- Owners can CRUD only their own properties.
-- Clients can read properties they are related to (via tenants/units).
-- Admins can read all properties.

CREATE POLICY "Owners can manage own properties"
  ON public.properties FOR ALL
  USING (auth.uid() = owner_id)
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Clients can read their properties"
  ON public.properties FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.units u
      JOIN public.tenants t ON t.unit_id = u.id
      WHERE u.property_id = properties.id AND t.profile_id = auth.uid()
    )
  );

CREATE POLICY "Admins can read all properties"
  ON public.properties FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 4. UNITS TABLE --------------------------------------------------------------
-- Owners can manage units in their properties.
-- Tenants can read their own unit.
-- Admins can read all units.

CREATE POLICY "Owners can manage units in their properties"
  ON public.units FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.properties p
      WHERE p.id = units.property_id AND p.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.properties p
      WHERE p.id = units.property_id AND p.owner_id = auth.uid()
    )
  );

CREATE POLICY "Tenants can read own unit"
  ON public.units FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.tenants t
      WHERE t.unit_id = units.id AND t.profile_id = auth.uid()
    )
  );

CREATE POLICY "Admins can read all units"
  ON public.units FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 5. TENANTS TABLE ------------------------------------------------------------
-- Owners can manage tenants in their properties.
-- Tenants can read their own record.
-- Admins can read all tenants.

CREATE POLICY "Owners can manage tenants in their properties"
  ON public.tenants FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.units u
      JOIN public.properties p ON p.id = u.property_id
      WHERE u.id = tenants.unit_id AND p.owner_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.units u
      JOIN public.properties p ON p.id = u.property_id
      WHERE u.id = tenants.unit_id AND p.owner_id = auth.uid()
    )
  );

CREATE POLICY "Tenants can read own record"
  ON public.tenants FOR SELECT
  USING (profile_id = auth.uid());

CREATE POLICY "Admins can read all tenants"
  ON public.tenants FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 6. TICKETS TABLE ------------------------------------------------------------
-- Reporters can create tickets and read/update their own.
-- Owners can read/update tickets for their properties.
-- Assigned staff can update tickets assigned to them.
-- Admins can read all tickets.

CREATE POLICY "Users can create tickets"
  ON public.tickets FOR INSERT
  WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Reporters can read own tickets"
  ON public.tickets FOR SELECT
  USING (reporter_id = auth.uid());

CREATE POLICY "Reporters can update own tickets (only if not resolved)"
  ON public.tickets FOR UPDATE
  USING (reporter_id = auth.uid() AND status NOT IN ('resolved', 'closed'))
  WITH CHECK (reporter_id = auth.uid());

CREATE POLICY "Owners can manage tickets for their properties"
  ON public.tickets FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.properties p
      WHERE p.id = tickets.property_id AND p.owner_id = auth.uid()
    )
  );

CREATE POLICY "Assigned staff can update their tickets"
  ON public.tickets FOR UPDATE
  USING (assigned_to = auth.uid());

CREATE POLICY "Admins can read all tickets"
  ON public.tickets FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 7. PAYMENTS TABLE -----------------------------------------------------------
-- Tenants can read their own payments.
-- Owners can read payments for their properties.
-- Admins can read all payments.
-- Payments are typically created server-side (Stripe webhook) — no INSERT
-- policy for clients.

CREATE POLICY "Tenants can read own payments"
  ON public.payments FOR SELECT
  USING (tenant_id = auth.uid());

CREATE POLICY "Owners can read payments for their properties"
  ON public.payments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.properties p
      WHERE p.id = payments.property_id AND p.owner_id = auth.uid()
    )
  );

CREATE POLICY "Admins can read all payments"
  ON public.payments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Payments INSERT/UPDATE should be done server-side only via service_role.
-- If client-side payment creation is needed, add:
-- CREATE POLICY "Tenants can create payments for themselves"
--   ON public.payments FOR INSERT
--   WITH CHECK (tenant_id = auth.uid());

-- 8. MESSAGES TABLE -----------------------------------------------------------
-- Senders can create and read messages they sent.
-- Receivers can read messages sent to them.
-- Ticket participants can read messages on their tickets.
-- Admins can read all messages.

CREATE POLICY "Users can send messages"
  ON public.messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Senders can read own messages"
  ON public.messages FOR SELECT
  USING (sender_id = auth.uid());

CREATE POLICY "Receivers can read their messages"
  ON public.messages FOR SELECT
  USING (receiver_id = auth.uid());

CREATE POLICY "Ticket participants can read ticket messages"
  ON public.messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.tickets t
      WHERE t.id = messages.ticket_id
        AND (t.reporter_id = auth.uid() OR t.assigned_to = auth.uid())
    )
  );

CREATE POLICY "Admins can read all messages"
  ON public.messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- 9. VERIFICATION QUERIES -----------------------------------------------------
-- Run these to verify RLS is working correctly:

-- Check which tables have RLS enabled:
-- SELECT schemaname, tablename, rowsecurity
-- FROM pg_tables
-- WHERE schemaname = 'public'
-- ORDER BY tablename;

-- Check active policies:
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- ORDER BY tablename, cmd;

-- Test as a tenant (replace UUID):
-- SET LOCAL ROLE authenticated;
-- SET LOCAL request.jwt.claim.sub TO '<tenant-user-id>';
-- SELECT * FROM public.payments;
-- RESET ROLE;

-- ============================================================================
-- END OF RLS POLICIES
-- ============================================================================

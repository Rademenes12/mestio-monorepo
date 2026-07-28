-- Migration: Expose the estate's contract end date to all estate members
-- (MASTER_BUILD par.16 / FixFlow_WSAD_DLA_AI Zadanie 2: "Umowa aktywna do" +
-- countdown in the app profile, colored green >30d / amber <=30d / red <=7d).
--
-- fixflow_subscriptions already has current_period_end (populated by the
-- Stripe webhook), but its RLS only allows the paying user or estate office
-- (admin/board) to read it. Members need to SEE the countdown too - so we
-- add a member-read policy AND a narrow view that exposes only the 3 safe
-- fields (estate_id, status, current_period_end), keeping stripe_customer_id
-- / stripe_price_id / metadata_json out of reach for plain members.

CREATE POLICY "subscriptions_select_estate_member" ON public.fixflow_subscriptions
  FOR SELECT USING (
    estate_id IS NOT NULL
    AND public.fixflow_is_estate_member(estate_id)
  );

-- security_invoker: the view runs with the QUERYING user's RLS on the base
-- table, not the view owner's - so it exposes nothing the policy above
-- doesn't already allow.
CREATE OR REPLACE VIEW public.v_fixflow_estate_contract
WITH (security_invoker = true) AS
SELECT estate_id, status, current_period_end
FROM public.fixflow_subscriptions;

GRANT SELECT ON public.v_fixflow_estate_contract TO authenticated;

-- 0016: Enroll onboarding emails also when lead is INSERT-ed as stage=won
-- (Stripe webhook + confirm-transfer insert won directly; previous trigger
-- was AFTER UPDATE OF stage only, so paid clients never got D0-D14 sequence.)

create or replace function crm_enroll_onboarding_sequence()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.stage = 'won' and (
    tg_op = 'INSERT' or (old.stage is distinct from 'won')
  ) then
    insert into public.crm_email_queue (lead_id, template_key, scheduled_at)
    values
      (new.id, 'onboarding_d0', now()),
      (new.id, 'onboarding_d1', now() + interval '1 day'),
      (new.id, 'onboarding_d2', now() + interval '2 days'),
      (new.id, 'onboarding_d3', now() + interval '3 days'),
      (new.id, 'onboarding_d7', now() + interval '7 days'),
      (new.id, 'onboarding_d14', now() + interval '14 days')
    on conflict (lead_id, template_key) do nothing;
  end if;

  if tg_op = 'UPDATE'
     and new.stage in ('churned', 'lost')
     and (old.stage is distinct from new.stage) then
    update public.crm_email_queue
    set status = 'cancelled'
    where lead_id = new.id and status = 'pending';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_crm_enroll_onboarding on crm_leads;

create trigger trg_crm_enroll_onboarding
  after insert or update of stage on crm_leads
  for each row
  execute function crm_enroll_onboarding_sequence();

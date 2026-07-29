-- Dodaje pola check-listy do crm_leads: płatność, umowa, onboarding
-- Gdy wszystkie 3 = true, system automatycznie progresuje stage i tworzy osiedle

alter table if exists crm_leads
  add column if not exists payment_received boolean default false,
  add column if not exists contract_signed boolean default false,
  add column if not exists onboarding_complete boolean default false;

comment on column crm_leads.payment_received is 'Czy płatność została otrzymana (ręcznie lub auto z webhooka)';
comment on column crm_leads.contract_signed is 'Czy umowa została podpisana (ręcznie lub auto z Autenti)';
comment on column crm_leads.onboarding_complete is 'Czy onboarding zakończony (wszystkie kroki wykonane)';

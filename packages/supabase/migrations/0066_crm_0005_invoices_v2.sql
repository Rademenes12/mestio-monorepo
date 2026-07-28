-- Faktury v2 (wzorzec HubSpot Commerce):
-- - due_date: termin platnosci (auto-status "Zalegla" po przekroczeniu)
-- - line_items: pozycje faktury (nazwa, ilosc, cena netto, VAT) jako jsonb

alter table crm_invoices add column if not exists due_date date;
alter table crm_invoices add column if not exists line_items jsonb default '[]'::jsonb;

comment on column crm_invoices.due_date is 'Termin platnosci - po przekroczeniu status issued -> overdue';
comment on column crm_invoices.line_items is 'Pozycje: [{name, qty, net, vat}] - vat w procentach (23)';

create index if not exists idx_crm_invoices_due_date on crm_invoices(due_date);

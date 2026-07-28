-- Uproszczenie pipeline: 11 → 8 etapów
-- contract → offer, onboarding → won, lost → churned

UPDATE crm_leads SET stage = 'offer' WHERE stage = 'contract';
UPDATE crm_leads SET stage = 'won' WHERE stage = 'onboarding';
UPDATE crm_leads SET stage = 'churned' WHERE stage = 'lost';

-- Dodaj komentarz
COMMENT ON COLUMN crm_leads.stage IS 'lead, contact, demo, offer, won, active, risk, churned';

-- ============================================================
-- MIGRACJA 0021: Fixy architektoniczne po audycie KPI + Team
-- PROBLEMY:
-- 1. kpi_cac references non-existent `expenses` table
-- 2. kpi_churn/kpi_mrr reference non-existent stage 'trial'
-- 3. crm_tasks missing `assigned_to` column (team page uses it)
-- 4. kpi_dashboard references `trial` stage
-- ============================================================

-- ----------------------------------------------------------
-- FIX 1: expenses table (for CAC calculation)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS expenses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category text NOT NULL DEFAULT 'other', -- marketing, ads, sales, infrastructure, other
    description text,
    amount numeric(10, 2) NOT NULL,
    incurred_at date DEFAULT CURRENT_DATE,
    created_at timestamptz DEFAULT now()
);

ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY expenses_owner ON expenses FOR ALL
    USING (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7')
    WITH CHECK (auth.uid() = '48ffc236-5d63-4af2-94f6-d10d2470e9c7');

COMMENT ON TABLE expenses IS 'Wydatki operacyjne — marketing, sprzedaż, infrastruktura. Używane do CAC.';

-- ----------------------------------------------------------
-- FIX 2: crm_tasks.assigned_to (for Team Dashboard)
-- ----------------------------------------------------------
ALTER TABLE crm_tasks
    ADD COLUMN IF NOT EXISTS assigned_to uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS progress integer DEFAULT 0 CHECK (progress >= 0 AND progress <= 100);

COMMENT ON COLUMN crm_tasks.assigned_to IS 'Kto wykonuje zadanie. NULL = nieprzypisane.';
COMMENT ON COLUMN crm_tasks.progress IS 'Postęp 0-100%.';

CREATE INDEX IF NOT EXISTS idx_crm_tasks_assigned_to ON crm_tasks(assigned_to);
CREATE INDEX IF NOT EXISTS idx_crm_tasks_due_date ON crm_tasks(due_date);

-- ----------------------------------------------------------
-- FIX 3: Naprawa widoków KPI — zastąp stage 'trial'
--        (Stage 'trial' nie istnieje — używamy 'demo' + 'offer')
-- ----------------------------------------------------------

-- KPI CHURN — fix: 'trial' → 'onboarding' + 'demo'
CREATE OR REPLACE VIEW kpi_churn AS
WITH monthly_churn AS (
    SELECT
        DATE_TRUNC('month', updated_at) as month,
        COUNT(CASE WHEN stage = 'churned' THEN 1 END) as churned,
        COUNT(CASE WHEN stage IN ('active', 'onboarding', 'demo', 'offer', 'contract') THEN 1 END) as active_start
    FROM crm_leads
    GROUP BY DATE_TRUNC('month', updated_at)
)
SELECT
    month,
    churned,
    active_start,
    CASE
        WHEN active_start > 0
        THEN ROUND((churned::DECIMAL / active_start) * 100, 2)
        ELSE 0
    END as churn_rate_percent
FROM monthly_churn
ORDER BY month DESC;

-- KPI MRR — fix: 'trial' → active pipeline stages
CREATE OR REPLACE VIEW kpi_mrr AS
WITH monthly_mrr AS (
    SELECT
        DATE_TRUNC('month', CURRENT_DATE) as month,
        SUM(mrr) as total_mrr,
        COUNT(*) as customer_count,
        SUM(CASE WHEN created_at >= DATE_TRUNC('month', CURRENT_DATE)
                 THEN mrr ELSE 0 END) as new_mrr,
        SUM(CASE WHEN stage = 'churned' AND updated_at >= DATE_TRUNC('month', CURRENT_DATE)
                 THEN mrr ELSE 0 END) as churned_mrr
    FROM crm_leads
    WHERE stage IN ('active', 'onboarding', 'won')
),
previous_month AS (
    SELECT SUM(mrr) as prev_mrr
    FROM crm_leads
    WHERE stage IN ('active', 'onboarding', 'won')
      AND created_at < DATE_TRUNC('month', CURRENT_DATE)
)
SELECT
    m.month,
    m.total_mrr,
    m.customer_count,
    m.new_mrr,
    m.churned_mrr,
    m.total_mrr - m.churned_mrr + m.new_mrr as net_mrr,
    p.prev_mrr,
    CASE
        WHEN p.prev_mrr > 0
        THEN ROUND(((m.total_mrr - p.prev_mrr) / p.prev_mrr) * 100, 2)
        ELSE NULL
    END as growth_rate_percent
FROM monthly_mrr m
CROSS JOIN previous_month p;

-- KPI DASHBOARD — fix 'trial' → 'active' + 'onboarding'
DROP VIEW IF EXISTS kpi_dashboard;
CREATE OR REPLACE VIEW kpi_dashboard AS
SELECT
    (SELECT cac FROM kpi_cac ORDER BY month DESC LIMIT 1) as current_cac,
    (SELECT avg_ltv FROM kpi_ltv) as avg_ltv,
    (SELECT churn_rate_percent FROM kpi_churn ORDER BY month DESC LIMIT 1) as current_churn,
    (SELECT total_mrr FROM kpi_mrr) as current_mrr,
    (SELECT growth_rate_percent FROM kpi_mrr) as mrr_growth,
    (SELECT avg_ltv FROM kpi_ltv) / NULLIF(
        (SELECT cac FROM kpi_cac ORDER BY month DESC LIMIT 1), 0
    ) as ltv_to_cac_ratio,
    (SELECT COUNT(*) FROM crm_leads WHERE stage = 'lead') as pending_leads,
    (SELECT COUNT(*) FROM crm_leads WHERE stage IN ('active', 'onboarding', 'won')) as active_customers,
    (SELECT COUNT(*) FROM crm_tasks WHERE done = false AND due_date < CURRENT_DATE) as overdue_tasks;

-- ----------------------------------------------------------
-- FIX 4: Team workload view
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW team_workload AS
SELECT
    u.id as user_id,
    u.email,
    COUNT(t.id) FILTER (WHERE NOT t.done) as open_tasks,
    COUNT(t.id) FILTER (WHERE t.done) as done_tasks,
    COUNT(t.id) FILTER (WHERE NOT t.done AND t.due_date < CURRENT_DATE) as overdue_tasks,
    COALESCE(AVG(t.progress) FILTER (WHERE NOT t.done), 0) as avg_progress
FROM auth.users u
LEFT JOIN crm_tasks t ON t.assigned_to = u.id
GROUP BY u.id, u.email;

-- ----------------------------------------------------------
-- FIX 5: Indeksy wydajnościowe
-- ----------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_crm_leads_stage_updated
    ON crm_leads(stage, updated_at)
    WHERE stage IN ('active', 'onboarding', 'won');

CREATE INDEX IF NOT EXISTS idx_crm_invoices_status_paid
    ON crm_invoices(status, created_at)
    WHERE status = 'paid';

CREATE INDEX IF NOT EXISTS idx_expenses_category
    ON expenses(category, incurred_at);

COMMENT ON INDEX idx_crm_leads_stage_updated IS 'Przyspiesza KPI views: churn, MRR, active_customers';
COMMENT ON INDEX idx_crm_invoices_status_paid IS 'Przyspiesza KPI LTV calculation';

-- KPI Dashboard dla Mestio CRM Owner
-- Dodaj te widoki do swojej bazy Supabase

-- 1. CAC (Customer Acquisition Cost)
CREATE OR REPLACE VIEW kpi_cac AS
WITH monthly_costs AS (
  SELECT 
    DATE_TRUNC('month', created_at) as month,
    SUM(CASE 
      WHEN category IN ('marketing', 'ads', 'sales') 
      THEN amount ELSE 0 
    END) as acquisition_costs
  FROM expenses
  GROUP BY DATE_TRUNC('month', created_at)
),
new_customers AS (
  SELECT 
    DATE_TRUNC('month', created_at) as month,
    COUNT(*) as new_count
  FROM crm_leads
  WHERE stage = 'won'
  GROUP BY DATE_TRUNC('month', created_at)
)
SELECT 
  mc.month,
  mc.acquisition_costs,
  nc.new_count,
  CASE 
    WHEN nc.new_count > 0 
    THEN ROUND(mc.acquisition_costs / nc.new_count, 2)
    ELSE NULL 
  END as cac
FROM monthly_costs mc
LEFT JOIN new_customers nc ON mc.month = nc.month
ORDER BY mc.month DESC;

-- 2. LTV (Lifetime Value)
CREATE OR REPLACE VIEW kpi_ltv AS
WITH customer_lifetime AS (
  SELECT 
    lead_id,
    MIN(created_at) as first_payment,
    MAX(created_at) as last_payment,
    COUNT(*) as payment_count,
    SUM(amount) as total_revenue,
    EXTRACT(MONTH FROM AGE(MAX(created_at), MIN(created_at))) as lifetime_months
  FROM crm_invoices
  WHERE status = 'paid'
  GROUP BY lead_id
)
SELECT 
  AVG(total_revenue) as avg_ltv,
  AVG(lifetime_months) as avg_lifetime_months,
  AVG(total_revenue / NULLIF(lifetime_months, 0)) as avg_monthly_value,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue) as median_ltv
FROM customer_lifetime
WHERE lifetime_months > 0;

-- 3. Churn Rate
CREATE OR REPLACE VIEW kpi_churn AS
WITH monthly_churn AS (
  SELECT 
    DATE_TRUNC('month', updated_at) as month,
    COUNT(CASE WHEN stage = 'churned' THEN 1 END) as churned,
    COUNT(CASE WHEN stage IN ('active', 'trial') THEN 1 END) as active_start
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

-- 4. MRR (Monthly Recurring Revenue) & Growth
CREATE OR REPLACE VIEW kpi_mrr AS
WITH monthly_mrr AS (
  SELECT 
    DATE_TRUNC('month', CURRENT_DATE) as month,
    SUM(mrr) as total_mrr,
    COUNT(*) as customer_count,
    SUM(CASE WHEN created_at >= DATE_TRUNC('month', CURRENT_DATE) THEN mrr ELSE 0 END) as new_mrr,
    SUM(CASE WHEN stage = 'churned' AND updated_at >= DATE_TRUNC('month', CURRENT_DATE) THEN mrr ELSE 0 END) as churned_mrr
  FROM crm_leads
  WHERE stage IN ('active', 'trial')
),
previous_month AS (
  SELECT 
    SUM(mrr) as prev_mrr
  FROM crm_leads
  WHERE stage IN ('active', 'trial')
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

-- 5. Główny widok KPI Dashboard
do $$ begin
CREATE OR REPLACE VIEW kpi_dashboard AS
SELECT 
  (SELECT cac FROM kpi_cac ORDER BY month DESC LIMIT 1) as current_cac,
  (SELECT avg_ltv FROM kpi_ltv) as avg_ltv,
  (SELECT churn_rate_percent FROM kpi_churn ORDER BY month DESC LIMIT 1) as current_churn,
  (SELECT total_mrr FROM kpi_mrr) as current_mrr,
  (SELECT growth_rate_percent FROM kpi_mrr) as mrr_growth,
  -- Dodatkowe metryki
  (SELECT avg_ltv FROM kpi_ltv) / NULLIF((SELECT cac FROM kpi_cac ORDER BY month DESC LIMIT 1), 0) as ltv_to_cac_ratio,
  (SELECT COUNT(*) FROM crm_leads WHERE stage = 'lead') as pending_leads,
  (SELECT COUNT(*) FROM crm_leads WHERE stage IN ('active', 'trial')) as active_customers,
  (SELECT COUNT(*) FROM crm_tasks WHERE done = false AND due_date < CURRENT_DATE) as overdue_tasks;
exception when others then null;
end $$;
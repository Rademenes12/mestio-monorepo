-- Aktualizacja widoków KPI po uproszczeniu pipeline (11→8 etapów)
-- Wklej w: https://supabase.com/dashboard/project/rtyywhbisjaxlpjcugdk/sql/new

CREATE OR REPLACE VIEW kpi_churn AS
WITH monthly_churn AS (
  SELECT DATE_TRUNC('month', updated_at) as mon,
    COUNT(CASE WHEN stage = 'churned' THEN 1 END) as churned,
    COUNT(CASE WHEN stage IN ('active','won','demo','offer') THEN 1 END) as active_start
  FROM crm_leads GROUP BY mon
)
SELECT mon, churned, active_start,
  CASE WHEN active_start > 0 THEN ROUND((churned::DECIMAL / active_start) * 100, 2) ELSE 0 END as churn_rate_percent
FROM monthly_churn ORDER BY mon DESC;

CREATE OR REPLACE VIEW kpi_mrr AS
WITH monthly_mrr AS (
  SELECT DATE_TRUNC('month', CURRENT_DATE) as mon, SUM(mrr) as total_mrr, COUNT(*) as customer_count,
    SUM(CASE WHEN created_at >= DATE_TRUNC('month', CURRENT_DATE) THEN mrr ELSE 0 END) as new_mrr,
    SUM(CASE WHEN stage = 'churned' AND updated_at >= DATE_TRUNC('month', CURRENT_DATE) THEN mrr ELSE 0 END) as churned_mrr
  FROM crm_leads WHERE stage IN ('active','won')
),
previous_month AS (
  SELECT SUM(mrr) as prev_mrr FROM crm_leads
  WHERE stage IN ('active','won') AND created_at < DATE_TRUNC('month', CURRENT_DATE)
)
SELECT m.mon, m.total_mrr, m.customer_count, m.new_mrr, m.churned_mrr,
  m.total_mrr - m.churned_mrr + m.new_mrr as net_mrr, p.prev_mrr,
  CASE WHEN p.prev_mrr > 0 THEN ROUND(((m.total_mrr - p.prev_mrr) / p.prev_mrr) * 100, 2) ELSE NULL END as growth_rate_percent
FROM monthly_mrr m CROSS JOIN previous_month p;

CREATE OR REPLACE VIEW kpi_dashboard AS
SELECT
  (SELECT cac FROM kpi_cac ORDER BY mon DESC LIMIT 1) as current_cac,
  (SELECT avg_ltv FROM kpi_ltv) as avg_ltv,
  (SELECT churn_rate_percent FROM kpi_churn ORDER BY mon DESC LIMIT 1) as current_churn,
  (SELECT total_mrr FROM kpi_mrr) as current_mrr,
  (SELECT growth_rate_percent FROM kpi_mrr) as mrr_growth,
  (SELECT avg_ltv FROM kpi_ltv) / NULLIF((SELECT cac FROM kpi_cac ORDER BY mon DESC LIMIT 1), 0) as ltv_to_cac_ratio,
  (SELECT COUNT(*) FROM crm_leads WHERE stage = 'lead') as pending_leads,
  (SELECT COUNT(*) FROM crm_leads WHERE stage IN ('active','won')) as active_customers,
  (SELECT COUNT(*) FROM crm_tasks WHERE done = false AND due_date < CURRENT_DATE) as overdue_tasks;

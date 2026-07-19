-- ============================================================
-- COHORT RETENTION ANALYSIS - Olist E-commerce
-- Objective: Measure customer retention month over month
-- ============================================================

WITH 
-- 1. First purchase date per customer (Cohort)
first_orders AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp::timestamp) AS first_purchase,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp::timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

-- 2. Monthly activity per customer (all their purchases)
cohort_activity AS (
    SELECT 
        f.cohort_month,
        f.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS activity_month,
        EXTRACT(MONTH FROM AGE(o.order_purchase_timestamp::timestamp, f.first_purchase)) AS month_offset
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN first_orders f ON c.customer_unique_id = f.customer_unique_id
    WHERE o.order_status = 'delivered'
)

-- 3. Calculate retention rate (%)
SELECT 
    cohort_month,
    month_offset,
    COUNT(DISTINCT customer_unique_id) AS active_customers,
    FIRST_VALUE(COUNT(DISTINCT customer_unique_id)) OVER (PARTITION BY cohort_month ORDER BY month_offset) AS cohort_size,
    ROUND(
        100.0 * COUNT(DISTINCT customer_unique_id) / 
        FIRST_VALUE(COUNT(DISTINCT customer_unique_id)) OVER (PARTITION BY cohort_month ORDER BY month_offset),
        2
    ) AS retention_rate_percent
FROM cohort_activity
GROUP BY cohort_month, month_offset
ORDER BY cohort_month, month_offset;
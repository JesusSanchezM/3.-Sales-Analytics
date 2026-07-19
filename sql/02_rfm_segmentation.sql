

-- ============================================================
-- RFM SEGMENTATION - Olist E-commerce
-- ============================================================

WITH 
-- 1. Calcular métricas RFM por cliente
customer_metrics AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp::timestamp) AS last_purchase,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value) AS monetary
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

-- 2. Fecha de referencia (última compra en todo el dataset)
reference_date AS (
    SELECT MAX(order_purchase_timestamp::timestamp) AS max_date FROM orders
),

-- 3. Calcular días desde última compra
rfm_scores AS (
    SELECT 
        customer_unique_id,
        EXTRACT(DAY FROM (SELECT max_date FROM reference_date) - last_purchase) AS recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY EXTRACT(DAY FROM (SELECT max_date FROM reference_date) - last_purchase) ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM customer_metrics
)

-- 4. Segmentación
SELECT 
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS total_score,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN '🏆 Champions (VIP)'
        WHEN monetary_score >= 4 AND recency_score >= 3 THEN '💰 Big Spenders'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN '⚠️ At Risk / Hibernating'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN '🆕 New Loyal'
        ELSE '📦 Core Customers'
    END AS customer_segment
FROM rfm_scores
ORDER BY total_score DESC, monetary DESC;




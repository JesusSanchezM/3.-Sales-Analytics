-- ============================================================
-- KPI DASHBOARD - Olist E-commerce
-- Objetivo: Resumen ejecutivo de métricas clave para dashboard
-- ============================================================

WITH
-- 1. Métricas generales de pedidos
order_metrics AS (
    SELECT
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT c.customer_unique_id) AS total_customers,
        COUNT(DISTINCT oi.product_id) AS total_products_sold,
        MIN(o.order_purchase_timestamp::timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp::timestamp) AS last_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
),

-- 2. Métricas financieras
financial_metrics AS (
    SELECT
        SUM(oi.price + oi.freight_value) AS total_revenue,
        ROUND(AVG(oi.price + oi.freight_value)::numeric, 2) AS avg_ticket,
        ROUND(AVG(oi.price)::numeric, 2) AS avg_product_price,
        SUM(oi.freight_value) AS total_freight,
        ROUND(AVG(oi.freight_value)::numeric, 2) AS avg_freight
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
),

-- 3. Métricas de clientes (frecuencia y antigüedad)
customer_metrics AS (
    SELECT
        ROUND(AVG(customer_freq)::numeric, 2) AS avg_orders_per_customer,
        ROUND(AVG(customer_monetary)::numeric, 2) AS avg_revenue_per_customer
    FROM (
        SELECT
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS customer_freq,
            SUM(oi.price + oi.freight_value) AS customer_monetary
        FROM orders o
        JOIN customers c ON o.customer_id = c.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.order_status = 'delivered'
        GROUP BY c.customer_unique_id
    ) AS customer_stats
),

-- 4. Métricas de temporalidad (últimos 30 días vs total)
recent_metrics AS (
    SELECT
        COUNT(DISTINCT CASE 
            WHEN o.order_purchase_timestamp::timestamp >= CURRENT_DATE - INTERVAL '30 days' 
            THEN o.order_id 
        END) AS orders_last_30d,
        SUM(CASE 
            WHEN o.order_purchase_timestamp::timestamp >= CURRENT_DATE - INTERVAL '30 days' 
            THEN oi.price + oi.freight_value 
            ELSE 0 
        END) AS revenue_last_30d
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
)

-- 5. Unificar todo en una sola fila
SELECT
    om.total_orders,
    om.total_customers,
    om.total_products_sold,
    om.first_order_date,
    om.last_order_date,
    fm.total_revenue,
    fm.avg_ticket,
    fm.avg_product_price,
    fm.total_freight,
    fm.avg_freight,
    cm.avg_orders_per_customer,
    cm.avg_revenue_per_customer,
    rm.orders_last_30d,
    rm.revenue_last_30d,
    -- KPIs derivados
    ROUND((fm.total_revenue / NULLIF(om.total_customers, 0))::numeric, 2) AS revenue_per_customer,
    ROUND((fm.total_revenue / NULLIF(om.total_orders, 0))::numeric, 2) AS revenue_per_order,
    ROUND((rm.revenue_last_30d / NULLIF(rm.orders_last_30d, 0))::numeric, 2) AS avg_ticket_last_30d
FROM order_metrics om
CROSS JOIN financial_metrics fm
CROSS JOIN customer_metrics cm
CROSS JOIN recent_metrics rm;
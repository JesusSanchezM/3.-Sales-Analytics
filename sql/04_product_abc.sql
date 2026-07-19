-- ============================================================
-- ABC PRODUCT CLASSIFICATION - Olist E-commerce
-- Objetivo: Identificar productos críticos por ingreso generado
-- ============================================================

WITH 
-- 1. Ingreso total por categoría de producto
product_revenue AS (
    SELECT 
        p.product_category_name,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
),

-- 2. Calcular ingreso acumulado y porcentaje de contribución
abc_calc AS (
    SELECT 
        product_category_name,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS total_overall,
        -- Convertir a numeric antes de redondear
        ROUND(
            (100.0 * SUM(total_revenue) OVER (ORDER BY total_revenue DESC) / 
            SUM(total_revenue) OVER ())::numeric,
            2
        ) AS cumulative_percent
    FROM product_revenue
)

-- 3. Asignar clase ABC
SELECT 
    product_category_name,
    total_revenue,
    cumulative_percent,
    CASE 
        WHEN cumulative_percent <= 80 THEN 'A (Alto impacto)'
        WHEN cumulative_percent <= 95 THEN 'B (Impacto medio)'
        ELSE 'C (Bajo impacto)'
    END AS abc_class
FROM abc_calc
ORDER BY cumulative_percent ASC;
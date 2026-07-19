-- ============================================================
-- EXPLORATORY DATA ANALYSIS (EDA) - Olist E-commerce
-- Objective: Understand data volume, quality, and key business metrics
-- ============================================================

-- 1. TABLE ROW COUNTS (Data Volume)
SELECT 'customers' AS table_name, COUNT(*) AS record_count FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
ORDER BY record_count DESC;


-- 2. DATA QUALITY: NULL CHECK IN CRITICAL TABLES
SELECT 
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_null_order_id,
    COUNT(customer_id) AS non_null_customer_id,
    COUNT(order_status) AS non_null_status,
    COUNT(order_purchase_timestamp) AS non_null_purchase_date
FROM orders

UNION ALL

SELECT 
    'customers',
    COUNT(*),
    COUNT(customer_id),
    COUNT(customer_unique_id),
    COUNT(customer_city),
    COUNT(customer_state)
FROM customers

UNION ALL

SELECT 
    'products',
    COUNT(*),
    COUNT(product_id),
    COUNT(product_category_name),
    COUNT(product_weight_g),
    COUNT(product_length_cm)
FROM products;


-- 3. ORDERS STATUS DISTRIBUTION (Operational Health)
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 4. TEMPORAL RANGE (Full Period Coverage)
SELECT 
    MIN(order_purchase_timestamp::timestamp) AS first_order_date,
    MAX(order_purchase_timestamp::timestamp) AS last_order_date,
    MAX(order_purchase_timestamp::timestamp) - MIN(order_purchase_timestamp::timestamp) AS time_span
FROM orders;


-- 5. MONTHLY ORDER VOLUME & REVENUE TREND (Seasonality)
SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    AVG(oi.price + oi.freight_value) AS avg_ticket
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;


-- 6. CUSTOMER PURCHASE FREQUENCY (Engagement)
WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    order_count,
    COUNT(customer_unique_id) AS num_customers,
    ROUND(100.0 * COUNT(customer_unique_id) / (SELECT COUNT(*) FROM customer_order_counts), 2) AS percentage
FROM customer_order_counts
GROUP BY order_count
ORDER BY order_count;


-- 7. PAYMENT METHOD PREFERENCE (Financial Analysis)
SELECT 
    payment_type,
    COUNT(DISTINCT order_id) AS total_transactions,
    SUM(payment_value) AS total_revenue,
    AVG(payment_value) AS avg_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


-- 8. PAYMENT INSTALLMENT BEHAVIOR (Credit Risk / Customer Trust)
SELECT 
    payment_installments,
    COUNT(DISTINCT order_id) AS num_orders,
    AVG(payment_value) AS avg_value,
    SUM(payment_value) AS total_value
FROM order_payments
WHERE payment_installments > 0
GROUP BY payment_installments
ORDER BY payment_installments
LIMIT 15;


-- 9. PRODUCT CATEGORY PRICING & REVIEW ANALYSIS (Top Categories)
SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    AVG(oi.price) AS avg_price,
    AVG(r.review_score) AS avg_review_score,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT oi.product_id) > 10
ORDER BY total_revenue DESC
LIMIT 15;


-- 10. TOP SELLING CITIES (Geographic Concentration)
SELECT 
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city, c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;
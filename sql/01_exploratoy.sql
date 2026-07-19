-- 1. Ver el tamaño de las tablas
SELECT 
    'customers' AS tabla, COUNT(*) AS registros FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products;

-- 2. Ver las primeras órdenes
SELECT 
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM orders
LIMIT 10;



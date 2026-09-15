SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'categories', COUNT(*) FROM categories;

SELECT * FROM order_details

SELECT MIN(order_date), MAX(order_date) FROM orders;


SELECT * FROM orders
WHERE shipped_date IS NULL

SELECT 
    order_id,
    order_date,
    shipped_date,
    required_date,
    ship_via,
    freight
FROM orders
WHERE shipped_date IS NULL;
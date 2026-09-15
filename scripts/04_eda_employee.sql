SELECT
  o.employee_id,
  e.first_name,
  e.last_name,
  COUNT(DISTINCT o.order_id) AS orders_processed,
  ROUND(SUM(unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue_generated
FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
JOIN order_details AS od
ON o.order_id = od.order_id
WHERE shipped_date IS NOT NULL
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY orders_processed DESC


SELECT
  o.employee_id,
  e.first_name,
  e.last_name,
  COUNT(DISTINCT o.order_id) AS orders_processed
FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
WHERE shipped_date IS NOT NULL
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY orders_processed DESC
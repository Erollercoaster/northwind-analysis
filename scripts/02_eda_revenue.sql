SELECT * FROM orders

SELECT * FROM order_details

-- order details for quantity and unit price

SELECT
  EXTRACT(YEAR FROM o.order_date) AS year,
  ROUND(SUM(unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM orders AS o
JOIN order_details AS od
ON o.order_id = od.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY year
ORDER BY year


SELECT
  EXTRACT(YEAR FROM o.order_date) AS year,
  EXTRACT(MONTH FROM o.order_date) AS month,
  ROUND(SUM(unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM orders AS o
JOIN order_details AS od
ON o.order_id = od.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY year, month
ORDER BY year, month

SELECT
  p.category_id,
  c.category_name,
  ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM products AS p
JOIN order_details AS od
ON p.product_id = od.product_id
JOIN categories AS c
ON p.category_id = c.category_id
GROUP BY p.category_id, c.category_name
ORDER BY p.category_id

SELECT *
FROM categories
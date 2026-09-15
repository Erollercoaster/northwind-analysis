SELECT *
FROM orders

SELECT
  c.customer_id,
  c.country,
  ROUND(SUM(unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
JOIN order_details AS od
ON o.order_id = od.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY c.customer_id
ORDER BY total_revenue DESC

SELECT
  c.country,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE o.shipped_date IS NOT NULL
GROUP BY c.country
ORDER BY total_orders DESC

-- churn risk : customers who have not ordered in 90 - 180 days

WITH dataset_end AS (
  SELECT
    MAX(order_date) AS last_date
  FROM orders
),
last_orders AS (
  SELECT
    customer_id,
    MAX(order_date) AS last_order_date
  FROM orders
  GROUP BY customer_id
)
SELECT
  lo.customer_id,
  lo.last_order_date,
  de.last_date - lo.last_order_date AS days_since_last_order,
  CASE
    WHEN de.last_date - lo.last_order_date > 90 THEN 'Churn Risk'
    ELSE 'Active'
  END AS customer_status
FROM last_orders AS lo
CROSS JOIN dataset_end AS de
ORDER BY days_since_last_order DESC

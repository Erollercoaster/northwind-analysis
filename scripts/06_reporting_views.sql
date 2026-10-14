-- Revenue over time
CREATE VIEW view_revenue_by_year_month AS 
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

-- Category performance  
CREATE VIEW view_revenue_by_category AS
SELECT
    p.category_id,
    c.category_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM order_details AS od
JOIN orders AS o ON od.order_id = o.order_id
JOIN products AS p ON od.product_id = p.product_id
JOIN categories AS c ON p.category_id = c.category_id
WHERE o.shipped_date IS NOT NULL
GROUP BY p.category_id, c.category_name
ORDER BY total_revenue DESC;

-- Customer rankings
CREATE VIEW view_top_customers AS 
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

-- Churn risk
CREATE VIEW view_churn_risk AS 
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

-- Employee performance
CREATE VIEW view_employee_performance AS 
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


-- Shipping performance
CREATE VIEW view_shipping_performance AS 
WITH shipping_stats AS (
    SELECT
        o.ship_via,
        s.company_name AS shipper_name,
        shipped_date - required_date AS day_difference,
        CASE
            WHEN shipped_date > required_date THEN 'Late'
            ELSE 'On Time'
        END AS order_status
    FROM orders AS o
    JOIN shippers AS s ON o.ship_via = s.shipper_id
    WHERE shipped_date IS NOT NULL
)
SELECT
    ship_via,
    shipper_name,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE order_status = 'Late') AS late_shipments,
    COUNT(*) FILTER (WHERE order_status = 'On Time') AS on_time_shipments,
    ROUND(AVG(day_difference)::numeric, 1) AS avg_days_difference
FROM shipping_stats
GROUP BY ship_via, shipper_name
ORDER BY ship_via


-- Discount analysis
CREATE VIEW view_discount_analysis AS
SELECT
    od.discount,
    ROUND(AVG(od.quantity)::numeric, 2) AS avg_quantity_ordered,
    COUNT(*) AS total_line_items
FROM order_details AS od
JOIN orders AS o ON od.order_id = o.order_id
WHERE o.shipped_date IS NOT NULL
GROUP BY od.discount
ORDER BY od.discount;
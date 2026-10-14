-- Dealing with shipping dates - more on seeing differences between days


-- Which shipper is used most frequently and are there differences in shipping time?
SELECT
  ship_via,
  COUNT(DISTINCT order_id)
FROM orders
GROUP BY ship_via

SELECT
  ship_via,
  required_date,
  shipped_date,
  shipped_date - required_date AS day_difference,
   CASE
    WHEN shipped_date > required_date THEN 'Late'
    ELSE 'On Time'
  END AS order_status
FROM orders
WHERE shipped_date IS NOT NULL
ORDER BY ship_via

WITH shipping_stats AS (
    SELECT
    ship_via,
    required_date,
    shipped_date,
    shipped_date - required_date AS day_difference,
    CASE
      WHEN shipped_date > required_date THEN 'Late'
      ELSE 'On Time'
    END AS order_status
  FROM orders
  WHERE shipped_date IS NOT NULL
  ORDER BY ship_via
)

SELECT
    ship_via,
    COUNT(*) AS total_shipments,
    COUNT(*) FILTER (WHERE order_status = 'Late') AS late_shipments,
    COUNT(*) FILTER (WHERE order_status = 'On Time') AS on_time_shipments,
    ROUND(AVG(day_difference)::numeric, 1) AS avg_days_difference
FROM shipping_stats
GROUP BY ship_via
ORDER BY ship_via

-- How many orders are shipped after the required date (late shipments)?
-- What is the average time between order date and ship date by shipper?
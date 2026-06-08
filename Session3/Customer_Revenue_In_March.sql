SELECT
    cust_id,
    SUM(total_order_cost) AS revenue
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2019
  AND EXTRACT(MONTH FROM order_date) = 3
GROUP BY cust_id
ORDER BY revenue DESC;
select * from product_sales;
WITH purchases AS (
    SELECT
        transaction_id,
        transaction_date,
        amount
    FROM product_sales
    WHERE product_id = 'PROD-2891'
      AND country = 'US'
      AND type = 'purchase'
      AND status = 'completed'
      AND transaction_date BETWEEN '2025-04-15' AND '2025-04-28'
),

daily_activity AS (
    -- purchases add revenue
    SELECT
        transaction_date,
        amount
    FROM purchases

    UNION ALL

    -- refunds subtract revenue
    SELECT
        r.transaction_date,
        -r.amount
    FROM product_sales r
    JOIN purchases p
      ON r.original_transaction_id = p.transaction_id
    WHERE r.type = 'refund'
      AND r.status = 'completed'
)

SELECT
    d.transaction_date,
    COALESCE(SUM(a.amount), 0) AS daily_net_revenue
FROM (
    SELECT generate_series(
        DATE '2025-04-15',
        DATE '2025-04-28',
        INTERVAL '1 day'
    )::date AS transaction_date
) d
LEFT JOIN daily_activity a
    ON d.transaction_date = a.transaction_date
GROUP BY d.transaction_date
ORDER BY d.transaction_date;
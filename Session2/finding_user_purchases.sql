select * from amazon_transactions;
WITH first_purchase AS (
    SELECT
        user_id,
        MIN(created_at) AS first_purchase_date
    FROM amazon_transactions
    GROUP BY user_id
)

SELECT DISTINCT f.user_id
FROM first_purchase f
JOIN amazon_transactions a
    ON a.user_id = f.user_id
   AND a.created_at BETWEEN f.first_purchase_date + 1
                        AND f.first_purchase_date + 7
ORDER BY f.user_id;
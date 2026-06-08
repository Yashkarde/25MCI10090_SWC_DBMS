WITH trends AS (
    SELECT
        product_id,
        product_name,
        month_start,
        monthly_active_users,
        LAG(monthly_active_users,1) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS p1,
        LAG(monthly_active_users,2) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS p2,
        LAG(monthly_active_users,3) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS p3,
        LAG(monthly_active_users,4) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS p4,
        LAG(monthly_active_users,5) OVER (
            PARTITION BY product_id
            ORDER BY month_start
        ) AS p5
    FROM product_engagement
),

turnaround AS (
    SELECT
        product_id,
        product_name,
        month_start AS growth_resumed_month,
        month_start - INTERVAL '3 month' AS decline_started_month,
        p3 AS lowest_users,
        monthly_active_users AS peak_users
    FROM trends
    WHERE
        p5 > p4
        AND p4 > p3
        AND p2 > p3
        AND p1 > p2
        AND monthly_active_users > p1
)

SELECT
    product_name,
    decline_started_month,
    growth_resumed_month,
    ROUND(
        (peak_users - lowest_users)::numeric
        / lowest_users,
        2
    ) AS growth_ratio
FROM turnaround
ORDER BY product_name;
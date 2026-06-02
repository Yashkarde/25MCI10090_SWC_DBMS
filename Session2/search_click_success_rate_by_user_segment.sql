select * from search_events;
WITH max_date AS (
    SELECT MAX(event_timestamp::date) AS max_dt
    FROM search_events
),

user_segments AS (
    SELECT
        a.user_id,
        CASE
            WHEN a.registration_date >= m.max_dt - INTERVAL '30 days'
                THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM accounts a
    CROSS JOIN max_date m
),

searches AS (
    SELECT
        event_id,
        user_id,
        session_id,
        event_timestamp AS search_time
    FROM search_events
    WHERE event_type = 'search'
),

first_clicks AS (
    SELECT
        s.event_id,
        MIN(c.event_timestamp) AS first_click_time
    FROM searches s
    LEFT JOIN search_events c
        ON c.user_id = s.user_id
       AND c.session_id = s.session_id
       AND c.event_type = 'click'
       AND c.event_timestamp > s.search_time
    GROUP BY s.event_id
)

SELECT
    us.user_segment,
    COUNT(*) AS total_searches,
    SUM(
        CASE
            WHEN fc.first_click_time IS NOT NULL
             AND fc.first_click_time <= s.search_time + INTERVAL '30 seconds'
            THEN 1
            ELSE 0
        END
    ) AS successful_searches,
    ROUND(
        AVG(
            CASE
                WHEN fc.first_click_time IS NOT NULL
                 AND fc.first_click_time <= s.search_time + INTERVAL '30 seconds'
                THEN 1.0
                ELSE 0.0
            END
        ),
        2
    ) AS success_rate
FROM searches s
JOIN user_segments us
    ON s.user_id = us.user_id
LEFT JOIN first_clicks fc
    ON s.event_id = fc.event_id
GROUP BY us.user_segment
ORDER BY us.user_segment;
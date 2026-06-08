SELECT
    7 AS month,
    COUNT(DISTINCT july.user_id) AS monthly_active_users
FROM user_actions july
JOIN user_actions june
    ON july.user_id = june.user_id
WHERE EXTRACT(YEAR FROM july.event_date) = 2022
  AND EXTRACT(MONTH FROM july.event_date) = 7
  AND EXTRACT(YEAR FROM june.event_date) = 2022
  AND EXTRACT(MONTH FROM june.event_date) = 6;
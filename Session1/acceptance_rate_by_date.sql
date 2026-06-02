SELECT
    s.date,
    ROUND(
        COUNT(DISTINCT (a.user_id_sender, a.user_id_receiver))::numeric
        / COUNT(DISTINCT (s.user_id_sender, s.user_id_receiver)),
        2
    ) AS acceptance_rate
FROM fb_friend_requests s
LEFT JOIN fb_friend_requests a
    ON s.user_id_sender = a.user_id_sender
   AND s.user_id_receiver = a.user_id_receiver
   AND a.action = 'accepted'
WHERE s.action = 'sent'
GROUP BY s.date
HAVING COUNT(DISTINCT (a.user_id_sender, a.user_id_receiver)) > 0
ORDER BY s.date;
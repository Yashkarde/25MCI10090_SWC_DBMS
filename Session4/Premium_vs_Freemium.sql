SELECT
    date,
    SUM(downloads) FILTER (WHERE paying_customer = 'no')
        AS non_paying_downloads,
    SUM(downloads) FILTER (WHERE paying_customer = 'yes')
        AS paying_downloads
FROM ms_download_facts d
JOIN ms_user_dimension u
    ON d.user_id = u.user_id
JOIN ms_acc_dimension a
    ON u.acc_id = a.acc_id
GROUP BY date
HAVING SUM(downloads) FILTER (WHERE paying_customer = 'no')
     >
       SUM(downloads) FILTER (WHERE paying_customer = 'yes')
ORDER BY date;
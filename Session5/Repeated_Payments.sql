
select count(*) as payment_count
from 
transactions t1,
transactions t2
WHERE
t1.transaction_id < t2.transaction_id and
t1.merchant_id=t2.merchant_id AND
t1.credit_card_id=t2.credit_card_id and
t1.amount=t2.amount AND
EXTRACT
(EPOCH FROM t2.transaction_timestamp - t1.transaction_timestamp)/60<=10;
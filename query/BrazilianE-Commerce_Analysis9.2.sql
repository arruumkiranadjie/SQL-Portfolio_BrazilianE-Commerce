WITH order_installments AS (
	SELECT	order_id,
			MAX(payment_installments) AS installments
    FROM olist_order_payments_dataset
    GROUP BY order_id
)

SELECT	CASE WHEN oi.installments > 1 THEN 'installment' ELSE 'single_payment' END AS payment_type,
		COUNT(*) AS total_orders,
        ROUND(AVG(r.review_score), 2) AS avg_review_score,
        ROUND(100.0 * SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS pct_low_reviews
FROM olist_orders_dataset o
JOIN order_installments oi
	ON o.order_id = oi.order_id
JOIN olist_order_reviews_dataset r 
	ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY payment_type
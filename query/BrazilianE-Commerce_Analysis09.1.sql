WITH order_installments AS (
	SELECT	order_id,
			MAX(payment_installments) AS installments
    FROM olist_order_payments_dataset
    GROUP BY order_id
),

order_outcomes AS (
	SELECT	o.order_id,
			oi.installments,
			CASE WHEN oi.installments > 1 THEN 'installment' ELSE 'single_payment' END AS payment_type
    FROM olist_orders_dataset o
    JOIN order_installments oi
		ON o.order_id = oi.order_id
	WHERE o.order_status = 'delivered'
)

SELECT 	payment_type,
		COUNT(*) AS total_orders,
        ROUND(AVG(installments), 2) AS avg_installments
FROM order_outcomes
GROUP BY payment_type

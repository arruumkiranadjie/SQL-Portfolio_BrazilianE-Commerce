WITH order_payment_profile AS ( 
		SELECT	p.order_id,
				COUNT(*) AS payment_attempts,
                SUM(p.payment_value) AS total_payment_value,
                MAX(p.payment_installments) AS max_installments,
                COUNT(DISTINCT p.payment_type) AS payment_type_count
        FROM olist_order_payments_dataset p
        GROUP BY p.order_id
),

order_value AS (
	SELECT	order_id,
			SUM(price + freight_value) AS order_value
    FROM olist_order_items_dataset
    GROUP BY order_id
)

SELECT	o.order_id,
		opp.payment_attempts,
        opp.total_payment_value,
        ROUND(ov.order_value, 2) AS order_value,
        opp.max_installments,
        opp.payment_type_count,
        ROUND(opp.total_payment_value/ NULLIF(ov.order_value, 0), 2) AS payment_to_order_ratio
FROM olist_orders_dataset o
JOIN order_payment_profile opp
	ON o.order_id = opp.order_id
JOIN order_value ov
	ON o.order_id = ov.order_id
WHERE o.order_status = 'delivered'
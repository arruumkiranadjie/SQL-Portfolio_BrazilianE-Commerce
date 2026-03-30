WITH payment_features AS (
	SELECT	o.order_id,
			COUNT(*) AS payment_attempts,
            SUM(p.payment_value) AS total_payment_value,
            MAX(p.payment_installments) AS max_installments,
            COUNT(DISTINCT p.payment_type) AS payment_type_count
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p
		ON o.order_id = p.order_id
	WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
),

order_value AS (
	SELECT	order_id,
			SUM(price + freight_value) AS order_value
    FROM olist_order_items_dataset 
    GROUP BY order_id
)

SELECT	pf.order_id,
		pf.payment_attempts,
		pf.max_installments,
		pf.payment_type_count,
        pf.total_payment_value,
        ROUND(ov.order_value, 2) AS order_value,
        ROUND(pf.total_payment_value/ NULLIF(ov.order_value, 0), 2) AS payment_to_order_ratio,
        CASE
			WHEN pf.payment_attempts >= 3 THEN 'Multiple Payments'
            WHEN pf.max_installments >= 10 THEN 'High Installments'
            WHEN pf.payment_type_count > 1 THEN 'Mixed Payment Types'
            WHEN pf.total_payment_value > ov.order_value * 1.2 THEN 'Overpayment'
            ELSE 'Normal'
		END AS anomaly_flag
FROM payment_features pf
JOIN order_value ov
	ON pf.order_id = ov.order_id
WHERE	pf.payment_attempts >= 3
	OR	pf.max_installments >= 10 
    OR 	pf.payment_type_count > 1 
    OR 	pf.total_payment_value > ov.order_value * 1.2
ORDER BY anomaly_flag
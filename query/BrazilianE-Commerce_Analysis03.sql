WITH order_funnel AS (
	SELECT	order_id,
			CASE WHEN order_status IN ('approved','processing','shipped','delivered') THEN 1 ELSE 0 END AS payment_approved,
            CASE WHEN order_status IN ('shipped','delivered') THEN 1 ELSE 0 END AS shipped,
            CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END AS delivered
    FROM olist_orders_dataset
)

SELECT	COUNT(*) AS total_orders,
		SUM(payment_approved) AS payment_approved_orders,
        SUM(shipped) AS shipped_orders,
        SUM(delivered) AS delivered_orders,
        ROUND(100.0 * SUM(payment_approved)/COUNT(*), 2) AS pct_order_to_payment,
        ROUND(100.0 * SUM(shipped)/SUM(payment_approved), 2) AS pct_payment_to_shipped,
        ROUND(100.0 * SUM(delivered)/SUM(shipped), 2) AS pct_shipped_to_delivered
FROM order_funnel
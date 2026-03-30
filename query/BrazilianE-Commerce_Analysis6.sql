WITH seller_sla AS (
	SELECT	oi.seller_id,
			o.order_id,
            CASE WHEN o.order_delivered_carrier_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END AS sla_compliant
    FROM olist_order_items_dataset oi
    JOIN olist_orders_dataset o
		ON oi.order_id = o.order_id
	WHERE o.order_status = 'delivered'
),

seller_sla_summary AS (
	SELECT	seller_id,
			COUNT(DISTINCT order_id) AS total_orders,
            SUM(sla_compliant) AS sla_compliant_orders
    FROM seller_sla
    GROUP BY seller_id
)

SELECT	seller_id,
		total_orders,
        sla_compliant_orders,
        ROUND(100.0 * sla_compliant_orders/total_orders, 2) AS sla_compliance_rate
FROM seller_sla_summary
WHERE total_orders >= 20
ORDER BY sla_compliance_rate ASC
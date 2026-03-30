WITH ranked_orders AS (
	SELECT	c.customer_unique_id,
			o.order_purchase_timestamp,
            ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_ranked
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
		ON o.customer_id = c.customer_id
	WHERE o.order_status = 'delivered'
),

first_second_purchase AS (
	SELECT	customer_unique_id,
			MAX(CASE WHEN order_ranked = 1 THEN order_purchase_timestamp END) AS first_purchase_date,
            MAX(CASE WHEN order_ranked = 2 THEN order_purchase_timestamp END) AS second_purchase_date
    FROM ranked_orders
    GROUP BY customer_unique_id
)

SELECT	COUNT(*) AS total_customers,
		SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 30 THEN 1 ELSE 0 END) AS repeat_within_30_days,
        ROUND(100.0 * SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 30 THEN 1 ELSE 0 END)/COUNT(*), 2) AS pct_repeat_30_days,
        SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 60 THEN 1 ELSE 0 END) AS repeat_within_60_days,
        ROUND(100.0 * SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 60 THEN 1 ELSE 0 END)/COUNT(*), 2) AS pct_repeat_60_days,
        SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 90 THEN 1 ELSE 0 END) AS repeat_within_90_days,
        ROUND(100.0 * SUM(CASE WHEN second_purchase_date IS NOT NULL AND TIMESTAMPDIFF(DAY, first_purchase_date, second_purchase_date) <= 90 THEN 1 ELSE 0 END)/COUNT(*), 2) AS pct_repeat_90_days
FROM first_second_purchase
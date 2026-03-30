WITH seller_monthly_revenue AS (
	SELECT	oi.seller_id,
			DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS revenue_month,
            SUM(oi.price + oi.freight_value) AS monthly_revenue,
            COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_order_items_dataset oi
    JOIN olist_orders_dataset o
		ON oi.order_id = o.order_id
	WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id, revenue_month
),

filtered_sellers AS (
	SELECT seller_id
    FROM seller_monthly_revenue
    GROUP BY seller_id
    HAVING COUNT(DISTINCT revenue_month) >= 3
)

SELECT	smr.seller_id,
		ROUND(AVG(smr.monthly_revenue), 2) AS avg_monthly_revenue,
        ROUND(STDDEV(smr.monthly_revenue), 2) AS revenue_stddev,
        ROUND(STDDEV(smr.monthly_revenue)/NULLIF(AVG(smr.monthly_revenue), 0), 2) AS revenue_volatility_ratio,
        COUNT(DISTINCT revenue_month) AS active_months
FROM seller_monthly_revenue smr
JOIN filtered_sellers fs
	ON smr.seller_id = fs.seller_id
GROUP BY smr.seller_id
ORDER BY revenue_volatility_ratio DESC
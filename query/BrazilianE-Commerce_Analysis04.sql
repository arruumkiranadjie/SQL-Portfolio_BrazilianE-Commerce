WITH delivery_performance AS (
	SELECT	order_id,
			CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END AS is_late
    FROM olist_orders_dataset 
    WHERE order_status = 'delivered'
),

review_analysis AS (
	SELECT	dp.is_late,
			r.review_score
    FROM delivery_performance dp
    JOIN olist_order_reviews_dataset r
		ON dp.order_id = r.order_id
)

SELECT	is_late,
		COUNT(*) AS total_orders,
        ROUND(AVG(review_score), 2) AS avg_review_score,
        SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) AS low_score_orders,
        ROUND(100.0 * SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END)/COUNT(*), 2) AS pct_low_reviews
FROM review_analysis
GROUP BY is_late
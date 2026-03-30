WITH category_monthly_orders AS (
	SELECT	pt.product_category_name_english AS category,
			MONTH(o.order_purchase_timestamp) AS monthly_num,
            COUNT(DISTINCT o.order_id) AS monthly_orders
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
		ON o.order_id = oi.order_id
	JOIN olist_products_dataset p
		ON oi.product_id = p.product_id
	JOIN product_category_name_translation pt
		ON p.product_category_name = pt.product_category_name
	WHERE o.order_status = 'delivered'
    GROUP BY pt.product_category_name_english, MONTH(o.order_purchase_timestamp)
),

category_avg AS (
	SELECT	category,
			AVG(monthly_orders) AS avg_monthly_orders
    FROM category_monthly_orders
    GROUP BY category 
)

SELECT	cmo.category,
		cmo.monthly_num,
        cmo.monthly_orders,
        ROUND(ca.avg_monthly_orders, 2) AS avg_monthly_orders,
        ROUND(cmo.monthly_orders/ NULLIF(ca.avg_monthly_orders, 0), 2) AS seasonality_index
FROM category_monthly_orders cmo
JOIN category_avg ca
	ON cmo.category = ca.category
ORDER BY cmo.category, cmo.monthly_num
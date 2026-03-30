WITH category_monthly_orders AS (
	SELECT	pt.product_category_name_english AS category,
			DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS year_months,
            COUNT(DISTINCT o.order_id) AS monthly_orders
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
		ON o.order_id = oi.order_id
	JOIN olist_products_dataset p
		ON oi.product_id = p.product_id
	JOIN product_category_name_translation pt
		ON p.product_category_name = pt.product_category_name
	WHERE o.order_status = 'delivered'
    GROUP BY pt.product_category_name_english, DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)

SELECT *
FROM category_monthly_orders
ORDER BY category, year_months
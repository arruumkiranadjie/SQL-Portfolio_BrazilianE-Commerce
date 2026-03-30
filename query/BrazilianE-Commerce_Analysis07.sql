WITH category_sales AS (
	SELECT	pt.product_category_name_english AS category,
			COUNT(DISTINCT o.order_id) AS total_orders,
            COUNT(oi.order_item_id) AS total_items,
            SUM(oi.price + oi.freight_value) AS total_revenue,
            ROUND(100.0 * SUM(oi.price + oi.freight_value)/ COUNT(DISTINCT o.order_id), 2) AS avg_order_value
    FROM olist_order_items_dataset oi
    JOIN olist_orders_dataset o
		ON oi.order_id = o.order_id
	JOIN olist_products_dataset p
		ON oi.product_id = p.product_id
	JOIN product_category_name_translation pt
		ON p.product_category_name = pt.product_category_name
	WHERE o.order_status = 'delivered'
    GROUP BY pt.product_category_name_english
)

SELECT	category,
		total_orders,
        total_items,
        ROUND(total_revenue, 2) AS total_revenue,
        avg_order_value,
        
        NTILE(4) OVER (ORDER BY total_orders DESC) AS volume_quartile,
        NTILE(4) OVER (ORDER BY total_revenue DESC) AS revenue_quartile
FROM category_sales
ORDER BY total_revenue DESC

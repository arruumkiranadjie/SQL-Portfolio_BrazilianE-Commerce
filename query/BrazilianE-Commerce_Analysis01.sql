WITH order_revenue AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp,
        SUM(p.payment_value) AS order_revenue
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    JOIN olist_order_payments_dataset p
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
),

customer_cumulative_revenue AS (
    SELECT
        customer_unique_id,
        order_purchase_timestamp,
        order_revenue,
        SUM(order_revenue) OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS cumulative_revenue,
        SUM(order_revenue) OVER (
            PARTITION BY customer_unique_id
        ) AS total_clv
    FROM order_revenue
),

clv_50pct_milestone AS (
    SELECT
        customer_unique_id,
        MIN(order_purchase_timestamp) AS date_reached_50pct_clv
    FROM customer_cumulative_revenue
    WHERE cumulative_revenue >= total_clv * 0.5
    GROUP BY customer_unique_id
)

SELECT
    c.customer_unique_id,
    ROUND(MAX(c.total_clv), 2) AS total_clv,
    MIN(c.order_purchase_timestamp) AS first_purchase_date,
    m.date_reached_50pct_clv,
    TIMESTAMPDIFF(
        DAY,
        MIN(c.order_purchase_timestamp),
        m.date_reached_50pct_clv
    ) AS days_to_50pct_clv
FROM customer_cumulative_revenue c
JOIN clv_50pct_milestone m
    ON c.customer_unique_id = m.customer_unique_id
GROUP BY
    c.customer_unique_id,
    m.date_reached_50pct_clv
ORDER BY total_clv DESC;
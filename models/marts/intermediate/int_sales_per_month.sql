with fct_orders AS(
    SELECT *
    FROM {{ref("fct_orders")}}
),

dim_tiempo AS(
    SELECT *
    FROM {{ ref('dim_tiempo') }}
),

sales_per_month AS(
    SELECT
        o.product_id,
        sum(o.quantity) as total_quantity_product,
        sum(o.product_price_usd*o.quantity) as real_profit,
        month(order_created_at_UTC) as month
    FROM fct_orders o
    GROUP BY product_id, month
)

SELECT * FROM sales_per_month
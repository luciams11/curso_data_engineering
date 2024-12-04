with fct_orders AS(
    SELECT *
    FROM {{ref("fct_orders")}}
),

dim_tiempo AS(
    SELECT *
    FROM {{ ref('dim_tiempo') }}
),

product_info AS(
    SELECT 
        product_id,
        product_name,
        product_price_usd
    FROM {{ ref('dim_products') }}
),

sales_per_month AS(
    SELECT
        o.product_id,
        p.product_name,
        sum(o.quantity) as total_quantity_product,
        sum(p.product_price_usd*o.quantity) as real_profit_usd,
        t.month,
        t.year
    FROM fct_orders o
    JOIN dim_tiempo t 
    ON date(o.order_created_at_UTC) = t.date_id
    LEFT JOIN product_info p
    ON o.product_id = p.product_id
    GROUP BY product_id, product_name, month, year
    ORDER BY year, month, product_name
)

SELECT * FROM sales_per_month
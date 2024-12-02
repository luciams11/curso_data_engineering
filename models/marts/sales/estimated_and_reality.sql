with fct_budget AS(
    SELECT *
    FROM {{ref("fct_budget")}}
),

sales_per_month AS(
    SELECT *
    FROM {{ ref('int_sales_per_month') }}
),

estimated_and_reality AS(
    SELECT
        b.product_id,
        b.estimated_quantity,
        b.estimated_profit_usd,
        s.total_quantity_product,
        s.real_profit,
        t.month_name
    FROM fct_budget b 
    JOIN sales_per_month s
    ON b.product_id = s.product_id
    JOIN dim_tiempo t
    ON b.month = t.month
    
)

SELECT * FROM estimated_and_reality
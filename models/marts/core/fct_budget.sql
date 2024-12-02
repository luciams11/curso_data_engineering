with stg_budget AS(
    SELECT 
        budget_id,
        month,
        product_id,
        estimated_quantity
    FROM {{ref("stg_google_sheets_budget")}}
),

product_info AS(
    SELECT 
        product_id,
        product_price_usd
    FROM {{ ref('dim_products') }}
),

fct_budget AS(
    SELECT
        b.budget_id,
        b.month,
        b.product_id,
        b.estimated_quantity,
        b.estimated_quantity*p.product_price_usd as estimated_profit_usd
    FROM stg_budget b 
    JOIN product_info p
    ON b.product_id = p.product_id
)

SELECT * FROM fct_budget
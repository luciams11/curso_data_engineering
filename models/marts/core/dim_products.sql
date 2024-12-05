with stg_products AS(
    SELECT * 
    FROM {{ref("stg_sql_server_dbo_products")}}
),

dim_products AS(
    SELECT 
        product_id,
        product_price_usd,
        product_name,
        origin_country,
        stock
    FROM stg_products
)

SELECT * FROM dim_products
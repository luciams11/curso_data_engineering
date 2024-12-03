WITH base_products AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_products') }}
    ),

base_products_origins AS(
    SELECT *
    FROM {{ ref('base_seed_files_products_origins') }}
),

stg_products AS (
    SELECT
        p.product_id,
        p.product_price_usd,
        p.product_name,
        coalesce(o.origin_country, 'Unknown') as origin_country,
        p.stock,
        p.is_deleted,
        p.date_load_UTC
    FROM base_products p
    LEFT JOIN base_products_origins o 
    ON p.product_name = o.product_name
    )

SELECT * FROM stg_products
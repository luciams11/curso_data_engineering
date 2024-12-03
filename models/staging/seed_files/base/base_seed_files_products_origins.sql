WITH src_products_origins AS (
    SELECT * 
    FROM {{ ref('products_origins') }}
    ),

renamed AS (
    SELECT
        plant_name as product_name,
        origin_country
    FROM src_products_origins
    )

SELECT * FROM renamed
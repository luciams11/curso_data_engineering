WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        product_id,
        price::decimal(10,2) as product_price,
        name as product_name,
        inventory as stock,
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted
WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        product_id,
        price::decimal(10,2) as product_price_usd,
        name as product_name,
        inventory::number(5,0) as stock,
        CASE
            WHEN _fivetran_deleted = null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_products
    )

SELECT * FROM renamed_casted
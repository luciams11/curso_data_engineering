WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    
    SELECT DISTINCT
        {{dbt_utils.generate_surrogate_key(['shipping_service'])}} as shipping_id,
        CASE 
            WHEN shipping_service = '' THEN 'sin asignar'
            ELSE shipping_service
        END AS shipping_service
        FROM src_orders
    )

SELECT * FROM renamed_casted
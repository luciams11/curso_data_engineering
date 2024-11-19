WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(["COALESCE(NULLIF(shipping_service, ''), 'sin asignar')"]) }} as shipping_service_id, 
        COALESCE(NULLIF(shipping_service, ''), 'sin asignar') as shipping_service
        FROM src_orders
    )

SELECT * FROM renamed_casted
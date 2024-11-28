WITH src_orders AS (
    SELECT * 
    FROM {{ ref("base_sql_server_dbo_orders") }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        user_id,
        promo_id,
        shipment_id,
        address_id,
        tracking_id,
        _fivetran_deleted,
        date_load_UTC
    FROM src_orders 


    )

SELECT * FROM renamed_casted
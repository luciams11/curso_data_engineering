WITH src_orders AS (
    SELECT * 
    FROM {{ ref("base_sql_server_dbo_orders") }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        order_cost_euros,
        order_total_euros,
        created_at_UTC,
        estimated_delivery_at_UTC,
        delivered_at_UTC,
        status_id,
        _fivetran_deleted,
        date_load_UTC
    FROM src_orders o 

    )

SELECT * FROM renamed_casted
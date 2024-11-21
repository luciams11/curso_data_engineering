WITH src_orders AS (
    SELECT * 
    FROM {{ ref("base_sql_server_dbo_orders") }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        order_cost::decimal(10,2) as order_cost_euros,
        order_total::decimal(10,2) as order_total_euros,
        convert_timezone('UTC', created_at) as created_at_UTC,
        convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at_UTC,
        convert_timezone('UTC', delivered_at) as delivered_at_UTC,
        status_id,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_orders o 


    )

SELECT * FROM renamed_casted
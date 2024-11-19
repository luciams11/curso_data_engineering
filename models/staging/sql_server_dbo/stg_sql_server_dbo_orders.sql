WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        {{ dbt_utils.generate_surrogate_key(["COALESCE(NULLIF(shipping_service, ''), 'sin asignar')"]) }} as shipping_service_id, 
        shipping_cost::decimal(10,2) as shipping_cost_euros,
        address_id,
        convert_timezone('UTC', created_at) as created_at_UTC,
        {{ dbt_utils.generate_surrogate_key(["COALESCE(NULLIF(promo_id, ''), 'no promo')"]) }} as promo_id, 
        convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at_UTC,
        order_cost::decimal(10,2) as order_cost_euros,
        user_id,
        order_total::decimal(10,2) as order_total_euros,
        convert_timezone('UTC', delivered_at) as delivered_at_UTC,
        CASE 
            WHEN TRIM(tracking_id) = '' THEN null
            ELSE tracking_id
        END AS tracking_id,
        status as order_status,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_orders
    )

SELECT * FROM renamed_casted
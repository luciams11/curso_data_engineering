WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        CASE 
            WHEN shipping_service IS NULL OR TRIM(shipping_service) = '' THEN 'en preparación'
            ELSE shipping_service
        END AS shipping_service,
        shipping_cost,
        address_id,
        created_at,
        {{dbt_utils.generate_surrogate_key(['promo_id'])}} as promo_id,
        estimated_delivery_at,
        order_cost,
        delivered_at,
        CASE 
            WHEN tracking_id IS NULL OR TRIM(tracking_id) = '' THEN 'en preparación'
            ELSE tracking_id
        END AS tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted
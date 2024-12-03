{{
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='fail'
    )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}

{% if is_incremental() %}

	  WHERE date_load_UTC > (SELECT MAX(date_load_UTC) FROM {{ this }} )

{% endif %}
    ),

renamed_casted AS (
    SELECT
        order_id, 
        user_id,
        address_id,
        {{ dbt_utils.generate_surrogate_key(["COALESCE(NULLIF(promo_id, ''), 'no promo')"]) }} as promo_id,

        convert_timezone('UTC', created_at) as order_created_at_UTC,
        order_cost::decimal(10,2) as order_cost_usd,
        order_total::decimal(10,2) as order_total_usd,
 
        -- Información de envío
        COALESCE(NULLIF(shipping_service, ''), 'not_assigned') as shipping_service,
        shipping_cost::decimal(10,2) as shipping_cost_usd,
        convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at_UTC,
        convert_timezone('UTC', delivered_at) as delivered_at_UTC,
        CASE 
            WHEN TRIM(tracking_id) = '' THEN 'not_assigned_yet'
            ELSE tracking_id
        END AS tracking_id, 
        status as order_status,
        CASE
            WHEN _fivetran_deleted is null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_orders
    )

SELECT * FROM renamed_casted
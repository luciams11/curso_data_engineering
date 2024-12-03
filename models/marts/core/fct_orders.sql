{{
    config(
        materialized='incremental',
        unique_key='order_item_id',
        on_schema_change='fail'
    )
}}

with stg_orders AS(
    SELECT *
    FROM {{ref("stg_sql_server_dbo_orders")}}
),

stg_order_items AS(
    SELECT *
    FROM {{ ref('stg_sql_server_dbo_order_items') }}
),

product_info AS(
    SELECT 
        product_id,
        product_name,
        product_price_usd
    FROM {{ ref('dim_products') }}
),

fct_orders AS(
    SELECT
        oi.order_item_id,
        o.order_id, 
        o.user_id,
        o.address_id,
        o.promo_id,
        o.order_created_at_UTC,
        --o.order_cost_usd,
        --o.order_total_usd,
        o.date_load_UTC,
 
        -- Información de envío
        o.shipping_service,
        o.shipping_cost_usd/count(oi.product_id) OVER (PARTITION BY o.order_id) as shipping_cost_per_product_usd,
        o.estimated_delivery_at_UTC,
        o.delivered_at_UTC,
        o.tracking_id, 
        o.order_status,

        oi.product_id,
        p.product_name,
        oi.quantity,
        p.product_price_usd
    FROM stg_orders o
    JOIN stg_order_items oi 
    ON o.order_id = oi.order_id
    JOIN product_info p 
    ON oi.product_id = p.product_id
)

SELECT * FROM fct_orders fct_o
--NO funciona
{% if is_incremental() %}

	  WHERE fct_o.date_load_UTC > (SELECT MAX(this.date_load_UTC) FROM {{ this }} as this)

{% endif %}
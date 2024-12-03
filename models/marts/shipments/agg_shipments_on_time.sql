WITH fct_orders AS (
    SELECT * 
    FROM {{ ref("fct_orders") }}
    ),

shipments_on_time AS (
    SELECT
        order_id, 
        shipping_service,
        estimated_delivery_at_UTC,
        delivered_at_UTC,
        order_status,
        CASE 
            WHEN estimated_delivery_at_UTC >= delivered_at_UTC THEN 'On time'
            ELSE 'Delayed'
        END AS shipment,
        CASE
            WHEN estimated_delivery_at_UTC > delivered_at_UTC THEN datediff('day',delivered_at_UTC, estimated_delivery_at_UTC)
            ELSE '0'
        END AS days_delayed
    FROM fct_orders 
    WHERE order_status = 'delivered'
    )

select * from shipments_on_time
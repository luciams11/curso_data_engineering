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
),

agg_shipments AS(
    SELECT
        shipping_service,
        COUNT(order_id) AS total_shipments,
        SUM(CASE WHEN shipment = 'On time' THEN 1 ELSE 0 END) AS shipments_on_time,
        SUM(CASE WHEN shipment = 'Delayed' THEN 1 ELSE 0 END) AS shipments_delayed,
        ROUND(SUM(CASE WHEN shipment = 'On time' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS pct_on_time,
        ROUND(SUM(CASE WHEN shipment = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 2) AS pct_delayed,
        AVG(days_delayed) AS avg_days_delayed,
        MAX(days_delayed) AS max_days_delayed,
        MIN(days_delayed) AS min_days_delayed,
        SUM(days_delayed) AS total_days_delayed
    FROM shipments_on_time
    GROUP BY shipping_service
)

select * from agg_shipments
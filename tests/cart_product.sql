SELECT *
FROM {{ ref('stg_sql_server_dbo_events') }}
WHERE event_type = 'add_to_cart' AND product_id IS NULL
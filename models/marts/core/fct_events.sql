with stg_events as(
    SELECT
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at_UTC,
        order_id
    FROM {{ ref('stg_sql_server_dbo_events') }}
)

select * from stg_events
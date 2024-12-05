WITH fct_events AS (
    SELECT * 
    FROM {{ ref("fct_events") }}
    ),

dim_users AS (
    SELECT * 
    FROM {{ ref("dim_users")}}
),

events_users AS (
    SELECT
        session_id,
        e.user_id,
        u.first_name,
        u.email,
        min(e.created_at_UTC) as first_event_time_utc,
        max(e.created_at_UTC) as last_event_time_utc,
        datediff(minute, min(e.created_at_UTC), max(e.created_at_UTC)) as session_length_minutes,
        sum(case when event_type = 'page_view' then 1 else 0 end) as page_view,
        sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart,
        sum(case when event_type = 'checkout' then 1 else 0 end) as checkout,
        sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped,
    FROM fct_events e
    LEFT JOIN dim_users u
    ON e.user_id = u.user_id
    group by session_id, e.user_id,first_name, email
    )

select * from events_users
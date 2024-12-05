{{
    config(
        materialized='incremental',
        unique_key='event_id',
        on_schema_change='fail'
    )
}}

with stg_events as(
    SELECT
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        created_at_UTC,
        order_id,
        date_load_UTC
    FROM {{ ref('stg_sql_server_dbo_events') }}
)

select * from stg_events

{% if is_incremental() %}

	  WHERE date_load_UTC > (SELECT MAX(date_load_UTC) FROM {{ this }} )

{% endif %}
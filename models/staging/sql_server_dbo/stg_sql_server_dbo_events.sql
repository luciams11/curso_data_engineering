{{
    config(
        materialized='incremental',
        unique_key='event_id',
        on_schema_change='fail'
    )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url,
        event_type,
        user_id,
        product_id,
        session_id,
        convert_timezone('UTC', created_at) as created_at_UTC,
        order_id,
        CASE
            WHEN _fivetran_deleted is null THEN false
            ELSE true
        END AS is_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_events
    )

SELECT * FROM renamed_casted

{% if is_incremental() %}

	  WHERE date_load_UTC > (SELECT MAX(date_load_UTC) FROM {{ this }} )

{% endif %}
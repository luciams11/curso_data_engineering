WITH src_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo_orders') }}
    ),

renamed_casted AS (
    
    SELECT DISTINCT
        status_id,
        order_status,
        _fivetran_deleted,
        date_load_UTC
        FROM src_orders
    )

SELECT * FROM renamed_casted
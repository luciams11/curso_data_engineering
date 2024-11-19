WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['order_id', 'product_id'])}} as order_item_id,
    	order_id,
        product_id,
        quantity,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_order_items
    )

SELECT * FROM renamed_casted
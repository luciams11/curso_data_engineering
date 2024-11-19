WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['promo_id'])}} as promo_id,
        lower(promo_id) as promo_name,
        discount as discount_euros,
        status as promo_status,
        _fivetran_deleted,
        convert_timezone('UTC',_fivetran_synced) AS date_load_UTC
    FROM src_promos

    UNION ALL

    SELECT 
        {{dbt_utils.generate_surrogate_key(["'no promo'"])}} as promo_id,
        'no promo' as promo_name,
        0 as discount_in_euros,
        'active' as status,
        NULL as _fivetran_deleted,
        convert_timezone('UTC', CURRENT_TIMESTAMP) AS date_load_UTC

    )

SELECT * FROM renamed_casted